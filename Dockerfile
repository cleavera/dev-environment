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
    fzf \
    tzdata \
  && rm -rf /var/lib/apt/lists/*

ENV TZ=Europe/London
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

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

RUN curl https://sh.rustup.rs -sSf | sh -s -- -y
ENV PATH="/home/${USERNAME}/.cargo/bin:${PATH}"
RUN cargo install starship --locked
RUN cargo install gitui --locked 
RUN cargo install gitlist --locked
RUN cargo install fnm --locked

RUN git clone https://github.com/neovim/neovim ~/.local/share/neovim \
  && cd ~/.local/share/neovim \
  && make CMAKE_BUILD_TYPE=RelWithDebInfo \
  && sudo make install

ENV FNM_DIR="/home/$USERNAME/.local/share/fnm"
ENV PATH="/home/$USERNAME/.local/share/fnm:$PATH"
RUN eval "$(fnm env --shell bash)" && fnm install lts/jod && fnm default lts/jod && npm install -g @google/gemini-cli@0.1.18

COPY projects.zsh /home/$USERNAME/.oh-my-zsh/custom/projects.zsh
COPY starship.toml /home/$USERNAME/.config/starship.toml
COPY .zshrc /home/$USERNAME/.zshrc
COPY .tmux.conf /home/$USERNAME/.tmux.conf
COPY gitui-theme.ron /home/$USERNAME/.config/gitui/theme.ron
COPY git-checkout.sh /usr/local/bin/git-checkout.sh
COPY entrypoint.sh /usr/local/bin/entrypoint.sh
COPY clean-repos.sh /usr/local/bin/clean-repos.sh

RUN sudo dos2unix /home/$USERNAME/.oh-my-zsh/custom/projects.zsh /home/$USERNAME/.config/starship.toml /home/$USERNAME/.zshrc /home/$USERNAME/.tmux.conf /home/$USERNAME/.config/gitui/theme.ron /usr/local/bin/git-checkout.sh /usr/local/bin/entrypoint.sh /usr/local/bin/clean-repos.sh
RUN sudo chmod +x /home/$USERNAME/.oh-my-zsh/custom/projects.zsh /usr/local/bin/git-checkout.sh /usr/local/bin/entrypoint.sh /usr/local/bin/clean-repos.sh
RUN sudo chown -R $USERNAME:$USERNAME /home/$USERNAME/.config

RUN git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm && ~/.tmux/plugins/tpm/bin/install_plugins
RUN git clone https://github.com/cleavera/nvim-config ~/.config/nvim

RUN nvim --headless -c "MasonInstallAll" -c "qa!"

ARG GIT_USER_NAME
ARG GIT_USER_EMAIL
RUN if [ -n "$GIT_USER_NAME" ]; then git config --global user.name "$GIT_USER_NAME"; fi && \
    if [ -n "$GIT_USER_EMAIL" ]; then git config --global user.email "$GIT_USER_EMAIL"; fi

RUN git config --global credential.helper store

USER root
RUN echo "$USERNAME:admin" | chpasswd && passwd -e $USERNAME && rm /etc/sudoers.d/$USERNAME

USER $USERNAME
WORKDIR /home/$USERNAME

ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]
CMD ["/bin/zsh"]
