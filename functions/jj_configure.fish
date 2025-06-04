function jj_configure -d "Configure jj.fish plugin settings"
    set -l options h/help p/prefix= l/length= r/reset

    if not argparse $options -- $argv
        return 1
    end

    if set -q _flag_help
        echo "Usage: jj_configure [OPTIONS]"
        echo ""
        echo "Configure jj.fish plugin settings"
        echo ""
        echo "Options:"
        echo "  -h, --help           Show this help message"
        echo "  -p, --prefix PREFIX  Set branch prefix (default: 'push-')"
        echo "  -l, --length LENGTH  Set change ID length (default: 12)"
        echo "  -r, --reset          Reset all settings to defaults"
        echo ""
        echo "Current settings:"
        echo "  Branch prefix: $jj_fish_branch_prefix"
        echo "  Change ID length: $jj_fish_change_id_length"
        echo ""
        echo "Examples:"
        echo "  jj_configure --prefix feature-"
        echo "  jj_configure --length 8"
        echo "  jj_configure --prefix pr- --length 10"
        echo "  jj_configure --reset"
        return 0
    end

    if set -q _flag_reset
        echo "Resetting jj.fish configuration to defaults..."
        set -e jj_fish_branch_prefix
        set -e jj_fish_change_id_length
        set -U jj_fish_branch_prefix push-
        set -U jj_fish_change_id_length 12
        echo "✓ Configuration reset to defaults"
        return 0
    end

    if set -q _flag_prefix
        if test -z "$_flag_prefix"
            echo "Error: Prefix cannot be empty" >&2
            return 1
        end
        set -U jj_fish_branch_prefix "$_flag_prefix"
        echo "✓ Branch prefix set to: $_flag_prefix"
    end

    if set -q _flag_length
        if not string match -qr '^\d+$' "$_flag_length"
            echo "Error: Length must be a positive integer" >&2
            return 1
        end
        if test "$_flag_length" -lt 1 -o "$_flag_length" -gt 40
            echo "Error: Length must be between 1 and 40" >&2
            return 1
        end
        set -U jj_fish_change_id_length "$_flag_length"
        echo "✓ Change ID length set to: $_flag_length"
    end

    if not set -q _flag_prefix; and not set -q _flag_length
        echo "Current jj.fish configuration:"
        echo "  Branch prefix: $jj_fish_branch_prefix"
        echo "  Change ID length: $jj_fish_change_id_length"
        echo ""
        echo "Use --help for usage information"
    end
end
