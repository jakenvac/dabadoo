> [!NOTE]
> Use [JankyBorders](https://github.com/FelixKratz/JankyBorders) instead.

# Dabadoo

Uh, Yabai Daba Doo? A companion tool for yabai that restores borders. (kinda)

> [!NOTE]
> This is one of my first swift projects and is very very alpha. Expect bugs.

## Installing

```sh
  brew tap jakenvac/formulae
  brew install dabadoo

  # run with
  dabadoo

  # or configure the service to run automatically
  brew services start dabadoo
```

## Config

A config file can be loaded from `~/.config/dabadoo/config.yaml`  
Here are all the options and their default values:

```yaml
appearance:
  # Roundness of the border corners
  border_radius: 12
  # Thickness of the border
  border_thickness: 6
  # The border color, can be #RRGGBB or #RRGGBBAA
  border_color: "#FFAACC"
  # Where the border sits relative to the edge of the window
  # can be "inline", "inset", or "outset". Default is "inline".
  border_position: "inline"
  # If the border is in front or behind the focused window
  # "front" or "back". Default is "back".
  border_layer: "back"

observer:
  # type can be "timer" or "window". Default is "timer".
  # Note: the window observer is broken
  type: "timer"
  # timer_interval is a Double representing the interval in seconds. Default is 0.5.
  timer_interval: 0.5
```

## TODO

- [ ] - Better installation methods
  - [ ] - Homebrew package
  - [ ] - Github release
- [ ] - Yabai Observer - use yabai signals to update borders
- [ ] - Background Service settings
