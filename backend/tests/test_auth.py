import pytest
from fastapi.testclient import TestClient
from app.main import app

client = TestClient(app)


def test_root():
    """Test root endpoint"""
    response = client.get("/")
    assert response.status_code == 200
    assert "message" in response.json()


def test_health_check():
    """Test health check endpoint"""
    response = client.get("/health")
    assert response.status_code == 200
    assert response.json()["status"] == "healthy"


def test_send_otp():
    """Test send OTP endpoint"""
    response = client.post(
        "/api/v1/auth/send-otp",
        json={"mobile_number": "9876543210"}
    )
    assert response.status_code == 200
    assert "mobile_number" in response.json()


def test_verify_otp_invalid():
    """Test verify OTP with invalid OTP"""
    response = client.post(
        "/api/v1/auth/verify-otp",
        json={"mobile_number": "9876543210", "otp": "0000"}
    )
    assert response.status_code == 400
