#!/bin/bash

# Test script for drun.sh
# This script tests the core functionality of drun.sh and drun-tutorial.sh

set -e  # Exit on any error

echo "==== DRUN TESTING SUITE ===="
echo "Testing container engine detection..."

# Test container engine detection
./drun.sh engine
if [ $? -ne 0 ]; then
  echo "❌ Container engine detection failed"
  exit 1
else
  echo "✅ Container engine detection works"
fi

# Create a temporary directory for testing
TEST_DIR=$(mktemp -d)
echo "Created temporary test directory: $TEST_DIR"

# Copy necessary files to test directory
cp drun.sh drun-tutorial.sh Dockerfile docker-compose.yml "$TEST_DIR"
cd "$TEST_DIR"

# Make scripts executable
chmod +x ./drun.sh ./drun-tutorial.sh

# Test building the container
echo "Testing container build..."
./drun.sh build
if [ $? -ne 0 ]; then
  echo "❌ Container build failed"
  exit 1
else
  echo "✅ Container build successful"
fi

# Test creating a simple Rails app
echo "Testing simple app creation..."
./drun-tutorial.sh new:simple
if [ $? -ne 0 ]; then
  echo "❌ Simple app creation failed"
  exit 1
else
  echo "✅ Simple app creation successful"
fi

# Test database creation
echo "Testing database creation..."
./drun.sh db:create
if [ $? -ne 0 ]; then
  echo "❌ Database creation failed"
  exit 1
else
  echo "✅ Database creation successful"
fi

# Test running a custom command
echo "Testing custom command execution..."
./drun.sh rails -v
if [ $? -ne 0 ]; then
  echo "❌ Custom command execution failed"
  exit 1
else
  echo "✅ Custom command execution successful"
fi

# Clean up
cd -
rm -rf "$TEST_DIR"
echo "Cleaned up test directory"

echo "All tests passed! ✅"
