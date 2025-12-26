function jjad --description "AI-powered jj description generator (supports copilot, cursor-agent, claude)"
    # Get the current diff
    set -l changes (jj diff --git 2>/dev/null; or jj diff)

    if test -z "$changes"
        echo (set_color yellow)"⚠ No changes to commit"(set_color normal)
        return 1
    end

    # Select AI tool first (before spinner)
    set -l tool
    if set -q JJ_AI_TOOL
        set tool $JJ_AI_TOOL
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

    # Generate commit message using selected AI tool in background
    fish -c "set tool $tool; source functions/__jj_ai_commit_message.fish; __jj_ai_commit_message (cat $input_file) > $output_file" &
    set -l bg_pid $last_pid

    # Show spinner while waiting
    __jj_ai_spinner $bg_pid

    # Wait for the background job to complete
    wait $bg_pid

    # Read the result
    set -l message (cat $output_file)
    rm -f $input_file $output_file

    if test -z "$message"
        echo (set_color red)"✗ Failed to generate commit message"(set_color normal)
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
