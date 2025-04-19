#!/bin/sh

set -e

# Detect container engine (Docker or Podman)
if command -v podman >/dev/null 2>&1 && [ -z "$FORCE_DOCKER" ]; then
  CONTAINER_ENGINE="podman"
  COMPOSE_CMD="podman-compose"
  # Check if podman-compose is available, use podman play kube as fallback
  if ! command -v podman-compose >/dev/null 2>&1; then
    if command -v podman-compose >/dev/null 2>&1; then
      COMPOSE_CMD="podman-compose"
    else
      echo "Warning: podman-compose not found. Please install it for better experience."
      echo "Defaulting to docker-compose..."
      COMPOSE_CMD="docker-compose"
    fi
  fi
else
  CONTAINER_ENGINE="docker"
  COMPOSE_CMD="docker-compose"
fi

echo "Using container engine: $CONTAINER_ENGINE with compose: $COMPOSE_CMD"

# Only execute the main case statement if the script is run directly
# This allows the script to be sourced by other scripts
if [ "$0" = "$BASH_SOURCE" ] || [ "$0" = "./drun.sh" ]; then
  case "$1" in
    "engine")
      echo "Current container engine: $CONTAINER_ENGINE"
      echo "Current compose command: $COMPOSE_CMD"
      ;;
    "force-docker")
      export FORCE_DOCKER=1
      echo "Forcing Docker for this session"
      exec $0 "${@:2}"
      ;;
    "force-podman")
      export FORCE_DOCKER=
      echo "Forcing Podman for this session"
      exec $0 "${@:2}"
      ;;
    "serve")
      $COMPOSE_CMD up
      ;;
    "build")
      $COMPOSE_CMD build
      ;;
    "console")
      $COMPOSE_CMD run --rm rails ./bin/rails console
      ;;
    "db:setup")
      $COMPOSE_CMD run --rm rails ./bin/rails db:setup
      ;;
    "db:migrate")
      $COMPOSE_CMD run --rm rails ./bin/rails db:migrate
      ;;
    "db:create")
      $COMPOSE_CMD run --rm rails ./bin/rails db:create
      ;;
    "test")
      $COMPOSE_CMD run --rm rails ./bin/rails test
      ;;
    "routes")
      $COMPOSE_CMD run --rm rails ./bin/rails routes
      ;;
    "help")
      echo "drun - Development environment for Ruby on Rails using Docker/Podman"
      echo ""
      echo "CONTAINER MANAGEMENT COMMANDS:"
      echo "  serve                   Start all containers"
      echo "  build                   Build all containers"
      echo "  console                 Open Rails console"
      echo "  db:setup                Set up the database"
      echo "  db:migrate              Run database migrations"
      echo "  db:create               Create the database"
      echo "  test                    Run tests"
      echo "  routes                  Show Rails routes"
      echo ""
      echo "CONTAINER ENGINE COMMANDS:"
      echo "  engine                  Show current container engine"
      echo "  force-docker            Force using Docker for this session"
      echo "  force-podman            Force using Podman for this session"
      echo ""
      echo "OTHER COMMANDS:"
      echo "  help                    Show this help message"
      echo "  [command]               Run arbitrary command in Rails container"
      echo ""
      echo "Examples:"
      echo "  ./drun.sh serve         Start the Rails server and all containers"
      echo "  ./drun.sh rails g model User name:string email:string"
      ;;
    *)
      $COMPOSE_CMD run --rm rails sh -c "$*"
      ;;
  esac
fi
