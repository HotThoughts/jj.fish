function __jj_ai_detect_tools --description "Detect available AI API providers"
    # Check for OpenAI API key
    if set -q OPENAI_API_KEY; and test -n "$OPENAI_API_KEY"
        echo openai
    end

    # Check for Anthropic API key
    if set -q ANTHROPIC_API_KEY; and test -n "$ANTHROPIC_API_KEY"
        echo anthropic
    end

    # Check for DeepSeek API key
    if set -q DEEPSEEK_API_KEY; and test -n "$DEEPSEEK_API_KEY"
        echo deepseek
    end
end
