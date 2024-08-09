FROM --platform=$TARGETPLATFORM ubuntu:latest AS build
RUN apt update && apt install curl -y

ARG PKL_VERSION=0.25.1

ARG TARGETPLATFORM
RUN if [ "$TARGETPLATFORM" = "linux/arm64" ]; then ARCHITECTURE=aarch64; else ARCHITECTURE=amd64; fi \
    && curl -L -o /pkl  "https://github.com/apple/pkl/releases/download/${PKL_VERSION}/pkl-linux-${ARCHITECTURE}"

RUN chmod +x /pkl

FROM --platform=$TARGETPLATFORM ubuntu:latest

RUN apt update && apt install gcc libstdc++6 -y
COPY --from=build /pkl /pkl

ENTRYPOINT ["/pkl"]