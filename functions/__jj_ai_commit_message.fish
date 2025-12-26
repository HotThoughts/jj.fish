function __jj_ai_commit_message --description "Generate commit message using available AI tool"
    set -l diff $argv[1]
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
            echo "$diff" | cursor-agent "$prompt" 2>/dev/null | tail -n 1
        case claude
            echo "$diff" | claude "$prompt" 2>/dev/null | tail -n 1
        case '*'
            echo "Unknown AI tool: $tool" >&2
            return 1
    end
end
