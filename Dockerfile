FROM python:3

ARG GITHUB_EMAIL
ARG GITHUB_USERNAME
ARG GITHUB_TOKEN
ARG USERID

# download steamcmd/git/python requirements
RUN apt-get -y update && \
    apt-get -y install lib32gcc1 lib32stdc++6 wget git && \
    apt-get clean && \
    rm -rf /var/lib/{apt,dpkg,cache,log}/

# setup steam user
RUN useradd -m steam -u ${USERID}
WORKDIR /home/steam
USER steam

RUN pip install gitpython
RUN git config --global user.email ${GITHUB_EMAIL}
RUN git config --global user.name ${GITHUB_USERNAME}
RUN git config --global user.token ${GITHUB_TOKEN}
RUN git config --global credential.helper store

COPY know_hosts /root/.ssh/known_hosts

# download steamcmd
RUN mkdir steamcmd && cd steamcmd && \
    wget -O - "https://steamcdn-a.akamaihd.net/client/installer/steamcmd_linux.tar.gz" | tar zxvf -

# start steamcmd to force it to update itself
RUN ./steamcmd/steamcmd.sh +quit && \
    mkdir -pv /home/steam/.steam/sdk32/ && \
    ln -s /home/steam/steamcmd/linux32/steamclient.so /home/steam/.steam/sdk32/steamclient.so

WORKDIR /app

CMD [ "python", "/app/main.py" ]