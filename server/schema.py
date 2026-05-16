from pydantic import BaseModel, Field

class HabitAnalysis(BaseModel):
    difficulty: str = Field(description="A string representing the estimated difficulty (e.g., 'Easy', 'Medium', 'Hard').")
    goal: str = Field(description="An extremely concise (3-5 words max) goal summary. Sacrifice grammar for brevity.")
