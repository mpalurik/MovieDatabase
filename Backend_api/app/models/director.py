from pydantic import BaseModel
from typing import List


class Director(BaseModel):
    firstName: str
    lastName: str
    bornDate: str
    nationality: str
    nationalityCode: List[str]
    imageFaceUrl: str


    class Config:
        orm_mode = True


class DirectorOut(Director):
    id: str  