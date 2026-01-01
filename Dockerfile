FROM ocaml/opam:alpine as build

RUN sudo apk add --update libev-dev openssl-dev gmp-dev

WORKDIR /home/opam

ADD homepage.opam homepage.opam
RUN opam install . --deps-only

ADD . .
RUN opam exec -- dune build

FROM alpine:3.18.4 as run

RUN apk add --update libev

COPY --from=build /home/opam/_build/default/bin/main.exe /bin/main

ENTRYPOINT /bin/main
