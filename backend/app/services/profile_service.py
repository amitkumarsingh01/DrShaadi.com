from typing import Optional
from bson import ObjectId
from app.core.database import get_database
from app.models.user import User
from app.schemas.profile import ProfileData, ProfileUpdateRequest
from datetime import datetime
import logging

logger = logging.getLogger(__name__)


class ProfileService:
    def __init__(self):
        self.db = get_database()
        self.users_collection = self.db.users

    async def update_profile(self, user_id: str, profile_data: ProfileData) -> bool:
        """Update user profile data"""
        try:
            await self.users_collection.update_one(
                {"_id": ObjectId(user_id)},
                {
                    "$set": {
                        "profile_data": profile_data.dict(),
                        "updated_at": datetime.utcnow()
                    }
                }
            )
            
            return True
            
        except Exception as e:
            logger.error(f"Error updating profile: {e}")
            return False

    async def get_profile(self, user_id: str) -> Optional[ProfileData]:
        """Get user profile data"""
        try:
            user_data = await self.users_collection.find_one({
                "_id": ObjectId(user_id)
            })
            
            if user_data and user_data.get("profile_data"):
                return ProfileData(**user_data["profile_data"])
            
            return None
            
        except Exception as e:
            logger.error(f"Error getting profile: {e}")
            return None

    async def get_profile_completion_percentage(self, user_id: str) -> int:
        """Calculate profile completion percentage"""
        try:
            profile_data = await self.get_profile(user_id)
            
            if not profile_data:
                return 0
            
            completed_fields = 0
            total_fields = 9
            
            # Check address fields
            if profile_data.address:
                if profile_data.address.location:
                    completed_fields += 1
                if profile_data.address.pincode:
                    completed_fields += 1
                if profile_data.address.grew_up_in:
                    completed_fields += 1
                if profile_data.address.residency_status:
                    completed_fields += 1
            
            # Check caste fields
            if profile_data.caste:
                if profile_data.caste.is_not_particular_about_caste or profile_data.caste.caste:
                    completed_fields += 1
                if profile_data.caste.subcaste:
                    completed_fields += 1
            
            # Check marital fields
            if profile_data.marital:
                if profile_data.marital.marital_status:
                    completed_fields += 1
                if profile_data.marital.height:
                    completed_fields += 1
                if profile_data.marital.diet:
                    completed_fields += 1
            
            return int((completed_fields / total_fields) * 100)
            
        except Exception as e:
            logger.error(f"Error calculating profile completion: {e}")
            return 0

    async def delete_profile(self, user_id: str) -> bool:
        """Delete user profile data"""
        try:
            await self.users_collection.update_one(
                {"_id": ObjectId(user_id)},
                {
                    "$unset": {"profile_data": ""},
                    "$set": {"updated_at": datetime.utcnow()}
                }
            )
            
            return True
            
        except Exception as e:
            logger.error(f"Error deleting profile: {e}")
            return False
