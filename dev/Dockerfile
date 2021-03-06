FROM alpine:3.13

ARG UID
ARG USERNAME
ARG DOCKER_GID
ENV USERNAME=$USERNAME

RUN apk update && apk add \
 sudo curl git make bash vim less shadow openssh-client \
 util-linux coreutils binutils findutils grep gawk sed \
 mandoc man-pages mandoc-apropos

# python, pip
RUN \
  apk add python3 && \
  python3 -m ensurepip && \
  ln -s /usr/bin/python3 /usr/bin/python && \
  pip3 install --no-cache --upgrade pip setuptools && \
  python --version && \
  pip3 --version

# docker, docker-compose
ARG COMPOSE_VERSION=1.28.5
ARG COMPOSE_URL="https://github.com/docker/compose/releases/download"
ARG COMPOSE_VERSION="1.28.5"
ARG COMPOSE_FILE="docker-compose-Linux-x86_64"
ARG COMPOSE_BIN="/usr/local/bin/docker-compose"
RUN \
  apk add docker-cli libffi-dev openssl-dev gcc libc-dev rust cargo && \
  curl -L "${COMPOSE_URL}/${COMPOSE_VERSION}/${COMPOSE_FILE}" -o "${COMPOSE_BIN}" && \
  chmod +x "${COMPOSE_BIN}"

RUN \
  addgroup -g $DOCKER_GID docker && \
  adduser $USERNAME -u $UID -D -s /bin/bash && \
  addgroup $USERNAME docker && \
  addgroup $USERNAME wheel && \
  echo "%wheel ALL=(ALL) NOPASSWD: ALL">/etc/sudoers.d/wheel-group

COPY scripts/ /usr/local/bin
COPY dotfiles/.vimrc /root/

RUN \
  echo "set bell-style none" >>/etc/inputrc && \
  rm /usr/bin/vi && \
  ln -s /usr/bin/vim /usr/bin/vi && \
  update-apk-doc

WORKDIR /home/$USERNAME
COPY dotfiles/ .
RUN chown -R $USERNAME.$USERNAME .

USER $USERNAME

ENTRYPOINT [ "/bin/sh", "-c" ]
CMD [ "/bin/bash --login", "# NOP kludge" ]
