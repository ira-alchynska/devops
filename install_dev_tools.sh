#!/bin/bash
# Script to install Docker, Docker Compose, Python, and Django

echo "Starting installation script..."

# Function to check if a command exists
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# ---- Install Docker ----
if command_exists docker; then
    echo "Docker is already installed ✅"
else
    echo "Installing Docker..."
    sudo apt-get update -y
    sudo apt-get install -y ca-certificates curl gnupg lsb-release
    sudo mkdir -p /etc/apt/keyrings
    curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
    echo \
      "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
      $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
    sudo apt-get update -y
    sudo apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
    echo "Docker installed successfully ✅"
fi

# ---- Install Docker Compose ----
if command_exists docker-compose; then
    echo "Docker Compose is already installed ✅"
else
    echo "Installing Docker Compose..."
    sudo apt-get install -y docker-compose
    echo "Docker Compose installed successfully ✅"
fi

# ---- Install Python ----
if command_exists python3; then
    echo "Python is already installed ✅"
else
    echo "Installing Python..."
    sudo apt-get update -y
    sudo apt-get install -y python3 python3-pip
    echo "Python installed successfully ✅"
fi

# ---- Install Django ----
if python3 -m django --version >/dev/null 2>&1; then
    echo "Django is already installed ✅"
else
    echo "Installing Django..."
    pip3 install django
    echo "Django installed successfully ✅"
fi

echo "✅ All tools are installed and up to date!"

