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
    dos2unix \
  && rm -rf /var/lib/apt/lists/* 

ARG USERNAME=dev
RUN useradd -m -s /bin/zsh $USERNAME && usermod -aG sudo $USERNAME
USER $USERNAME
WORKDIR /home/$USERNAME
RUN sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended

USER root

COPY projects.zsh /home/$USERNAME/.oh-my-zsh/custom/projects.zsh
COPY set_password.sh /usr/local/bin/set_password.sh
COPY starship.toml /home/$USERNAME/.config/starship.toml
COPY .zshrc /home/$USERNAME/.zshrc
COPY .tmux.conf /home/$USERNAME/.tmux.conf

RUN dos2unix /home/$USERNAME/.oh-my-zsh/custom/projects.zsh /usr/local/bin/set_password.sh /home/$USERNAME/.config/starship.toml /home/$USERNAME/.zshrc /home/$USERNAME/.tmux.conf && \
    chmod +x /home/$USERNAME/.oh-my-zsh/custom/projects.zsh /usr/local/bin/set_password.sh && \
    chown -R $USERNAME:$USERNAME /home/$USERNAME

USER $USERNAME
WORKDIR /home/$USERNAME

RUN curl https://sh.rustup.rs -sSf | sh -s -- -y
ENV PATH="/home/${USERNAME}/.cargo/bin:${PATH}"
RUN cargo install starship --locked \
  && cargo install gitui --locked

RUN git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm

CMD ["sudo /usr/local/bin/set_password.sh"]
