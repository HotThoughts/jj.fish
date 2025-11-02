#!/usr/bin/env fish
# Test plugin initialization

set -l plugin_dir (dirname (dirname (status filename)))
set -l init_file "$plugin_dir/conf.d/jj.fish"

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
        echo "  ✗ Fail: expected success" >&2
    end
end

echo "Testing plugin initialization..."
echo ""

# Test 1: Init file exists
run_test "Init file exists"
test -f "$init_file"
assert_success

# Test 2: Init file checks for jj
run_test "Init file checks for jj command"
grep -q "command -q jj" "$init_file"
assert_success

# Test 3: Init file checks for gh
run_test "Init file checks for gh command"
grep -q "command -q gh" "$init_file"
assert_success

# Test 4: Init file has proper guards
run_test "Init file checks interactive status"
grep -q "status is-interactive" "$init_file"
assert_success

# Test 5: Init file provides helpful error messages
run_test "Init file has install URLs"
grep -q "https://" "$init_file"
assert_success

# Test 6: Init file uses stderr for messages
run_test "Init file redirects to stderr"
grep -q ">&2" "$init_file"
assert_success

echo ""
echo "Results: $pass_count/$test_count passed, $fail_count failed"

if test $fail_count -gt 0
    exit 1
end
