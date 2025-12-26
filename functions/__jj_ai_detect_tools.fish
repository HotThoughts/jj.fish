function __jj_ai_detect_tools --description "Detect available AI tools"
    # Check for standalone GitHub Copilot CLI (preferred)
    if command -q copilot
        echo "copilot"
    end
    
    # Check for cursor-agent
    if command -q cursor-agent
        echo "cursor-agent"
    end
    
    # Check for Claude CLI
    if command -q claude
        echo "claude"
    end
end
