{ pkgs, ... }:

{
  home.packages = with pkgs; [
    antigravity
    gh
  ];
}
