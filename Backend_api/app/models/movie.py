from typing import List
from pydantic import BaseModel



class Movie(BaseModel):
    title: str
    releaseYear: int
    genre: List[str]
    description: str
    imageUrl: str
    #director as ObjectID not string
    director: str


    class Config:
        orm_mode = True


class MovieOut(Movie):
    id: str  # MongoDB ID field
    title: str
    releaseYear: int
