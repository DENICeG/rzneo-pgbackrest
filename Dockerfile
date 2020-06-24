FROM debian as builder

RUN apt update && \
    apt -y upgrade && \
    apt install -y ca-certificates rsync git devscripts build-essential valgrind autoconf \
        autoconf-archive libssl-dev zlib1g-dev libxml2-dev libpq-dev libbz2-dev \
        libxml-checker-perl libyaml-libyaml-perl libdbd-pg-perl pkg-config curl

RUN mkdir -p /build
WORKDIR /build
RUN curl -LO https://github.com/pgbackrest/pgbackrest/archive/release/2.27.tar.gz && \ 
    tar xvfz 2.27.tar.gz && \
    mv pgbackrest-release-2.27 pgbackrest
WORKDIR /build/pgbackrest/src
RUN ls -la  && ./configure && make pgbackrest

FROM debian

RUN apt update && apt -y upgrade && apt install -y ca-certificates pgbackrest
COPY --from=builder /build/pgbackrest/src/pgbackrest /usr/bin/pgbackrest

ENTRYPOINT [ "sleep" ]
CMD ["infinity"]
