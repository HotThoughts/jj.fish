# jj.fish/functions/abbr.fish
# Abbreviations for jj.fish plugin

# Core jj operations
abbr --add jjl 'jj log'
abbr --add jjll 'jj log --limit'
abbr --add jjlr 'jj log --revisions'
abbr --add jjst 'jj st'
abbr --add jjd 'jj describe'
abbr --add jjdm 'jj describe -m'
abbr --add jjn 'jj new'
abbr --add jjnm 'jj new main'
abbr --add jjnmo 'jj new main@origin'
abbr --add jja 'jj abandon'
abbr --add jjr 'jj rebase'
abbr --add jjrmo 'jj rebase -d main@origin'
abbr --add jjc 'jj commit'
abbr --add jjci 'jj commit -i'

# Viewing and comparing
abbr --add jjs 'jj show'
abbr --add jjdf 'jj diff'
abbr --add jjid 'jj interdiff'
abbr --add jjev 'jj evolog'

# Editing changes
abbr --add jje 'jj edit'
abbr --add jjsq 'jj squash'
abbr --add jjsqi 'jj squash -i'
abbr --add jjsp 'jj split'
abbr --add jjde 'jj diffedit'
abbr --add jjab 'jj absorb'

# Navigation
abbr --add jjnx 'jj next'
abbr --add jjpv 'jj prev'

# Bookmarks (branches)
abbr --add jjb 'jj bookmark'
abbr --add jjbl 'jj bookmark list'
abbr --add jjbs 'jj bookmark set'
abbr --add jjbt 'jj bookmark track'
abbr --add jjbd 'jj bookmark delete'

# Operations
abbr --add jjop 'jj op'
abbr --add jjopl 'jj op log'
abbr --add jju 'jj undo'

# Conflict resolution
abbr --add jjrs 'jj resolve'
abbr --add jjrt 'jj restore'

# Advanced operations
abbr --add jjdu 'jj duplicate'
abbr --add jjrv 'jj revert'
abbr --add jjpa 'jj parallelize'

# Git integration
abbr --add jjgic 'jj git init --colocate'
abbr --add jjgp 'jj git push'
abbr --add jjgpc 'jj git push --change'
abbr --add jjgf 'jj git fetch'

# Alternative shorter abbreviations
abbr --add ji 'jj git init --colocate'
abbr --add jp 'jj git push'
abbr --add jf 'jj git fetch'
abbr --add jd 'jj describe -m'
abbr --add jr 'jj rebase -d main@origin'
abbr --add jc 'jj commit'
abbr --add jci 'jj commit -i'
abbr --add jbt 'jj bookmark track'
abbr --add jbs 'jj bookmark set'
