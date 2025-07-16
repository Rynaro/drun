# drun.sh

`drun` is a simple Docker container management tool for Ruby on Rails development. It provides a streamlined workflow for managing Rails applications in containers, with built-in support for PostgreSQL, Redis, and other essential services.

<p align="center">
  <img src="assets/logo.png" alt="drun logo" width="200" />
</p>

## 🚀 Quick Start

### For New Rails Projects

1. **Install drun in an empty directory:**
   ```bash
   curl -o drun.sh https://raw.githubusercontent.com/Rynaro/drun/main/drun.sh
   curl -o docker-compose.yml https://raw.githubusercontent.com/Rynaro/drun/main/docker-compose.yml
   curl -o Dockerfile https://raw.githubusercontent.com/Rynaro/drun/main/Dockerfile
   curl -o .env.example https://raw.githubusercontent.com/Rynaro/drun/main/.env.example
   chmod +x drun.sh
   ```

2. **Get suggested commands for new Rails projects:**
   ```bash
   ./drun.sh suggested
   ```

3. **Create a new Rails application (recommended):**
   ```bash
   ./drun.sh rails new . --skip-docker --database=postgresql
   ```

4. **Start your development environment:**
   ```bash
   ./drun.sh rails db:create
   ./drun.sh serve
   ```

5. **Visit http://localhost:3000 in your browser**

### For Existing Rails Projects

1. **Copy drun files to your project root:**
   ```bash
   curl -o drun.sh https://raw.githubusercontent.com/Rynaro/drun/main/drun.sh
   curl -o docker-compose.yml https://raw.githubusercontent.com/Rynaro/drun/main/docker-compose.yml
   curl -o Dockerfile https://raw.githubusercontent.com/Rynaro/drun/main/Dockerfile
   curl -o .env.example https://raw.githubusercontent.com/Rynaro/drun/main/.env.example
   chmod +x drun.sh
   ```

2. **Configure your environment (optional):**
   ```bash
   cp .env.example .env
   # Edit .env to customize database, ports, etc.
   ```

3. **Start your development environment:**
   ```bash
   ./drun.sh serve
   ```

## � Available Commands

### Quick Start Commands
| Command | Description |
|---------|-------------|
| `./drun.sh suggested` | Show suggested commands for new Rails projects |
| `./drun.sh help` | Show complete help with all available commands |

### Container Management
| Command | Description |
|---------|-------------|
| `./drun.sh build` | Build containers |
| `./drun.sh up` or `./drun.sh serve` | Start containers (foreground) |
| `./drun.sh down` | Stop containers |
| `./drun.sh restart` | Restart containers |
| `./drun.sh ps` or `./drun.sh status` | Show container status |
| `./drun.sh logs [service]` | View logs (default: rails) |

### Rails Development
| Command | Description |
|---------|-------------|
| `./drun.sh shell` or `./drun.sh bash` | Open bash shell in Rails container |
| `./drun.sh console` | Open Rails console |
| `./drun.sh rails <cmd>` | Run any Rails command |
| `./drun.sh rake <task>` | Run any Rake task |
| `./drun.sh bundle <cmd>` | Run any Bundler command |
| `./drun.sh test [args]` | Run Rails tests |

### Cleanup Commands
| Command | Description |
|---------|-------------|
| `./drun.sh clean` | Clean project containers, volumes, and networks |
| `./drun.sh clean-all` | Clean all project resources including images |

### Other Commands
| Command | Description |
|---------|-------------|
| `./drun.sh thanks` | Show appreciation message |
| `./drun.sh <custom>` | Run custom commands directly in Rails container |

## � Common Usage Examples

### Starting a New Rails Project
```bash
# 1. Set up drun in empty directory
curl -o drun.sh https://raw.githubusercontent.com/Rynaro/drun/main/drun.sh && chmod +x drun.sh

# 2. Get the suggested commands
./drun.sh suggested

# 3. Create Rails app (preserves drun Docker setup)
./drun.sh rails new . --skip-docker --database=postgresql

# 4. Set up database and start server
./drun.sh rails db:create
./drun.sh rails db:migrate
./drun.sh serve
```

### Working with Existing Rails Projects
```bash
# 1. Add drun to your project
curl -o drun.sh https://raw.githubusercontent.com/Rynaro/drun/main/drun.sh
curl -o docker-compose.yml https://raw.githubusercontent.com/Rynaro/drun/main/docker-compose.yml
curl -o Dockerfile https://raw.githubusercontent.com/Rynaro/drun/main/Dockerfile
chmod +x drun.sh

# 2. Start development environment
./drun.sh serve
```

### Daily Development Workflow
```bash
# Start your work session
./drun.sh serve

# Generate models, controllers, etc.
./drun.sh rails generate model User name:string email:string
./drun.sh rails generate controller Users

# Run database migrations
./drun.sh rails db:migrate

# Run tests
./drun.sh test
./drun.sh rails test:system

# Debug in Rails console
./drun.sh console

# Install new gems
./drun.sh bundle add devise
./drun.sh bundle install

# Check routes
./drun.sh rake routes

# Clean up when done
./drun.sh down
```

