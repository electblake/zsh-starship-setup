# zsh-starship-setup

`zsh-starship-setup`, also known simply as `starship-setup`, is a Zsh plugin designed to streamline the configuration of the [Starship](https://starship.rs) prompt for XDG and shared host-specific starship configuration.

## Features
- **Dynamic Configuration Path**: Automatically configures `STARSHIP_CONFIG` to use host-specific settings where available, with fallbacks to general settings. (ie. `starship.<computer-name>.toml`)
- **XDG Base Directory Compliance**: Optionally configures Starship to utilize XDG base directory standards for both cache and configuration files.

## Installation

### Prerequisites

- Zsh (`brew install zsh`)
- [starship](https://starship.rs) (`brew install starship`)

### Install

[zgenom](https://github.com/jandamm/zgenom)

If you're using `zgenom` or og zgen or other plugin manager (maybe), your `.zshrc` file where you load your other Zsh plugins might look like:

```bash
# setttings
zstyle ':starship:config' debug true # Enables debuging
zstyle ':starship:config' use-xdg true # Set to use XDG environment variables

if ! zgenom saved; then
    # plugins..
    zgenom load electblake/zsh-starship-setup

    # the end
    zgenom save
fi
```
`zgenom update && exec zsh` to re-compile zgen

[oh-my-zsh](https://github.com/ohmyzsh/ohmyzsh/wiki/Customization#adding-a-new-plugin)

To manually install the plugin, clone the repository and source it within your `.zshrc`:

```bash
git clone https://github.com/electblake/zsh-starship-setup.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-starship-setup
```

```bash
$ZSH_CUSTOM
└── plugins
    └── zsh-starship-setup
        └── zsh-starship-setup.plugin.zsh
```

`~/.zshrc`

```bash
plugins=(git bundler zsh-starship-setup)
```

## Configuration

To activate XDG support and customize Starship via `zstyle`, add the following lines to your `.zshrc` file:

```bash
zstyle ':starship:setup' use-xdg true
zstyle ':starship:setup' debug true  # Optional: Enables debugging output
```

Understood! Here's a streamlined and updated README section that correctly reflects the typical and XDG-based configuration paths for `starship-setup` plugin users. This version ensures clarity on default versus XDG paths without assuming user preferences.

---

### Host-Specific Configuration

The `starship-setup` plugin allows you to use distinct configurations for Starship on different machines, ideal for users who operate across multiple environments.

#### Configuration Logic

`starship-setup` selects the correct Starship configuration file based on the system's hostname:

1. **Determine the Host Name**: The plugin retrieves your computer's hostname using:
   - **macOS**: `scutil --get ComputerName` to use the computer's name without the `.local` suffix typical of Bonjour services.
   - **Linux/Unix**: `hostname` for straightforward hostname retrieval.

2. **Configuration File Naming**:
   - Typically, the configuration file should be named `starship.<hostname>.toml`. For instance, if your hostname is `pluto`, the file should be `starship.pluto.toml`.
   - For users with a preference for XDG standards, place the file under the subdirectory: `~/.config/starship/starship.pluto.toml`.

3. **Configuration File Location**:
   - The default location for Starship configuration files is `~/.config/starship.toml`.
   - If customizing per-host, you might place it in `~/.config/starship/` as `starship.<hostname>.toml` or follow the XDG path if you prefer organized subdirectories.

#### How to Set Up

Preview and create the correct configuration file based on your system type:

```bash
# For Linux and Unix-like systems
echo "Your host-specific configuration file: ~/.config/starship.$(hostname).toml"

# For macOS users
echo "Your host-specific configuration file: ~/.config/starship.$(scutil --get ComputerName).toml"
```

**Create and Customize:**
   
```bash
# Use this command to create and edit your host-specific configuration file
nano ~/.config/starship.pluto.toml  # Replace 'pluto' with your actual hostname
```

Adjust your Starship configuration within this file as needed. Use `exec zsh` to restart your shell for the changes to take effect.

#### Example

If the computer's name is "pluto", and you are following typical path conventions (not strict XDG layouts), you would create a file named `~/.config/starship/starship.pluto.toml`. Customize this file to define how your prompt behaves and appears on "pluto".

Using these steps, you can maintain unique configurations for each of your machines, enhancing your productivity and ease of use in different computing environments.

---

This revised README section provides clear, user-friendly guidance for setting up host-specific configurations with and without XDG preferences. It correctly directs users on the path conventions and helps them understand how to manage their configuration files effectively.

### Contributing

Contributions are welcome! Please open issues or submit pull requests on [GitHub](https://github.com/electblake/zsh-starship-setup) if you have suggestions or code improvements.

### License

This project is licensed under the MIT License - see the [LICENSE](https://github.com/electblake/zsh-starship-setup/LICENSE) file for details.