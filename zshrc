#### History

setopt extended_history       # record timestamp of command in HISTFILE
setopt hist_expire_dups_first # delete duplicates first when HISTFILE size exceeds HISTSIZE
#export HISTORY_IGNORE="(cd ..|*-e*)"

#### Aliases

alias ls="ls --color=auto"
alias ll="ls -lhtr"
alias grep="grep --color"
alias history="history -E"
alias ifconfig="ifconfig -f inet:cidr"
alias zz_urldecode='python3 -c "import sys; import urllib.parse as urlp; print(urlp.unquote_plus(sys.argv[1]))"'
alias zz_urlencode='python3 -c "import sys; import urllib.parse as urlp; print(urlp.quote_plus(sys.argv[1]))"'
alias zz_ssh_add="ssh-add /Users/my-user/key_ed25519 -t 4h"
alias ansible="/Users/my-user/work/ansible-venv/bin/ansible"
alias ansible-playbook="/Users/my-user/work/ansible-venv/bin/ansible-playbook"
alias ansible-galaxy="/Users/my-user/work/ansible-venv/bin/ansible-galaxy"
alias ansible-lint="/Users/my-user/work/ansible-venv/bin/ansible-lint"

#### Autocomplete

autoload -U compinit
compinit
fpath=( $HOME/site-functions $fpath )

#### Env Var

PATH="$PATH:$HOME/bin:$HOME/Library/Python/3.9/bin:/opt/podman/bin"

#### PS1
if [ "${TERM}" = "xterm-256color" ]
  then
    PS1="%(?.✅.❌ %F{red}%?%f) %(!.%F{red}%n%F{white}@%F{red}localhost %F{magenta}%~ %F{cyan}$%f .%F{green}%n%F{magenta}@%F{green}localhost %F{magenta}%~ %F{cyan}$%f "
fi

#### Functions

zz_conn_test()
{
if [ $# -eq 2 ]
then
  nc -v -G10 -w1 "${1}" "${2}"
else
  echo "Usage: zz_conn_test <host> <port>"
fi
}

zz_local_ip()
{
ifconfig -f inet:cidr en0 | grep -E "inet\s|ether\s|inet6\s"
}

zz_public_ip()
{
dig +short myip.opendns.com @resolver1.opendns.com
}

zz_gen_pass()
{
local __pass_lenght=16
cat /dev/urandom | LC_CTYPE=C LANG=C tr -dc 'A-Za-z0-9!#$%&()*+,-./:;<=>?@[\]^_{|}~' | tr -s 'A-Za-z0-9' | fold -w ${__pass_lenght}  |head -n 16
}

zz_web_search()
{
local __param="${@}"

## replace all spaces with + ${param// /+}

open "https://www.google.com/search?q=${__param// /+}"
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
echo "TCP Listening Ports"
sudo lsof -iTCP -sTCP:LISTEN
echo " "
echo "UDP Listening ports"
sudo lsof -iUDP
}

zz_connections_list()
{
echo "TCP ESTABLISHED Connections"
sudo lsof -iTCP -sTCP:ESTABLISHED
echo " "
echo "UDP ESTABLISHED Connections"
sudo lsof -iUDP
}

zz_epoch_converter()
{
if [ $# -gt 0 ]
then
date -r "${@}"
else
echo "Usage: zz_epoch_converter <epoch_date>"
fi
}

zz_hex_string()
{
local __str=$(openssl rand -hex 32)
echo "cleartext string : ${_pass}"
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

zz_cert_validity()
{
local __expiration_date
local __now_epoch="$(date +%s)"
if [ ! -z ${1} ]
then
echo "---- ${1} ----"
__expiration_date=$(LANG=en_US.UTF-8 date -j -f "%b %d %T %Y %Z" \
                    "$(echo "Q" | openssl s_client -connect ${1}:443 -servername ${1} 2>/dev/null | \
                    openssl x509 -dates -noout |grep "notAfter" |cut -d'=' -f2)" +"%s")
__days_left=$(( (${__expiration_date} / 86400 ) - (${__now_epoch} / 86400 ) ))
if [ $__days_left -lt 30 ]
then
echo "[WARNING] Certificate expiration: $(date -r ${__expiration_date})"
else
echo "[OK] Certificate expiration: $(date -r ${__expiration_date})"
fi
echo -e
else
echo "Usage: zz_cert_validity <website>"
fi
}
