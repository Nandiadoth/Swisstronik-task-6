#!/bin/bash

# Define the repository URL
REPO_URL="https://github.com/cryptobunkie/swtr06"

# Create a temporary directory to clone the repository
TEMP_DIR=$(mktemp -d)

# Clone the repository into the temporary directory
echo "Cloning the repository from $REPO_URL into a temporary directory..."
git clone $REPO_URL "$TEMP_DIR"

# Copy the contents of the cloned repository to the root of the Codespace
echo "Copying the contents to the root directory..."
cp -rT "$TEMP_DIR" .

# Remove the temporary directory
rm -rf "$TEMP_DIR"

# Install npm dependencies
echo "Installing npm dependencies..."
npm install

# Prompt for the private key
read -p "Enter your private key: " PRIVATE_KEY

# Update the .env file with the private key
if [ -f .env ]; then
  echo "Updating .env file with the provided private key..."
  sed -i "s|PRIVATE_KEY=\"\"|PRIVATE_KEY=\"$PRIVATE_KEY\"|g" .env
else
  echo "PRIVATE_KEY=\"$PRIVATE_KEY\"" > .env
  echo ".env file created and updated."
fi

# Run the deployment script
echo "Running the deployment script..."
npm run script ./scripts/deploy-6.ts

# Prompt for the contract verification
read -p "Enter the contract address 1 for verification: " CONTRACT_ADDRESS

# Run the contract verification command
echo "Verifying the contract on the Swisstronik network..."
npx hardhat verify --network swisstronik --contract contracts/Hello_swtr.sol:Swisstronik "$CONTRACT_ADDRESS"

# Remove the private key inside the quotation marks in the .env file
echo "Removing the private key from the .env file..."
sed -i 's|PRIVATE_KEY="[^"]*"|PRIVATE_KEY=""|g' .env

# Final output
echo ""
echo "👍👍 ALL DONE 👍👍"
echo ""
echo "Credit to AnonID.TOP for laying the groundwork 👏👏"
echo ""
echo "Join my Telegram channel for more updates: https://t.me/CryptoBunkie"
echo ""
