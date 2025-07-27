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
    wget \
    fontconfig \
    locales \
    unzip \
  && rm -rf /var/lib/apt/lists/*

RUN sed -i '/en_GB.UTF-8/s/^# //g' /etc/locale.gen && locale-gen
ENV LANG=en_GB.UTF-8
ENV LANGUAGE=en_GB:en
ENV LC_ALL=en_GB.UTF-8

RUN mkdir -p /usr/local/share/fonts/caskaydiamono \
    && wget -O /tmp/caskaydia.zip https://github.com/ryanoasis/nerd-fonts/releases/download/v3.2.1/CascadiaCode.zip \
    && unzip /tmp/caskaydia.zip -d /usr/local/share/fonts/caskaydiamono \
    && rm /tmp/caskaydia.zip \
    && fc-cache -f -v 

ARG USERNAME=dev
RUN useradd -m -s /bin/zsh $USERNAME && usermod -aG sudo $USERNAME && \
    echo "$USERNAME ALL=(ALL) NOPASSWD:ALL" > /etc/sudoers.d/$USERNAME
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

RUN git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm && ~/.tmux/plugins/tpm/bin/install_plugins
RUN git clone https://github.com/neovim/neovim ~/git/neovim \
  && make CMAKE_BUILD_TYPE=RelWithDebInfo \
  && sudo make install

CMD ["sudo /usr/local/bin/set_password.sh"]
