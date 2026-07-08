function __jj_ai_commit_message --description "Generate commit message using available AI CLI tool"
    set -l diff_content (cat)
    set -l prompt "Generate a concise, conventional commit message for these changes. Return only the commit message, no explanation."

    # Tool should be passed in via environment or already set
    if not set -q tool
        echo "Error: AI tool not selected" >&2
        return 1
    end

    # Generate message with selected tool
    switch $tool
        case copilot
            # Standalone copilot CLI - context-aware, uses git repo directly
            copilot -p "$prompt" 2>/dev/null | string match -r '^[a-z]+(\([a-z]+\))?: .+$' | head -n 1
        case cursor cursor-agent
            echo "$diff_content" | cursor-agent "$prompt" 2>/dev/null | tail -n 1
        case claude
            echo "$diff_content" | claude "$prompt" 2>/dev/null | tail -n 1
        case codex
            set -l last_message_file (mktemp)
            echo "$diff_content" | codex exec -o "$last_message_file" "$prompt" >/dev/null 2>&1
            cat "$last_message_file" 2>/dev/null
            rm -f "$last_message_file"
        case '*'
            echo "Unknown AI tool: $tool" >&2
            return 1
    end
end
