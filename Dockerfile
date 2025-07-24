FROM debian:bookworm

ENV DEBIAN_FRONTEND=noninteractive

RUN \
  apt-get update \
  && apt-get install -y \
    build-essential \
    pkg-config \
    libssl-dev \
    cmake \
    sudo \
    zsh \
    curl \
    git \
    tmux \
  && rm -rf /var/lib/apt/lists/* 

ARG USERNAME=dev
RUN useradd -m -s /bin/zsh $USERNAME && usermod -aG sudo $USERNAME
RUN chown -R $USERNAME:$USERNAME /home/$USERNAME

RUN sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended

COPY projects.zsh /home/$USERNAME/.oh-my-zsh/custom/projects.zsh
COPY set_password.sh /usr/local/bin/set_password.sh
RUN chmod +x /home/$USERNAME/.oh-my-zsh/custom/projects.zsh
RUN chmod +x /usr/local/bin/set_password.sh

USER $USERNAME
WORKDIR /home/$USERNAME

RUN curl https://sh.rustup.rs -sSf | sh -s -- -y
ENV PATH="/home/${USERNAME}/.cargo/bin:${PATH}"
RUN cargo install starship --locked \
  && cargo install gitui --locked

RUN mkdir -p .config
COPY starship.toml /home/$USERNAME/.config/starship.toml

CMD ["/usr/local/bin/set_password.sh"]
