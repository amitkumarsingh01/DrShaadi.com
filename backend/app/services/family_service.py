from typing import List, Optional
from bson import ObjectId
from app.core.database import get_database
from app.core.security import generate_family_id
from app.models.family import Family, FamilyCreate, FamilyJoinRequest, FamilyJoinStatus
from app.models.user import User
from datetime import datetime
import logging

logger = logging.getLogger(__name__)


class FamilyService:
    def __init__(self):
        self.db = get_database()
        self.families_collection = self.db.families
        self.join_requests_collection = self.db.family_join_requests
        self.users_collection = self.db.users

    async def create_family(self, created_by: str) -> Family:
        """Create new family"""
        try:
            family_id = generate_family_id()
            
            family = Family(
                family_id=family_id,
                created_by=created_by,
                members=[created_by]
            )
            
            result = await self.families_collection.insert_one(family.dict(by_alias=True))
            family.id = str(result.inserted_id)
            
            # Update user with family_id
            await self.users_collection.update_one(
                {"_id": ObjectId(created_by)},
                {"$set": {"family_id": family_id}}
            )
            
            return family
            
        except Exception as e:
            logger.error(f"Error creating family: {e}")
            raise

    async def join_family(self, family_id: str, user_id: str) -> Family:
        """Join existing family"""
        try:
            # Check if family exists
            family_data = await self.families_collection.find_one({
                "family_id": family_id
            })
            
            if not family_data:
                raise ValueError("Family not found")
            
            # Add user to family members
            await self.families_collection.update_one(
                {"family_id": family_id},
                {
                    "$addToSet": {"members": user_id},
                    "$set": {"updated_at": datetime.utcnow()}
                }
            )
            
            # Update user with family_id
            await self.users_collection.update_one(
                {"_id": ObjectId(user_id)},
                {"$set": {"family_id": family_id}}
            )
            
            # Get updated family
            updated_family = await self.families_collection.find_one({
                "family_id": family_id
            })
            
            updated_family["id"] = str(updated_family["_id"])
            return Family(**updated_family)
            
        except Exception as e:
            logger.error(f"Error joining family: {e}")
            raise

    async def get_family_by_id(self, family_id: str) -> Optional[Family]:
        """Get family by family_id"""
        try:
            family_data = await self.families_collection.find_one({
                "family_id": family_id
            })
            
            if family_data:
                family_data["id"] = str(family_data["_id"])
                return Family(**family_data)
            
            return None
            
        except Exception as e:
            logger.error(f"Error getting family: {e}")
            return None

    async def get_family_by_user_id(self, user_id: str) -> Optional[Family]:
        """Get family by user ID"""
        try:
            user_data = await self.users_collection.find_one({
                "_id": ObjectId(user_id)
            })
            
            if not user_data or not user_data.get("family_id"):
                return None
            
            return await self.get_family_by_id(user_data["family_id"])
            
        except Exception as e:
            logger.error(f"Error getting family by user ID: {e}")
            return None

    async def leave_family(self, family_id: str, user_id: str) -> bool:
        """Leave family"""
        try:
            # Remove user from family members
            await self.families_collection.update_one(
                {"family_id": family_id},
                {
                    "$pull": {"members": user_id},
                    "$set": {"updated_at": datetime.utcnow()}
                }
            )
            
            # Remove family_id from user
            await self.users_collection.update_one(
                {"_id": ObjectId(user_id)},
                {"$unset": {"family_id": ""}}
            )
            
            return True
            
        except Exception as e:
            logger.error(f"Error leaving family: {e}")
            return False

    async def create_join_request(self, family_id: str, requester_id: str, requester_name: str) -> FamilyJoinRequest:
        """Create family join request"""
        try:
            join_request = FamilyJoinRequest(
                family_id=family_id,
                requester_id=requester_id,
                requester_name=requester_name
            )
            
            result = await self.join_requests_collection.insert_one(join_request.dict(by_alias=True))
            join_request.id = str(result.inserted_id)
            
            return join_request
            
        except Exception as e:
            logger.error(f"Error creating join request: {e}")
            raise

    async def get_join_requests(self, family_id: str) -> List[FamilyJoinRequest]:
        """Get family join requests"""
        try:
            cursor = self.join_requests_collection.find({
                "family_id": family_id,
                "status": FamilyJoinStatus.PENDING
            })
            
            requests = []
            async for request in cursor:
                request["id"] = str(request["_id"])
                requests.append(FamilyJoinRequest(**request))
            
            return requests
            
        except Exception as e:
            logger.error(f"Error getting join requests: {e}")
            return []

    async def process_join_request(self, request_id: str, action: str) -> bool:
        """Process join request (approve/reject)"""
        try:
            status = FamilyJoinStatus.APPROVED if action == "approve" else FamilyJoinStatus.REJECTED
            
            await self.join_requests_collection.update_one(
                {"_id": ObjectId(request_id)},
                {
                    "$set": {
                        "status": status,
                        "processed_at": datetime.utcnow()
                    }
                }
            )
            
            if action == "approve":
                # Get the request details
                request_data = await self.join_requests_collection.find_one({
                    "_id": ObjectId(request_id)
                })
                
                if request_data:
                    # Add user to family
                    await self.join_family(
                        request_data["family_id"],
                        request_data["requester_id"]
                    )
            
            return True
            
        except Exception as e:
            logger.error(f"Error processing join request: {e}")
            return False
