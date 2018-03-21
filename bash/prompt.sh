# vim: set ft=sh:
# vim:ts=2:sw=2
#
# BlueDrink9 custom bash prompt. Relies on 2 other files.
# Assumes a solarised terminal, with 16 colours.

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

source ${SCRIPT_DIR}/colour_variables.sh
source ${SCRIPT_DIR}/functions.sh


FLASHING="\[\E[5m\]"

# Set the full bash prompt.
function set_bash_prompt () {
  # Set the PROMPT_SYMBOL variable. We do this first so we don't lose the
  # return value of the last command.
  set_prompt_symbol $?

  USER_AT_HOST="${Blue}\u${NC}@${Yellow}\h${NC}"

  # Sets GIT_PROMPT
  parse_git_branch
  GIT_STATUS_PROMPT="${GIT_PROMPT}"
  GIT_BRANCH="`get_git_branch`"
  if [ ! "${BRANCH}" == "" ]
  then
    GIT_BRANCH="{${GIT_BRANCH}}"
  fi
  #set_git_prompt
  #GIT_STATUS_PROMPT="${BRANCH}"
  # \e]0 escapes to window title, \a ends it.
  WINDOW_TITLE_BASH_PATH="\[\e]2;[\W] \u@\h: [\w] ${GIT_BRANCH} – Bash\a\]"
  CURR_FULL_PATH="\w"
  CURR_DIR="\W"
  TIME_PROMPT="\t"

  # Set the bash prompt variable.
  # Space left after title is actually for start of prompt.
  # Gives space between vi +: and time.
  PS1="${WINDOW_TITLE_BASH_PATH} ${White}${On_Black}${TIME_PROMPT}${NC} ${USER_AT_HOST}: ${PREV_COMMAND_COLOUR}[${CURR_DIR}]${NC}${GIT_STATUS_PROMPT} ${PROMPT_SYMBOL} "
}

# Tell bash to execute this function just before displaying its prompt.
PROMPT_COMMAND=set_bash_prompt
PROMPT_COMMAND=$PROMPT_COMMAND && tmux rename-window "$WINDOW_TITLE_BASH_PATH"
