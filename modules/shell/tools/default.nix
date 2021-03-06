{ lib, ... }:

with lib; {
  imports = [
    ./atcoder-tools.nix
    ./bat.nix
    ./exa.nix
    ./htop.nix
    ./online-judge-tools.nix
    ./online-judge-verify-helper.nix
    ./prettyping.nix
    ./ranger.nix
    ./ripgrep.nix
    ./strace.nix
    ./tcpdump.nix
  ];
}
