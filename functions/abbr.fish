# jj.fish/functions/abbr.fish
# Abbreviations for jj.fish plugin

# === Status and Inspection ===
abbr --add jjst 'jj st'                          # Show status
abbr --add jjl 'jj log'                          # Show change log
abbr --add jjll 'jj log --limit'                 # Show log with limit
abbr --add jjlr 'jj log --revisions'             # Show log for specific revisions

# === Creating and Modifying Changes ===
abbr --add jjnm 'jj new main'                    # Create new change based on main
abbr --add jjnmo 'jj new main@origin'            # Create new change based on origin/main
abbr --add jjd 'jj describe'                     # Edit change description
abbr --add jjdm 'jj describe -m'                 # Set change description with message
abbr --add jja 'jj abandon'                      # Abandon a change

# === History Management ===
abbr --add jjrmo 'jj rebase -d main@origin'      # Rebase onto origin/main
abbr --add jjc 'jj commit'                       # Commit change
abbr --add jjci 'jj commit -i'                   # Commit change interactively

# === Bookmarks (branches) ===
abbr --add jjbs 'jj bookmark set'                # Set bookmark
abbr --add jjbt 'jj bookmark track'              # Track remote bookmark

# === Git Integration ===
abbr --add jjgic 'jj git init --colocate'        # Initialize colocated Git repo
abbr --add jjgp 'jj git push'                    # Push to Git remote
abbr --add jjgpc 'jj git push --change'          # Push specific change to Git remote
abbr --add jjgf 'jj git fetch'                   # Fetch from Git remote

# === Short Forms (ultra-brief alternatives) ===
abbr --add ji 'jj git init --colocate'           # Short: init
abbr --add jp 'jj git push'                      # Short: push
abbr --add jd 'jj describe -m'                   # Short: describe
abbr --add jr 'jj rebase -d main@origin'         # Short: rebase
abbr --add jc 'jj commit'                        # Short: commit
abbr --add jci 'jj commit -i'                    # Short: commit interactive
