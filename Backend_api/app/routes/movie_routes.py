from fastapi import APIRouter, HTTPException, Query
from typing import List
from models.movie import Movie, MovieOut
from db import movies_collection
from bson import ObjectId
import logging
import re

router = APIRouter()


@router.get("/", response_model=List[MovieOut])
async def get_movies():
    movies = await movies_collection.find().to_list(None)
    formatted_movies = []
    for movie in movies:
        movie["id"] = str(movie["_id"])  # Convert _id to string
        if "director" in movie:
            movie["director"] = str(movie["director"])  # Convert director ObjectId to string
        formatted_movies.append(movie)
    
    return formatted_movies


@router.get("/{movie_id}", response_model=MovieOut)
async def get_movie(movie_id: str):
    try:
        # movie_id is valid and handle ObjectId conversion correctly
        movie = await movies_collection.find_one({"_id": ObjectId(movie_id)})
        
        if not movie:
            raise HTTPException(status_code=404, detail="Movie not found")

        # Convert MongoDB ObjectId fields to strings
        movie["id"] = str(movie["_id"])  # Convert _id to string
        if "director" in movie:
            movie["director"] = str(movie["director"])  # Convert director ObjectId to string

        return movie

    except Exception as e:
        logging.error(f"Error retrieving movie by ID: {e}")
        raise HTTPException(status_code=500, detail="Internal Server Error")


@router.post("/", response_model=MovieOut)
async def create_movie(movie: Movie):
    try:
        
        # Convert the director field to ObjectId if it's a string
        if not ObjectId.is_valid(movie.director):
            raise HTTPException(status_code=400, detail="Invalid director ID")
        
        # Convert the director to ObjectId
        movie_dict = movie.dict()
        movie_dict["director"] = ObjectId(movie.director)

        # Insert the movie into the database
        new_movie = await movies_collection.insert_one(movie_dict)
        created_movie = await movies_collection.find_one({"_id": new_movie.inserted_id})

        # Convert the ObjectId to string for output
        created_movie["id"] = str(created_movie["_id"])
        created_movie["director"] = str(created_movie["director"])

        return created_movie
    except Exception as e:
        logging.error(f"Error creating movie: {e}")
        raise HTTPException(status_code=500, detail="Internal Server Error")


@router.put("/{movie_id}", response_model=MovieOut)
async def update_movie(movie_id: str, movie: Movie):
    try:
        # Validate movie_id
        if not ObjectId.is_valid(movie_id):
            raise HTTPException(status_code=400, detail="Invalid movie ID")

        movie_dict = movie.dict()
        # Convert the director field to ObjectId if it is present
        if "director" in movie_dict and movie_dict["director"]:
            if not ObjectId.is_valid(movie_dict["director"]):
                raise HTTPException(status_code=400, detail="Invalid director ID")
            movie_dict["director"] = ObjectId(movie_dict["director"])

        # Update the movie in the database
        result = await movies_collection.update_one(
            {"_id": ObjectId(movie_id)}, {"$set": movie_dict}
        )
        if result.modified_count == 0:
            raise HTTPException(status_code=404, detail="Movie not found")

        # Fetch and format the updated movie
        updated_movie = await movies_collection.find_one({"_id": ObjectId(movie_id)})
        updated_movie["id"] = str(updated_movie["_id"])
        if "director" in updated_movie:
            updated_movie["director"] = str(updated_movie["director"])

        return updated_movie
    except Exception as e:
        logging.error(f"Error updating movie: {e}")
        raise HTTPException(status_code=500, detail="Internal Server Error")



@router.delete("/{movie_id}")
async def delete_movie(movie_id: str):
    result = await movies_collection.delete_one({"_id": ObjectId(movie_id)})
    if result.deleted_count == 0:
        raise HTTPException(status_code=404, detail="Movie not found")
    return {"message": "Movie deleted successfully"}


@router.get("/name/search", response_model=List[MovieOut])
async def search_movies(query: str = Query(...)):
    logging.info(f"Searching for movies with query: {query}")
    
    try:
        regex_query = re.compile(query, re.IGNORECASE)  # Case-insensitive search
        
        # Search the movies collection using regex on title (you can extend this for other fields)
        movies = await movies_collection.find({"title": {"$regex": regex_query}}).to_list(None)

        # Pokud není nic nalezeno, jednoduše vrátíme prázdný seznam
        if not movies:
            logging.info(f"No movies found for query: {query}")
            return []  # Vracení prázdného seznamu místo vyvolání chyby

        # Format the movies for output
        formatted_movies = []
        for movie in movies:
            movie["id"] = str(movie["_id"])  # Convert _id to string
            if "director" in movie:
                movie["director"] = str(movie["director"])  # Convert director ObjectId to string
            formatted_movies.append(MovieOut(**movie))  # Pydantic model for validation

        return formatted_movies

    except Exception as e:
        logging.error(f"Error during movie search: {e}")
        raise HTTPException(status_code=500, detail=f"Internal Server Error: {e}")
    
    
@router.get("/director/{director_id}", response_model=List[MovieOut])
async def get_movies_by_director(director_id: str):
    try:
        # Validate the director_id and convert it to ObjectId
        if not ObjectId.is_valid(director_id):
            raise HTTPException(status_code=400, detail="Invalid director ID")
        
        director_object_id = ObjectId(director_id)
        
        # Query the movies collection for all movies with the given director ID
        movies = await movies_collection.find({"director": director_object_id}).to_list(100)  # Fetch up to 100 movies

        # If no movies are found, return an empty list
        if not movies:
            logging.info(f"No movies found for director with ID: {director_id}")
            return []  # Return an empty list instead of raising an error

        # Log the number of movies found for debugging purposes
        logging.info(f"Found {len(movies)} movies for director with ID: {director_id}")
        
        # Convert the MongoDB _id and director fields to strings for output
        formatted_movies = []
        for movie in movies:
            movie["id"] = str(movie["_id"])  # Convert _id to string
            movie["director"] = str(movie["director"])  # Convert director ObjectId to string
            formatted_movies.append(MovieOut(**movie))  # Pydantic model for validation

        return formatted_movies
    
    except Exception as e:
        logging.error(f"Error retrieving movies by director: {e}")
        raise HTTPException(status_code=500, detail=f"Internal Server Error: {e}")