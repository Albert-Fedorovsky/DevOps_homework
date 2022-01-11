FROM alpine
MAINTAINER Albert Fedorovsky <alb271@yandex.ru>

RUN apk update
RUN apk add --no-cache git make musl-dev go

# Configure Go
ENV GOROOT /usr/lib/go
ENV GOPATH /go
ENV PATH /go/bin:$PATH

RUN mkdir -p ${GOPATH}/src ${GOPATH}/bin

# Install Glide
# RUN go get -u github.com/Masterminds/glide/...

# Install fmt and net/http
RUN go get fmt
RUN go get net/http

# Set ports
EXPOSE 8181

ADD main.go /go_app/
RUN go build /go_app/main.go
CMD ["/main"]
