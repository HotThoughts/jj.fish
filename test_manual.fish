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

function test_jj_configure
    echo "🔧 Testing jj_configure function..."

    # Test help
    echo "Testing --help:"
    jj_configure --help
    echo ""

    # Test current settings
    echo "Current settings:"
    jj_configure
    echo ""

    # Test setting prefix
    echo "Setting prefix to 'test-':"
    jj_configure --prefix test-
    echo ""

    # Test setting length
    echo "Setting length to 8:"
    jj_configure --length 8
    echo ""

    # Test combined settings
    echo "Setting prefix to 'feature-' and length to 10:"
    jj_configure --prefix feature- --length 10
    echo ""

    # Test error cases
    echo "Testing error cases:"
    echo "Empty prefix (should fail):"
    jj_configure --prefix ""
    echo ""

    echo "Invalid length (should fail):"
    jj_configure --length abc
    echo ""

    echo "Length out of range (should fail):"
    jj_configure --length 0
    echo ""

    # Reset to defaults
    echo "Resetting to defaults:"
    jj_configure --reset
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

function test_jjbranch
    echo "🌿 Testing jjbranch function..."

    # Test basic functionality
    echo "Creating branch with default settings:"
    jjbranch
    echo ""

    # Test with custom settings
    echo "Testing with custom prefix:"
    jj_configure --prefix test- --length 6
    jjbranch
    echo ""

    # Create another change to test different change ID
    echo "# Additional content" >>README.md
    jj commit -m "docs: add more content to README"

    echo "Creating branch for new change:"
    jjbranch
    echo ""

    # Reset settings
    jj_configure --reset
    echo ""
end

function test_jgp
    echo "⚡ Testing jgp function..."

    # Test help
    echo "Testing jgp --help:"
    jgp --help
    echo ""

    # Test dry run if available
    echo "Testing jgp with --dry-run (if supported):"
    jgp --dry-run 2>/dev/null; or echo "Dry run not supported by jj version"
    echo ""
end

function test_jjpr
    echo "🚀 Testing jjpr function (GitHub integration)..."

    if not command -q gh
        echo "⚠️  Skipping jjpr test - GitHub CLI not available"
        return 0
    end

    # Check if authenticated
    if not gh auth status >/dev/null 2>&1
        echo "⚠️  Skipping jjpr test - not authenticated with GitHub CLI"
        echo "Run 'gh auth login' to test PR functionality"
        return 0
    end

    echo "⚠️  jjpr test requires a real GitHub repository"
    echo "This test will NOT actually create a PR"
    echo "To test manually:"
    echo "1. Create a GitHub repository"
    echo "2. Add it as origin: jj git remote add origin <repo-url>"
    echo "3. Run: jjpr"
    echo ""
end

function test_error_conditions
    echo "❌ Testing error conditions..."

    # Test outside jj repository
    cd /tmp
    echo "Testing jjbranch outside jj repository (should fail):"
    jjbranch
    echo ""

    echo "Testing jjpr outside jj repository (should fail):"
    jjpr
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
    test_jj_configure
    test_setup_repo
    test_jjbranch
    test_jgp
    test_jjpr
    test_error_conditions

    echo "✅ All manual tests completed!"
    echo ""
    echo "Test repository is at: $test_dir"
    echo "Run 'rm -rf $test_dir' to clean up when done"
    echo ""
    echo "To test GitHub functionality:"
    echo "1. Create a test repository on GitHub"
    echo "2. cd $test_dir"
    echo "3. jj git remote add origin <your-repo-url>"
    echo "4. jjpr"
end

# Check if script is being run directly
if test (basename (status filename)) = "test_manual.fish"
    run_all_tests
end
