function jgp -d "Shortcut for 'jj git push'"
    # Check if jj is available
    if not command -q jj
        echo "Error: jj (Jujutsu) is not installed or not in PATH" >&2
        return 1
    end

    # Pass all arguments to jj git push
    jj git push $argv
end
