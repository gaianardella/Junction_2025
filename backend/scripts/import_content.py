"""Utility script to push sample content into Firestore.

Run locally with:
    GOOGLE_APPLICATION_CREDENTIALS=/path/to/key.json \
    poetry run python backend/scripts/import_content.py
"""

from __future__ import annotations

import json
from pathlib import Path

from dotenv import load_dotenv
from google.cloud import firestore

load_dotenv()

PROJECT_ID = "junction2025-478315"

ROOT_DIR = Path(__file__).resolve().parents[2]
SAMPLE_FILE = ROOT_DIR / "docs" / "sample_content.json"


def load_sample_data() -> dict:
    if not SAMPLE_FILE.exists():
        raise FileNotFoundError(f"Sample content file not found: {SAMPLE_FILE}")
    with SAMPLE_FILE.open("r", encoding="utf-8") as f:
        return json.load(f)


def upload_collection(db: firestore.Client, collection: str, items: list[dict]) -> None:
    if not items:
        return
    col_ref = db.collection(collection)
    for item in items:
        doc_id = item.get("id")
        doc_ref = col_ref.document(doc_id) if doc_id else col_ref.document()
        doc_ref.set(item)
        print(f"[{collection}] Uploaded document {doc_ref.id}")


def main() -> None:
    data = load_sample_data()
    db = firestore.Client(project=PROJECT_ID)

    upload_collection(db, "nano_lessons", data.get("nano_lessons", []))
    upload_collection(db, "articles", data.get("articles", []))
    upload_collection(db, "quests", data.get("quests", []))
    upload_collection(db, "actions", data.get("actions", []))
    upload_collection(db, "lessons", data.get("lessons", []))
    upload_collection(db, "warnings", data.get("warnings", []))

    print("Done.")


if __name__ == "__main__":
    main()
