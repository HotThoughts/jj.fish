#!/usr/bin/env fish
# Test abbreviations are loaded correctly

set -l plugin_dir (dirname (dirname (status filename)))

# Source the abbreviations
source "$plugin_dir/functions/abbr.fish"

set -l test_count 0
set -l pass_count 0
set -l fail_count 0

function assert_abbr_exists
    set -l abbr_name $argv[1]
    set -l expected_value $argv[2]
    set test_count (math $test_count + 1)

    set -l actual_value (abbr --show | grep "^abbr -a -- $abbr_name " | sed "s/abbr -a -- $abbr_name //")

    if test "$actual_value" = "$expected_value"
        set pass_count (math $pass_count + 1)
        echo "✓ $abbr_name = $expected_value"
    else
        set fail_count (math $fail_count + 1)
        echo "✗ $abbr_name: expected '$expected_value', got '$actual_value'" >&2
    end
end

echo "Testing abbreviations..."
echo ""

# Test core abbreviations
assert_abbr_exists "jjl" "'jj log'"
assert_abbr_exists "jjst" "'jj st'"
assert_abbr_exists "jjd" "'jj describe'"
assert_abbr_exists "jjdm" "'jj describe -m'"
assert_abbr_exists "jjnm" "'jj new main'"
assert_abbr_exists "jjc" "'jj commit'"
assert_abbr_exists "jjci" "'jj commit -i'"

# Test git integration
assert_abbr_exists "jjgp" "'jj git push'"
assert_abbr_exists "jjgf" "'jj git fetch'"
assert_abbr_exists "jjgic" "'jj git init --colocate'"

# Test short forms
assert_abbr_exists "jp" "'jj git push'"
assert_abbr_exists "jd" "'jj describe -m'"
assert_abbr_exists "jc" "'jj commit'"

echo ""
echo "Results: $pass_count/$test_count passed, $fail_count failed"

if test $fail_count -gt 0
    exit 1
end
