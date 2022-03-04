FROM debian:buster-slim

RUN echo 'deb http://deb.debian.org/debian buster-backports main' > /etc/apt/sources.list.d/buster-backports.list

RUN apt-get update &&\
    apt-get install -y moreutils\
                       libimage-exiftool-perl\
                       build-essential\
                       libffi-dev\
                       qalculate\
                       task-spooler\
                       build-essential\
                       libffi-dev\
                       unzip\
                       xmlstarlet\
                       jq\
                       sox\
                       libsox-fmt-all\
                       unrar-free\
                       curl\
                       ncdu\
                       rclone\
                       restic\
                       ripgrep\
                       ranger\
                       git\
                       locales-all\
                       apt-transport-https\
                       ca-certificates\
                       lsb-release\
                       rlwrap\
                       fzf\
                       gpg\
                       ffmpeg\
                       lua5.3\
                       gettext\
                       python3-pip\
                       python3-virtualenv\
                       python3\
                       netcat\
                       ucspi-tcp\
                       procps\
                       adb\
                       direnv\
                       postgresql-client &&\
    apt-get install -t buster-backports -y tmux

RUN echo 'deb http://download.opensuse.org/repositories/shells:/fish:/release:/3/Debian_10/ /' | tee /etc/apt/sources.list.d/shells:fish:release:3.list
RUN curl -fsSL https://download.opensuse.org/repositories/shells:fish:release:3/Debian_10/Release.key | gpg --dearmor | tee /etc/apt/trusted.gpg.d/shells_fish_release_3.gpg > /dev/null

RUN apt-get update && apt-get install -y fish

RUN curl -fsSL https://download.docker.com/linux/debian/gpg | gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
RUN echo "deb [arch=amd64 signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/debian $(lsb_release -cs) stable" | tee /etc/apt/sources.list.d/docker.list
RUN apt-get update &&\
    apt-get install -y docker-ce-cli

RUN pip3 install docker-compose
 
RUN sh -c 'echo "deb http://apt.postgresql.org/pub/repos/apt $(lsb_release -cs)-pgdg main" > /etc/apt/sources.list.d/pgdg.list'
RUN curl -L https://www.postgresql.org/media/keys/ACCC4CF8.asc | apt-key add -
RUN apt-get update && apt-get -y install postgresql-client-13

WORKDIR /root

RUN curl -sL https://raw.githubusercontent.com/skywind3000/z.lua/1.8.10/z.lua > /usr/bin/z.lua &&\
    chmod 755 /usr/bin/z.lua &&\
    mkdir -p .config/fish/conf.d &&\
    echo "z.lua --init fish | source" >> .config/fish/conf.d/z.fish

RUN cd /tmp &&\
    curl -L https://github.com/borkdude/jet/releases/download/v0.0.13/jet-0.0.13-linux-amd64.zip > jet.zip &&\
    unzip /tmp/jet.zip &&\
    cp jet /usr/local/bin/

RUN cd /tmp &&\
    curl -L https://github.com/babashka/babashka/releases/download/v0.6.7/babashka-0.6.7-linux-amd64.tar.gz > babashka.tgz &&\
    tar zxf babashka.tgz &&\
    cp bb /usr/local/bin/

RUN apt-get install -y openjdk-11-jdk-headless

RUN curl https://download.clojure.org/install/linux-install-1.10.3.1029.sh | bash &&\
    clj -Spath

RUN cd /tmp &&\
    curl -L https://github.com/clojure-lsp/clojure-lsp/releases/download/2021.11.16-16.52.14/clojure-lsp-native-linux-amd64.zip > clojure-lsp.zip &&\
    unzip clojure-lsp.zip &&\
    mv clojure-lsp /usr/local/bin/

RUN cd /tmp &&\
    curl -L https://github.com/sharkdp/fd/releases/download/v8.2.1/fd-musl_8.2.1_amd64.deb > fd.deb &&\
    dpkg -i fd.deb

RUN cd /tmp &&\
    curl -L https://github.com/sharkdp/bat/releases/download/v0.17.1/bat-musl_0.17.1_amd64.deb > bat.deb &&\
    dpkg -i bat.deb

RUN cd /tmp &&\
    curl -L https://github.com/greglook/cljstyle/releases/download/0.15.0/cljstyle_0.15.0_linux_static.zip > cljstyle.zip &&\
    unzip cljstyle.zip &&\
    cp cljstyle /usr/bin &&\
    chmod 755 /usr/bin/cljstyle

RUN curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip" &&\
    unzip awscliv2.zip &&\
    ./aws/install

RUN rm -r /tmp/*

WORKDIR /root

RUN rm -rf .config/clojure &&\
    git clone https://github.com/practicalli/clojure-deps-edn.git .config/clojure &&\
    rm .config/clojure/rebel_readline.edn

RUN git clone https://github.com/tmux-plugins/tpm .tmux/plugins/tpm
COPY tmux.conf .tmux.conf

COPY config.fish .config/fish/
COPY git-aliases.fish .config/fish/conf.d/
COPY functions .config/fish/functions
RUN fish -c 'curl -sL https://git.io/fisher | source &&\
             fisher install jorgebucaran/fisher &&\
             fisher install jethrokuan/fzf &&\
             fisher install rafaelrinaldi/pure &&\
             fisher install h-matsuo/fish-color-scheme-switcher &&\
             fisher install skywind3000/z.lua &&\
             fisher install danhper/fish-ssh-agent'

RUN cd /tmp &&\
    curl -LO https://github.com/neovim/neovim/releases/latest/download/nvim.appimage &&\
    chmod 755 nvim.appimage &&\
    ./nvim.appimage --appimage-extract &&\
    mv squashfs-root /opt/nvim &&\
    ln -s /opt/nvim/AppRun /usr/bin/nvim

RUN curl -fLo .config/nvim/autoload/plug.vim --create-dirs\
      https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

COPY nvim .config/nvim
# RUN fish -c "nvim +PackerInstall +qall"

RUN mkdir .docker
COPY docker_config.json .docker/config.json

COPY bin /root/bin
RUN chmod 755 /root/bin/*

RUN git config --global user.email "spieden@exaptic.com"

CMD fish

