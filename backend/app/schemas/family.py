from pydantic import BaseModel
from typing import List, Optional
from app.models.family import FamilyJoinStatus


class FamilyCreateRequest(BaseModel):
    created_by: str


class FamilyJoinRequest(BaseModel):
    family_id: str
    user_id: str


class FamilyResponse(BaseModel):
    id: str
    family_id: str
    created_by: str
    members: List[str]
    created_at: str
    updated_at: str
    is_active: bool


class FamilyJoinRequestResponse(BaseModel):
    id: str
    family_id: str
    requester_id: str
    requester_name: str
    status: FamilyJoinStatus
    requested_at: str
    processed_at: Optional[str] = None


class FamilyJoinRequestAction(BaseModel):
    action: str  # "approve" or "reject"
