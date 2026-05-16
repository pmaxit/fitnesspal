import pytest
from app import app
from unittest.mock import patch

@pytest.fixture
def client():
    app.config['TESTING'] = True
    with app.test_client() as client:
        yield client

def test_analyze_habit_success(client):
    data = {
        "title": "Morning Run",
        "description": "Run for 30 minutes every morning before breakfast"
    }
    
    # We will test the real agent integration with OpenRouter API
    response = client.post('/api/analyze-habit', json=data)
    
    assert response.status_code == 200
    json_data = response.get_json()
    assert "difficulty" in json_data
    assert "goal" in json_data
    assert isinstance(json_data["difficulty"], str)
    assert isinstance(json_data["goal"], str)
    print("\n--- Real LLM Response ---")
    print(json_data)

def test_analyze_habit_missing_fields(client):
    data = {
        "title": "Morning Run"
        # missing description
    }
    response = client.post('/api/analyze-habit', json=data)
    assert response.status_code == 400
    assert "error" in response.get_json()
