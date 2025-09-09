#!/usr/bin/env python3
"""
Setup script for DrShaadi Backend API
"""

import os
import subprocess
import sys


def run_command(command, description):
    """Run a command and handle errors"""
    print(f"🔄 {description}...")
    try:
        result = subprocess.run(command, shell=True, check=True, capture_output=True, text=True)
        print(f"✅ {description} completed successfully")
        return True
    except subprocess.CalledProcessError as e:
        print(f"❌ {description} failed: {e.stderr}")
        return False


def main():
    """Main setup function"""
    print("🚀 Setting up DrShaadi Backend API...")
    
    # Check if Python is available
    if not run_command("python3 --version", "Checking Python version"):
        print("❌ Python3 is not installed or not in PATH")
        sys.exit(1)
    
    # Create virtual environment
    if not run_command("python3 -m venv venv", "Creating virtual environment"):
        print("❌ Failed to create virtual environment")
        sys.exit(1)
    
    # Determine activation script based on OS
    if os.name == 'nt':  # Windows
        activate_script = "venv\\Scripts\\activate"
        pip_command = "venv\\Scripts\\pip"
    else:  # macOS/Linux
        activate_script = "source venv/bin/activate"
        pip_command = "venv/bin/pip"
    
    # Install dependencies
    if not run_command(f"{pip_command} install -r requirements.txt", "Installing dependencies"):
        print("❌ Failed to install dependencies")
        sys.exit(1)
    
    # Create .env file if it doesn't exist
    if not os.path.exists(".env"):
        if os.path.exists("env.example"):
            run_command("cp env.example .env", "Creating .env file from template")
            print("📝 Please edit .env file with your configuration")
        else:
            print("⚠️  env.example not found, please create .env file manually")
    
    print("\n🎉 Setup completed successfully!")
    print("\n📋 Next steps:")
    print("1. Edit .env file with your configuration")
    print("2. Start MongoDB (if running locally)")
    print("3. Run the application:")
    print("   - Windows: venv\\Scripts\\python run.py")
    print("   - macOS/Linux: source venv/bin/activate && python3 run.py")
    print("4. Visit http://localhost:8000/docs for API documentation")


if __name__ == "__main__":
    main()
