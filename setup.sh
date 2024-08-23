#!/bin/bash

# Define the repository URL
REPO_URL="https://github.com/cryptobunkie/task6test"

# Clone the repository
echo "Cloning the repository from $REPO_URL..."
git clone $REPO_URL

# Extract the repo name from the URL
REPO_NAME=$(basename $REPO_URL .git)

# Navigate into the repository directory
echo "Navigating into the repository directory..."
cd $REPO_NAME

# Install npm dependencies
echo "Installing npm dependencies..."
npm install

echo "Setup completed!"

echo "Now, add your private key to the .env file in the task6test folder. Paste the key inside the quotation marks"
