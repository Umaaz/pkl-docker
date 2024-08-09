FROM --platform=$TARGETPLATFORM alpine:latest AS build
RUN apk add --no-cache curl

ARG PKL_VERSION=0.25.1

ARG TARGETPLATFORM
RUN if [ "$TARGETPLATFORM" = "linux/arm64" ]; then ARCHITECTURE=aarch64; else ARCHITECTURE=amd64; fi \
    && curl -L -o /pkl  "https://github.com/apple/pkl/releases/download/${PKL_VERSION}/pkl-linux-${ARCHITECTURE}"

RUN chmod +x /pkl

FROM --platform=$TARGETPLATFORM alpine:latest

RUN apk add --no-cache libstdc++ libc6-compat
COPY --from=build /pkl /pkl

ENTRYPOINT ["/pkl"]