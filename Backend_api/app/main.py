from fastapi import FastAPI
from routes.movie_routes import router as movie_router
from routes.director_routes import router as director_router
from fastapi.middleware.cors import CORSMiddleware

app = FastAPI()


app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

# Include routes
app.include_router(movie_router, prefix="/movies", tags=["Movies"])
app.include_router(director_router, prefix="/directors", tags=["Directors"])

@app.get("/")
async def root():
    return {"message": "Welcome to the Movie Database API"}
