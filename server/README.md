# FitnessPal Habit Analyzer API

This backend service provides AI-driven habit analysis using the Google Agent Development Kit (ADK) and OpenRouter (Gemma 3). It is designed to be consumed by the FitnessPal Flutter app to automatically determine habit difficulty and generate concise goals.

## API Documentation

### Analyze Habit
Analyzes a habit title and description to provide structured metrics.

*   **Endpoint**: `/api/analyze-habit`
*   **Method**: `POST`
*   **Content-Type**: `application/json`

#### Request Schema
| Field | Type | Description |
| :--- | :--- | :--- |
| `title` | `string` | The user-defined name of the habit (e.g., "Morning Run"). |
| `description` | `string` | A detailed description of the habit routine or goal. |

#### Response Schema
| Field | Type | Description |
| :--- | :--- | :--- |
| `difficulty` | `string` | Estimated effort level: `Easy`, `Moderate`, or `Hard`. |
| `goal` | `string` | An extremely concise (3-5 words) summary of the objective. |

#### Example Interaction

**Request:**
```json
{
  "title": "Morning Run",
  "description": "Run for 30 minutes every morning before breakfast"
}
```

**Response:**
```json
{
  "difficulty": "Moderate",
  "goal": "Run before breakfast"
}
```

---

## Technical Stack
- **Framework**: Flask (Python)
- **AI Engine**: Google Agent Development Kit (ADK)
- **Model**: Gemma 3 4B (via OpenRouter)
- **Validation**: Pydantic

## Getting Started

1.  **Install Dependencies**:
    ```bash
    pip install google-adk litellm flask pydantic python-dotenv PyYAML
    ```
2.  **Environment Variables**:
    Create a `.env` file in the `server/` directory:
    ```env
    OPENROUTER_API_KEY=your_key_here
    ```
3.  **Run Server**:
    ```bash
    python app.py
    ```
    The server runs on `http://127.0.0.1:5000`.

## Testing
Run the suite with:
```bash
pytest -s test_app.py
```
