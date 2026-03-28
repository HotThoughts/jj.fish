function __jj_ai_spinner --description "Show a loading spinner while running a command with timeout"
    set -l pid $argv[1]
    set -l timeout_seconds $argv[2]
    if test -z "$timeout_seconds"
        set timeout_seconds 10
    end

    set -l frames '⠋' '⠙' '⠹' '⠸' '⠼' '⠴' '⠦' '⠧' '⠇' '⠏'
    set -l frame_count (count $frames)
    set -l i 1
    set -l elapsed_ticks 0
    set -l timeout_ticks (math "$timeout_seconds * 10")  # Convert to 0.1s ticks

    # Hide cursor
    echo -n (tput civis) >&2

    while kill -0 $pid 2>/dev/null
        # Check timeout (elapsed in 0.1s ticks)
        if test $elapsed_ticks -ge $timeout_ticks
            # Kill the process and its children if it's still running
            kill -TERM $pid 2>/dev/null
            sleep 0.2
            # Force kill if still running
            kill -KILL $pid 2>/dev/null
            # Also try to kill the process group
            kill -TERM -$pid 2>/dev/null
            kill -KILL -$pid 2>/dev/null
            break
        end

        printf "\r%s %s" (set_color cyan)$frames[$i](set_color normal) "Generating commit message..." >&2
        set i (math "($i % $frame_count) + 1")
        sleep 0.1
        set elapsed_ticks (math "$elapsed_ticks + 1")
    end

    # Clear spinner line and show cursor
    printf "\r\033[K" >&2
    echo -n (tput cnorm) >&2
end
