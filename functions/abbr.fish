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
abbr --add jja 'jj abandon'
abbr --add jjrmo 'jj rebase -d main@origin'
abbr --add jjc 'jj commit'
abbr --add jjci 'jj commit -i'
abbr --add jjbs 'jj bookmark set'
abbr --add jjbt 'jj bookmark track'

# Git integration
abbr --add jjgic 'jj git init --colocate'
abbr --add jjgp 'jj git push'
abbr --add jjgpc 'jj git push --change'
abbr --add jjgf 'jj git fetch'

# Alternative shorter abbreviations
abbr --add ji 'jj git init --colocate'
abbr --add jp 'jj git push'
abbr --add jd 'jj describe -m'
abbr --add jr 'jj rebase -d main@origin'
abbr --add jc 'jj commit'
abbr --add jci 'jj commit -i'
