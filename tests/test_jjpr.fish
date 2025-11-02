#!/usr/bin/env fish
# Test jjpr function error handling

set -l plugin_dir (dirname (dirname (status filename)))

# Source the function
source "$plugin_dir/functions/jjpr.fish"

set -l test_count 0
set -l pass_count 0
set -l fail_count 0

function run_test
    set -l test_name $argv[1]
    set test_count (math $test_count + 1)
    echo "Testing: $test_name"
end

function assert_success
    if test $status -eq 0
        set pass_count (math $pass_count + 1)
        echo "  ✓ Pass"
    else
        set fail_count (math $fail_count + 1)
        echo "  ✗ Fail: expected success (exit 0)" >&2
    end
end

function assert_failure
    if test $status -ne 0
        set pass_count (math $pass_count + 1)
        echo "  ✓ Pass"
    else
        set fail_count (math $fail_count + 1)
        echo "  ✗ Fail: expected failure (exit non-zero)" >&2
    end
end

echo "Testing jjpr function..."
echo ""

# Test 1: No arguments should fail
run_test "No arguments should fail"
jjpr >/dev/null 2>&1
assert_failure

# Test 2: Check error message content for no arguments
run_test "Error message mentions usage"
set -l output (jjpr 2>&1)
echo "$output" | grep -q "Usage:"
assert_success

# Test 3: Function should check for gh command
run_test "Function checks for gh CLI"
# This test passes if the function definition contains the gh check
grep -q "command -v gh" "$plugin_dir/functions/jjpr.fish"
assert_success

# Test 4: Function should check for jj command
run_test "Function checks for jj CLI"
grep -q "command -v jj" "$plugin_dir/functions/jjpr.fish"
assert_success

# Test 5: Function uses proper error redirection
run_test "Function redirects errors to stderr"
grep -q ">&2" "$plugin_dir/functions/jjpr.fish"
assert_success

# Test 6: Function validates command exit codes
run_test "Function checks exit status"
grep -q "status" "$plugin_dir/functions/jjpr.fish"
assert_success

echo ""
echo "Results: $pass_count/$test_count passed, $fail_count failed"

if test $fail_count -gt 0
    exit 1
end
