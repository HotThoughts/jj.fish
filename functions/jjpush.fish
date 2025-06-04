function jjpush -d "Amend local changes into current commit and force-push branch with lease"
    # Ensure jj and git are available
    if not command -q jj
        echo "Error: jj (Jujutsu) is not installed or not in PATH" >&2
        return 1
    end
    if not command -q git
        echo "Error: git is not installed or not in PATH" >&2
        return 1
    end

    # Check for local changes
    if test (count (git status --porcelain)) -gt 0
        echo "🔄 You have local changes. Please commit them before pushing if you want them included."
    end

    # Get current branch name (from before squash)
    set -l branch (git branch --show-current)
    if test -z "$branch"
        echo "Error: Not on a branch. Please checkout a branch first." >&2
        return 1
    end

    # Update the branch to point to the current JJ commit and re-attach HEAD
    set -l commit (jj log -r @ --no-graph -T 'commit_id' | head -n1)
    git branch -f "$branch" $commit
    git checkout "$branch"

    # Push jj bookmark and commit to remote
    set -l bookmark (jj log -r @ --no-graph -T 'bookmarks' | head -n1)
    if test -n "$bookmark"
        echo "🌿 Pushing jj bookmark and commit to remote with jj git push --allow-new..."
        jj bookmark set "$bookmark" -r @
        jj git push --allow-new
    end

    # Push with force-with-lease
    echo "🚀 Pushing $branch to origin with --force-with-lease..."
    git push --force-with-lease origin $branch
end
