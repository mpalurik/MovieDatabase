from fastapi import APIRouter, HTTPException, Query
from typing import List
from models.director import Director, DirectorOut
from db import directors_collection
from bson import ObjectId
import logging

router = APIRouter()


@router.get("/", response_model=List[DirectorOut])
async def get_directors():
    directors = await directors_collection.find().to_list(None)
    return [{"id": str(director["_id"]), **director} for director in directors]


@router.get("/{director_id}", response_model=DirectorOut)
async def get_director(director_id: str):
    director = await directors_collection.find_one({"_id": ObjectId(director_id)})
    if not director:
        raise HTTPException(status_code=404, detail="Director not found")
    return {"id": str(director["_id"]), **director}


@router.post("/", response_model=List[DirectorOut])
async def create_directors(directors: List[Director]):
    directors_data = [director.dict() for director in directors]
    result = await directors_collection.insert_many(directors_data)
    
    created_directors = await directors_collection.find(
        {"_id": {"$in": result.inserted_ids}}
    ).to_list(length=len(result.inserted_ids))
    
    # Vraťte seznam vytvořených režisérů
    return [
        {"id": str(director["_id"]), **director} for director in created_directors
    ]

@router.delete("/bulk")
async def delete_multiple_directors(director_ids: list[str]):
    object_ids = [ObjectId(director_id) for director_id in director_ids]
    result = await directors_collection.delete_many({"_id": {"$in": object_ids}})
    
    if result.deleted_count == 0:
        raise HTTPException(status_code=404, detail="No directors found to delete")
    
    return {"message": f"{result.deleted_count} directors deleted successfully"}