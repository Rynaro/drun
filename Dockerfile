# drun - Simple Docker Runner for Rails Development
# Optimized for quick start and existing Rails environments

ARG RUBY_VERSION=3.4
# ARG NODE_VERSION=20 # Future improvement, currently using Alpine's default node version

# Build stage - Install dependencies and build tools
FROM ruby:${RUBY_VERSION}-alpine AS builder

# Install build dependencies
RUN apk add --no-cache \
    build-base \
    postgresql-dev \
    vips-dev \
    git \
    nodejs \
    npm \
    yarn \
    && npm install -g yarn \
    && rm -rf /var/cache/apk/*

# Install Rails globally (for quick start)
RUN gem install rails bundler --no-document

# Runtime stage - Clean and secure
FROM ruby:${RUBY_VERSION}-alpine


# Install runtime dependencies (including build-base for native gems)
RUN apk add --no-cache \
    postgresql-libs \
    vips \
    nodejs \
    yarn \
    git \
    bash \
    curl \
    tzdata \
    build-base \
    yaml-dev \
    && rm -rf /var/cache/apk/*

ARG BUNDLE_PATH=/var/bundle
# Create non-root user with proper permissions
RUN addgroup -g 1000 -S drunner && \
    adduser -u 1000 -S drunner -G drunner -s /bin/bash && \
    mkdir -p /opt/app ${BUNDLE_PATH} && \
    chown -R drunner:drunner /opt/app ${BUNDLE_PATH}

# Copy Rails and bundler from builder
COPY --from=builder /usr/local/bundle /usr/local/bundle

# Set working directory
WORKDIR /opt/app

ENV BUNDLE_PATH=${BUNDLE_PATH}
# Configure bundle to use shared volume for gems
RUN bundle config set --global path "${BUNDLE_PATH}" && \
    bundle config set --global bin '/opt/app/bin' && \
    bundle config set --global deployment false

# Switch to non-root user
USER drunner

# Environment variables for Rails development
ENV RAILS_ENV=development \
    BINDING=0.0.0.0 \
    PORT=3000 \
    RAILS_LOG_TO_STDOUT=true \
    RAILS_SERVE_STATIC_FILES=true

# Expose Rails port
EXPOSE 3000

# Metadata labels
LABEL maintainer="drun Team" \
      version="2.1.2" \
      description="Simple Docker Runner for Rails Development" \
      org.opencontainers.image.source="https://github.com/Rynaro/drun" \
      org.opencontainers.image.title="drun" \
      org.opencontainers.image.description="Docker container optimized for Rails development" \
      org.opencontainers.image.vendor="drun Team"

# Override Ruby's entrypoint to avoid to open CLI by default
ENTRYPOINT [""]
