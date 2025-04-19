#!/bin/sh

set -e

# Source the common container engine detection and setup from drun.sh
. ./drun.sh

create_rails_app() {
  local app_type=$1
  local extra_args=$2

  echo "Creating a new Rails application..."

  # Build the container first
  $COMPOSE_CMD build

  # Default database is always PostgreSQL
  local db_arg="--database=postgresql"

  case "$app_type" in
    "simple")
      echo "Creating a simple Rails application (API only)..."
      $COMPOSE_CMD run --rm rails rails new . $db_arg --api $extra_args
      ;;
    "full")
      echo "Creating a complete Rails application with frontend assets..."
      $COMPOSE_CMD run --rm rails rails new . $db_arg $extra_args
      ;;
    "tutorial")
      echo "Creating a Rails tutorial application with blog scaffold..."
      $COMPOSE_CMD run --rm rails rails new . $db_arg $extra_args

      # Configure database and create basic scaffolding
      echo "Setting up database configuration..."
      cat > config/database.yml << EOF
default: &default
  adapter: postgresql
  encoding: unicode
  host: <%= ENV["POSTGRES_HOST"] %>
  username: <%= ENV["POSTGRES_USER"] %>
  password: <%= ENV["POSTGRES_PASSWORD"] %>
  pool: <%= ENV.fetch("RAILS_MAX_THREADS") { 5 } %>

development:
  <<: *default
  database: app_development

test:
  <<: *default
  database: app_test

production:
  <<: *default
  database: app_production
  username: app
  password: <%= ENV["APP_DATABASE_PASSWORD"] %>
EOF

      echo "Creating blog scaffold for learning..."
      $COMPOSE_CMD run --rm rails rails generate scaffold Post title:string content:text published:boolean
      $COMPOSE_CMD run --rm rails rails db:create db:migrate
      ;;
    *)
      echo "Creating a custom Rails application..."
      $COMPOSE_CMD run --rm rails rails new . $db_arg $extra_args
      ;;
  esac

  # Post-setup tips
  echo ""
  echo "Rails application created successfully!"
  echo ""
  echo "Next steps:"
  echo "1. Edit config/database.yml to ensure database connection:"
  echo "   Make sure it has the following under default: section:"
  echo "     host: <%= ENV[\"POSTGRES_HOST\"] %>"
  echo "     username: <%= ENV[\"POSTGRES_USER\"] %>"
  echo "     password: <%= ENV[\"POSTGRES_PASSWORD\"] %>"
  echo ""
  echo "2. Start your application:"
  echo "   ./drun.sh serve"
  echo ""
  echo "3. Visit http://localhost:3000 in your browser"
}

case "$1" in
  "quickstart")
    create_rails_app "tutorial" ""
    ;;
  "new:simple")
    create_rails_app "simple" "$2"
    ;;
  "new:full")
    create_rails_app "full" "$2"
    ;;
  "new:tutorial")
    create_rails_app "tutorial" "$2"
    ;;
  "help")
    echo "drun-tutorial - Development environment for Ruby on Rails using Docker/Podman"
    echo ""
    echo "QUICK START COMMANDS FOR BEGINNERS:"
    echo "  quickstart              Create a ready-to-run tutorial blog app with PostgreSQL"
    echo "  new:simple              Create a new API-only Rails app with PostgreSQL"
    echo "  new:full                Create a new complete Rails app with PostgreSQL"
    echo "  new:tutorial            Create a new tutorial app with blog scaffolding"
    echo ""
    echo "Examples:"
    echo "  ./drun-tutorial.sh quickstart    Create and set up a ready-to-run tutorial app"
    ;;
  *)
    echo "Unknown command. Use './drun-tutorial.sh help' for available commands."
    exit 1
    ;;
esac