## 🔧 Configuration

### Environment Variables

Create a `.env` file to customize your setup:

```bash
# Copy the example file
cp .env.example .env
```

Key configuration options:
- `PROJECT_NAME`: Used for container naming (defaults to directory name)
- `PORT`: Rails server port (default: 3000)
- `POSTGRES_DB`: Database name
- `POSTGRES_USER`: Database username
- `POSTGRES_PASSWORD`: Database password
- `REDIS_URL`: Redis connection string

### Custom Docker Images

If you need to customize the Docker setup:

1. **Modify the Dockerfile** for additional system packages
2. **Update docker-compose.yml** for service configuration
3. **Rebuild containers** with `./drun.sh build`

## 📦 Technical Stack

`drun` provides a complete containerized development environment with:

### Core Components
- **Ruby 3.4** (Alpine Linux for minimal footprint)
- **Rails** (globally installed and ready to use)
- **PostgreSQL 17.5** with SCRAM-SHA-256 authentication
- **Redis 8** for caching and background jobs
- **Node.js & Yarn** for asset compilation

### Container Features
- **Multi-stage Docker builds** for optimized images
- **Non-root user** (`drunner`) for security
- **Persistent volumes** for data, gems, and node_modules
- **Health checks** for all services
- **Project-specific resource labeling**

### Development Tools
- **Bundle path optimization** for gem caching
- **Hot reloading** with volume mounts
- **Custom command support** for any Rails workflow
- **Clean resource management** with project isolation

## 🔒 Security Features

`drun` follows security best practices:

### Container Security
- **Non-root user execution** (`drunner` user with UID 1000)
- **Minimal Alpine Linux base** for reduced attack surface
- **Multi-stage builds** to exclude build dependencies from final image
- **Proper file permissions** for application and bundle directories

### Database Security
- **PostgreSQL SCRAM-SHA-256** authentication
- **Isolated database volumes** with proper permissions
- **Environment variable configuration** (no hardcoded secrets)
- **Health check endpoints** for monitoring

### Network Security
- **Container network isolation** with Docker Compose
- **Port binding only when needed** (3000 for Rails, 5432/6379 for DBs)
- **Redis password protection** support
- **Project-specific resource labeling** for isolation

## 🚀 Performance Optimizations

### Docker Optimizations
- **Multi-stage builds** reduce final image size
- **Cached gem volumes** prevent reinstallation
- **Node modules caching** speeds up asset compilation
- **Minimal Alpine base** for faster downloads

### Development Workflow
- **Hot reloading** with volume mounts
- **Parallel service startup** with dependency management
- **Persistent data volumes** prevent data loss
- **Efficient cleanup commands** for resource management

## �️ Troubleshooting

### Common Issues

**Container won't start:**
```bash
# Check container status
./drun.sh ps

# View logs for debugging
./drun.sh logs rails
./drun.sh logs postgres
```

**Database connection issues:**
```bash
# Ensure database is running
./drun.sh ps

# Check database logs
./drun.sh logs postgres

# Recreate database
./drun.sh rails db:drop db:create db:migrate
```

**Permission errors:**
```bash
# Clean up and rebuild
./drun.sh clean
./drun.sh build
```

**Port conflicts:**
```bash
# Change port in .env file
echo "PORT=3001" >> .env
./drun.sh down
./drun.sh serve
```

### Getting Help

- **View all commands**: `./drun.sh help`
- **Check container status**: `./drun.sh ps`
- **View service logs**: `./drun.sh logs [service]`
- **Get suggested commands**: `./drun.sh suggested`

## 🔄 Migration from Other Tools

### From Rails with Docker
If you're already using Rails with Docker:
1. Replace your existing `Dockerfile` and `docker-compose.yml`
2. Use `./drun.sh` instead of `docker-compose` commands
3. Enjoy simplified commands and better security

### From Docked
If you're using Rails' `docked` tool:
1. `drun` provides similar functionality with enhanced features
2. Better security with non-root user
3. More comprehensive service stack (Redis, PostgreSQL)
4. Simplified command interface

## 📄 License

This project is licensed under the [MIT License](LICENSE).

## 🙏 Acknowledgments

- Inspired by [Docked](https://github.com/rails/docked) by the Rails team
- Built with ❤️ for the Rails community
- Special thanks to all contributors and users

## 📚 Additional Resources

- [Docker Documentation](https://docs.docker.com/)
- [Rails Guides](https://guides.rubyonrails.org/)
- [PostgreSQL Documentation](https://www.postgresql.org/docs/)
- [Redis Documentation](https://redis.io/documentation)

---

**Happy coding with drun! 🚀**
