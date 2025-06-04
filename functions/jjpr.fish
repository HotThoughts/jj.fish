function jjpr -d "Create a bookmark, push to GitHub, and open a pull request"
    # Check if required tools are available
    if not command -q jj
        echo "Error: jj (Jujutsu) is not installed or not in PATH" >&2
        return 1
    end

    if not command -q gh
        echo "Error: GitHub CLI (gh) is not installed or not in PATH" >&2
        return 1
    end

    # Get configuration variables with defaults
    set -l prefix $jj_fish_branch_prefix
    set -l length $jj_fish_change_id_length

    # Warn if there are uncommitted changes, but proceed
    if test (count (git status --porcelain)) -gt 0
        echo "⚠️  Warning: You have uncommitted changes. Only committed changes will be included in the pull request."
    end

    # Fallback to defaults if variables are not set
    if test -z "$prefix"
        set prefix push-
    end

    if test -z "$length"
        set length 12
    end

    # Ensure current commit is descendant of main
    set -l base_branch main
    set -l current_commit (git rev-parse HEAD)
    set -l merge_base (git merge-base $base_branch $current_commit 2>/dev/null)

    if test "$merge_base" != (git rev-parse $base_branch)
        echo "❌ Your current commit is not based on '$base_branch'."
        echo "Please rebase your work onto '$base_branch' before running jjpr."
        return 1
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
    echo "📝 Creating bookmark: $branch_name"
    if not jj bookmark set "$branch_name" -r @
        echo "Error: Failed to create bookmark" >&2
        return 1
    end

    # Create a git branch from the bookmark (if it doesn't already exist)
    if not git show-ref --verify --quiet "refs/heads/$branch_name"
        echo "🌱 Creating git branch: $branch_name"
        git branch "$branch_name"
    end

    # Checkout the branch (ensures HEAD is correct)
    git checkout "$branch_name"

    # Fetch remote branch (optional, but do not rebase)
    echo "🔄 Fetching remote branch (if exists)..."
    git fetch origin "$branch_name"

    # Push the jj bookmark and commit to remote
    echo "🌿 Pushing jj bookmark and commit to remote with jj git push --allow-new..."
    if not jj git push --allow-new
        echo "Error: Failed to push jj bookmark to remote" >&2
        return 1
    end

    # Push the branch to GitHub
    echo "🚀 Pushing branch to GitHub..."
    if not git push -u origin "$branch_name"
        echo "Error: Failed to push git branch to GitHub" >&2
        return 1
    end

    # Get the PR title from the jj description
    set -l pr_title (jj log -r @ --template 'description' 2>/dev/null | grep -v '^@' | head -n1)

    if test -z "$pr_title"
        echo "Error: Failed to get change description for PR title" >&2
        return 1
    end

    # Get current GitHub user
    set -l github_user (gh api user --jq .login 2>/dev/null)

    if test $status -ne 0
        echo "Warning: Failed to get GitHub username. PR will not be auto-assigned." >&2
        set github_user ""
    end

    # Create the pull request
    echo "🔗 Creating pull request..."
    set -l gh_args --fill --title "$pr_title" --head "$branch_name" --base main

    if test -n "$github_user"
        set gh_args $gh_args --assignee "$github_user"
    end

    if gh pr create $gh_args
        echo "✅ Pull request created successfully!"
        return 0
    else
        echo "Error: Failed to create pull request" >&2
        return 1
    end
end
