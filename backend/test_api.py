#!/usr/bin/env python3
"""
Test script to verify API endpoints
"""

import requests
import json

BASE_URL = "http://localhost:8000/api/v1"

def test_health():
    """Test health endpoint"""
    try:
        response = requests.get("http://localhost:8000/health")
        print(f"Health check: {response.status_code} - {response.json()}")
        return response.status_code == 200
    except Exception as e:
        print(f"Health check failed: {e}")
        return False

def test_send_otp():
    """Test send OTP endpoint"""
    try:
        data = {"mobile_number": "9876543210"}
        response = requests.post(f"{BASE_URL}/auth/send-otp", json=data)
        print(f"Send OTP: {response.status_code} - {response.json()}")
        return response.status_code == 200
    except Exception as e:
        print(f"Send OTP failed: {e}")
        return False

def test_verify_otp():
    """Test verify OTP endpoint"""
    try:
        data = {"mobile_number": "9876543210", "otp": "1234"}
        response = requests.post(f"{BASE_URL}/auth/verify-otp", json=data)
        print(f"Verify OTP: {response.status_code} - {response.json()}")
        return response.status_code == 200
    except Exception as e:
        print(f"Verify OTP failed: {e}")
        return False

def test_register():
    """Test register endpoint"""
    try:
        data = {
            "name": "Test User",
            "mobile_number": "9876543210",
            "profile_type": "myself"
        }
        response = requests.post(f"{BASE_URL}/auth/register", json=data)
        print(f"Register: {response.status_code} - {response.json()}")
        return response.status_code == 200
    except Exception as e:
        print(f"Register failed: {e}")
        return False

def main():
    """Run all tests"""
    print("🧪 Testing DrShaadi API...")
    
    tests = [
        ("Health Check", test_health),
        ("Send OTP", test_send_otp),
        ("Verify OTP", test_verify_otp),
        ("Register User", test_register),
    ]
    
    passed = 0
    total = len(tests)
    
    for test_name, test_func in tests:
        print(f"\n🔍 {test_name}...")
        if test_func():
            print(f"✅ {test_name} passed")
            passed += 1
        else:
            print(f"❌ {test_name} failed")
    
    print(f"\n📊 Results: {passed}/{total} tests passed")
    
    if passed == total:
        print("🎉 All tests passed! API is working correctly.")
    else:
        print("⚠️  Some tests failed. Check the backend server.")

if __name__ == "__main__":
    main()
