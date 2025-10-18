#!/usr/bin/env python3
"""generate_manifest.py — builds/updates `evidence_manifest.csv` from files in assets/photos/ using EXIF when available.

Usage: python generate_manifest.py

Dependencies (optional): pillow, exifread
pip install pillow exifread
"""
import csv
import os
from pathlib import Path

try:
    from PIL import Image
    _HAS_PIL = True
except Exception:
    _HAS_PIL = False

BASE = Path(__file__).parent
PHOTOS = BASE / "assets" / "photos"
MANIFEST = BASE / "evidence_manifest.csv"

def extract_exif_date(path):
    if not _HAS_PIL:
        return None
    try:
        img = Image.open(path)
        exif = img._getexif()
        if not exif:
            return None
        # Common tag 36867 is DateTimeOriginal
        date = exif.get(36867) or exif.get(306)
        return date
    except Exception:
        return None

def build_manifest():
    rows = []
    for p in sorted(PHOTOS.glob("*")):
        if not p.is_file():
            continue
        date = extract_exif_date(p) or ""
        rows.append({
            'filename': p.name,
            'date_taken': date,
            'location': '',
            'taken_by': '',
            'legal_relevance': '',
            'notes': ''
        })
    # write CSV
    with open(MANIFEST, 'w', newline='', encoding='utf-8') as f:
        writer = csv.DictWriter(f, fieldnames=['filename','date_taken','location','taken_by','legal_relevance','notes'])
        writer.writeheader()
        for r in rows:
            writer.writerow(r)
    print(f"Wrote manifest to {MANIFEST}")

if __name__ == '__main__':
    build_manifest()
