#!/usr/bin/env bash

set -euo pipefail

script_dir=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)
if [[ -z "$script_dir" ]]; then
  echo "❌  Could not determine script directory." >&2
  exit 1
fi
cd "$script_dir" || exit 1

if [[ $EUID -eq 0 ]]; then
  echo "❌  Please run this script as a normal user, not root." >&2
  exit 1
fi

echo "⇒ Installing prerequisites (base-devel, git)…"
sudo pacman -Syyu --noconfirm
sudo pacman -S --needed --noconfirm base-devel git rsync

tmpdir=$(mktemp -d)
trap 'rm -rf "$tmpdir"' EXIT INT TERM

# check if yay is already installed
if command -v yay &> /dev/null; then
  echo "✅  yay is already installed."
else
  echo "❗  yay is not installed. Proceeding with installation."
  echo "⇒ Cloning yay PKGBUILD from the AUR…"
  git clone --depth=1 https://aur.archlinux.org/yay.git "$tmpdir/yay" || {
    echo "❌  Failed to clone yay repository." >&2
    exit 1
  }

  echo "⇒ Building and installing yay…"
  (
    cd "$tmpdir/yay"
    makepkg -si --noconfirm        # build & install via pacman
  )

  echo "✅  yay installed successfully!"
fi


# Copy configuration files into $config
echo "⇒ Installing dotfiles from $script_dir…"
mkdir -p "$HOME/.config"
rsync -a "$script_dir/config/" "$HOME/.config/"
echo "✅  dotfiles installed successfully!"

# Copy scripts to $HOME/.local/bin
echo "⇒ Copying scripts to $HOME/.local/bin…"
mkdir -p "$HOME/.local/bin"
rsync -a "$script_dir/scripts/" "$HOME/.local/bin/"
chmod +x "$HOME/.local/bin/"*  # Make scripts executable
echo "✅  scripts installed successfully!"

# Copy other configuration files
echo "⇒ Copying other configuration files…"
# Backup existing files before overwriting
[[ -f "$HOME/.zshrc" ]] && cp "$HOME/.zshrc" "$HOME/.zshrc.backup"
cp "$script_dir/.zshrc" "$HOME/.zshrc"

[[ -f "$HOME/.ssh/config" ]] && cp "$HOME/.ssh/config" "$HOME/.ssh/config.backup"
mkdir -p "$HOME/.ssh"
cp "$script_dir/ssh/config" "$HOME/.ssh/config"
chmod 600 "$HOME/.ssh/config"  # Ensure SSH config has correct permissions

sudo mkdir -p /etc/greetd
sudo cp "$script_dir/other/greetd.conf" /etc/greetd/greetd.conf
echo "✅  config files installed successfully!"

packages=(
  bat brightnessctl btop cliphist curl dbeaver direnv
  discord dolphin eza fd firefox-developer-edition fzf gamemode gamescope gcc gimp
  git greetd grimblast hyprland-meta-git inkscape jq kitty
  libation-bin make mako mangohud neofetch neovim-nightly-bin
  nvtop nwg-hello opendoas openssh pipewire playerctl prusa-slicer qt5-wayland qt6-wayland
  remmina ripgrep rustup silicon slack-desktop
  spotify swaybg swayidle swaylock thunderbird unzip vim vlc vulkan-tools
  waybar wf-recorder wget wine wireplumber wl-clipboard
  wl-mirror wofi vencord zellij zip zoxide zsh
)

echo "⇒ Installing packages with yay…"
yay -S --needed --noconfirm \
  --answerdiff None \
  --answerclean All \
  "${packages[@]}"

echo "⇒ Enabling services…"
sudo systemctl enable greetd.service

echo "✅  All done!"
