ARG RUBY_VERSION=3.3
FROM ruby:$RUBY_VERSION-alpine

RUN apk update && \
      apk add --no-cache build-base vips-dev postgresql-dev nodejs npm git && \
      npm install -g yarn

WORKDIR /app

# Copy Gemfile and Gemfile.lock if they exist
COPY Gemfile* ./

# Install gems if Gemfile exists, otherwise skip
RUN if [ -f Gemfile ]; then bundle install; fi

# Copy the rest of the application
COPY . .

# Set up bundler configuration
RUN bundle config set --global path 'vendor/bundle' && \
    bundle config set --global without 'development test'

VOLUME "/bundle"
RUN bundle config set --global path '/bundle'
ENV PATH="/bundle/ruby/3.3.0/bin:${PATH}"

RUN gem install rails

EXPOSE 3000

ENTRYPOINT [""]
