{ config, lib, options, pkgs, ... }:

with lib; {
  imports = [ ./apps ./input ./term ./xmonad.nix ];
}
