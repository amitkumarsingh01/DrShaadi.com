from pydantic import BaseModel
from typing import Optional


class AddressData(BaseModel):
    location: str
    pincode: str
    grew_up_in: str
    residency_status: str


class CasteData(BaseModel):
    caste: Optional[str] = None
    subcaste: Optional[str] = None
    is_not_particular_about_caste: bool = False


class MaritalData(BaseModel):
    marital_status: str
    height: str
    diet: str


class ProfileData(BaseModel):
    address: Optional[AddressData] = None
    caste: Optional[CasteData] = None
    marital: Optional[MaritalData] = None


class ProfileUpdateRequest(BaseModel):
    user_id: str
    profile_data: ProfileData


class ProfileResponse(BaseModel):
    user_id: str
    profile_data: ProfileData
    completion_percentage: int
