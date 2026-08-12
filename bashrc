################### CUSTOMISATIONS ########################

# Check window size after each command
shopt -s checkwinsize

#### History

HISTCONTROL=ignoreboth
HISTSIZE=10000
HISTFILESIZE=20000
HISTTIMEFORMAT="%G-%m-%d_%T "
export HISTIGNORE="&:ls:ll:la:cd:exit:clear:history"
shopt -s histappend
shopt -s cmdhist

#### Env Vars

PATH="$PATH:$HOME/bin"

#### Aliases

alias ls="ls --color=auto"
alias ll="ls -lhtr"
alias grep="grep --color"
alias zz_urldecode='python3 -c "import sys; import urllib.parse as urlp; print(urlp.unquote_plus(sys.argv[1]))"'
alias zz_urlencode='python3 -c "import sys; import urllib.parse as urlp; print(urlp.quote_plus(sys.argv[1]))"'
alias zz_ssh_add="ssh-add $HOME/key_ed25519 -t 4h"
alias ansible="$HOME/work/ansible-venv/bin/ansible"
alias ansible-playbook="$HOME/work/ansible-venv/bin/ansible-playbook"
alias ansible-galaxy="$HOME/work/ansible-venv/bin/ansible-galaxy"
alias ansible-lint="$HOME/work/ansible-venv/bin/ansible-lint"

#### Functions

# Fix for echo color output in functions
ECHO_RESET="\033[0m"
ECHO_BLACK="\033[0;30m"
ECHO_RED="\033[0;31m"
ECHO_GREEN="\033[0;32m"
ECHO_YELLOW="\033[0;33m"
ECHO_BLUE="\033[0;34m"
ECHO_MAGENTA="\033[0;35m"
ECHO_CYAN="\033[0;36m"
ECHO_WHITE="\033[0;37m"
ECHO_BOLD_BLACK="\033[1;30m"
ECHO_BOLD_RED="\033[1;31m"
ECHO_BOLD_GREEN="\033[1;32m"
ECHO_BOLD_YELLOW="\033[1;33m"
ECHO_BOLD_BLUE="\033[1;34m"
ECHO_BOLD_MAGENTA="\033[1;35m"
ECHO_BOLD_CYAN="\033[1;36m"
ECHO_BOLD_WHITE="\033[1;37m"

rc_cmd() {
    if [ ${?} -eq 0 ]; then
        echo -e "✅"
    else
        echo -e ["❌ ${?}]"
    fi
}

zz_conn_test(){
if [ ${#} -eq 2 ]
then
  if command -v nc >/dev/null 2>&1
  then
    nc -z -v -w1 "${1}" "${2}"
  else
    echo -e "${ECHO_RED}[ERROR]: nc is missing${ECHO_RESET}"
  fi
else
  echo "Usage: zz_conn_test <host> <port>"
fi
}

zz_local_ip()
{
ip -4 -br address show
}

zz_public_ip()
{
if command -v dig >/dev/null 2>&1
then
dig +short myip.opendns.com @resolver1.opendns.com
else
echo -e "${ECHO_RED}[ERROR]: dig is missing ${ECHO_RESET}"
fi
}

zz_gen_pass()
{
cat /dev/urandom | LC_CTYPE=C LANG=C tr -dc 'A-Za-z0-9!#$%&*+-.?@_' | fold -w48  |head -n 1 |fold -w1 |awk '!seen[$0]++' | tr -d '\n' ; echo
}

zz_ansible_venv()
{
source $HOME/work/ansible-venv/bin/activate
}

zz_remote_cmd()
{
local __host="${1}"
local __cmd="${2}"
if [ "${1}" = "-h" ] || [ "${1}" = "--help" ] || [ $# -ne 2 ]
then
echo 'Usage: zz_remote_cmd <host> "<cmd>"'
else
ssh ${__host} -t "${__cmd}"
fi
}

zz_listen_ports()
{
echo "Listening Ports"
sudo ss -nautpl
}

zz_connections_list()
{
echo "TCP ESTABLISHED Connections"
sudo ss -nautp |grep ESTAB
}

zz_epoch_converter()
{
if [ ${#} -gt 0 ]
then
date -d @"${@}"
else
echo "Usage: zz_epoch_converter <epoch_date>"
fi
}

zz_hex_string()
{
local __str=$(openssl rand -hex 32)
echo "cleartext string : ${__str}"
echo "SHA256 string    : "$(echo -n "${__str}" | shasum -a 256)
unset __str
}

zz_count_char()
{
if [ ! -z "${1}" ]
then
echo "${#1}"
else
echo "Usage: zz_count_char <string>"
fi
}

#### PS1

# Colors with proper escaping for PS1

RESET="\[\033[0m\]"
BLACK="\[\033[0;30m\]"
RED="\[\033[0;31m\]"
GREEN="\[\033[0;32m\]"
YELLOW="\[\033[0;33m\]"
BLUE="\[\033[0;34m\]"
MAGENTA="\[\033[0;35m\]"
CYAN="\[\033[0;36m\]"
WHITE="\[\033[0;37m\]"
BOLD_BLACK="\[\033[1;30m\]"
BOLD_RED="\[\033[1;31m\]"
BOLD_GREEN="\[\033[1;32m\]"
BOLD_YELLOW="\[\033[1;33m\]"
BOLD_BLUE="\[\033[1;34m\]"
BOLD_MAGENTA="\[\033[1;35m\]"
BOLD_CYAN="\[\033[1;36m\]"
BOLD_WHITE="\[\033[1;37m\]"

unset PROMPT_COMMAND
PS1=""
PS1="\n${BOLD_BLUE}┌─\$(rc_cmd)-[${RESET}${BOLD_CYAN}\u${RESET}${BOLD_BLUE}@${RESET}${BOLD_GREEN}\h${RESET}${BOLD_BLUE}]─[${RESET}${YELLOW}\w${RESET}${BOLD_BLUE}]\n${BOLD_BLUE}└─\$ ${RESET}"
