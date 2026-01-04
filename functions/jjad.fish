function jjad --description "AI-powered jj description generator (uses OpenAI/Anthropic/DeepSeek API)"
    # Get the current diff
    set -l changes (jj diff --git 2>/dev/null; or jj diff)

    if test -z "$changes"
        echo (set_color yellow)"⚠ No changes to commit"(set_color normal)
        return 1
    end

    # Select AI provider first (before spinner)
    set -l tool
    if set -q JJ_AI_TOOL
        set tool $JJ_AI_TOOL
        # Validate that the tool is supported
        set -l available_tools (__jj_ai_detect_tools)
        if not contains $tool $available_tools
            echo (set_color yellow)"⚠ JJ_AI_TOOL is set to '$tool' but this provider is not available."(set_color normal) >&2
            echo (set_color yellow)"   Falling back to auto-detection..."(set_color normal) >&2
            set -e JJ_AI_TOOL
            set tool (__jj_ai_select_tool)
            if test $status -ne 0
                return 1
            end
        end
    else
        set tool (__jj_ai_select_tool)
        if test $status -ne 0
            return 1
        end
    end

    # Create temp files for input and output
    set -l input_file (mktemp)
    set -l output_file (mktemp)
    echo "$changes" >$input_file

    # Run API call in background
    # Using a block inherits all functions and variables from the current session
    begin
        __jj_ai_commit_message < $input_file
    end >$output_file 2>&1 &
    set -l bg_pid $last_pid

    # Show spinner with timeout (10s)
    __jj_ai_spinner $bg_pid 10

    # Wait for the background job to complete
    wait $bg_pid 2>/dev/null
    set -l wait_status $status

    # Read the result
    set -l message (cat $output_file 2>/dev/null)
    rm -f $input_file $output_file

    # Check if process timed out or failed
    if test $wait_status -ne 0; or test -z "$message"
        set api_status 1
    else
        set api_status 0
    end

    if test $api_status -ne 0; or test -z "$message"; or string match -q "*Error:*" "$message"
        echo (set_color red)"✗ Failed to generate commit message"(set_color normal)
        if test -n "$message"
            echo (set_color yellow)"$message"(set_color normal) >&2
        else if test $api_status -ne 0
            echo (set_color yellow)"Request timed out or failed. Check your API key and network connection."(set_color normal) >&2
        end
        return 1
    end

    # Display the generated message
    echo (set_color blue)"💬 Generated message:"(set_color normal) (set_color white --bold)"$message"(set_color normal)

    # Ask for confirmation
    read -P (set_color green)"Use this message? [Y/n] "(set_color normal) -l confirm

    if test -z "$confirm"; or string match -qi "y*" "$confirm"
        jj describe -m "$message"
        echo (set_color green)"✓ Description set"(set_color normal)
    else
        echo (set_color red)"✗ Cancelled"(set_color normal)
        return 1
    end
end
