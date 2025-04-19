#!/bin/bash

# Universal test script for drun.sh
# This script tests the core functionality of drun.sh with either Docker or Podman
# Controlled by the FORCE_DOCKER environment variable

set -e  # Exit on any error

# Determine which engine we're testing
if [ -n "$FORCE_DOCKER" ]; then
  ENGINE="Docker"
else
  ENGINE="Podman"
fi

echo "==== DRUN $ENGINE TESTING SUITE ===="

echo "Testing container engine detection..."
# Check if the correct engine is detected
./drun.sh engine | grep -q "$ENGINE"
if [ $? -ne 0 ]; then
  echo "❌ $ENGINE engine detection failed"
  exit 1
else
  echo "✅ $ENGINE engine detected correctly"
fi

# Create a temporary directory for testing
TEST_DIR=$(mktemp -d)
echo "Created temporary test directory: $TEST_DIR"

# Copy necessary files to test directory
cp drun.sh drun-tutorial.sh Dockerfile docker-compose.yml "$TEST_DIR"
# Copy podman-compose.yml if it exists
[ -f podman-compose.yml ] && cp podman-compose.yml "$TEST_DIR" || true
cd "$TEST_DIR"

# Make scripts executable
chmod +x ./drun.sh ./drun-tutorial.sh

# Test building the container
echo "Testing container build with $ENGINE..."
./drun.sh build
if [ $? -ne 0 ]; then
  echo "❌ $ENGINE container build failed"
  exit 1
else
  echo "✅ $ENGINE container build successful"
fi

# Test creating a simple app
echo "Testing creating a simple app with $ENGINE..."
./drun-tutorial.sh new:simple
if [ $? -ne 0 ]; then
  echo "❌ Creating simple app with $ENGINE failed"
  exit 1
else
  echo "✅ Creating simple app with $ENGINE successful"
fi

# Test database commands
echo "Testing database creation with $ENGINE..."
./drun.sh db:create
if [ $? -ne 0 ]; then
  echo "❌ Database creation with $ENGINE failed"
  exit 1
else
  echo "✅ Database creation with $ENGINE successful"
fi

# Test Rails version check
echo "Testing Rails version check with $ENGINE..."
./drun.sh rails -v
if [ $? -ne 0 ]; then
  echo "❌ Rails version check with $ENGINE failed"
  exit 1
else
  echo "✅ Rails version check with $ENGINE successful"
fi

# Test db:migrate
echo "Testing db:migrate with $ENGINE..."
./drun.sh db:migrate
if [ $? -ne 0 ]; then
  echo "❌ db:migrate with $ENGINE failed"
  exit 1
else
  echo "✅ db:migrate with $ENGINE successful"
fi

# Test running a general command
echo "Testing running a custom command with $ENGINE..."
./drun.sh ls -la
if [ $? -ne 0 ]; then
  echo "❌ Custom command execution with $ENGINE failed"
  exit 1
else
  echo "✅ Custom command execution with $ENGINE successful"
fi

# Clean up
cd -
rm -rf "$TEST_DIR"
echo "Cleaned up test directory"

echo "All $ENGINE tests passed! ✅"
