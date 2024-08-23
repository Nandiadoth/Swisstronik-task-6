#!/bin/bash

# Define the repository URL
REPO_URL="https://github.com/chinadizi/bunkie06"

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

# Run the deployment script and capture output
echo "Running the deployment script..."
DEPLOY_OUTPUT=$(npm run script ./scripts/deploy-6.ts)

# Extract the proxy target address (line 32 output) and save it to deployed-proxy.txt
PROXY_TARGET=$(echo "$DEPLOY_OUTPUT" | grep -oP '(?<=proxy.target: ).*')
echo "Proxy target address (deployed proxy): $PROXY_TARGET"
echo "$PROXY_TARGET" > deployed-proxy.txt

# Extract the implementation transaction hash URL (line 55 output) and save it to implementation.txt
UPGRADE_HASH=$(echo "$DEPLOY_OUTPUT" | grep -oP '(?<=upgrade.hash: ).*')
IMPLEMENTATION_URL="https://explorer-evm.testnet.swisstronik.com/tx/$UPGRADE_HASH"
echo "Implementation transaction URL: $IMPLEMENTATION_URL"
echo "$IMPLEMENTATION_URL" > implementation.txt

# Prompt for the contract address 1 for verification
read -p "Enter the Contract address 1 for verification: " CONTRACT_ADDRESS

# Run the contract verification command
echo "Verifying the contract on the Swisstronik network..."
npx hardhat verify --network swisstronik --contract contracts/Hello_swtr.sol:Swisstronik "$CONTRACT_ADDRESS"

# Remove the private key from the .env file
echo "Removing the private key from the .env file..."
sed -i 's|PRIVATE_KEY=.*||g' .env

# Final output
echo "👍👍 ALL DONE 👍👍"
echo ""
echo "Proxy target address saved to deployed-proxy.txt."
echo "Implementation transaction URL saved to implementation.txt."
echo ""
echo "Credit to AnonID.TOP for laying the groundwork 👏👏"
echo ""
echo "Join my Telegram channel for more updates: T.me/CryptoBunkie"
