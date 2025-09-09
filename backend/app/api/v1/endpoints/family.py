from fastapi import APIRouter, HTTPException, Depends
from app.schemas.family import (
    FamilyCreateRequest, FamilyJoinRequest, FamilyResponse,
    FamilyJoinRequestResponse, FamilyJoinRequestAction
)
from app.services.family_service import FamilyService
from app.core.security import verify_token
from typing import List

router = APIRouter()


def get_current_user_id(token: str = Depends(verify_token)) -> str:
    """Get current user ID from token"""
    if not token:
        raise HTTPException(status_code=401, detail="Invalid authentication credentials")
    return token.get("user_id")


@router.post("/create", response_model=FamilyResponse)
async def create_family(
    request: FamilyCreateRequest,
    user_id: str = Depends(get_current_user_id)
):
    """Create new family"""
    try:
        family_service = FamilyService()
        family = await family_service.create_family(user_id)
        
        return FamilyResponse(
            id=family.id,
            family_id=family.family_id,
            created_by=family.created_by,
            members=family.members,
            created_at=family.created_at.isoformat(),
            updated_at=family.updated_at.isoformat(),
            is_active=family.is_active
        )
    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))


@router.post("/join", response_model=FamilyResponse)
async def join_family(
    request: FamilyJoinRequest,
    user_id: str = Depends(get_current_user_id)
):
    """Join existing family"""
    try:
        family_service = FamilyService()
        family = await family_service.join_family(request.family_id, user_id)
        
        return FamilyResponse(
            id=family.id,
            family_id=family.family_id,
            created_by=family.created_by,
            members=family.members,
            created_at=family.created_at.isoformat(),
            updated_at=family.updated_at.isoformat(),
            is_active=family.is_active
        )
    except ValueError as e:
        raise HTTPException(status_code=404, detail=str(e))
    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))


@router.get("/my-family", response_model=FamilyResponse)
async def get_my_family(user_id: str = Depends(get_current_user_id)):
    """Get current user's family"""
    try:
        family_service = FamilyService()
        family = await family_service.get_family_by_user_id(user_id)
        
        if not family:
            raise HTTPException(status_code=404, detail="No family found")
        
        return FamilyResponse(
            id=family.id,
            family_id=family.family_id,
            created_by=family.created_by,
            members=family.members,
            created_at=family.created_at.isoformat(),
            updated_at=family.updated_at.isoformat(),
            is_active=family.is_active
        )
    except HTTPException:
        raise
    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))


@router.get("/{family_id}", response_model=FamilyResponse)
async def get_family(family_id: str, user_id: str = Depends(get_current_user_id)):
    """Get family by ID"""
    try:
        family_service = FamilyService()
        family = await family_service.get_family_by_id(family_id)
        
        if not family:
            raise HTTPException(status_code=404, detail="Family not found")
        
        return FamilyResponse(
            id=family.id,
            family_id=family.family_id,
            created_by=family.created_by,
            members=family.members,
            created_at=family.created_at.isoformat(),
            updated_at=family.updated_at.isoformat(),
            is_active=family.is_active
        )
    except HTTPException:
        raise
    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))


@router.post("/leave")
async def leave_family(user_id: str = Depends(get_current_user_id)):
    """Leave current family"""
    try:
        family_service = FamilyService()
        family = await family_service.get_family_by_user_id(user_id)
        
        if not family:
            raise HTTPException(status_code=404, detail="No family to leave")
        
        success = await family_service.leave_family(family.family_id, user_id)
        
        if not success:
            raise HTTPException(status_code=500, detail="Failed to leave family")
        
        return {"message": "Successfully left family"}
    except HTTPException:
        raise
    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))


@router.get("/{family_id}/requests", response_model=List[FamilyJoinRequestResponse])
async def get_join_requests(
    family_id: str,
    user_id: str = Depends(get_current_user_id)
):
    """Get family join requests"""
    try:
        family_service = FamilyService()
        
        # Check if user is part of the family
        family = await family_service.get_family_by_user_id(user_id)
        if not family or family.family_id != family_id:
            raise HTTPException(status_code=403, detail="Not authorized to view requests")
        
        requests = await family_service.get_join_requests(family_id)
        
        return [
            FamilyJoinRequestResponse(
                id=req.id,
                family_id=req.family_id,
                requester_id=req.requester_id,
                requester_name=req.requester_name,
                status=req.status,
                requested_at=req.requested_at.isoformat(),
                processed_at=req.processed_at.isoformat() if req.processed_at else None
            )
            for req in requests
        ]
    except HTTPException:
        raise
    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))


@router.post("/requests/{request_id}/process")
async def process_join_request(
    request_id: str,
    action: FamilyJoinRequestAction,
    user_id: str = Depends(get_current_user_id)
):
    """Process join request (approve/reject)"""
    try:
        family_service = FamilyService()
        success = await family_service.process_join_request(request_id, action.action)
        
        if not success:
            raise HTTPException(status_code=500, detail="Failed to process request")
        
        return {"message": f"Request {action.action}ed successfully"}
    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))
