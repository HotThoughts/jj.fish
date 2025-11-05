function jjpr --description "Push jj change and create GitHub PR"
    set -l change_id $argv[1]

    # Validate input
    if test -z "$change_id"
        set change_id "@"
    end

    # Check required dependencies
    if not command -v gh >/dev/null 2>&1
        echo "Error: gh CLI not found. Install from https://cli.github.com" >&2
        return 1
    end

    if not command -v jj >/dev/null 2>&1
        echo "Error: jj not found. Install from https://github.com/martinvonz/jj" >&2
        return 1
    end

    # Verify change exists and get description
    set -l title (jj log -r $change_id -T description --no-graph 2>/dev/null | head -1 | string trim)

    if test -z "$title"
        set title "Update from jj change $change_id"
    end

    # Push change to remote
    set -l push_output (jj git push -c $change_id 2>&1)
    set -l push_status $status

    if test $push_status -ne 0
        echo "Error: jj git push failed" >&2
        echo "$push_output" >&2
        return 1
    end

    # Extract branch name from push output using string operations
    # Match patterns like "Creating bookmark push-abcdef" or "Move sideways bookmark foo"
    set -l branch_name ""

    for line in (string split \n -- $push_output)
        # Try "Creating bookmark <name>" or "Add bookmark <name>"
        if string match -qr '(?:Creating|Add) bookmark (\S+)' -- $line
            set branch_name (string replace -r '.*(?:Creating|Add) bookmark (\S+).*' '$1' -- $line)
            break
        end

        # Try "Move sideways bookmark <name> from"
        if string match -qr 'Move sideways bookmark (\S+) from' -- $line
            set branch_name (string replace -r '.*Move sideways bookmark (\S+) from.*' '$1' -- $line)
            break
        end
    end

    # Fallback: try getting bookmark from jj log
    if test -z "$branch_name"
        set branch_name (jj log -r $change_id -T 'bookmarks' --no-graph 2>/dev/null | string trim)
    end

    if test -z "$branch_name"
        echo "Error: could not determine branch name" >&2
        echo "Push output:" >&2
        echo "$push_output" >&2
        return 1
    end

    # Get default branch from repository
    set -l default_branch (gh repo view --json defaultBranchRef --jq '.defaultBranchRef.name' 2>/dev/null)
    if test -z "$default_branch"
        # Fallback: try git default branch
        set default_branch (git symbolic-ref refs/remotes/origin/HEAD 2>/dev/null | sed 's@^refs/remotes/origin/@@')
    end
    if test -z "$default_branch"
        # Last resort: assume main
        set default_branch main
    end

    # Display push summary (filter out verbose output)
    echo ""
    echo "✓ Pushed change to remote"
    echo "  Branch: $branch_name"
    echo ""

    # Create GitHub PR
    if not gh pr create --base "$default_branch" --head "$branch_name" --title "$title" --assignee @me
        echo "Error: failed to create PR" >&2
        return 1
    end
end
