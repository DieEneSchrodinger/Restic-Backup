# Builder
FROM alpine:3.23 AS builder

RUN apk --no-cache add git make musl-dev gcc && \
    git clone https://github.com/exander77/supertinycron.git && \
    cd supertinycron && \ 
    sed -i 's/musl-gcc/gcc/g; /upx/d' Makefile && \
    make

# Runtime
FROM alpine:3.23

COPY --from=builder /supertinycron/supertinycron /usr/local/bin/supertinycron
COPY entrypoint.sh /entrypoint.sh

RUN chmod +x /entrypoint.sh && \
    apk --no-cache add bash restic openssh

ENTRYPOINT ["/bin/bash", "/entrypoint.sh"]