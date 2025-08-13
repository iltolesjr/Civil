import json
import os
import sys
import time
from datetime import datetime, timezone
from typing import Dict, List, Any

import requests
import yaml

STATE_FILE = os.path.join(os.path.dirname(__file__), "state.json")
CONFIG_FILE = os.path.join(os.path.dirname(__file__), "config.yml")
COURTLISTENER_SEARCH = "https://www.courtlistener.com/api/rest/v3/search/"


def load_state() -> Dict[str, Any]:
    if os.path.exists(STATE_FILE):
        with open(STATE_FILE, "r", encoding="utf-8") as f:
            return json.load(f)
    return {"last_seen": {}}  # per query name: set of result ids


def save_state(state: Dict[str, Any]) -> None:
    with open(STATE_FILE, "w", encoding="utf-8") as f:
        json.dump(state, f, indent=2, sort_keys=True)


def load_config() -> Dict[str, Any]:
    with open(CONFIG_FILE, "r", encoding="utf-8") as f:
        return yaml.safe_load(f)


def search_courtlistener(query: str, max_results: int = 10) -> List[Dict[str, Any]]:
    params = {
        "q": query,
        "page_size": max_results,
        "order": "dateFiled desc",
    }
    # If you have an API token, set headers here.
    headers = {}
    r = requests.get(COURTLISTENER_SEARCH, params=params, headers=headers, timeout=30)
    r.raise_for_status()
    data = r.json()
    results = data.get("results", [])
    # normalize a small subset for our purposes
    normalized = []
    for item in results:
        normalized.append(
            {
                "id": item.get("id"),
                "absolute_url": item.get("absolute_url"),
                "caseName": item.get("caseName"),
                "court": item.get("court"),
                "dateFiled": item.get("dateFiled"),
                "snippet": item.get("snippet"),
            }
        )
    return normalized

def create_github_issue(repo: str, token: str, title: str, body: str, labels: List[str] | None = None) -> None:
    if not repo or not token:
        print("Skipping issue creation: missing repo or token.")
        return
    url = f"https://api.github.com/repos/{repo}/issues"
    payload = {"title": title, "body": body}
    if labels:
        payload["labels"] = labels
    headers = {
        "Accept": "application/vnd.github+json",
        "Authorization": f"Bearer {token}",
        "X-GitHub-Api-Version": "2022-11-28",
    }
    r = requests.post(url, headers=headers, json=payload, timeout=30)
    if r.status_code >= 300:
        print(f"WARN: Failed to create issue: {r.status_code} {r.text}")
    else:
        data = r.json()
        print(f"Created issue #{data.get('number')}: {data.get('html_url')}")


def gh_output(key: str, value: str) -> None:
    # For GitHub Actions step outputs (optional future use)
    print(f"::set-output name={key}::{value}")


def main() -> int:
    state = load_state()
    config = load_config()
    queries = config.get("queries", [])
    now = datetime.now(timezone.utc).isoformat()

    new_findings: List[Dict[str, Any]] = []
    issue_flags: Dict[str, bool] = {}
    for q in queries:
        name = q.get("name") or q.get("q")[:20]
        query_text = q.get("q", "").strip()
        max_results = int(q.get("max_results", 10))
        create_issue = bool(q.get("create_issue", True))
        issue_flags[name] = create_issue
        if not query_text:
            continue

        print(f"Searching CourtListener for [{name}]: {query_text}")
        try:
            results = search_courtlistener(query_text, max_results=max_results)
        except Exception as e:
            print(f"ERROR: search failed for {name}: {e}")
            continue

        seen_ids = set(state.get("last_seen", {}).get(name, []))
        fresh = [r for r in results if str(r.get("id")) not in seen_ids]
        if not fresh:
            print(f"No new results for {name}.")
        else:
            print(f"{len(fresh)} new result(s) for {name}.")
            for item in fresh:
                new_findings.append({"query": name, **item})

            # update state
            new_ids = seen_ids | {str(r.get("id")) for r in fresh}
            state.setdefault("last_seen", {})[name] = sorted(new_ids)

    if new_findings:
        # Save state for next run
        save_state(state)

        # Emit a JSON file of findings (useful as artifact)
        out_dir = os.path.join(os.path.dirname(__file__), "out")
        os.makedirs(out_dir, exist_ok=True)
        out_file = os.path.join(out_dir, f"findings_{int(time.time())}.json")
        with open(out_file, "w", encoding="utf-8") as f:
            json.dump(new_findings, f, indent=2)
        print(f"Wrote findings to {out_file}")

        # Create GitHub issues when enabled
        repo = os.environ.get("GITHUB_REPOSITORY")  # e.g., owner/repo
        token = os.environ.get("GITHUB_TOKEN") or os.environ.get("GH_TOKEN")
        for item in new_findings:
            qname = item.get('query')
            if not issue_flags.get(qname, True):
                continue
            title = f"CourtListener: {item.get('caseName') or item.get('id')} [{qname}]"
            url = f"https://www.courtlistener.com{item.get('absolute_url')}" if item.get("absolute_url") else ""
            body = (
                f"Found: {datetime.now(timezone.utc).strftime('%Y-%m-%d %H:%M:%SZ')} UTC\n"
                f"Query: {qname}\n"
                f"URL: {url}\n"
                f"Date Filed: {item.get('dateFiled')}\n"
                f"Court: {item.get('court')}\n\n"
                f"Snippet:\n{item.get('snippet') or ''}\n"
            )
            create_github_issue(repo=repo, token=token, title=title, body=body, labels=["bot", "courtlistener"]) 
    else:
        print("No new findings across all queries.")

    return 0


if __name__ == "__main__":
    raise SystemExit(main())
