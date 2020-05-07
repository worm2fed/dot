set -g theme_color_scheme zenburn
set -g fish_color_autosuggestion 'a4d2ae'
set -g VIRTUAL_ENV_DISABLE_PROMPT 1

set -gx PATH $PATH "/usr/local/opt/gnu-getopt/bin"

# haskell
set -gx PATH $PATH "$HOME/.ghcup/bin"
set -gx PATH $PATH "$HOME/.cabal/bin/"
set -gx PATH $PATH "$HOME/.local/bin/"
