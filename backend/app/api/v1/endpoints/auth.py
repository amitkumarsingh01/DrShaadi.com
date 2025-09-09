from fastapi import APIRouter, HTTPException, Depends
from app.schemas.auth import (
    OTPRequest, OTPResponse, OTPVerifyRequest, 
    RegisterRequest, LoginRequest, Token
)
from app.services.auth_service import AuthService
from app.core.security import verify_token
from typing import Optional

router = APIRouter()


def get_current_user_id(token: str = Depends(verify_token)) -> Optional[str]:
    """Get current user ID from token"""
    if not token:
        raise HTTPException(status_code=401, detail="Invalid authentication credentials")
    return token.get("user_id")


@router.post("/send-otp", response_model=OTPResponse)
async def send_otp(request: OTPRequest):
    """Send OTP to mobile number"""
    try:
        auth_service = AuthService()
        result = await auth_service.send_otp(request.mobile_number)
        return OTPResponse(**result)
    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))


@router.post("/verify-otp")
async def verify_otp(request: OTPVerifyRequest):
    """Verify OTP"""
    try:
        auth_service = AuthService()
        is_valid = await auth_service.verify_otp(request.mobile_number, request.otp)
        
        if not is_valid:
            raise HTTPException(status_code=400, detail="Invalid OTP")
        
        return {"verified": True, "message": "OTP verified successfully"}
    except HTTPException:
        raise
    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))


@router.post("/register", response_model=Token)
async def register(request: RegisterRequest):
    """Register new user"""
    try:
        auth_service = AuthService()
        
        # Check if user already exists
        existing_user = await auth_service.get_user_by_mobile(request.mobile_number)
        if existing_user:
            raise HTTPException(status_code=400, detail="User already exists")
        
        # Create user
        user = await auth_service.create_user(request)
        
        # Create access token
        access_token = await auth_service.create_access_token_for_user(user)
        
        return Token(access_token=access_token)
    except HTTPException:
        raise
    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))


@router.post("/login", response_model=Token)
async def login(request: LoginRequest):
    """Login user"""
    try:
        auth_service = AuthService()
        
        # Get user
        user = await auth_service.get_user_by_mobile(request.mobile_number)
        if not user:
            raise HTTPException(status_code=404, detail="User not found")
        
        # Create access token
        access_token = await auth_service.create_access_token_for_user(user)
        
        return Token(access_token=access_token)
    except HTTPException:
        raise
    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))


@router.get("/me")
async def get_current_user(user_id: str = Depends(get_current_user_id)):
    """Get current user details"""
    try:
        auth_service = AuthService()
        user = await auth_service.get_user_by_id(user_id)
        
        if not user:
            raise HTTPException(status_code=404, detail="User not found")
        
        return user
    except HTTPException:
        raise
    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))
