# Function to set up environment based on XDG Base Directory Specification
setup_xdg_environment() {
    if zstyle -t ':starship:setup' use-xdg; then
        local cache_dir="${XDG_CACHE_HOME:-$HOME/.cache}/starship"
        local config_dir="${XDG_CONFIG_HOME:-$HOME/.config}/starship"

        # Ensure directories exist
        mkdir -p "$cache_dir" "$config_dir"
        export STARSHIP_CACHE="$cache_dir"
        export STARSHIP_CONFIG="$config_dir/starship.toml"
        
        # Debug output for setting XDG environment variables
        zstyle -t ':starship:setup' debug && echo "-- starship-setup: XDG variables initialized - CACHE at $STARSHIP_CACHE, CONFIG at $STARSHIP_CONFIG"
    else
        zstyle -t ':starship:setup' debug && echo "-- starship-setup: XDG support is disabled."
    fi
}

# Function to get the computer name
get_computer_name() {
    local computer_name
    if [[ "$OSTYPE" == "darwin"* ]]; then
        # For macOS
        if ! computer_name=$(scutil --get ComputerName); then
            echo "-- starship-setup: Failed to retrieve Computer Name on macOS" >&2
            return 1
        fi
    else
        # For Linux and other unix-like OS
        if ! computer_name=$(hostname); then
            echo "-- starship-setup: Failed to retrieve Computer Name" >&2
            return 1
        fi
    fi
    echo "$computer_name"
}

setup_xdg_environment  # Call XDG setup

local computer_name=$(get_computer_name) || return 1
local config_directory=""
local config_found=false
local host_config_name="starship.$computer_name.toml"

# Define default and host-specific config file locations
local default_config="$HOME/.config/starship.toml"
local xdg_config="${XDG_CONFIG_HOME:-$HOME/.config}/starship/starship.toml"
local config_locations=("$STARSHIP_CONFIG" "$default_config" "$xdg_config")

# Find any valid configuration file to determine the config directory
for config_path in "${config_locations[@]}"; do
    if [[ -n "$config_path" && -f "$config_path" ]]; then
        config_directory="${config_path%/*}"
        config_found=true
        break
    fi
done

# If a config directory is found, look for a host-specific config file there
if [[ "$config_found" == true ]]; then
    local host_config="$config_directory/$host_config_name"
    if [[ -f "$host_config" ]]; then
        export STARSHIP_CONFIG="$host_config"
        zstyle -t ':starship:setup' debug && echo "-- starship-setup: Host-specific CONFIG set at $STARSHIP_CONFIG"
    else
        export STARSHIP_CONFIG="$config_directory/starship.toml"  # Use the general config if host-specific not found
        zstyle -t ':starship:setup' debug && echo "-- starship-setup: General CONFIG set at $STARSHIP_CONFIG"
        zstyle -t ':starship:setup' debug && echo "-- starship-setup: No host-specific config found. Create '$host_config' to enable host-specific configuration."
    fi
else
    zstyle -t ':starship:setup' debug && echo "-- starship-setup: No custom configurations found; fallback to default behavior."
fi