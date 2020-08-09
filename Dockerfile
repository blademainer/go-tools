FROM golang:latest as build

ARG REPOSITORY
ARG GOPROXY
ENV BUILD_PROJECT_PATH=${GOPATH}/src/${REPOSITORY}
ENV GO111MODULE=on
ENV GOPROXY=${GOPROXY}
ENV BIN=/app/bin

RUN setup.sh; \
    env; \
    if [ -z "$REPOSITORY" ]; then \
        echo "repository arg is null!"; \
        exit 1; \
    else \
        echo "path===${GOPATH}/src/$REPOSITORY"; \
    fi

ADD . ${GOPATH}/src/${REPOSITORY}

RUN cd ${BUILD_PROJECT_PATH} && \
    if [ -f "go_build.sh" ]; then \
        bash go_build.sh; \
    else \
        echo "not found: go_build.sh"; \
        exit 1; \
    fi

#FROM alpine:latest as certs
#RUN apk --update add ca-certificates && \
#    apk add bash && \
#    mkdir -p /app
#ARG app
#ENV APP=$app
#
#COPY --from=build /app/bin/ /app/
#
#WORKDIR /app
#CMD ["bash", "-c", "/app/${APP}"]
#EXPOSE 8080
