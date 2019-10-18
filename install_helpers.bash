# install_helpers.bash
# author: Seong Yong-ju <sei40kr@gmail.com>

COLUMNS="$(tput cols)"

BOLD="$(tput bold)"
RED="$(tput setaf 1)"
GREEN="$(tput setaf 2)"
YELLOW="$(tput setaf 3)"
BLUE="$(tput setaf 4)"
PURPLE="$(tput setaf 5)"
CYAN="$(tput setaf 6)"
WHITE="$(tput setaf 7)"
RESET="$(tput sgr0)"


print_line() {
    local empty_line
    empty_line="$(printf "%${COLUMNS}s")"

    echo "${empty_line// /-}"
}

print_title() {
    local title
    title="$1"

    clear
    print_line
    echo "# ${BOLD}${title}${RESET}"
    print_line
    echo ''
}

print_desc() {
    local desc
    desc="$1"

    echo "$desc"
    echo ''
}

ask_yn() {
    local prompt
    local answer
    prompt="$1"

    read -n1 -rp "${prompt} [yn]: " answer
    echo ''
    echo ''

    if [[ "$answer" == [yY] ]]; then
        return 0
    fi

    return 1
}

print_info() {
    local message
    message="$1"

    echo "${message}"
}

print_warning() {
    local message
    message="$1"

    echo -e "${YELLOW}${message}${RESET}"
}

print_danger() {
    local message
    message="$1"

    echo -e "${RED}${message}${RESET}"
}

error() {
    local message
    local status_code
    message="$1"
    status_code="$2"

    echo "$message" >&2
    exit "${status_code:-1}"
}

pause() {
    print_line
    read -sn 1 -p 'Press enter to continue ...'
}

pacman_query() {
    local -a pkgs
    pkgs=( "$@" )

    pacman -Q "${pkgs[@]}" &>/dev/null
}

pacman_sync() {
    local -a pkgs
    pkgs=( "$@" )
    sudo pacman -Spy --print-format '%r' "${pkgs[@]}" | read -ra repos

    echo 'Installing'

    for pkg in "${pkgs[@]}"; do
        echo "- ${pkg}"
    done

    sudo pacman -Sy --needed --noconfirm --noprogressbar "${pkgs[@]}"
}

trizen_sync() {
    local -a pkgs
    pkgs=( "$@" )

    if ! pacman_query trizen; then
        error 'trizen is not installed. Aborting.'
    fi

    echo 'Installing'

    for pkg in "${pkgs[@]}"; do
        echo "- ${pkg}"
    done

    trizen -Sy --needed --noconfirm --noprogressbar --nopull "${pkgs[@]}"
}

stack_install() {
    local -a pkgs
    pkgs=( "$@")

    if ! pacman_query stack; then
        error 'stack is not installed. Aborting.'
    fi

    echo 'Installing'
    printf "%s\n" "${pkgs[@]}"

    stack install "${pkgs[@]}"
}

systemctl_enable() {
    local service
    service="$1"

    sudo systemctl enable --now "$service"
}

systemctl_user_enable() {
    local service
    service="$1"

    systemctl --user enable --now "$service"
}