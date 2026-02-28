FROM alpine/git AS base

ARG TAG=latest
RUN git clone https://github.com/vwh/sqlite-online.git && \
    cd sqlite-online && \
    ([[ "$TAG" = "latest" ]] || git checkout ${TAG}) && \
    rm -rf .git

FROM --platform=$BUILDPLATFORM oven/bun:alpine AS build

WORKDIR /sqlite-online
COPY --from=base /git/sqlite-online .
RUN bun ci && \
    bun run build

FROM joseluisq/static-web-server

COPY --from=build /sqlite-online/dist ./public
