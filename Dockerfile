FROM ruby:3.2-slim

RUN curl -sL https://deb.nodesource.com/setup_19.x | bash -

RUN apt-get update -qq && \
      apt-get install -y build-essential libvips libpq-dev nodejs npm

RUN npm install -g yarn

WORKDIR /app

VOLUME "/bundle"
RUN bundle config set --global path '/bundle'
ENV PATH="/bundle/ruby/3.2.0/bin:${PATH}"

RUN gem install rails

EXPOSE 3000
