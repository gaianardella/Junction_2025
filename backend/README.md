# Backend (FastAPI + Gemini)

This backend receives a **prompt** and an optional **PDF file**, then sends them to **Gemini 2.5 Flash**.  
Non-PDF files are not supported yet (conversion TBD).

---

## Setup

cd backend
python3 -m venv .venv
source .venv/bin/activate       # Windows: .venv\Scripts\activate
pip install -r requirements.txt
cp .env.example .env            # add your GEMINI_API_KEY here

## Run

uvicorn main:app --reload --port 8000

## Endpoint
 POST /analyze

 Form-data:

  'prompt' (required)

  'file' (optional, PDF only, if not PDF will be converted)
 
 Returns:
 
  { "answer": "Gemini response text" }

# When the model is run in Google Cloud
# https://backend-service-647778379452.europe-north1.run.app

## Sending a request to Gemini

curl -X POST   -F "prompt=What can be a good prompt?" -F "file=@backend/some_data.pdf;type=application/pdf" https://backend-service-647778379452.europe-north1.run.app/analyze
