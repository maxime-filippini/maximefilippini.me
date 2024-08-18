FROM ghcr.io/gleam-lang/gleam:v1.4.1-elixir
COPY . /app/
WORKDIR /app
CMD ["gleam", "run"]