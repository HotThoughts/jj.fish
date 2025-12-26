function __jj_ai_spinner --description "Show a loading spinner while running a command"
    set -l pid $argv[1]
    set -l frames '⠋' '⠙' '⠹' '⠸' '⠼' '⠴' '⠦' '⠧' '⠇' '⠏'
    set -l frame_count (count $frames)
    set -l i 1

    # Hide cursor
    echo -n (tput civis) >&2

    while kill -0 $pid 2>/dev/null
        printf "\r%s %s" (set_color cyan)$frames[$i](set_color normal) "Generating commit message..." >&2
        set i (math "($i % $frame_count) + 1")
        sleep 0.1
    end

    # Clear spinner line and show cursor
    printf "\r\033[K" >&2
    echo -n (tput cnorm) >&2
end
