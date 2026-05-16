import json
import os
import yaml
import asyncio
from flask import Flask, request, jsonify
from dotenv import load_dotenv

# Google ADK Imports
from google.adk.agents.llm_agent import LlmAgent
from google.adk.models.registry import LLMRegistry
from google.adk.models.lite_llm import LiteLlm
from google.adk.runners import Runner
from google.adk.sessions.in_memory_session_service import InMemorySessionService
from google.genai import types

# Local Imports
from schema import HabitAnalysis

# Load Environment variables
load_dotenv()

# Register OpenRouter provider with ADK LiteLLM integration
LLMRegistry._register("openrouter/.*", LiteLlm)

app = Flask(__name__)

# Initialize Global Components
session_service = InMemorySessionService()

def load_agent_config():
    """Loads agent configuration from YAML file with fallback defaults."""
    config_path = os.path.join(os.path.dirname(__file__), "agent.yaml")
    if os.path.exists(config_path):
        with open(config_path, "r") as f:
            return yaml.safe_load(f)
    return {
        "name": "habit_analyzer_agent",
        "description": "Analyzes habit descriptions into structured goals and difficulty levels.",
        "instruction": "You are a habit analyst. Extract the goal and difficulty from the input."
    }

# Initialize the Habit Analysis Agent
config = load_agent_config()
habit_agent = LlmAgent(
    name=config["name"],
    model="openrouter/google/gemma-3-4b-it",
    description=config.get("description", ""),
    instruction=config["instruction"],
    output_schema=HabitAnalysis,
    output_key="analysis_result"
)

def analyze_habit_with_agent(title: str, description: str):
    """
    Orchestrates the ADK Runner to process habit text and extract structured results.
    """
    prompt = f"Habit Title: {title}\nHabit Description: {description}"
    message = types.Content(role="user", parts=[types.Part.from_text(text=prompt)])
    
    try:
        runner = Runner(
            app_name="fitnesspal",
            agent=habit_agent,
            session_service=session_service,
            auto_create_session=True
        )
        
        # Execute the agent and collect events
        events = list(runner.run(
            user_id="default_user",
            session_id="habit_session",
            new_message=message
        ))
        
        # Extract the structured response from event state or output
        result = None
        for event in events:
            # Check state_delta for the structured result (populated via output_key)
            if event.actions and event.actions.state_delta and "analysis_result" in event.actions.state_delta:
                result = event.actions.state_delta["analysis_result"]
                break
            # Fallback to direct output
            elif getattr(event, 'output', None):
                result = event.output
                break
        
        # Format the result for the API response
        if isinstance(result, HabitAnalysis):
            return result.model_dump()
        if hasattr(result, 'model_dump'):
            return result.model_dump()
        if isinstance(result, dict):
            return result
        
        return {"difficulty": "Unknown", "goal": "Could not parse agent response."}

    except Exception as e:
        return {"difficulty": "Error", "goal": str(e)}

@app.route('/api/analyze-habit', methods=['POST'])
def analyze_habit():
    data = request.get_json()
    if not data or 'title' not in data or 'description' not in data:
        return jsonify({"error": "Please provide both 'title' and 'description'"}), 400
        
    result = analyze_habit_with_agent(data['title'], data['description'])
    return jsonify(result), 200

if __name__ == '__main__':
    port = int(os.environ.get('PORT', 5000))
    app.run(debug=False, host='0.0.0.0', port=port)
