# FROM ubuntu AS build
# RUN apt update && DEBIAN_FRONTEND=noninteractive apt -y install libreadline-dev libconfig-dev libssl-dev lua5.2 liblua5.2-dev libevent-dev libjansson-dev libpython2-dev libpython3-dev libgcrypt-dev zlib1g-dev lua-lgi make git dpkg-dev debhelper autoconf-archive

# WORKDIR /data
# RUN git clone --recursive https://github.com/kenorb-contrib/tg-cli.git tg
# # RUN cd tg && ./configure --disable-openssl --disable-libconfig --disable-liblua --disable-python --disable-json --prefix=/usr CFLAGS="$CFLAGS -w" && make
# RUN cd tg && ./configure --disable-openssl --prefix=/usr CFLAGS="$CFLAGS -w" && make
# # RUN cd tg && ./configure --disable-openssl --prefix=/usr CFLAGS="$CFLAGS -w" && make
# # RUN cd tg && env CFLAGS="-Wno-cast-function-type" ./configure --disable-libconfig --disable-liblua --disable-python --disable-json --disable-openssl && make

# FROM ubuntu
# RUN apt update && DEBIAN_FRONTEND=noninteractive apt -y install libevent-dev libjansson-dev libconfig-dev libreadline-dev liblua5.2-dev
# WORKDIR /data
# COPY --from=build /data/tg/bin/telegram-cli /usr/local/bin/telegram-cli
# RUN mkdir -p /etc/telegram-cli/
# COPY --from=build /data/tg/server.pub /etc/telegram-cli/server.pub

# ENTRYPOINT ["telegram-cli"]


# FROM debian:11 AS build
# RUN apt update && DEBIAN_FRONTEND=noninteractive apt -y install libreadline-dev libconfig-dev libssl-dev lua5.2 liblua5.2-dev libevent-dev libjansson-dev libpython2-dev libpython3-dev libgcrypt-dev zlib1g-dev lua-lgi make git dpkg-dev

# WORKDIR /data
# RUN git clone --recursive https://github.com/kenorb-contrib/tg-cli.git tg
# RUN cd tg && ./configure && make

# FROM debian:11
# RUN apt update && DEBIAN_FRONTEND=noninteractive apt -y install libevent-dev libjansson-dev libconfig-dev libreadline-dev liblua5.2-dev
# WORKDIR /data
# COPY --from=build /data/tg/bin/telegram-cli /usr/local/bin/telegram-cli
# RUN mkdir -p /etc/telegram-cli/
# COPY --from=build /data/tg/server.pub /etc/telegram-cli/server.pub

# ENTRYPOINT ["telegram-cli"]


FROM debian:11

RUN apt-get update && DEBIAN_FRONTEND=noninteractive apt-get install -y build-essential git luajit luarocks libreadline-dev libconfig-dev libssl-dev lua5.2 liblua5.2-dev libevent-dev libjansson-dev libpython-dev zlib1g-dev zlib1g
RUN git clone --recursive https://github.com/kenorb-contrib/tg.git /tg &&
RUN cd /tg && ./configure && make && mv -v /tg/bin/* /usr/bin/
RUN mkdir -vp /etc/telegram-cli/ && mv -v /tg/tg-server.pub /etc/telegram-cli/server.pub
RUN rm -rf /tg/ && DEBIAN_FRONTEND=noninteractive apt-get purge -y --auto-remove build-essential git && apt-get clean && rm -rf /var/lib/apt/lists/

ENTRYPOINT ["telegram-cli"]
