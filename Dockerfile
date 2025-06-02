ARG RUBY_VERSION=3.4
ARG APP_FOLDER_PATH=/opt/app
ARG DRUN_USER=drunner
ARG DRUN_GROUP=drunner
ARG BUNDLE_PATH=/var/bundle

# Build stage
FROM ruby:$RUBY_VERSION-alpine AS builder

# Re-declare ARGs for builder stage
ARG APP_FOLDER_PATH
ARG DRUN_USER
ARG DRUN_GROUP
ARG BUNDLE_PATH

# Install build dependencies and clean up in the same layer
RUN apk update && \
    apk add --no-cache \
    build-base \
    vips-dev \
    postgresql-dev \
    nodejs \
    npm && \
    npm install -g yarn && \
    rm -rf /var/cache/apk/*

# Set up bundle config
WORKDIR ${APP_FOLDER_PATH}
RUN mkdir -p ${BUNDLE_PATH} && \
    bundle config set --global path '${BUNDLE_PATH}' && \
    gem install rails

# Final stage
FROM ruby:$RUBY_VERSION-alpine

# Re-declare ARGs for final stage
ARG APP_FOLDER_PATH
ARG DRUN_USER
ARG DRUN_GROUP
ARG BUNDLE_PATH

# Install runtime dependencies and clean up in the same layer
RUN apk update && \
    apk add --no-cache \
    vips \
    postgresql-libs \
    nodejs \
    tzdata && \
    rm -rf /var/cache/apk/*

# Create non-root user and set up app directory
RUN addgroup -S ${DRUN_GROUP} && \
    adduser -S ${DRUN_USER} -G ${DRUN_GROUP} && \
    mkdir -p ${APP_FOLDER_PATH} && \
    chown -R ${DRUN_USER}:${DRUN_GROUP} ${APP_FOLDER_PATH}

WORKDIR ${APP_FOLDER_PATH}

# Create bundle directory and copy from builder
RUN mkdir -p ${BUNDLE_PATH}
COPY --from=builder --chown=${DRUN_USER}:${DRUN_GROUP} ${BUNDLE_PATH} ${BUNDLE_PATH}
ENV PATH="${BUNDLE_PATH}/ruby/3.4.0/bin:${PATH}"

# Switch to non-root user
USER ${DRUN_USER}

# Add metadata labels
LABEL maintainer="drun Team" \
      version="2.0" \
      description="Docker RUNner for Rails" \
      org.opencontainers.image.source="https://github.com/Rynaro/drun"

# Expose port
EXPOSE 3000

# Use exec form for ENTRYPOINT
ENTRYPOINT [""]
