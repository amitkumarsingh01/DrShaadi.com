from pydantic import BaseModel, Field
from typing import Optional, List
from datetime import datetime
from enum import Enum


class ProfileType(str, Enum):
    MYSELF = "myself"
    FAMILY_MEMBER = "family_member"


class User(BaseModel):
    id: Optional[str] = Field(alias="_id")
    name: str
    email: Optional[str] = None
    mobile_number: str
    is_mobile_verified: bool = False
    family_id: Optional[str] = None
    profile_type: ProfileType = ProfileType.MYSELF
    profile_data: Optional[dict] = None
    created_at: datetime = Field(default_factory=datetime.utcnow)
    updated_at: datetime = Field(default_factory=datetime.utcnow)
    is_active: bool = True

    class Config:
        populate_by_name = True
        json_encoders = {
            datetime: lambda v: v.isoformat()
        }


class UserCreate(BaseModel):
    name: str
    mobile_number: str
    profile_type: ProfileType = ProfileType.MYSELF
    family_id: Optional[str] = None


class UserUpdate(BaseModel):
    name: Optional[str] = None
    email: Optional[str] = None
    profile_data: Optional[dict] = None
    is_mobile_verified: Optional[bool] = None


class UserResponse(BaseModel):
    id: str
    name: str
    email: Optional[str] = None
    mobile_number: str
    is_mobile_verified: bool
    family_id: Optional[str] = None
    profile_type: ProfileType
    profile_data: Optional[dict] = None
    created_at: datetime
    updated_at: datetime
    is_active: bool

    class Config:
        from_attributes = True
