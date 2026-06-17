# This file imports all home modules
# Individual modules can be enabled/disabled via config.modules.home.*
{ ... }:

{
  imports = [
    ./base
    ./desktop
    ./laptop
    ./development
    ./gaming
  ];
}
