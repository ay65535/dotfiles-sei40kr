{ lib, ... }:

with lib; {
  imports = [
    ./cupsd.nix
    ./deluge.nix
    ./docker.nix
    ./fstrim.nix
    ./picom.nix
    ./protonvpn.nix
    ./psd.nix
    ./redshift.nix
    ./sshd.nix
    ./tlp.nix
    ./transmission.nix
  ];
}
