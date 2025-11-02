# jj.fish plugin initialization
# This file is loaded when the plugin is installed

status is-interactive; or exit

# Check for required dependencies
if not command -q jj
    echo "jj.fish: Error: jj (Jujutsu) is not installed or not in PATH" >&2
    echo "Install from: https://github.com/martinvonz/jj" >&2
end

# Optional dependency for PR creation (jjpr function)
if not command -q gh
    echo "jj.fish: Info: gh CLI not found. The 'jjpr' function requires it for PR creation." >&2
    echo "Install from: https://cli.github.com" >&2
end
