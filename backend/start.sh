#!/bin/bash

echo "🚀 Starting DrShaadi Backend API..."

# Check if Python3 is available
if ! command -v python3 &> /dev/null; then
    echo "❌ Python3 is not installed or not in PATH"
    exit 1
fi

# Check if virtual environment exists
if [ ! -d "venv" ]; then
    echo "🔄 Creating virtual environment..."
    python3 -m venv venv
fi

# Activate virtual environment
echo "🔄 Activating virtual environment..."
source venv/bin/activate

# Install dependencies
echo "🔄 Installing dependencies..."
pip install -r requirements.txt

# Create .env file if it doesn't exist
if [ ! -f ".env" ]; then
    echo "🔄 Creating .env file..."
    cp env.example .env
    echo "📝 Please edit .env file with your configuration"
fi

# Start the application
echo "🚀 Starting FastAPI server..."
python3 run.py
