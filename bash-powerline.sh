#!/usr/bin/env bash

## Uncomment to disable git info
#POWERLINE_GIT=0

__powerline() {
    # Colorscheme
    readonly RESET='\[\033[m\]'

    readonly SYMBOL_GIT_BRANCH=''
    readonly SYMBOL_GIT_MODIFIED='*'
    readonly SYMBOL_GIT_PUSH='↑'
    readonly SYMBOL_GIT_PULL='↓'

    readonly SYMBOL_ARROW=''

    readonly COL_ARR='34'  # blue ribbon behind CWD
    readonly COL_GRN='32'  # errorlevel 0 prompt color
    readonly COL_RED='31'  # error prompt color
    readonly COL_TXT='36'  # CWD/Git text color. 36 = cyan, 37 = gray, 90 = dk gray, 94 = lt blue

    PS_SYMBOL='$'

    __git_info() { 
        [[ $POWERLINE_GIT = 0 ]] && return # disabled
        hash git 2>/dev/null || return # git not found
        local git_eng="env LANG=C git"   # force git output in English to make our work easier

        # get current branch name
        local ref=$($git_eng symbolic-ref --short HEAD 2>/dev/null)

        if [[ -n "$ref" ]]; then
            # prepend branch symbol
            ref="$SYMBOL_GIT_BRANCH $ref"  # space between symbol and branch if you please
        else
            # get tag name or short unique hash
            ref=$($git_eng describe --tags --always 2>/dev/null)
        fi

        [[ -n "$ref" ]] || return  # not a git repo

        local marks
        local modified=" "  # modified character or empty space

        # scan first two lines of output from `git status`
        while IFS= read -r line; do
            if [[ $line =~ ^## ]]; then # header line
                [[ $line =~ ahead\ ([0-9]+) ]] && marks+=" $SYMBOL_GIT_PUSH${BASH_REMATCH[1]}"
                [[ $line =~ behind\ ([0-9]+) ]] && marks+=" $SYMBOL_GIT_PULL${BASH_REMATCH[1]}"
                [[ -n $marks ]] && marks+=" "  # trailing space to pad prompt
            else # branch is modified if output contains more lines after the header line
                modified=$SYMBOL_GIT_MODIFIED
                break
            fi
        done < <($git_eng status --porcelain --branch 2>/dev/null)  # note the space between the two <

        # print the git branch segment without a trailing newline
        printf " $ref$modified$marks"
    }

    ps1() {
        # Check the exit code of the previous command and display different
        # colors in the prompt accordingly. 
        if [ $? -eq 0 ]; then
            local symbol="\[\e[7;$COL_GRN;49m\]$SYMBOL_ARROW\[\e[27;$COL_GRN;49m\]$SYMBOL_ARROW$RESET $PS_SYMBOL "
        else
            local symbol="\[\e[7;$COL_RED;49m\]$SYMBOL_ARROW e:$? \[\e[27;$COL_RED;49m\]$SYMBOL_ARROW$RESET $PS_SYMBOL "
        fi

        local cwd="\[\e[7;$COL_ARR;49m\]$SYMBOL_ARROW\[\e[27;$COL_TXT;$((COL_ARR + 10))m\] \w \[\e[$COL_ARR;49m\]$SYMBOL_ARROW$RESET"
        # Bash by default expands the content of PS1 unless promptvars is disabled.
        # We must use another layer of reference to prevent expanding any user
        # provided strings, which would cause security issues.
        # POC: https://github.com/njhartwell/pw3nage
        # Related fix in git-bash: https://github.com/git/git/blob/9d77b0405ce6b471cb5ce3a904368fc25e55643d/contrib/completion/git-prompt.sh#L324
        if shopt -q promptvars; then
            __powerline_git_info="$(__git_info)"
            local git="\[\e[${COL_TXT}m\]\${__powerline_git_info}$RESET"
        else
            # promptvars is disabled. Avoid creating unnecessary env var.
            local git="\[\e[${COL_TXT}m\]$(__git_info)$RESET"
        fi

        PS1="$cwd$git$symbol"
    }

    PROMPT_COMMAND="ps1${PROMPT_COMMAND:+; $PROMPT_COMMAND}"
}

__powerline
unset __powerline
