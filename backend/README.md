# DrShaadi Backend API

A FastAPI-based backend for the DrShaadi matrimonial services application.

## Features

- **Authentication**: OTP-based mobile verification
- **User Management**: User registration and profile management
- **Family Management**: Create and join family profiles
- **Profile Management**: Multi-step profile creation
- **MongoDB Integration**: Async MongoDB operations
- **JWT Authentication**: Secure token-based authentication
- **CORS Support**: Cross-origin resource sharing

## Project Structure

```
backend/
├── app/
│   ├── api/
│   │   └── v1/
│   │       ├── endpoints/
│   │       │   ├── auth.py
│   │       │   ├── family.py
│   │       │   └── profile.py
│   │       └── api.py
│   ├── core/
│   │   ├── config.py
│   │   ├── database.py
│   │   └── security.py
│   ├── models/
│   │   ├── user.py
│   │   ├── family.py
│   │   └── otp.py
│   ├── schemas/
│   │   ├── auth.py
│   │   ├── family.py
│   │   └── profile.py
│   ├── services/
│   │   ├── auth_service.py
│   │   ├── family_service.py
│   │   └── profile_service.py
│   └── main.py
├── tests/
├── requirements.txt
├── env.example
└── README.md
```

## Setup Instructions

### 1. Prerequisites

- Python 3.8+
- MongoDB (local or cloud)
- pip or pipenv

### 2. Install Dependencies

```bash
# Create virtual environment
python -m venv venv

# Activate virtual environment
# On Windows:
venv\Scripts\activate
# On macOS/Linux:
source venv/bin/activate

# Install dependencies
pip install -r requirements.txt
```

### 3. Environment Configuration

```bash
# Copy environment file
cp env.example .env

# Edit .env file with your configuration
```

### 4. MongoDB Setup

```bash
# Start MongoDB (if running locally)
mongod

# Or use MongoDB Atlas for cloud database
```

### 5. Run the Application

```bash
# Development mode
python -m app.main

# Or using uvicorn directly
uvicorn app.main:app --reload --host 0.0.0.0 --port 8000
```

## API Endpoints

### Authentication
- `POST /api/v1/auth/send-otp` - Send OTP to mobile number
- `POST /api/v1/auth/verify-otp` - Verify OTP
- `POST /api/v1/auth/register` - Register new user
- `POST /api/v1/auth/login` - Login user
- `GET /api/v1/auth/me` - Get current user details

### Family Management
- `POST /api/v1/family/create` - Create new family
- `POST /api/v1/family/join` - Join existing family
- `GET /api/v1/family/my-family` - Get current user's family
- `GET /api/v1/family/{family_id}` - Get family by ID
- `POST /api/v1/family/leave` - Leave current family
- `GET /api/v1/family/{family_id}/requests` - Get family join requests
- `POST /api/v1/family/requests/{request_id}/process` - Process join request

### Profile Management
- `POST /api/v1/profile/create` - Create user profile
- `PUT /api/v1/profile/update` - Update user profile
- `GET /api/v1/profile/` - Get user profile
- `DELETE /api/v1/profile/` - Delete user profile
- `GET /api/v1/profile/completion` - Get profile completion percentage

## API Documentation

Once the server is running, visit:
- **Swagger UI**: http://localhost:8000/docs
- **ReDoc**: http://localhost:8000/redoc

## Database Schema

### Users Collection
```json
{
  "_id": "ObjectId",
  "name": "string",
  "email": "string",
  "mobile_number": "string",
  "is_mobile_verified": "boolean",
  "family_id": "string",
  "profile_type": "string",
  "profile_data": "object",
  "created_at": "datetime",
  "updated_at": "datetime",
  "is_active": "boolean"
}
```

### Families Collection
```json
{
  "_id": "ObjectId",
  "family_id": "string",
  "created_by": "string",
  "members": ["string"],
  "created_at": "datetime",
  "updated_at": "datetime",
  "is_active": "boolean"
}
```

### OTPs Collection
```json
{
  "_id": "ObjectId",
  "mobile_number": "string",
  "otp": "string",
  "expires_at": "datetime",
  "attempts": "number",
  "is_verified": "boolean",
  "created_at": "datetime"
}
```

## Testing

```bash
# Run tests
pytest

# Run tests with coverage
pytest --cov=app
```

## Development

### Code Style
- Follow PEP 8
- Use type hints
- Add docstrings for functions and classes

### Adding New Endpoints
1. Create endpoint in `app/api/v1/endpoints/`
2. Add service methods in `app/services/`
3. Define schemas in `app/schemas/`
4. Update API router in `app/api/v1/api.py`

## Deployment

### Using Docker
```bash
# Build image
docker build -t drshaadi-backend .

# Run container
docker run -p 8000:8000 drshaadi-backend
```

### Using Gunicorn
```bash
gunicorn app.main:app -w 4 -k uvicorn.workers.UvicornWorker
```

## Environment Variables

| Variable | Description | Default |
|----------|-------------|---------|
| MONGODB_URL | MongoDB connection string | mongodb://localhost:27017 |
| DATABASE_NAME | Database name | drshaadi |
| SECRET_KEY | JWT secret key | your-secret-key-change-in-production |
| OTP_EXPIRE_MINUTES | OTP expiration time | 5 |
| DEBUG | Debug mode | True |
