#!/usr/bin/env fish
# Test runner for jj.fish plugin

set -l test_dir (dirname (status filename))
set -l total_passed 0
set -l total_failed 0
set -l test_files

echo "================================"
echo "Running jj.fish test suite"
echo "================================"
echo ""

# Find all test files
for test_file in $test_dir/test_*.fish
    if test -f "$test_file"
        set -a test_files $test_file
    end
end

if test (count $test_files) -eq 0
    echo "No test files found in $test_dir" >&2
    exit 1
end

# Run each test file
for test_file in $test_files
    set -l test_name (basename $test_file)
    echo "→ Running $test_name"
    echo ---

    if fish "$test_file"
        set total_passed (math $total_passed + 1)
        echo "✓ $test_name passed"
    else
        set total_failed (math $total_failed + 1)
        echo "✗ $test_name failed" >&2
    end

    echo ""
end

# Summary
echo "================================"
echo "Test Summary"
echo "================================"
echo "Passed: $total_passed"
echo "Failed: $total_failed"
echo "Total:  "(math $total_passed + $total_failed)
echo ""

if test $total_failed -gt 0
    echo "✗ Some tests failed" >&2
    exit 1
else
    echo "✓ All tests passed"
    exit 0
end
