from pydantic import BaseModel, Field
from typing import Optional
from datetime import datetime


class OTP(BaseModel):
    id: Optional[str] = Field(alias="_id")
    mobile_number: str
    otp: str
    expires_at: datetime
    attempts: int = 0
    is_verified: bool = False
    created_at: datetime = Field(default_factory=datetime.utcnow)

    class Config:
        populate_by_name = True
        json_encoders = {
            datetime: lambda v: v.isoformat()
        }


class OTPCreate(BaseModel):
    mobile_number: str


class OTPVerify(BaseModel):
    mobile_number: str
    otp: str


class OTPResponse(BaseModel):
    mobile_number: str
    expires_at: datetime
    attempts: int
    is_verified: bool

    class Config:
        from_attributes = True
