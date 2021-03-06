FROM segment/chamber:2.7.5 as chamber

FROM alpine:3.13

COPY --from=chamber /chamber /usr/local/bin/chamber

ARG UID
ARG USER
ARG DOCKER_GID
ENV USER=$USER

RUN apk update && apk add \
 sudo curl git make bash vim less shadow openssh-client \
 util-linux coreutils binutils findutils grep gawk sed \
 mandoc man-pages mandoc-apropos \
 figlet

# python, pip
RUN \
  apk add python3 && \
  python3 -m ensurepip && \
  ln -s /usr/bin/python3 /usr/bin/python && \
  pip3 install --no-cache --upgrade pip setuptools && \
  python --version && \
  pip3 --version

# docker-cli and docker-compose
RUN \
  apk add docker-cli libffi-dev openssl-dev gcc libc-dev rust cargo python3-dev && \
  pip install docker-compose

RUN \
  addgroup -g $DOCKER_GID docker && \
  adduser $USER -u $UID -D -s /bin/bash && \
  addgroup $USER docker && \
  addgroup $USER wheel && \
  echo "%wheel ALL=(ALL) NOPASSWD: ALL">/etc/sudoers.d/wheel-group

COPY scripts/ /usr/local/bin
COPY dotfiles/.vimrc /root/

RUN \
  echo "set bell-style none" >>/etc/inputrc && \
  rm /usr/bin/vi && \
  ln -s /usr/bin/vim /usr/bin/vi && \
  update-apk-doc

WORKDIR /home/$USER
COPY dotfiles/ .
RUN chown -R $USER.$USER .

USER $USER

ENTRYPOINT [ "/bin/sh", "-c" ]
CMD [ "/bin/bash --login", "# NOP kludge" ]
