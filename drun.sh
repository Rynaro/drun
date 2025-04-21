#!/usr/bin/env bash
set -euo pipefail

# Detect which compose command to use
detect_compose_cmd() {
  if command -v docker-compose >/dev/null 2>&1; then
    echo "docker-compose"
  elif command -v docker >/dev/null 2>&1 && docker compose version >/dev/null 2>&1; then
    echo "docker compose"
  else
    echo "docker-compose"
  fi
}

# Pick container engine
if command -v podman >/dev/null 2>&1 && [ -z "${FORCE_DOCKER-}" ]; then
  CONTAINER_ENGINE="podman"
  if command -v podman-compose >/dev/null 2>&1; then
    COMPOSE_CMD="podman-compose"
  else
    echo "⚠️  podman-compose not found; falling back to Docker Compose"
    CONTAINER_ENGINE="docker"
    COMPOSE_CMD="$(detect_compose_cmd)"
  fi
else
  CONTAINER_ENGINE="docker"
  COMPOSE_CMD="$(detect_compose_cmd)"
fi

echo "Using engine: $CONTAINER_ENGINE  ·  compose: $COMPOSE_CMD"

# Only run commands if script is executed (not sourced)
if [[ "${BASH_SOURCE[0]}" == "$0" ]]; then
  cmd=${1:-help}
  shift || true

  case "$cmd" in
    engine)
      echo "Engine: $CONTAINER_ENGINE"
      echo "Compose: $COMPOSE_CMD"
      ;;
    force-docker)
      export FORCE_DOCKER=1
      exec "$0" "${@}"
      ;;
    force-podman)
      unset FORCE_DOCKER
      exec "$0" "${@}"
      ;;
    serve|build)
      exec $COMPOSE_CMD "$cmd"
      ;;
    console|db:setup|db:migrate|db:create|test|routes)
      exec $COMPOSE_CMD run --rm rails ./bin/rails "$cmd"
      ;;
    help)
      cat <<-EOF
      drun.sh — Easy Containerized Rails!

      Usage: ./drun.sh <command> [args...]

      Commands:
        serve               Start all containers
        build               Build images only
        console             Rails console
        db:setup            Create + migrate + seed
        db:migrate          Run migrations
        db:create           Create database
        test                Run test suite
        routes              List Rails routes

      Engine control:
        engine              Show current engine/compose
        force-docker        Switch to Docker for this session
        force-podman        Switch to Podman for this session

      Any other <command> gets exec’d inside the Rails container:
        ./drun.sh rails g model User name:string

      EOF
      ;;
    *)
      exec $COMPOSE_CMD run --rm rails sh -c "$cmd ${*:-}"
      ;;
  esac
fi
