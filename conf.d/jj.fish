# jj.fish plugin initialization
# This file is loaded when the plugin is installed

status is-interactive; or exit

# Set default configuration if not already set
if not set -q jj_fish_branch_prefix
    set -g jj_fish_branch_prefix push-
end

if not set -q jj_fish_change_id_length
    set -g jj_fish_change_id_length 12
end

# Check for required dependencies
if not command -q jj
    echo "jj.fish: Warning: jj (Jujutsu) is not installed or not in PATH" >&2
end

if not command -q gh
    echo "jj.fish: Warning: GitHub CLI (gh) is not installed. PR creation will not work." >&2
end

# Fish abbreviations for jj workflows
abbr -a jgi 'jj git init --colocate'
abbr -a jgp 'jj git push'
abbr -a jd 'jj describe -m'
