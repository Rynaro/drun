ARG RUBY_VERSION=3.3
FROM ruby:$RUBY_VERSION-alpine

# Install system dependencies
RUN apk update && \
    apk add --no-cache build-base vips-dev postgresql-dev nodejs npm git yaml-dev && \
    npm install -g yarn

# Set up the working directory
WORKDIR /app

# Configure bundler
RUN gem install bundler --no-document && \
    bundle config set --global path 'vendor/bundle' && \
    bundle config set --global without 'development test'

# Install Rails
RUN gem install rails

# Set up the entrypoint
ENTRYPOINT [""]

# Expose the default Rails port
EXPOSE 3000
