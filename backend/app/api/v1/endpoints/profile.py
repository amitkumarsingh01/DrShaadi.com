from fastapi import APIRouter, HTTPException, Depends
from app.schemas.profile import ProfileUpdateRequest, ProfileResponse
from app.services.profile_service import ProfileService
from app.core.security import verify_token
from typing import Optional

router = APIRouter()


def get_current_user_id(token: str = Depends(verify_token)) -> str:
    """Get current user ID from token"""
    if not token:
        raise HTTPException(status_code=401, detail="Invalid authentication credentials")
    return token.get("user_id")


@router.post("/create", response_model=ProfileResponse)
async def create_profile(
    request: ProfileUpdateRequest,
    user_id: str = Depends(get_current_user_id)
):
    """Create or update user profile"""
    try:
        profile_service = ProfileService()
        success = await profile_service.update_profile(user_id, request.profile_data)
        
        if not success:
            raise HTTPException(status_code=500, detail="Failed to create profile")
        
        completion_percentage = await profile_service.get_profile_completion_percentage(user_id)
        
        return ProfileResponse(
            user_id=user_id,
            profile_data=request.profile_data,
            completion_percentage=completion_percentage
        )
    except HTTPException:
        raise
    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))


@router.put("/update", response_model=ProfileResponse)
async def update_profile(
    request: ProfileUpdateRequest,
    user_id: str = Depends(get_current_user_id)
):
    """Update user profile"""
    try:
        profile_service = ProfileService()
        success = await profile_service.update_profile(user_id, request.profile_data)
        
        if not success:
            raise HTTPException(status_code=500, detail="Failed to update profile")
        
        completion_percentage = await profile_service.get_profile_completion_percentage(user_id)
        
        return ProfileResponse(
            user_id=user_id,
            profile_data=request.profile_data,
            completion_percentage=completion_percentage
        )
    except HTTPException:
        raise
    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))


@router.get("/", response_model=ProfileResponse)
async def get_profile(user_id: str = Depends(get_current_user_id)):
    """Get user profile"""
    try:
        profile_service = ProfileService()
        profile_data = await profile_service.get_profile(user_id)
        completion_percentage = await profile_service.get_profile_completion_percentage(user_id)
        
        return ProfileResponse(
            user_id=user_id,
            profile_data=profile_data,
            completion_percentage=completion_percentage
        )
    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))


@router.delete("/")
async def delete_profile(user_id: str = Depends(get_current_user_id)):
    """Delete user profile"""
    try:
        profile_service = ProfileService()
        success = await profile_service.delete_profile(user_id)
        
        if not success:
            raise HTTPException(status_code=500, detail="Failed to delete profile")
        
        return {"message": "Profile deleted successfully"}
    except HTTPException:
        raise
    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))


@router.get("/completion")
async def get_profile_completion(user_id: str = Depends(get_current_user_id)):
    """Get profile completion percentage"""
    try:
        profile_service = ProfileService()
        completion_percentage = await profile_service.get_profile_completion_percentage(user_id)
        
        return {
            "user_id": user_id,
            "completion_percentage": completion_percentage
        }
    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))
