import json
import os
from pathlib import Path

from fastapi import FastAPI, UploadFile, File, Form, HTTPException
from fastapi.middleware.cors import CORSMiddleware
from google import genai
from google.genai import types
from google.cloud import firestore
from dotenv import load_dotenv

# Load environment variables from .env (if present)
load_dotenv()

API_KEY = os.getenv("GEMINI_API_KEY")
if not API_KEY:
    raise RuntimeError("GEMINI_API_KEY is not set in the environment. Set it as described in https://ai.google.dev/gemini-api/docs/api-key")

client = genai.Client(api_key=API_KEY)

FIRESTORE_PROJECT = os.getenv("GCP_PROJECT_ID", "junction2025-478315")
firestore_client = firestore.Client(project=FIRESTORE_PROJECT)

app = FastAPI()

# Optional: allow frontend (Flutter in emulator/device) to call this backend
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],  # you can restrict this later
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)


@app.get("/")
def health_check():
    return {"status": "ok"}


def fetch_nano_lessons(limit: int = 10) -> list[dict]:
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


def build_prompt_for_nano(user_profile: dict, lessons: list[dict]) -> str:
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


async def convert_to_pdf_stub(upload_file: UploadFile) -> bytes:
    """
    TODO: implement conversion from arbitrary file types to PDF.
    For now this is just a placeholder and will raise an error.
    """
    # Here in the future you might:
    # - Save upload_file to disk as a temp file
    # - Run a conversion library/tool to produce a PDF
    # - Read the resulting PDF back to bytes and return it
    raise NotImplementedError("Conversion from non-PDF to PDF is not implemented yet.")


@app.post("/analyze")
async def analyze(
    prompt: str = Form(...),
    file: UploadFile | None = File(None),
):
    """
    Accepts a prompt and optionally a file.
    If a PDF file is provided, it is sent along with the prompt to Gemini.
    If a non-PDF file is provided, it will be converted to pdf NOT IMPLEMENTED YET.
    """

    contents_list = []

    if file is not None:
        # Check if the file is a PDF
        is_pdf_mime = file.content_type == "application/pdf"
        is_pdf_ext = Path(file.filename or "").suffix.lower() == ".pdf"

        if is_pdf_mime or is_pdf_ext:
            # Read PDF bytes and wrap as a Part, like in the official example
            pdf_bytes = await file.read()
            pdf_part = types.Part.from_bytes(
                data=pdf_bytes,
                mime_type="application/pdf",
            )
            contents_list.append(pdf_part)
        else:
            # Non-PDF: use the conversion stub (not implemented yet)
            try:
                pdf_bytes = await convert_to_pdf_stub(file)
            except NotImplementedError as e:
                # For now, just return a clear error instead of crashing
                raise HTTPException(
                    status_code=400,
                    detail=str(e),
                )
            pdf_part = types.Part.from_bytes(
                data=pdf_bytes,
                mime_type="application/pdf",
            )
            contents_list.append(pdf_part)

    # Prompt goes after the file in contents (like official docs example)
    contents_list.append(prompt)

    try:
        response = client.models.generate_content(
            model="gemini-2.5-flash",
            contents=contents_list,
        )
    except Exception as e:
        raise HTTPException(
            status_code=500,
            detail=f"Error calling Gemini: {e}",
        )

    return {"answer": response.text}


@app.post("/recommend/nano")
async def recommend_nano():
    lessons = fetch_nano_lessons(limit=5)
    if not lessons:
        raise HTTPException(status_code=404, detail="No nano lessons found in Firestore.")

    user_profile = {
        "age_group": "18-24",
        "life_stage": "first_apartment",
        "goals": ["build_emergency_fund", "reduce_impulse_spending"],
        "recent_behavior": {
            "impulse_radar": "high",
            "subscriptions": "growing",
            "wants_vs_needs": "wants 35%",
        },
        "preferred_style": "bullets",
    }

    prompt = build_prompt_for_nano(user_profile, lessons)

    try:
        response = client.models.generate_content(
            model="gemini-2.5-flash",
            contents=[prompt],
        )
    except Exception as e:
        raise HTTPException(status_code=500, detail=f"Error calling Gemini: {e}")

    raw_text = response.text or ""
    try:
        recommendation = json.loads(raw_text)
    except json.JSONDecodeError:
        recommendation = {"raw_text": raw_text}

    return {
        "user_profile": user_profile,
        "lessons_considered": [lesson["id"] for lesson in lessons],
        "gemini_response": recommendation,
    }
