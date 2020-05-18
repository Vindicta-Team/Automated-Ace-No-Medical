FROM python:3

# download steamcmd requirements
RUN apt-get -y update && \
    apt-get -y install lib32gcc1 lib32stdc++6 wget && \
    apt-get clean && \
    rm -rf /var/lib/{apt,dpkg,cache,log}/

# setup steam user
RUN useradd -m steam
WORKDIR /home/steam
USER steam

# download steamcmd
RUN mkdir steamcmd && cd steamcmd && \
    wget -O - "https://steamcdn-a.akamaihd.net/client/installer/steamcmd_linux.tar.gz" | tar zxvf -

# start steamcmd to force it to update itself
RUN ./steamcmd/steamcmd.sh +quit && \
    mkdir -pv /home/steam/.steam/sdk32/ && \
    ln -s /home/steam/steamcmd/linux32/steamclient.so /home/steam/.steam/sdk32/steamclient.so

WORKDIR /app

CMD [ "python", "/app/main.py" ]