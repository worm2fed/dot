set -g theme_color_scheme zenburn
set -g fish_color_autosuggestion 'a4d2ae'
set -g VIRTUAL_ENV_DISABLE_PROMPT 1

set -gx PATH "/usr/local/sbin" $PATH
set -gx PATH "/usr/local/bin/" $PATH
set -gx PATH "/usr/local/opt/gnu-getopt/bin" $PATH

# haskell
set -gx PATH "$HOME/.ghcup/bin" $PATH
set -gx PATH "$HOME/.cabal/bin/" $PATH
set -gx PATH "$HOME/.local/bin/" $PATH

# icu4c
set -g LDFLAGS "-L/usr/local/opt/icu4c/lib"
set -g CPPFLAGS "-I/usr/local/opt/icu4c/include"

# neo4j
#set -g NEO4J_HOME "$HOME/workspace/neo4j"
