function __jj_ai_select_tool --description "Interactive AI tool selector"
    set -l tools (__jj_ai_detect_tools)
    
    if test (count $tools) -eq 0
        echo (set_color red)"✗ No AI tools found. Please install one:"(set_color normal) >&2
        echo "  - copilot: https://github.com/github/copilot-cli" >&2
        echo "  - cursor-agent: https://cursor.sh" >&2
        echo "  - claude: https://claude.ai/cli" >&2
        return 1
    end
    
    if test (count $tools) -eq 1
        echo $tools[1]
        return 0
    end
    
    # Multiple tools available - show selection menu
    echo (set_color cyan)"🤖 Multiple AI tools detected. Select one:"(set_color normal) >&2
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
