#!/bin/bash

# This script installs the tools and packages that you frequently use.

# Function to ask for confirmation
confirm() {
  read -r -p "$1 [y/N] " response
  case "$response" in
  [yY][eE][sS] | [yY])
    true
    ;;
  *)
    false
    ;;
  esac
}

# -----------------
# APT Packages
# -----------------
if confirm "Do you want to install packages using APT?"; then
  echo "Updating APT..."
  sudo apt-get update

  echo "Installing essential packages..."
  sudo apt-get install -y curl wget unzip zip build-essential git gcc make

  echo "Installing command-line tools..."
  sudo apt-get install -y vlc mplayer mpv htop btop atop locust python3-pip python3-venv yarn nmap jq id3v2 cava dijo fzf tmux zsh timg lsix stow cloc dirsearch wireshark tshark dumpcap net-tools pandoc texlive-full lazygit python3-paho-mqtt speech-dispatcher espeak libpcap-dev

  echo "Installing development tools..."
  sudo apt-get install -y default-jdk qemu-system-i386 mtools grub-pc-bin grub-common

  #Batcat
  sudo apt install bat
fi

# -----------------
# Snap Packages
# -----------------
if confirm "Do you want to install packages using Snap?"; then
  echo "Installing Snap packages..."
  sudo snap install atuin
  sudo snap install broot
fi

# -----------------
# Pip and Pipx
# -----------------
if confirm "Do you want to install Python packages using pip/pipx?"; then
  echo "Installing pipx..."
  sudo apt install pipx
  pipx ensurepath

  echo "Installing Python packages with pipx..."
  pipx install pytube
  pipx install git+https://github.com/mps-youtube/yewtube.git

  echo "Installing Python packages with pip..."
  pip install rembg
fi

# -----------------
# NVM, Node.js, and NPM packages
# -----------------
if confirm "Do you want to install Node.js using NVM and global NPM packages?"; then
  echo "Installing NVM..."
  curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.1/install.sh | bash
  export NVM_DIR="$HOME/.nvm"
  [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"

  echo "Installing latest version of Node.js..."
  nvm install node
  nvm use node

  echo "Installing global NPM packages..."
  npm i -g typescript typescript-language-server eslint prettier eslint_d @google/gemini-cli
fi

# -----------------
# Yarn
# -----------------
if confirm "Do you want to install Yarn?"; then
  echo "Installing Yarn..."
  corepack enable
fi

# -----------------
# Go
# -----------------
if confirm "Do you want to install Go and Go packages?"; then
  echo "Installing Go..."
  sudo apt-get install -y golang-go

  echo "Installing Go packages..."
  go install github.com/rivo/tview@latest
  go install github.com/quackduck/devzat@latest
  go install github.com/go-delve/delve/cmd/dlv@latest
fi

# -----------------
# Rust (Cargo)
# -----------------
if confirm "Do you want to install Rust and Cargo packages?"; then
  echo "Installing Rust..."
  curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
  source "$HOME/.cargo/env"
fi

# -----------------
# Oh My Zsh and plugins
# -----------------
if confirm "Do you want to install Oh My Zsh and its plugins?"; then
  echo "Installing Oh My Zsh..."
  sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended

  echo "Installing Oh My Zsh plugins..."
  ZSH_CUSTOM=${ZSH_CUSTOM:-~/.oh-my-zsh/custom}
  git clone https://github.com/catppuccin/zsh-syntax-highlighting.git ${ZSH_CUSTOM}/plugins/catppuccin
  git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM}/plugins/zsh-autosuggestions
  git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM}/plugins/zsh-syntax-highlighting
fi

# -----------------
# Other tools
# -----------------
if confirm "Do you want to install other tools (lazydocker, curlie, uv, yt-dlp, ytfzf, wezterm, atuin)?"; then
  echo "Installing lazydocker..."
  curl https://raw.githubusercontent.com/jesseduffield/lazydocker/master/scripts/install_update_linux.sh | bash

  echo "Installing curlie..."
  curl -sS https://webinstall.dev/curlie | bash

  echo "Installing uv..."
  curl -LsSf https://astral.sh/uv/install.sh | sh

  echo "Installing yt-dlp..."
  sudo wget https://github.com/yt-dlp/yt-dlp/releases/latest/download/yt-dlp -O /usr/local/bin/yt-dlp
  sudo chmod a+rx /usr/local/bin/yt-dlp

  echo "Installing ytfzf..."
  git clone https://github.com/pystardust/ytfzf.git
  cd ytfzf
  sudo make install doc
  cd ..

  echo "Installing wezterm..."
  curl -fsSL https://apt.fury.io/wez/gpg.key | sudo gpg --yes --dearmor -o /usr/share/keyrings/wezterm-fury.gpg
  echo 'deb [signed-by=/usr/share/keyrings/wezterm-fury.gpg] https://apt.fury.io/wez/ * *' | sudo tee /etc/apt/sources.list.d/wezterm.list
  sudo apt-get update
  sudo apt-get install -y wezterm

  echo "Installing atuin..."
  curl --proto '=https' --tlsv1.2 -LsSf https://setup.atuin.sh | sh

fi

# -----------------
# Docker
# -----------------
if confirm "Do you want to install Docker and Docker Compose?"; then
  echo "Installing Docker..."
  sudo apt-get install -y docker.io
  sudo systemctl start docker
  sudo systemctl enable docker
  sudo usermod -aG docker $USER

  echo "Installing Docker Compose..."
  sudo apt-get install -y docker-compose
fi

echo "Installation script finished."
echo "Please restart your shell or run 'source ~/.bashrc' or 'source ~/.zshrc' to apply changes."
