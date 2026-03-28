function __jj_ai_select_tool --description "Interactive AI provider selector"
    set -l tools (__jj_ai_detect_tools)

    if test (count $tools) -eq 0
        echo (set_color red)"✗ No AI API keys found. Please set one:"(set_color normal) >&2
        echo "  - OpenAI: export OPENAI_API_KEY='your-key'" >&2
        echo "    Get key: https://platform.openai.com/api-keys" >&2
        echo "  - Anthropic: export ANTHROPIC_API_KEY='your-key'" >&2
        echo "    Get key: https://console.anthropic.com/settings/keys" >&2
        echo "  - DeepSeek: export DEEPSEEK_API_KEY='your-key'" >&2
        echo "    Get key: https://platform.deepseek.com/api_keys" >&2
        return 1
    end

    if test (count $tools) -eq 1
        echo $tools[1]
        return 0
    end

    # Multiple providers available - show selection menu
    echo (set_color cyan)"🤖 Multiple AI providers detected. Select one:"(set_color normal) >&2
    for i in (seq (count $tools))
        echo (set_color yellow)"$i."(set_color normal) "$tools[$i]" >&2
    end

    read -P (set_color green)"Choice [1-"(count $tools)"]: "(set_color normal) -l choice

    if test -z "$choice"; or not string match -qr '^\d+$' "$choice"
        return 1
    end

    if test $choice -ge 1; and test $choice -le (count $tools)
        echo $tools[$choice]
        return 0
    end

    return 1
end
