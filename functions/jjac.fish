function jjac --description "AI-powered jj commit (uses your AI CLI tool)"
    # Get the current diff, written straight to a file - fish would otherwise
    # split multi-line command substitution output into a list and mangle it
    set -l input_file (mktemp)
    if not jj diff --git >$input_file 2>/dev/null
        jj diff >$input_file
    end

    if test ! -s $input_file
        echo (set_color yellow)"⚠ No changes to commit"(set_color normal)
        rm -f $input_file
        return 1
    end

    # Select AI tool first
    set -l tool
    if set -q JJ_AI_TOOL
        set tool $JJ_AI_TOOL
        # Validate that the tool is supported
        set -l available_tools (__jj_ai_detect_tools)
        if not contains $tool $available_tools
            echo (set_color yellow)"⚠ JJ_AI_TOOL is set to '$tool' but this tool is not available."(set_color normal) >&2
            echo (set_color yellow)"   Falling back to auto-detection..."(set_color normal) >&2
            set tool (__jj_ai_select_tool)
            if test $status -ne 0
                rm -f $input_file
                return 1
            end
        end
    else
        set tool (__jj_ai_select_tool)
        if test $status -ne 0
            rm -f $input_file
            return 1
        end
    end

    # Create temp file for output
    set -l output_file (mktemp)

    # Run in background. The tool is passed explicitly since a called
    # function does not inherit the caller's local variables, even from
    # within a backgrounded block.
    begin
        __jj_ai_commit_message $tool <$input_file
    end >$output_file 2>&1 &
    set -l bg_pid $last_pid

    # Show spinner with timeout (10s)
    __jj_ai_spinner $bg_pid 10

    # Wait for the background job to complete
    wait $bg_pid 2>/dev/null
    set -l wait_status $status

    # Read the result, collecting it into a single string so a multi-line
    # message survives intact instead of being split into a list
    set -l message (cat $output_file 2>/dev/null | string collect)
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
            echo (set_color yellow)"Request timed out or failed. Check that your AI CLI tool is installed and authenticated."(set_color normal) >&2
        end
        return 1
    end

    # Display the generated message
    echo (set_color blue)"💬 Generated message:"(set_color normal) (set_color white --bold)"$message"(set_color normal)

    # Ask for confirmation
    read -P (set_color green)"Commit with this message? [Y/n] "(set_color normal) -l confirm

    if test -z "$confirm"; or string match -qi "y*" "$confirm"
        jj commit -m "$message"
        echo (set_color green)"✓ Change committed"(set_color normal)
    else
        echo (set_color red)"✗ Cancelled"(set_color normal)
        return 1
    end
end
