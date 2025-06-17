FROM elixir:1.15-alpine

RUN apk add --no-cache build-base git nodejs npm inotify-tools bash

WORKDIR /app

COPY mix.exs mix.lock ./
COPY config ./config

RUN mix local.hex --force && mix local.rebar --force
RUN mix deps.get

COPY . .

RUN mix compile

COPY wait-for-it.sh .
RUN chmod +x wait-for-it.sh

EXPOSE 4000

CMD ["mix", "phx.server"]