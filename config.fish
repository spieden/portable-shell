fish_hybrid_key_bindings

set fish_greeting
set -x EDITOR nvim
set -x BAT_THEME "Solarized (light)"
set -x SHELL /usr/bin/fish
set -x _ZL_DATA ~/.local/zlua
set -x CLJ_CONFIG ~/.config/clojure
set -x DOCKER_CONTEXT default

set fish_color_autosuggestion brgreen

direnv hook fish | source

fish_add_path /root/bin

