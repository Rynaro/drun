#!/bin/bash

set -e

# Simple Docker runner for Rails development
COMPOSE_CMD="docker-compose"
DRUN_VERSION="2.0.0"
PROJECT_NAME="${PWD##*/}"

# Helper functions
ensure_built() {
  if ! docker-compose ps | grep -q "Up\|running"; then
    echo "No containers running. Building and starting..."
    docker-compose up -d
  fi
}

# Container management functions
start_containers() {
  echo "Starting containers..."
  $COMPOSE_CMD up
}

stop_containers() {
  echo "Stopping containers..."
  $COMPOSE_CMD down
}

restart_containers() {
  echo "Restarting containers..."
  $COMPOSE_CMD down
  $COMPOSE_CMD up -d
}

show_logs() {
  local service="${1:-rails}"
  $COMPOSE_CMD logs -f "$service"
}

show_status() {
  $COMPOSE_CMD ps
}

# Rails command functions
run_rails_command() {
  ensure_built
  shift
  $COMPOSE_CMD exec rails ./bin/rails "$@"
}

run_rake_task() {
  ensure_built
  shift
  $COMPOSE_CMD exec rails bundle exec rake "$@"
}

run_bundle_command() {
  ensure_built
  shift
  $COMPOSE_CMD exec rails bundle "$@"
}

run_tests() {
  ensure_built
  $COMPOSE_CMD exec rails ./bin/rails test "${@:2}"
}

# Cleanup functions
clean_project_containers() {
  echo "Cleaning up project containers..."
  $COMPOSE_CMD down --volumes --remove-orphans
}

clean_project_images() {
  echo "Cleaning up project images..."
  # Get images related to this project
  local project_images
  project_images=$(docker images --filter "label=com.docker.compose.project=$PROJECT_NAME" -q)

  if [ -n "$project_images" ]; then
    docker rmi -f $project_images
  else
    echo "No project-specific images found."
  fi
}

clean_project_volumes() {
  echo "Cleaning up project volumes..."
  # Get volumes related to this project
  local project_volumes
  project_volumes=$(docker volume ls --filter "label=com.docker.compose.project=$PROJECT_NAME" -q)

  if [ -n "$project_volumes" ]; then
    docker volume rm -f $project_volumes
  else
    echo "No project-specific volumes found."
  fi
}

clean_project_networks() {
  echo "Cleaning up project networks..."
  # Get networks related to this project
  local project_networks
  project_networks=$(docker network ls --filter "label=com.docker.compose.project=$PROJECT_NAME" -q)

  if [ -n "$project_networks" ]; then
    docker network rm $project_networks
  else
    echo "No project-specific networks found."
  fi
}

# Main command handling
case "$1" in
  "build")
    echo "Building containers..."
    $COMPOSE_CMD build
    ;;
  "up"|"serve")
    start_containers
    ;;
  "down")
    stop_containers
    ;;
  "restart")
    restart_containers
    ;;
  "logs")
    show_logs "$2"
    ;;
  "shell"|"bash")
    ensure_built
    $COMPOSE_CMD exec rails bash
    ;;
  "console")
    ensure_built
    $COMPOSE_CMD exec rails ./bin/rails console
    ;;
  "rails")
    run_rails_command "$@"
    ;;
  "rake")
    run_rake_task "$@"
    ;;
  "bundle")
    run_bundle_command "$@"
    ;;
  "test")
    run_tests "$@"
    ;;
  "clean")
    echo "Cleaning up project resources..."
    clean_project_containers
    clean_project_volumes
    clean_project_networks
    ;;
  "clean-all")
    echo "Cleaning up all project resources including images..."
    clean_project_containers
    clean_project_volumes
    clean_project_networks
    clean_project_images
    ;;
  "ps"|"status")
    show_status
    ;;
  "thanks")
    echo ""
    echo "  ____  ____  _   _ _   _ "
    echo " |  _ \|  _ \| | | | \ | |"
    echo " | | | | |_) | | | |  \| |"
    echo " | |_| |  _ <| |_| | |\  |"
    echo " |____/|_| \_\\\___/|_| \_|"
    echo ""
    echo "Version: $DRUN_VERSION - Obsidian Pickaxe"
    echo ""
    echo "Thank you for using drun.sh! 🚀"
    echo "Your development workflow just got better!"
    echo ""
    ;;
  "help"|"")
    echo "drun - Simple Docker Runner for Rails Development"
    echo ""
    echo "CONTAINER COMMANDS:"
    echo "  build                   Build containers"
    echo "  up, serve               Start containers (foreground)"
    echo "  down                    Stop containers"
    echo "  restart                 Restart containers"
    echo "  ps, status              Show container status"
    echo "  logs [service]          Show logs (default: rails)"
    echo ""
    echo "RAILS COMMANDS:"
    echo "  shell, bash             Open bash shell in Rails container"
    echo "  console                 Open Rails console"
    echo "  rails <cmd>             Run rails command (e.g., rails generate model User)"
    echo "  rake <task>             Run rake task"
    echo "  bundle <cmd>            Run bundle command"
    echo "  test [args]             Run Rails tests"
    echo "  rspec [args]            Run RSpec tests"
    echo ""
    echo "CLEANUP COMMANDS:"
    echo "  clean                   Clean project containers, volumes, and networks"
    echo "  clean-all               Clean all project resources including images"
    echo ""
    echo "OTHER COMMANDS:"
    echo "  thanks                  Show appreciation message"
    echo ""
    echo "EXAMPLES:"
    echo "  ./drun.sh build                              # Build containers"
    echo "  ./drun.sh up                                 # Start development server"
    echo "  ./drun.sh rails generate model User name:string"
    echo "  ./drun.sh rails db:migrate"
    echo "  ./drun.sh rake routes"
    echo "  ./drun.sh test"
    echo "  ./drun.sh clean                              # Clean up when done"
    ;;
  *)
    # For any other command, run it directly in the Rails container
    ensure_built
    $COMPOSE_CMD exec rails sh -c "$*"
    ;;
esac
