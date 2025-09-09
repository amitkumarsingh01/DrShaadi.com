from pydantic import BaseModel, Field
from typing import Optional
from app.models.user import ProfileType


class Token(BaseModel):
    access_token: str
    token_type: str = "bearer"


class TokenData(BaseModel):
    user_id: Optional[str] = None


class LoginRequest(BaseModel):
    mobile_number: str


class RegisterRequest(BaseModel):
    name: str
    mobile_number: str
    profile_type: ProfileType = ProfileType.MYSELF
    family_id: Optional[str] = None


class OTPRequest(BaseModel):
    mobile_number: str


class OTPVerifyRequest(BaseModel):
    mobile_number: str
    otp: str


class OTPResponse(BaseModel):
    mobile_number: str
    expires_at: str
    message: str = "OTP sent successfully"
