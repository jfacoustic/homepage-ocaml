FROM ocaml/opam:alpine AS build

USER root
RUN apk add --no-cache libev-dev openssl-dev gmp-dev

RUN mkdir -p /home/opam/project

COPY --chown=opam:opam homepage.opam /home/opam/project/
WORKDIR /home/opam/project

USER opam
RUN opam install . --deps-only

USER root
COPY --chown=opam:opam . /home/opam/project

USER opam
RUN mkdir -p _build && opam exec -- dune build

FROM alpine:3.18.4 AS run
RUN apk add --no-cache libev
COPY --from=build /home/opam/project/_build/default/bin/main.exe /bin/main
ENTRYPOINT ["/bin/main"]
