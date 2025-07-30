# jj.fish/functions/abbr.fish
# Abbreviations for jj.fish plugin

# Core jj operations
abbr --add jjl 'jj log'
abbr --add jjll 'jj log --limit'
abbr --add jjlr 'jj log --revisions'
abbr --add jjst 'jj st'
abbr --add jjd 'jj describe'
abbr --add jjdm 'jj describe -m'
abbr --add jjnm 'jj new main'
abbr --add jjnmo 'jj new main@origin'

# Git integration
abbr --add jjgic 'jj git init --colocate'
abbr --add jjgp 'jj git push'
abbr --add jjgpc 'jj git push --change'
abbr --add jjgf 'jj git fetch'

# Alternative shorter abbreviations
abbr --add jgi 'jj git init --colocate'
abbr --add jgp 'jj git push'
abbr --add jd 'jj describe -m'
