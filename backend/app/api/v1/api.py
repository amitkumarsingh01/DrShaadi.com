from fastapi import APIRouter
from app.api.v1.endpoints import auth, family, profile

api_router = APIRouter()

api_router.include_router(auth.router, prefix="/auth", tags=["authentication"])
api_router.include_router(family.router, prefix="/family", tags=["family"])
api_router.include_router(profile.router, prefix="/profile", tags=["profile"])
