#!/bin/bash

# Comprehensive test suite for drun.sh
# Tests all commands and templates

set -e  # Exit on any error

run_test() {
  local test_name="$1"
  local command="$2"

  echo "Testing: $test_name"
  eval "$command"

  if [ $? -ne 0 ]; then
    echo "❌ Test failed: $test_name"
    exit 1
  else
    echo "✅ Test passed: $test_name"
  fi
}

create_test_dir() {
  local template="$1"

  TEST_DIR=$(mktemp -d)
  echo "Created test directory for $template: $TEST_DIR"

  # Copy necessary files
  cp drun.sh drun-tutorial.sh Dockerfile docker-compose.yml "$TEST_DIR"
  cd "$TEST_DIR"
  chmod +x ./drun.sh ./drun-tutorial.sh

  # Create app with specified template
  run_test "Creating $template app" "./drun-tutorial.sh $template"

  # Return the test directory
  echo "$TEST_DIR"
}

cleanup_test_dir() {
  local dir="$1"
  cd - > /dev/null
  rm -rf "$dir"
  echo "Cleaned up test directory: $dir"
}

echo "==== DRUN COMPREHENSIVE TEST SUITE ===="

# Test engine detection
run_test "Container engine detection" "./drun.sh engine"

# Test each template type
for template in "new:simple" "new:full" "new:tutorial" "quickstart"; do
  echo "==== Testing template: $template ===="

  TEST_DIR=$(create_test_dir "$template")

  # Test common commands
  run_test "Database creation" "./drun.sh db:create"
  run_test "Database migration" "./drun.sh db:migrate"
  run_test "Rails version check" "./drun.sh rails -v"

  # Test build command
  run_test "Container build" "./drun.sh build"

  # Clean up before next template
  cleanup_test_dir "$TEST_DIR"
done

echo "==== Testing container engine switching ===="
run_test "Switch to Docker" "./drun.sh force-docker engine"
run_test "Switch to Podman" "./drun.sh force-podman engine"

echo "All tests completed successfully! ✅"
