# -*- mode: sh -*-

# zprofile
# author: Seong Yong-ju <sei40kr@gmail.com>

if [[ "$OSTYPE" == darwin* && -x /usr/libexec/path_helper ]]; then
    eval "$(/usr/libexec/path_helper -s)"
fi

typeset -U path
typeset -U fpath
typeset -U manpath


## Homebrew

if [[ "$OSTYPE" == darwin* && "${+commands[brew]}" == 1 ]]; then
    __brew_prefix="$(brew --prefix)"

    path=( "${__brew_prefix}/bin" "${__brew_prefix}/sbin" "${path[@]}" )
    fpath=( "${__brew_prefix}/share/zsh/site-functions" "${fpath[@]}" )
    manpath=( "${__brew_prefix}/share/man" "${manpath[@]}" )
fi


## Google Cloud SDK

if [[ -n "$__brew_prefix" ]]; then
    CLOUDSDK_ROOT_DIR="${__brew_prefix}/Caskroom/google-cloud-sdk/latest/google-cloud-sdk"

    if [[ -d "$CLOUDSDK_ROOT_DIR" ]]; then
        export CLOUDSDK_ROOT_DIR

        . "${CLOUDSDK_ROOT_DIR}/path.zsh.inc"
    else
        unset CLOUDSDK_ROOT_DIR
    fi

    unset __brew_prefix
fi


## Rust

# Cargo
export CARGO_HOME="${HOME}/.cargo"
path=( "${CARGO_HOME}/bin" "${path[@]}" )


## Go

# goenv
export GOENV_ROOT="${HOME}/.goenv"
export GOPATH="${HOME}/go/system"
path=( "${GOENV_ROOT}/bin" "${GOENV_ROOT}/shims" "${GOPATH}/bin" "${path[@]}" )


## Java

# jenv
export JENV_ROOT="${HOME}/.jenv"
path=( "${JENV_ROOT}/bin" "${JENV_ROOT}/shims" "${path[@]}" )


## Perl

# Perlbrew
export PERLBREW_ROOT="${HOME}/perl5/perlbrew"
export PERL5LIB="${HOME}/perl5/lib/perl5:${PERL5LIB:+:${PERL5LIB}}"
export PERL_LOCAL_LIB_ROOT="${HOME}/perl5:${PERL_LOCAL_LIB_ROOT:+:${PERL_LOCAL_LIB_ROOT}}"
export PERL_MB_OPT="--install_base '${HOME}/perl5'"
export PERL_MM_OPT="INSTALL_BASE=${HOME}/perl5"
path=( "${HOME}/perl5/bin" "${PERLBREW_ROOT}/bin" "${path[@]}" )
manpath=( "${HOME}/perl5/man" "${manpath[@]}" )


## Ruby

path=( "${HOME}/.gem/ruby/2.6.0/bin" "${path[@]}" )

# rbenv
export RBENV_ROOT="${HOME}/.rbenv"
path=( "${RBENV_ROOT}/bin" "${RBENV_ROOT}/shims" "${path[@]}" )


## Node.js

# nvm
export NVM_DIR="${HOME}/.nvm"

# Yarn
path=( "${HOME}/.yarn/bin" "${path[@]}" )


path=( "${HOME}/.local/bin" "${path[@]}" )
fpath=( "${ZDOTDIR}/functions"
        "${ZDOTDIR}/completions"
        "${fpath[@]}" )


#
# Others

WORKSPACE_DIR="${HOME}/projects"


export PATH
export FPATH
export MANPATH

if [[ -z "$DISPLAY" && "$XDG_VTNR" -eq 1 ]]; then
    exec startx
fi