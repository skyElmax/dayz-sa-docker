FROM steamcmd/steamcmd:latest

ENV DEBIAN_FRONTEND=noninteractive
ENV CLIENT_MODS=""
ENV STEAM_USER=""
ENV STEAM_PASSWORD=""
ENV CONFIGURATION="Release"

# install deps
RUN apt-get update
RUN apt-get upgrade -y
RUN apt-get install curl -y
RUN apt-get install lib32gcc-s1 -y
RUN apt-get install tar -y
RUN apt-get install procps -y
RUN apt-get install rsync -y

# update steamcmd & validate user permissions
RUN steamcmd +quit

# game
EXPOSE 2302/udp 2303/udp 2304/udp 2305/udp

# steam
EXPOSE 8766/udp 27016/udp

VOLUME /root/servers/dayz-server

COPY entrypoint.sh /root/servers/entrypoint.sh
RUN chmod +x /root/servers/entrypoint.sh

ENTRYPOINT [ "/root/servers/entrypoint.sh" ]

CMD [ "start" ]