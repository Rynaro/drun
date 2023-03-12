#! /bin/sh

if [ "$1" = "serve" ]; then
  docker-compose up
else
  docker-compose run --rm rails sh -c "$*"
fi
