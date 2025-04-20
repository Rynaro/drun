ARG RUBY_VERSION=3.3
FROM ruby:$RUBY_VERSION-alpine

# Install system dependencies
RUN apk update && \
    apk add --no-cache build-base vips-dev postgresql-dev nodejs npm git && \
    npm install -g yarn

# Set up the working directory
WORKDIR /app

# Configure bundler
RUN bundle config set --global path 'vendor/bundle' && \
    bundle config set --global without 'development test'

# Install bundler
RUN gem install bundler --no-document

# Set up the entrypoint
ENTRYPOINT [""]

# Expose the default Rails port
EXPOSE 3000
