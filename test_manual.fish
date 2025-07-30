#!/usr/bin/env fish

# Manual test script for jj.fish plugin
# Run this script to test all functions manually

set -l test_dir "/tmp/jj-fish-test-$(date +%s)"
set -l original_dir (pwd)
set -l test_repo "https://github.com/HotThoughts/jj-fish-test.git"

function cleanup
    echo "🧹 Cleaning up test environment..."
    cd "$original_dir"
    if test -d "$test_dir"
        rm -rf "$test_dir"
    end
end

function test_prerequisites
    echo "🔍 Checking prerequisites..."

    if not command -q fish
        echo "❌ Fish shell not found"
        return 1
    end
    echo "✅ Fish shell: $(fish --version)"

    if not command -q jj
        echo "❌ jj (Jujutsu) not found"
        return 1
    end
    echo "✅ jj: $(jj --version)"

    if not command -q gh
        echo "⚠️  GitHub CLI not found (jjpr will not work)"
    else
        echo "✅ GitHub CLI: $(gh --version | head -n1)"
    end

    if not command -q git
        echo "❌ Git not found"
        return 1
    end
    echo "✅ Git: $(git --version)"

    echo ""
end

function test_abbreviations
    echo "🔧 Testing abbreviations..."

    echo "Testing jj abbreviations are loaded:"
    abbr --show | grep -E "^abbr jj" | head -5
    echo ""

    echo "Testing alternative abbreviations are loaded:"
    abbr --show | grep -E "^abbr j[gd]" | head -3
    echo ""
end

function test_setup_repo
    echo "📁 Setting up test repository..."

    mkdir -p "$test_dir"
    cd "$test_dir"

    # Initialize jj repository
    jj init --git
    jj config set user.name "Test User"
    jj config set user.email "test@example.com"

    # Create initial content
    echo "# Test Repository" >README.md
    echo "This is a test repository for jj.fish plugin" >>README.md
    jj commit -m "feat: initial commit with README"

    echo "✅ Test repository created at $test_dir"
    echo ""
end

function test_jj_commands
    echo "🌿 Testing jj command abbreviations..."

    echo "Testing jj status:"
    jjst
    echo ""

    echo "Testing jj log (limited):"
    jjll 3
    echo ""

    echo "Testing jj describe:"
    echo "Would run: jjdm 'test commit message'"
    echo ""
end

function test_git_integration
    echo "⚡ Testing git integration abbreviations..."

    echo "Testing git push abbreviation:"
    echo "Would run: jjgp (equivalent to 'jj git push')"
    echo ""

    echo "Testing git init abbreviation:"
    echo "Would run: jjgic (equivalent to 'jj git init --colocate')"
    echo ""
end

function test_alternative_abbreviations
    echo "🚀 Testing alternative abbreviations..."

    echo "Testing alternative git init:"
    echo "Would run: jgi (equivalent to 'jj git init --colocate')"
    echo ""

    echo "Testing alternative git push:"
    echo "Would run: jgp (equivalent to 'jj git push')"
    echo ""

    echo "Testing alternative describe:"
    echo "Would run: jd 'message' (equivalent to 'jj describe -m message')"
    echo ""
end

function test_error_conditions
    echo "❌ Testing error conditions..."

    # Test outside jj repository
    cd /tmp
    echo "Testing jj commands outside jj repository:"
    echo "jjst should show error or no repository status"
    jjst 2>/dev/null; or echo "Not in a jj repository (expected)"
    echo ""

    # Return to test directory
    cd "$test_dir"
end

function run_all_tests
    echo "🧪 Starting jj.fish manual tests"
    echo "=================================="
    echo ""

    # Setup trap for cleanup
    trap cleanup EXIT

    test_prerequisites; or return 1
    test_abbreviations
    test_setup_repo
    test_jj_commands
    test_git_integration
    test_alternative_abbreviations
    test_error_conditions

    echo "✅ All manual tests completed!"
    echo ""
    echo "Test repository is at: $test_dir"
    echo "Run 'rm -rf $test_dir' to clean up when done"
    echo ""
    echo "To test abbreviations manually:"
    echo "1. cd $test_dir"
    echo "2. Try typing abbreviations like 'jjl', 'jjst', 'jjgp' etc."
    echo "3. They should expand when you press space or enter"
end

# Check if script is being run directly
if test (basename (status filename)) = "test_manual.fish"
    run_all_tests
end
