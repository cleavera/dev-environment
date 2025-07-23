FROM debian:bookworm

ENV DEBIAN_FRONTEND=noninteractive

RUN \
  apt-get update \
  && apt-get install -y sudo zsh curl git starship tmux \
  && rm -rf /var/lib/apt/lists/* 

ARG USERNAME=dev
RUN useradd -m -s /bin/zsh $USERNAME && usermod -aG sudo $USERNAME

COPY set_password.sh /usr/local/bin/set_password.sh
RUN chmod +x /usr/local/bin/set_password.sh

COPY starship.toml /home/$USERNAME/.config/starship.toml

USER $USERNAME
WORKDIR /home/$USERNAME

CMD ["/usr/local/bin/set_password.sh"]
