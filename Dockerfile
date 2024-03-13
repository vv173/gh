# syntax=docker/dockerfile:1.6
ARG ALPINE_IMAGE_TAG=3.19.1
FROM alpine:${ALPINE_IMAGE_TAG} AS builder

ARG TARGETPLATFORM
ARG GH_CLI_VERSION=2.45.0


LABEL org.opencontainers.image.title="gh" \
      org.opencontainers.image.version="${GH_CLI_VERSION}"

# Update packages and install dependencies
RUN apk update && \
    apk upgrade && \
    apk add --no-cache curl git ca-certificates && \
    update-ca-certificates 2>/dev/null || true 

# Download and install binaries
RUN export RELEASE_PLATFORM="${TARGETPLATFORM//\//_}" && \
    curl -LJ https://github.com/cli/cli/releases/download/v${GH_CLI_VERSION}/gh_${GH_CLI_VERSION}_${RELEASE_PLATFORM}.tar.gz -o gh_${GH_CLI_VERSION}_${RELEASE_PLATFORM}.tar.gz && \
    tar -xzvf gh_${GH_CLI_VERSION}_${RELEASE_PLATFORM}.tar.gz && \
    install -m 755 gh_${GH_CLI_VERSION}_${RELEASE_PLATFORM}/bin/gh /usr/local/bin && \
    rm -rf gh_${GH_CLI_VERSION}_${RELEASE_PLATFORM}*

FROM scratch

# copy the ca-certificate.crt from the build stage
COPY --from=builder /etc/ssl/certs/ca-certificates.crt /etc/ssl/certs/

# Copy gh binary
COPY --from=builder /usr/local/bin/gh /gh

WORKDIR /workspace

ENTRYPOINT ["/gh"]
CMD ["--help"]
