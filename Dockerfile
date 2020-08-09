FROM golang:latest as build

ARG repository
ARG goproxy
ENV BUILD_PROJECT_PATH=${GOPATH}/src/${repository}
ENV GO111MODULE=on
ENV GOPROXY=${goproxy}
ENV BIN=/app/bin

RUN env; \
    if [ -z "$repository" ]; then \
        echo "repository arg is null!"; \
        exit 1; \
    else \
        echo "path===${GOPATH}/src/$repository"; \
    fi

ADD . ${GOPATH}/src/${repository}

RUN cd ${BUILD_PROJECT_PATH} && \
    if [ -f "go_build.sh" ]; then \
        bash go_build.sh; \
    else \
        echo "not found: go_build.sh"; \
        exit 1; \
    fi

FROM alpine:latest as certs
RUN apk --update add ca-certificates && \
    apk add bash && \
    mkdir -p /app
ARG app
ENV APP=$app

COPY --from=build /app/bin/ /app/

WORKDIR /app
CMD ["bash", "-c", "/app/${APP}"]
EXPOSE 8080
