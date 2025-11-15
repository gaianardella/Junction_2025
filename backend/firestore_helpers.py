from typing import List, Dict

from dependencies import firestore_client


def fetch_nano_lessons(limit: int = 10) -> List[Dict]:
    docs = (
        firestore_client.collection("nano_lessons")
        .limit(limit)
        .stream()
    )
    lessons = []
    for doc in docs:
        data = doc.to_dict() or {}
        data["id"] = doc.id
        lessons.append(data)
    return lessons
