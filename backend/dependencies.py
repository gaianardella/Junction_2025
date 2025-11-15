import os

from dotenv import load_dotenv
from google import genai
from google.cloud import firestore

load_dotenv()

API_KEY = os.getenv("GEMINI_API_KEY")
if not API_KEY:
    raise RuntimeError(
        "GEMINI_API_KEY is not set in the environment. "
        "Set it as described in https://ai.google.dev/gemini-api/docs/api-key"
    )

FIRESTORE_PROJECT = os.getenv("GCP_PROJECT_ID", "junction2025-478315")

gemini_client = genai.Client(api_key=API_KEY)
firestore_client = firestore.Client(project=FIRESTORE_PROJECT)
