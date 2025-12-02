FROM alpine:latest

COPY entrypoint.sh /

RUN apk update && apk --no-cache add bash restic openssh && chmod a+x /entrypoint.sh

ENTRYPOINT ["/bin/bash", "/entrypoint.sh"] 
