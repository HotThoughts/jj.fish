function __jj_ai_commit_message --description "Generate commit message using direct API calls"
    # Read diff from stdin
    set -l diff_content (cat)

    # Truncate diff if too large (keep first 8000 chars to avoid token limits)
    if test (string length "$diff_content") -gt 8000
        set diff_content (string sub -s 1 -l 8000 "$diff_content")
        set diff_content "$diff_content\n... (truncated)"
    end

    # Tool should be passed in via environment or already set
    if not set -q tool
        echo "Error: AI provider not selected" >&2
        return 1
    end

    # Generate message with selected API provider
    switch $tool
        case openai
            __jj_ai_openai_api "$diff_content"
        case anthropic claude
            __jj_ai_anthropic_api "$diff_content"
        case deepseek
            __jj_ai_deepseek_api "$diff_content"
        case '*'
            echo "Unknown AI provider: $tool" >&2
            echo "Supported: openai, anthropic, deepseek" >&2
            return 1
    end
end

function __jj_ai_openai_api --description "Call OpenAI API for commit message"
    set -l diff_content "$argv[1]"
    set -l api_key "$OPENAI_API_KEY"

    if test -z "$api_key"
        echo "Error: OPENAI_API_KEY not set" >&2
        return 1
    end

    set -l model "$JJ_AI_OPENAI_MODEL"
    if test -z "$model"
        set model "gpt-4o-mini"  # Fast and cheap default
    end

    # Create temp file for JSON payload to avoid escaping issues
    set -l json_file (mktemp)

    # Escape JSON properly using jq if available, otherwise use basic escaping
    if command -q jq
        jq -n \
            --arg model "$model" \
            --arg diff "$diff_content" \
            '{
                model: $model,
                messages: [
                    {role: "system", content: "You are a helpful assistant that generates conventional commit messages."},
                    {role: "user", content: ("Generate a concise, conventional commit message for these changes. Return only the commit message, no explanation or additional text.\n\nChanges:\n" + $diff)}
                ],
                temperature: 0.7,
                max_tokens: 100
            }' > "$json_file"
    else
        # Basic JSON escaping - escape quotes, newlines, backslashes
        set -l escaped_diff (echo "$diff_content" | sed 's/\\/\\\\/g' | sed 's/"/\\"/g' | sed ':a;N;$!ba;s/\n/\\n/g')
        printf '{"model":"%s","messages":[{"role":"system","content":"You are a helpful assistant that generates conventional commit messages."},{"role":"user","content":"Generate a concise, conventional commit message for these changes. Return only the commit message, no explanation or additional text.\\n\\nChanges:\\n%s"}],"temperature":0.7,"max_tokens":100}\n' "$model" "$escaped_diff" > "$json_file"
    end

    # Call OpenAI API with timeout (10 seconds)
    set -l response (curl -sS --max-time 10 --connect-timeout 5 \
        -H "Content-Type: application/json" \
        -H "Authorization: Bearer $api_key" \
        -d @"$json_file" \
        https://api.openai.com/v1/chat/completions 2>&1)
    set -l curl_status $status

    rm -f "$json_file"

    # Normalize response to single string (join if array)
    # Use printf to handle both single strings and arrays correctly
    set -l response_str (printf '%s\n' $response | string collect)

    # Check for curl errors
    if test $curl_status -ne 0
        echo "Error: API request failed (curl error)" >&2
        echo "$response_str" | grep -v '^$' | head -n 3 >&2
        return 1
    end

    # Check for API error responses
    if echo "$response_str" | grep -q '"error"'
        echo "Error: API returned an error" >&2
        if command -q jq
            echo "$response_str" | jq -r '.error.message // .error.type // "Unknown error"' 2>/dev/null | head -n 1 >&2
        else
            echo "$response_str" | grep -o '"message":"[^"]*"' | head -n 1 | sed 's/"message":"\(.*\)"/\1/' >&2
        end
        return 1
    end

    # Extract message from response using jq if available
    if command -q jq
        set -l message (echo "$response_str" | jq -r '.choices[0].message.content // empty' 2>/dev/null)
    else
        # Fallback: basic extraction
        set -l message (echo "$response_str" | grep -o '"content":"[^"]*"' | head -n 1 | sed 's/"content":"\(.*\)"/\1/' | sed 's/\\n/ /g' | string trim)
    end

    if test -z "$message"
        echo "Error: Failed to parse API response" >&2
        return 1
    end

    echo "$message"
end

function __jj_ai_anthropic_api --description "Call Anthropic API for commit message"
    set -l diff_content "$argv[1]"
    set -l api_key "$ANTHROPIC_API_KEY"

    if test -z "$api_key"
        echo "Error: ANTHROPIC_API_KEY not set" >&2
        return 1
    end

    set -l model "$JJ_AI_ANTHROPIC_MODEL"
    if test -z "$model"
        set model "claude-3-5-haiku-20241022"  # Fast and small default
    end

    # Create temp file for JSON payload to avoid escaping issues
    set -l json_file (mktemp)

    # Escape JSON properly using jq if available, otherwise use basic escaping
    if command -q jq
        jq -n \
            --arg model "$model" \
            --arg diff "$diff_content" \
            '{
                model: $model,
                max_tokens: 100,
                messages: [
                    {role: "user", content: ("Generate a concise, conventional commit message for these changes. Return only the commit message, no explanation or additional text.\n\nChanges:\n" + $diff)}
                ]
            }' > "$json_file"
    else
        # Basic JSON escaping - escape quotes, newlines, backslashes
        set -l escaped_diff (echo "$diff_content" | sed 's/\\/\\\\/g' | sed 's/"/\\"/g' | sed ':a;N;$!ba;s/\n/\\n/g')
        printf '{"model":"%s","max_tokens":100,"messages":[{"role":"user","content":"Generate a concise, conventional commit message for these changes. Return only the commit message, no explanation or additional text.\\n\\nChanges:\\n%s"}]}\n' "$model" "$escaped_diff" > "$json_file"
    end

    # Call Anthropic API with timeout (10 seconds)
    set -l response (curl -sS --max-time 10 --connect-timeout 5 \
        -H "Content-Type: application/json" \
        -H "x-api-key: $api_key" \
        -H "anthropic-version: 2023-06-01" \
        -d @"$json_file" \
        https://api.anthropic.com/v1/messages 2>&1)
    set -l curl_status $status

    rm -f "$json_file"

    # Normalize response to single string (join if array)
    # Use printf to handle both single strings and arrays correctly
    set -l response_str (printf '%s\n' $response | string collect)

    # Check for curl errors
    if test $curl_status -ne 0
        echo "Error: API request failed (curl error)" >&2
        echo "$response_str" | grep -v '^$' | head -n 3 >&2
        return 1
    end

    # Check for API error responses
    if echo "$response_str" | grep -q '"error"'
        echo "Error: API returned an error" >&2
        if command -q jq
            echo "$response_str" | jq -r '.error.message // .error.type // "Unknown error"' 2>/dev/null | head -n 1 >&2
        else
            echo "$response_str" | grep -o '"message":"[^"]*"' | head -n 1 | sed 's/"message":"\(.*\)"/\1/' >&2
        end
        return 1
    end

    # Extract message from response using jq if available
    if command -q jq
        set -l message (echo "$response_str" | jq -r '.content[0].text // empty' 2>/dev/null)
    else
        # Fallback: basic extraction
        set -l message (echo "$response_str" | grep -o '"text":"[^"]*"' | head -n 1 | sed 's/"text":"\(.*\)"/\1/' | sed 's/\\n/ /g' | string trim)
    end

    if test -z "$message"
        echo "Error: Failed to parse API response" >&2
        return 1
    end

    echo "$message"
end

function __jj_ai_deepseek_api --description "Call DeepSeek API for commit message"
    set -l diff_content "$argv[1]"
    set -l api_key "$DEEPSEEK_API_KEY"

    if test -z "$api_key"
        echo "Error: DEEPSEEK_API_KEY not set" >&2
        return 1
    end

    set -l model "$JJ_AI_DEEPSEEK_MODEL"
    if test -z "$model"
        set model "deepseek-chat"  # Good default
    end

    # Create temp file for JSON payload to avoid escaping issues
    set -l json_file (mktemp)

    # Escape JSON properly using jq if available, otherwise use basic escaping
    if command -q jq
        jq -n \
            --arg model "$model" \
            --arg diff "$diff_content" \
            '{
                model: $model,
                messages: [
                    {role: "system", content: "You are a helpful assistant that generates conventional commit messages."},
                    {role: "user", content: ("Generate a concise, conventional commit message for these changes. Return only the commit message, no explanation or additional text.\n\nChanges:\n" + $diff)}
                ],
                temperature: 0.7,
                max_tokens: 100
            }' > "$json_file"
    else
        # Basic JSON escaping - escape quotes, newlines, backslashes
        set -l escaped_diff (echo "$diff_content" | sed 's/\\/\\\\/g' | sed 's/"/\\"/g' | sed ':a;N;$!ba;s/\n/\\n/g')
        printf '{"model":"%s","messages":[{"role":"system","content":"You are a helpful assistant that generates conventional commit messages."},{"role":"user","content":"Generate a concise, conventional commit message for these changes. Return only the commit message, no explanation or additional text.\\n\\nChanges:\\n%s"}],"temperature":0.7,"max_tokens":100}\n' "$model" "$escaped_diff" > "$json_file"
    end

    # Call DeepSeek API with timeout (10 seconds)
    set -l response (curl -sS --max-time 10 --connect-timeout 5 \
        -H "Content-Type: application/json" \
        -H "Authorization: Bearer $api_key" \
        -d @"$json_file" \
        https://api.deepseek.com/v1/chat/completions 2>&1)
    set -l curl_status $status

    rm -f "$json_file"

    # Normalize response to single string (join if array)
    # Use printf to handle both single strings and arrays correctly
    set -l response_str (printf '%s\n' $response | string collect)

    # Check for curl errors
    if test $curl_status -ne 0
        echo "Error: API request failed (curl error)" >&2
        echo "$response_str" | grep -v '^$' | head -n 3 >&2
        return 1
    end

    # Check for API error responses
    if echo "$response_str" | grep -q '"error"'
        echo "Error: API returned an error" >&2
        if command -q jq
            echo "$response_str" | jq -r '.error.message // .error.type // "Unknown error"' 2>/dev/null | head -n 1 >&2
        else
            echo "$response_str" | grep -o '"message":"[^"]*"' | head -n 1 | sed 's/"message":"\(.*\)"/\1/' >&2
        end
        return 1
    end

    # Extract message from response using jq if available
    if command -q jq
        set -l message (echo "$response_str" | jq -r '.choices[0].message.content // empty' 2>/dev/null)
    else
        # Fallback: basic extraction
        set -l message (echo "$response_str" | grep -o '"content":"[^"]*"' | head -n 1 | sed 's/"content":"\(.*\)"/\1/' | sed 's/\\n/ /g' | string trim)
    end

    if test -z "$message"
        echo "Error: Failed to parse API response" >&2
        return 1
    end

    echo "$message"
end
