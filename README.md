# drun - Quick Start Ruby on Rails

`drun` is a beginner-friendly tool for setting up Ruby on Rails projects with Docker or Podman. It's perfect for learning Rails or quickly setting up a new project.

<p align="center">
  <img src="assets/logo.png" alt="drun logo" width="200" />
</p>

## 📚 Documentation

- [Getting Started](GETTING_STARTED.md) - Quick setup and common commands
- [Beginner's Guide](BEGINNERS_GUIDE.md) - Comprehensive guide for learning Rails

## 🚀 Quick Start

### For Beginners
1. Make sure you have [Docker](https://www.docker.com/get-started/) or [Podman](https://podman.io/getting-started/installation) installed
2. Run:
   ```bash
   git clone https://github.com/Rynaro/drun.git myapp
   cd myapp
   chmod +x ./drun.sh ./drun-tutorial.sh
   ./drun-tutorial.sh quickstart
   ```
3. Start your app:
   ```bash
   ./drun.sh serve
   ```
4. Visit http://localhost:3000 in your browser

### For Experienced Users
If you just want the container management script:
```bash
curl -o drun.sh https://raw.githubusercontent.com/Rynaro/drun/main/drun.sh && chmod +x drun.sh
```

## 🧩 Available Templates

`drun` offers several templates to get you started:

| Command | Description |
|---------|-------------|
| `./drun-tutorial.sh quickstart` | Creates a complete blog app with scaffolding - perfect for beginners! |
| `./drun-tutorial.sh new:simple` | Creates a minimal API-only application |
| `./drun-tutorial.sh new:full` | Creates a complete Rails application with frontend support |
| `./drun-tutorial.sh new:tutorial` | Creates a learning-focused app with blog scaffolding |

## 🛠️ Common Commands

| Command | Description |
|---------|-------------|
| `./drun.sh serve` | Start the application |
| `./drun.sh console` | Open Rails console |
| `./drun.sh db:migrate` | Run database migrations |
| `./drun.sh test` | Run the test suite |
| `./drun.sh help` | List all available commands |

## 📦 Technical Details

`drun` provides a complete development environment:

- Ruby 3.3
- Latest Rails
- PostgreSQL 15 database
- Redis for caching and background jobs
- Works with both Docker and Podman

## 📄 License

This project is licensed under the [MIT License](LICENSE).

## 🙏 Acknowledgments

This project has been influenced by [Docked](https://github.com/rails/docked), a similar tool by the Rails team.
