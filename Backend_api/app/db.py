from motor.motor_asyncio import AsyncIOMotorClient

client = AsyncIOMotorClient("mongodb://localhost:27017")
db = client.movieDatabase
movies_collection = db.movies
directors_collection = db.directors
