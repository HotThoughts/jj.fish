function __jj_ai_commit_message --description "Generate commit message using available AI CLI tool"
    set -l tool $argv[1]
    set -l prompt "Generate a concise, conventional commit message for these changes. Return only the commit message, no explanation."

    if test -z "$tool"
        echo "Error: AI tool not selected" >&2
        return 1
    end

    # Generate message with selected tool. The diff is read from this
    # function's own stdin (the caller redirects it in), which each command
    # below inherits directly - avoids ever buffering a multi-line diff in a
    # fish variable, which would split it into a list and corrupt it.
    switch $tool
        case copilot
            # Standalone copilot CLI - context-aware, uses git repo directly
            copilot -p "$prompt" 2>/dev/null | string match -r '^[a-z]+(\([a-z]+\))?: .+$' | head -n 1
        case cursor cursor-agent
            cursor-agent "$prompt" 2>/dev/null | tail -n 1
        case claude
            claude "$prompt" 2>/dev/null | tail -n 1
        case codex
            set -l last_message_file (mktemp)
            codex exec -o "$last_message_file" "$prompt" >/dev/null 2>&1
            cat "$last_message_file" 2>/dev/null
            rm -f "$last_message_file"
        case '*'
            echo "Unknown AI tool: $tool" >&2
            return 1
    end
end
