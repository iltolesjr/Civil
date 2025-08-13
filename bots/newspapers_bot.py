import json
import os
import time
from datetime import datetime, timezone
from typing import Any, Dict, List, Optional

import requests
import yaml

STATE_FILE = os.path.join(os.path.dirname(__file__), "newspapers_state.json")
CONFIG_FILE = os.path.join(os.path.dirname(__file__), "newspapers_config.yml")
CHRONICLING_API = "https://chroniclingamerica.loc.gov/search/pages/results/"  # Library of Congress


def load_state() -> Dict[str, Any]:
    if os.path.exists(STATE_FILE):
        with open(STATE_FILE, "r", encoding="utf-8") as f:
            return json.load(f)
    return {"last_seen": {}}


def save_state(state: Dict[str, Any]) -> None:
    with open(STATE_FILE, "w", encoding="utf-8") as f:
        json.dump(state, f, indent=2, sort_keys=True)


def load_config() -> Dict[str, Any]:
    with open(CONFIG_FILE, "r", encoding="utf-8") as f:
        return yaml.safe_load(f)


def search_newspapers(phrase: str, states: Optional[List[str]], date1: int, date2: int, max_results: int) -> List[Dict[str, Any]]:
    params = {
        "format": "json",
        "andtext": phrase,
        "dateFilterType": "yearRange",
        "date1": date1,
        "date2": date2,
        "rows": max_results,
        "sort": "date desc"
    }
    if states:
        # Chronicling America accepts 'state' as state abbreviations or full names; try passing joined list
        # If this proves unreliable, we could loop per state.
        params["state"] = states
    r = requests.get(CHRONICLING_API, params=params, timeout=60)
    r.raise_for_status()
    data = r.json()
    items = data.get("items", [])
    results = []
    for it in items:
        results.append({
            "id": it.get("id"),
            "title": it.get("title"),
            "date": it.get("date"),
            "snippet": it.get("snippet"),
            "ocr_eng": it.get("ocr_eng"),
            "url": it.get("url"),
            "pdf": it.get("pdf"),
            "ocr_url": it.get("ocr"),
            "state": it.get("state"),
        })
    return results


def create_github_issue(repo: str, token: str, title: str, body: str, labels: Optional[List[str]] = None) -> None:
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


def main() -> int:
    config = load_config()
    state = load_state()
    now = datetime.now(timezone.utc).isoformat()

    new_hits: List[Dict[str, Any]] = []
    for q in config.get("queries", []):
        name = q.get("name") or q.get("phrase")[:40]
        phrase = q.get("phrase", "").strip()
        states = q.get("states") or []
        date1 = int(q.get("date1", 1850))
        date2 = int(q.get("date2", 1970))
        max_results = int(q.get("max_results", 25))
        create_issue = bool(q.get("create_issue", True))
        if not phrase:
            continue

        print(f"Searching Chronicling America for [{name}]: {phrase}")
        try:
            results = search_newspapers(phrase, states, date1, date2, max_results)
        except Exception as e:
            print(f"ERROR: search failed for {name}: {e}")
            continue

        seen = set(state.get("last_seen", {}).get(name, []))
        fresh = [r for r in results if str(r.get("id")) not in seen]
        if fresh:
            state.setdefault("last_seen", {})[name] = sorted(seen | {str(r.get("id")) for r in fresh})
            for item in fresh:
                item["query"] = name
            new_hits.extend(fresh)
        else:
            print(f"No new results for {name}.")

    if new_hits:
        save_state(state)
        out_dir = os.path.join(os.path.dirname(__file__), "out")
        os.makedirs(out_dir, exist_ok=True)
        out_file = os.path.join(out_dir, f"newspaper_hits_{int(time.time())}.json")
        with open(out_file, "w", encoding="utf-8") as f:
            json.dump(new_hits, f, indent=2)
        print(f"Wrote {len(new_hits)} hits to {out_file}")

        repo = os.environ.get("GITHUB_REPOSITORY")
        token = os.environ.get("GITHUB_TOKEN") or os.environ.get("GH_TOKEN")
        for item in new_hits:
            title = f"Newspaper hit: {item.get('title') or item.get('id')} [{item.get('query')}]"
            body = (
                f"Query: {item.get('query')}\n"
                f"Date: {item.get('date')}\n"
                f"State: {item.get('state')}\n"
                f"URL: {item.get('url')}\n"
                f"PDF: {item.get('pdf')}\n\n"
                f"Snippet (OCR):\n{(item.get('snippet') or item.get('ocr_eng') or '')[:1000]}\n"
            )
            create_github_issue(repo, token, title, body, labels=["bot", "newspapers"]) 
    else:
        print("No new results across all queries.")

    return 0


if __name__ == "__main__":
    raise SystemExit(main())
