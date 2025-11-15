import json
from typing import Dict, List

from dependencies import gemini_client


def build_prompt_for_nano(user_profile: Dict, lessons: List[Dict]) -> str:
    lesson_lines = []
    for lesson in lessons:
        tags = ", ".join(lesson.get("tags", []))
        line = (
            f"- ID: {lesson.get('id')} | Title: {lesson.get('title')}\n"
            f"  Summary: {lesson.get('summary')}\n"
            f"  Action hint: {lesson.get('action_hint')}\n"
            f"  Tags: {tags}"
        )
        lesson_lines.append(line)

    prompt = f"""
You are a financial literacy coach choosing the best nano learning tip for one user.
Select ONE lesson from the list and explain why it fits.

User profile:
{json.dumps(user_profile, indent=2)}

Available nano lessons:
{chr(10).join(lesson_lines)}

Respond in JSON with fields:
{{
  "lesson_id": "...",
  "title": "...",
  "reason": "short explanation tailored to this user"
}}
"""
    return prompt.strip()


def call_gemini(contents: List[str | Dict]) -> str:
    response = gemini_client.models.generate_content(
        model="gemini-2.5-flash",
        contents=contents,
    )
    return response.text or ""
