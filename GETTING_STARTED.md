# Getting Started with drun

This guide will help you quickly get started with Rails development using `drun`.

## 📋 Prerequisites

You need either Docker or Podman installed on your system:

- [Install Docker](https://docs.docker.com/get-docker/)
- [Install Podman](https://podman.io/getting-started/installation)

## 🚀 Quick Start

### 1. Clone the repository

```bash
git clone https://github.com/Rynaro/drun.git myapp
cd myapp
chmod +x ./drun.sh ./drun-tutorial.sh
```

### 2. Choose a template

Choose one of these commands based on your needs:

```bash
# For complete beginners - creates a ready-to-run blog app
./drun-tutorial.sh quickstart

# For an API-only application
./drun-tutorial.sh new:simple

# For a full application with frontend support
./drun-tutorial.sh new:full

# For a tutorial application with scaffolding
./drun-tutorial.sh new:tutorial
```

### 3. Start your application

```bash
./drun.sh serve
```

### 4. Visit your application

Open your browser and go to: http://localhost:3000

## 🔍 Common Commands

Here are some common commands you'll use while developing:

```bash
# Start the server
./drun.sh serve

# Open Rails console
./drun.sh console

# Run database migrations
./drun.sh db:migrate

# Create a database
./drun.sh db:create

# Run tests
./drun.sh test

# Generate a new model
./drun.sh rails generate model User name:string email:string

# Generate a new controller
./drun.sh rails generate controller Users index show

# Run any Rails command
./drun.sh rails [command]
```

## 🧹 For Experienced Users: Removing Tutorial Functionality

If you're an experienced Rails developer and want to keep only the essential container management functionality:

1. After setting up your project, you can safely remove the tutorial script:
   ```bash
   rm drun-tutorial.sh
   ```

2. You can also remove the tutorial-related documentation:
   ```bash
   rm BEGINNERS_GUIDE.md
   ```

3. Your project will continue to work normally with just `drun.sh`, which provides all the container management commands you need.

## 📝 Database Configuration

Your application is configured to use PostgreSQL. The database connection is set up using environment variables:

```yaml
default: &default
  adapter: postgresql
  encoding: unicode
  host: <%= ENV["POSTGRES_HOST"] %>
  username: <%= ENV["POSTGRES_USER"] %>
  password: <%= ENV["POSTGRES_PASSWORD"] %>
  pool: <%= ENV.fetch("RAILS_MAX_THREADS") { 5 } %>
```

These variables are automatically set by `docker-compose.yml` or `podman-compose.yml`.

## 🧩 Project Structure

Here's a quick overview of the main directories in your Rails application:

```
app/
  controllers/  # Controllers handle incoming requests
  models/       # Models represent your data
  views/        # Views display information to users
  assets/       # JavaScript, CSS, and images
config/         # Configuration files
db/             # Database files and migrations
```

## 📚 Next Steps

- For beginners: Check out the [Beginner's Guide](BEGINNERS_GUIDE.md)
- For more commands: Run `./drun.sh help`
- For Rails documentation: Visit [Rails Guides](https://guides.rubyonrails.org/)

## 🆘 Troubleshooting

- If you encounter errors, check the terminal output and log files in `log/development.log`
- Make sure your database configuration is correct
- Try rebuilding with `./drun.sh build`
- Restart your application with `./drun.sh serve`

Happy coding with Rails and drun! 🎉
