# Modular Home Manager Configuration

This directory contains modular home-manager configurations organized by functionality and device type.

## Overview

The home configuration has been refactored from a monolithic file into composable modules. This allows:

- **Device-specific settings**: Laptop touchpad config only applies to laptops
- **Feature separation**: Gaming, development, base desktop tools are independent modules
- **Per-host composition**: Each host declaratively specifies which modules to enable
- **User profile flexibility**: Different users or hosts can have different configurations

## Module Structure

### `modules/home/base/`
Core configuration for all desktop environments:
- Noctalia shell integration
- Essential terminal and tools (kitty, fuzzel, swaylock)
- Notification daemon (mako)
- Idle/screenlock daemon (swayidle)
- Essential packages (chromium, swaybg, xwayland-satellite)

**Enabled by**: Any host using a graphical environment

### `modules/home/desktop/`
Desktop environment configuration (Niri window manager):
- Niri window manager settings
- Keyboard layout
- Hotkey bindings
- Window rules (corner radius, etc.)
- Spawn-at-startup configuration

**Enabled by**: Both laptop and desktop hosts

### `modules/home/laptop/`
Laptop-specific hardware tweaks:
- Touchpad tap-to-click
- Other laptop-only input settings

**Enabled by**: Laptop hosts only (e.g., xps9343)

### `modules/home/development/`
Development tools and configuration:
- Git (with configurable user.name and user.email)
- GitHub CLI
- Development SDKs (dotnet-sdk_10, etc.)

**Enabled by**: Hosts used for software development

### `modules/home/gaming/`
Gaming-related packages and configuration:
- Piper (mouse configuration tool)
- (Can be extended with more gaming-specific tools)

**Enabled by**: Desktop hosts with gaming support

## Usage

### Enabling Modules for a Host

In a host's NixOS configuration (e.g., `hosts/xps9343/default.nix`):

```nix
modules.users.francesco = {
  enable = true;
  profiles = [ "base" "laptop" "development" ];
};
```

### Available Profiles

- `base` - Core desktop tools and Noctalia shell
- `desktop` - Desktop environment (Niri) configuration
- `laptop` - Laptop-specific input config (touchpad)
- `development` - Git, GitHub CLI, coding tools
- `gaming` - Gaming packages and tools

### Example Configurations

**Laptop Developer (xps9343)**:
```nix
modules.users.francesco.profiles = [ "base" "laptop" "development" ];
```

**Desktop Gaming Developer (midgar)**:
```nix
modules.users.francesco.profiles = [ "base" "desktop" "development" "gaming" ];
```

**Minimal Server**:
```nix
modules.users.francesco.profiles = [ "base" ];
```

## Customization

### Adding a New Module

1. Create a new directory: `modules/home/your-feature/`
2. Create `default.nix` with options and config:

```nix
{ config, lib, pkgs, ... }:

let
  cfg = config.modules.home.your-feature;
in
{
  options.modules.home.your-feature = {
    enable = lib.mkEnableOption "Your feature description";
  };

  config = lib.mkIf cfg.enable {
    # Your home-manager configuration here
    home.packages = [ pkgs.some-package ];
  };
}
```

3. Add import to `modules/home/default.nix`
4. Use the new profile in host configurations

### Customizing Module Settings

For module-specific configuration (like Git user details), extend the options:

```nix
options.modules.home.development = {
  enable = lib.mkEnableOption "Development tools";
  
  git = {
    enable = lib.mkEnableOption "Git";
    userName = lib.mkOption { ... };
    userEmail = lib.mkOption { ... };
  };
};
```

Then configure in the host:

```nix
modules.home.development = {
  enable = true;
  git = {
    enable = true;
    userName = "Your Name";
    userEmail = "your@email.com";
  };
};
```

### Per-Monitor Configuration

To customize monitor setup (especially for vertical monitors), edit `modules/home/desktop/default.nix`:

```nix
programs.niri.settings = {
  outputs = {
    "DP-1" = {  # Find your monitor name with: swaymsg -t get_outputs
      position = { x = 0; y = 0; };
      scale = 1.0;
      transform = "normal";  # "90" for vertical
    };
  };
};
```

## Migration from Old System

The old `users/francesco/home.nix` has been split into modules. If you customized it, find your settings in:

- **Noctalia shell settings** → `modules/home/base/`
- **Niri window manager** → `modules/home/desktop/`
- **Touchpad config** → `modules/home/laptop/`
- **Git/GitHub** → `modules/home/development/`
- **Gaming packages** → `modules/home/gaming/`

## Persistence Configuration

Home persistence directories are still defined in `modules/users/francesco/default.nix` and apply to all profiles. To make persistence profile-specific, move the `home.persistence` block into individual modules.

## Future Improvements

- Add per-profile persistence configuration
- Create additional profiles (e.g., `server`, `minimal`, `creative`)
- Add profile composition helpers
- Create shared home module library for multi-user setups
