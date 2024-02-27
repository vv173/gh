# syntax=docker/dockerfile:1.6
ARG ALPINE_IMAGE_TAG=3.19.1
FROM alpine:${ALPINE_IMAGE_TAG}

ARG TARGETPLATFORM
ARG GH_CLI_VERSION=2.44.1

# Update packages and install dependencies
RUN apk update && \
    apk upgrade && \
    apk add --no-cache curl git && \
    rm -rf /etc/apk/cache

# Download and install binaries
RUN export RELEASE_PLATFORM="${TARGETPLATFORM//\//_}" && \
    curl -LJ https://github.com/cli/cli/releases/download/v${GH_CLI_VERSION}/gh_${GH_CLI_VERSION}_${RELEASE_PLATFORM}.tar.gz -o gh_${GH_CLI_VERSION}_${RELEASE_PLATFORM}.tar.gz && \
    tar -xzvf gh_${GH_CLI_VERSION}_${RELEASE_PLATFORM}.tar.gz && \
    install -m 755 gh_${GH_CLI_VERSION}_${RELEASE_PLATFORM}/bin/gh /usr/local/bin

ENTRYPOINT ["gh"]
# CMD ["--help"]
