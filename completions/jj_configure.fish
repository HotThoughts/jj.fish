complete -c jj_configure -s h -l help -d "Show help message"
complete -c jj_configure -s p -l prefix -d "Set branch prefix" -r
complete -c jj_configure -s l -l length -d "Set change ID length" -r
complete -c jj_configure -s r -l reset -d "Reset all settings to defaults"

# Provide prefix suggestions
complete -c jj_configure -l prefix -xa "push- feature- pr- fix- hotfix-"

# Provide length suggestions
complete -c jj_configure -l length -xa "8 10 12 16 20"
