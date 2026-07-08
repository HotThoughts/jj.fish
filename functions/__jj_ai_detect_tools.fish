function __jj_ai_detect_tools --description "Detect available AI CLI tools"
    if command -q copilot
        echo copilot
    end

    if command -q cursor-agent
        echo cursor-agent
    end

    if command -q claude
        echo claude
    end

    if command -q codex
        echo codex
    end
end
