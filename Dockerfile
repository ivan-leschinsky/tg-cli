FROM ubuntu:18.04 AS build
RUN apt update && DEBIAN_FRONTEND=noninteractive apt -y install libreadline-dev libconfig-dev libssl-dev lua5.2 liblua5.2-dev libevent-dev libjansson-dev libpython2-dev make zlib1g-dev libgcrypt20-dev git python2

WORKDIR /data
# Original:
# RUN git clone --recursive https://github.com/vysheng/tg.git && cd tg
RUN git clone --recursive https://github.com/ivan-leschinsky/tg-cli.git tg
# RUN cd tg && ./configure --disable-openssl --disable-libconfig --disable-liblua --disable-python --disable-json --prefix=/usr CFLAGS="$CFLAGS -w" && make
RUN cd tg && ./configure --disable-openssl --prefix=/usr CFLAGS="$CFLAGS -w" && make
# RUN cd tg && ./configure --disable-openssl --prefix=/usr CFLAGS="$CFLAGS -w" && make
# RUN cd tg && env CFLAGS="-Wno-cast-function-type" ./configure --disable-libconfig --disable-liblua --disable-python --disable-json --disable-openssl && make

FROM ubuntu
RUN apt update && DEBIAN_FRONTEND=noninteractive apt -y install libevent-dev libjansson-dev libconfig-dev libreadline-dev liblua5.2-dev
WORKDIR /data
COPY --from=build /data/tg/bin/telegram-cli /usr/local/bin/telegram-cli
RUN mkdir -p /etc/telegram-cli/
COPY --from=build /data/tg/server.pub /etc/telegram-cli/server.pub

ENTRYPOINT ["telegram-cli"]
