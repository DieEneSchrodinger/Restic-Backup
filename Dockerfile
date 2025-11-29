FROM alpine:3

RUN apk update && apk --no-cache add bash restic openssh

COPY crontab entrypoint.sh /

RUN crontab -u root /crontab && rm -f /crontab && chmod a+x /entrypoint.sh 

ENTRYPOINT ["/bin/bash" "/entrypoint.sh"] 
