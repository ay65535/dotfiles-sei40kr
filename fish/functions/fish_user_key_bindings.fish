# fish_user_key_bindings.fish
# author: Seong Yong-ju <sei40kr@gmail.com>

function fish_user_key_bindings
    bind \ct __fzf_find_file
    bind \cr __fzf_reverse_isearch
    bind \ec '__fzf_cd --hidden'
    bind \t __fzf_complete
    bind \cx\cg __fzf_ghq
end
