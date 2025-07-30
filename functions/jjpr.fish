function jjpr --description "Push jj change and create GitHub PR"
    set -l change_id $argv[1]

    if test -z "$change_id"
        echo "Usage: jjpr <change-id>"
        echo "Example: jjpr abc123def"
        return 1
    end

    echo "📝 Getting commit description..."
    set -l title (jj log -r $change_id -T description --no-graph | head -1 | string trim)

    if test -z "$title"
        set title "Update from jj change $change_id"
    end

    echo "📍 Getting branch name..."
    set -l push_output (jj git push -c $change_id 2>&1)
    echo $push_output

    set -l branch_name (echo $push_output | grep "Add bookmark" | awk '{print $3}')
    if test -z "$branch_name"
        set branch_name (echo $push_output | grep "Creating bookmark" | awk '{print $3}')
    end
    if test -z "$branch_name"
        set branch_name (echo $push_output | grep "Move sideways bookmark" | sed 's/.*Move sideways bookmark \([^ ]*\) from.*/\1/')
    end
    if test -z "$branch_name"
        echo "❌ Could not determine branch name from push output"
        echo "Push output was:"
        echo $push_output
        return 1
    end

    echo "🎯 Creating GitHub PR..."
    echo "Title: $title"
    echo "Branch: $branch_name"

    gh pr create --base main --head "$branch_name" --title "$title" --assignee @me

    if test $status -eq 0
        echo "✅ Successfully created PR!"
    else
        echo "❌ Failed to create PR"
        return 1
    end
end
