from pydantic import BaseModel, Field
from typing import Optional, List
from datetime import datetime
from enum import Enum


class FamilyJoinStatus(str, Enum):
    PENDING = "pending"
    APPROVED = "approved"
    REJECTED = "rejected"


class Family(BaseModel):
    id: Optional[str] = Field(alias="_id")
    family_id: str
    created_by: str
    members: List[str] = []
    created_at: datetime = Field(default_factory=datetime.utcnow)
    updated_at: datetime = Field(default_factory=datetime.utcnow)
    is_active: bool = True

    class Config:
        populate_by_name = True
        json_encoders = {
            datetime: lambda v: v.isoformat()
        }


class FamilyCreate(BaseModel):
    created_by: str


class FamilyJoinRequest(BaseModel):
    id: Optional[str] = Field(alias="_id")
    family_id: str
    requester_id: str
    requester_name: str
    status: FamilyJoinStatus = FamilyJoinStatus.PENDING
    requested_at: datetime = Field(default_factory=datetime.utcnow)
    processed_at: Optional[datetime] = None

    class Config:
        populate_by_name = True
        json_encoders = {
            datetime: lambda v: v.isoformat()
        }


class FamilyResponse(BaseModel):
    id: str
    family_id: str
    created_by: str
    members: List[str]
    created_at: datetime
    updated_at: datetime
    is_active: bool

    class Config:
        from_attributes = True


class FamilyJoinRequestResponse(BaseModel):
    id: str
    family_id: str
    requester_id: str
    requester_name: str
    status: FamilyJoinStatus
    requested_at: datetime
    processed_at: Optional[datetime] = None

    class Config:
        from_attributes = True
