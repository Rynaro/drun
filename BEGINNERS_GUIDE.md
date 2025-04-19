# Beginner's Guide to Ruby on Rails with drun

This guide will help you learn Ruby on Rails using `drun` without worrying about complex setup or configuration.

## Introduction to Ruby on Rails

Ruby on Rails (or Rails) is a web application framework written in Ruby. It follows the Model-View-Controller (MVC) pattern and emphasizes the use of well-known software engineering principles:

- **Convention over Configuration** (CoC): Rails makes assumptions about what you want to do and how you're going to do it, rather than requiring you to specify every detail.
- **Don't Repeat Yourself** (DRY): Your code should only express each concept in one place.

## Setting Up Your First Rails Application

With `drun`, you can create your first Rails application in minutes:

1. Clone the repository:
   ```bash
   git clone https://github.com/Rynaro/drun.git myapp
   cd myapp
   ```

2. Make the scripts executable:
   ```bash
   chmod +x ./drun.sh ./drun-tutorial.sh
   ```

3. Create a tutorial application:
   ```bash
   ./drun-tutorial.sh quickstart
   ```

4. Start the server:
   ```bash
   ./drun.sh serve
   ```

5. Open your browser and visit http://localhost:3000

Congratulations! You've just created and started your first Rails application.

## Understanding the drun Scripts

drun provides two main scripts to help you with your Rails development:

### drun.sh
This is the main script for managing your Rails application containers. It provides commands for:
- Starting and stopping the server (`serve`)
- Running Rails commands (`console`, `db:migrate`, `test`, etc.)
- Managing container engines (Docker/Podman)
- Running arbitrary commands in the container

### drun-tutorial.sh
This script helps you create new Rails applications and set up tutorial projects. It provides commands for:
- Creating new applications (`quickstart`, `new:simple`, `new:full`, `new:tutorial`)
- Setting up tutorial projects with pre-configured examples
- Generating scaffolded applications

## Understanding Your Rails Application

Let's take a look at the main directories in your Rails application:

- `app/` - Contains the core of your application:
  - `controllers/` - Controllers handle incoming requests
  - `models/` - Models represent your data and business logic
  - `views/` - Views display information to the user
  - `assets/` - JavaScript, CSS, and images
- `config/` - Configuration files for your application
- `db/` - Database files and migrations
- `public/` - Static files accessible directly by the browser

## The Tutorial Blog Application

The `quickstart` command creates a simple blog application with a `Post` model and scaffold. Let's explore how it works:

### The Model (app/models/post.rb)

This file defines your Post model:

```ruby
class Post < ApplicationRecord
end
```

Even though it's empty, Rails uses conventions to assume a lot about this model, including that it maps to a `posts` database table with `title`, `content`, and `published` columns.

### The Controller (app/controllers/posts_controller.rb)

The controller handles requests related to posts. It has actions for listing, showing, creating, updating, and deleting posts.

### The Views (app/views/posts/)

The views display the posts to users and provide forms for creating and editing them.

## Making Changes to Your Application

Let's modify the application to better understand how Rails works:

1. Edit app/views/posts/index.html.erb to change the page title:

   Create a file locally and then copy it to your container:

   ```bash
   # First, view the original file
   ./drun.sh cat app/views/posts/index.html.erb

   # Now, create a modified file locally
   # (Add or change the title to "My Awesome Blog" for example)

   # Then copy it to the container
   ./drun.sh cp /path/to/your/modified/index.html.erb app/views/posts/index.html.erb
   ```

2. Refresh your browser to see the changes

## Creating a New Model

Let's add a Comment model to our blog:

```bash
./drun.sh rails generate model Comment post:references content:text author:string
```

This creates:
- A Comment model file
- A migration file to create the comments table
- A test file

Now run the migration:

```bash
./drun.sh rails db:migrate
```

## Setting Up Model Relationships

Edit `app/models/post.rb` to add the relationship:

```ruby
class Post < ApplicationRecord
  has_many :comments
end
```

Edit `app/models/comment.rb` to ensure comments are deleted when a post is deleted:

```ruby
class Comment < ApplicationRecord
  belongs_to :post
end
```

## Using the Rails Console

The Rails console is a great way to experiment with your models:

```bash
./drun.sh console
```

Try these commands:

```ruby
# Create a post
post = Post.create(title: "My First Post", content: "Hello Rails World!", published: true)

# Add a comment
post.comments.create(author: "John", content: "Great post!")

# Find all posts
Post.all

# Find all comments for a post
Post.first.comments
```

Type `exit` to exit the console.

## Next Steps in Your Rails Journey

Now that you have a basic understanding of Rails, here are some next steps:

1. Add more models to your application
2. Create custom routes in `config/routes.rb`
3. Style your application with CSS
4. Add user authentication
5. Deploy your application

## Learning Resources

To deepen your understanding of Rails, check out these resources:

- [Rails Guides](https://guides.rubyonrails.org/)
- [Ruby on Rails Tutorial by Michael Hartl](https://www.railstutorial.org/)


## Troubleshooting Common Issues

### Database Connection Problems

If you have database connection issues, make sure your `config/database.yml` file has the correct environment variables:

```yaml
default: &default
  adapter: postgresql
  encoding: unicode
  host: <%= ENV["POSTGRES_HOST"] %>
  username: <%= ENV["POSTGRES_USER"] %>
  password: <%= ENV["POSTGRES_PASSWORD"] %>
  pool: <%= ENV.fetch("RAILS_MAX_THREADS") { 5 } %>
```

### Rails Server Not Starting

If the Rails server won't start, check:

1. The terminal output for error messages
2. The log files in `log/development.log`

You can always restart the server:

```bash
# Stop the current server (Ctrl+C)
# Then restart it
./drun.sh serve
```

## Getting Help

If you get stuck, remember:

- Run `./drun.sh help` to see all available container management commands
- Run `./drun-tutorial.sh help` to see all available project creation commands
- Check [Rails Guides](https://guides.rubyonrails.org/) for documentation
- Search for error messages online
- Ask questions on [Stack Overflow](https://stackoverflow.com/questions/tagged/ruby-on-rails)

Happy coding!
