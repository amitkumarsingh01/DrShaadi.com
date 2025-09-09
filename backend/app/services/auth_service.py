from datetime import datetime, timedelta
from typing import Optional
from bson import ObjectId
from app.core.database import get_database
from app.core.security import generate_otp, create_access_token
from app.models.user import User, UserCreate, ProfileType
from app.models.otp import OTP, OTPCreate, OTPVerify
from app.core.config import settings
import logging

logger = logging.getLogger(__name__)


class AuthService:
    def __init__(self):
        self.db = get_database()
        self.users_collection = self.db.users
        self.otp_collection = self.db.otps

    async def send_otp(self, mobile_number: str) -> dict:
        """Send OTP to mobile number"""
        try:
            # Generate OTP (using default 1234 for testing)
            otp_code = "1234"  # generate_otp(settings.OTP_LENGTH)
            expires_at = datetime.utcnow() + timedelta(minutes=settings.OTP_EXPIRE_MINUTES)
            
            # Check if OTP already exists for this mobile number
            existing_otp = await self.otp_collection.find_one({
                "mobile_number": mobile_number,
                "is_verified": False
            })
            
            if existing_otp:
                # Update existing OTP
                await self.otp_collection.update_one(
                    {"_id": existing_otp["_id"]},
                    {
                        "$set": {
                            "otp": otp_code,
                            "expires_at": expires_at,
                            "attempts": 0,
                            "created_at": datetime.utcnow()
                        }
                    }
                )
            else:
                # Create new OTP
                otp_data = OTP(
                    mobile_number=mobile_number,
                    otp=otp_code,
                    expires_at=expires_at
                )
                await self.otp_collection.insert_one(otp_data.dict(by_alias=True))
            
            # In production, send SMS here using Twilio or similar service
            logger.info(f"OTP for {mobile_number}: {otp_code}")
            
            return {
                "mobile_number": mobile_number,
                "expires_at": expires_at.isoformat(),
                "message": "OTP sent successfully"
            }
            
        except Exception as e:
            logger.error(f"Error sending OTP: {e}")
            raise

    async def verify_otp(self, mobile_number: str, otp: str) -> bool:
        """Verify OTP"""
        try:
            otp_record = await self.otp_collection.find_one({
                "mobile_number": mobile_number,
                "otp": otp,
                "is_verified": False
            })
            
            if not otp_record:
                return False
            
            # Check if OTP is expired
            if datetime.utcnow() > otp_record["expires_at"]:
                return False
            
            # Check attempts
            if otp_record["attempts"] >= settings.MAX_OTP_ATTEMPTS:
                return False
            
            # Mark OTP as verified
            await self.otp_collection.update_one(
                {"_id": otp_record["_id"]},
                {"$set": {"is_verified": True}}
            )
            
            return True
            
        except Exception as e:
            logger.error(f"Error verifying OTP: {e}")
            return False

    async def create_user(self, user_data: UserCreate) -> User:
        """Create new user"""
        try:
            user = User(
                name=user_data.name,
                mobile_number=user_data.mobile_number,
                profile_type=user_data.profile_type,
                family_id=user_data.family_id,
                is_mobile_verified=True
            )
            
            result = await self.users_collection.insert_one(user.dict(by_alias=True))
            user.id = str(result.inserted_id)
            
            return user
            
        except Exception as e:
            logger.error(f"Error creating user: {e}")
            raise

    async def get_user_by_mobile(self, mobile_number: str) -> Optional[User]:
        """Get user by mobile number"""
        try:
            user_data = await self.users_collection.find_one({
                "mobile_number": mobile_number
            })
            
            if user_data:
                user_data["id"] = str(user_data["_id"])
                return User(**user_data)
            
            return None
            
        except Exception as e:
            logger.error(f"Error getting user: {e}")
            return None

    async def get_user_by_id(self, user_id: str) -> Optional[User]:
        """Get user by ID"""
        try:
            user_data = await self.users_collection.find_one({
                "_id": ObjectId(user_id)
            })
            
            if user_data:
                user_data["id"] = str(user_data["_id"])
                return User(**user_data)
            
            return None
            
        except Exception as e:
            logger.error(f"Error getting user by ID: {e}")
            return None

    async def create_access_token_for_user(self, user: User) -> str:
        """Create access token for user"""
        token_data = {
            "user_id": user.id,
            "mobile_number": user.mobile_number
        }
        return create_access_token(token_data)
