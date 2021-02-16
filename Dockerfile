FROM elixir:1.11.3-alpine
RUN apk add build-base
WORKDIR /app
COPY . /app
RUN mix local.hex --force \
    && mix local.rebar --force \
    && mix deps.get \
    && mix deps.compile \
    && MIX_ENV=prod mix distillery.release \
    && rm -rf /app/_build/prod/rel/perf_analizer/etc

FROM elixir:1.11.3-alpine
WORKDIR /app
RUN apk update && apk upgrade && apk add bash
COPY --from=0 /app/_build/prod /app
VOLUME /app/rel/perf_analizer/etc
ENTRYPOINT exec /app/rel/perf_analizer/bin/perf_analizer foreground
