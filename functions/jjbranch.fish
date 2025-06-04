function jjbranch -d "Create a bookmark with push-<change-id> format"
    # Check if jj is available
    if not command -q jj
        echo "Error: jj (Jujutsu) is not installed or not in PATH" >&2
        return 1
    end

    # Get configuration variables with defaults
    set -l prefix $jj_fish_branch_prefix
    set -l length $jj_fish_change_id_length

    # Fallback to defaults if variables are not set
    if test -z "$prefix"
        set prefix push-
    end

    if test -z "$length"
        set length 12
    end

    # Get the short change ID
    set -l change_id (jj log -r @ --no-graph -T "change_id.short($length)" 2>/dev/null)

    if test $status -ne 0
        echo "Error: Failed to get change ID. Are you in a jj repository?" >&2
        return 1
    end

    # Create the branch name
    set -l branch_name "$prefix$change_id"

    # Create the bookmark
    if jj bookmark set "$branch_name" -r @
        echo "✓ Created bookmark: $branch_name"
        # Create a git branch from the bookmark if it doesn't exist
        if not git show-ref --verify --quiet "refs/heads/$branch_name"
            echo "🌱 Creating git branch: $branch_name"
            git branch "$branch_name"
        end
        # Switch to the branch
        git checkout "$branch_name"
        echo "✓ Switched to branch: $branch_name"
        return 0
    else
        echo "Error: Failed to create bookmark" >&2
        return 1
    end
end
