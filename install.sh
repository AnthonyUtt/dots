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

# Link configuration files into $config
echo "⇒ Installing dotfiles from $script_dir…"
mkdir -p "$HOME/.config"
ln -s "$script_dir/config" "$HOME/.config"
echo "✅  dotfiles installed successfully!"

# Copy scripts to $HOME/.local/bin
echo "⇒ Copying scripts to $HOME/.local/bin…"
mkdir -p "$HOME/.local/bin"
rsync -a "$script_dir/scripts/" "$HOME/.local/bin/"
chmod +x "$HOME/.local/bin/"*  # Make scripts executable
echo "✅  scripts installed successfully!"

echo "⇒ Installing other configuration files…"
ln -s "$script_dir/.zshrc" "$HOME/.zshrc"
ln -s "$script_dir/ssh/config" "$HOME/.ssh/config"

sudo mkdir -p /etc/greetd
sudo ln -s "$script_dir/other/greetd.conf" /etc/greetd/greetd.conf
# copy nwg-hello conf bc any changes should be machine-specific
sudo cp -r "$script_dir/other/nwg-hello" /etc/nwg-hello
# same for doas
sudo cp "$script_dir/other/doas.conf" /etc/doas.conf
echo "✅  config files installed successfully!"

cli_tools=(
  bat btop curl direnv eza fd fzf jq neofetch neovim-nightly-bin
  nvtop ripgrep unzip vim wget wine zellij zip zoxide zsh
)
desktop_apps=(
  dbeaver dolphin firefox-developer-edition gimp inkscape kitty
  libation-bin prusa-slicer remmina slack-desktop spotify-launcher thunderbird vlc vesktop
)
desktop_environment=(
  brightnessctl cliphist greetd hyprland-meta-git mako nwg-drawer nwg-hello pipewire
  playerctl qt5-wayland qt6-wayland swaybg swayidle swaylock waybar wf-recorder
  wireplumber wl-clipboard wl-mirror walker-bin pipewire-pulse pwvucontrol
  rose-pine-hyprcursor hyprshot
)
dev_tools=(
  docker docker-compose
)
fonts=(
  ttf-jetbrains-mono-nerd
  otf-departure-mono
  ttf-font-awesome
  nerd-fonts
  noto-fonts-emoji
  ttf-twemoji
)
gaming=(
  gamemode gamescope mangohud nvtop steam vulkan-tools libratbag
)
graphics=(
  nvidia-open-dkms nvidia-utils nvidia-settings
  lib32-nvidia-utils egl-wayland libva-nvidia-driver
)
system_utilities=(
  gcc git linux-zen-headers make man-db man-pages openssh rustup silicon
  opendoas openssh
)

echo "⇒ Installing packages with yay…"
yay -S --needed --noconfirm \
  --answerdiff None \
  --answerclean All \
  "${cli_tools[@]}" \
  "${desktop_apps[@]}" \
  "${desktop_environment[@]}" \
  "${fonts[@]}" \
  "${gaming[@]}" \
  "${graphics[@]}" \
  "${system_utilities[@]}"

echo "⇒ Enabling services…"
sudo systemctl enable greetd.service

# Enable zsh as the default shell
if [[ "$SHELL" != "$(which zsh)" ]]; then
  echo "⇒ Changing default shell to zsh…"
  chsh -s "$(which zsh)"
else
  echo "✅  zsh is already the default shell."
fi

echo "⇒ Checking for nvidia GPU…"
HAS_NVIDIA="$(lspci | grep NVIDIA &>/dev/null && echo 1 || echo 0)"

if [[ "$HAS_NVIDIA" == "1" ]]; then
  echo "✅  nvidia GPU found!"
  echo "⇒ Configuring nvidia drivers…"
  echo "options nvidia_drm modeset=1" | sudo tee /etc/modprobe.d/nvidia-drm.conf > /dev/null
  sudo sed -i '/^MODULES=/ s/)/nvidia nvidia_modeset nvidia_uvm nvidia_drm)/g' /etc/mkinitcpio.conf
  sudo mkinitcpio -P
fi

echo "⇒ Configuring libratbag for Logitech G502 X LIGHTSPEED…"
sudo ln -s "$script_dir/other/logitech-g502-x-lightspeed.device" /usr/share/libratbag/logitech-g502-x-lightspeed.device

echo "⇒ Updating font cache…"
fc-cache -fv

echo "⇒ Updating icon cache…"
gtk-update-icon-cache -f /usr/share/icons/hicolor

echo "⇒ Updating desktop database…"
update-desktop-database -q

echo "⇒ Cleaning up…"
yay -Rns --noconfirm "$(yay -Qdtq)"  # Remove unused dependencies

echo "✅  All done!"
