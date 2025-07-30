# jj.fish plugin initialization
# This file is loaded when the plugin is installed

status is-interactive; or exit

# Check for required dependencies
if not command -q jj
    echo "jj.fish: Warning: jj (Jujutsu) is not installed or not in PATH" >&2
end
