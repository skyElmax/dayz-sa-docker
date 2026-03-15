FROM steamcmd/steamcmd:latest

ENV DEBIAN_FRONTEND=noninteractive
ENV CLIENT_MODS=""
ENV STEAM_USER=""
ENV STEAM_PASSWORD=""
ENV CONFIGURATION="Release"

# install deps
RUN apt-get update && apt-get install -y \
    curl \
    lib32gcc-s1 \
    tar \
    procps \
    rsync

# update steamcmd & validate user permissions
RUN steamcmd +quit

# game
EXPOSE 2302/udp 2303/udp 2304/udp 2305/udp

# steam
EXPOSE 8766/udp 27016/udp

VOLUME /root/servers/dayz-server

WORKDIR /root/servers/
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

ENTRYPOINT [ "/bin/bash", "/entrypoint.sh" ]

CMD [ "start" ]