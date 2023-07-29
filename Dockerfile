ARG RUBY_VERSION=3.2
FROM ruby:$RUBY_VERSION-alpine

RUN apk update && \
      apk add --no-cache build-base vips-dev postgresql-dev nodejs npm && \
      npm install -g yarn

WORKDIR /app

VOLUME "/bundle"
RUN bundle config set --global path '/bundle'
ENV PATH="/bundle/ruby/3.2.0/bin:${PATH}"

RUN gem install rails

EXPOSE 3000

ENTRYPOINT [""]
