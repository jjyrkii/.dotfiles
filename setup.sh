#!/bin/bash

pwd=$(pwd)

# Make sure snap is gone
if command -v snap &> /dev/null; then
    echo "Removing snap"
    while true; do
        # Get a list of all installed Snap packages
        snap_list=$(sudo snap list --all | tail -n +2 | awk '!/disabled/{print $1}')

        # If there are no more Snap packages installed, exit the loop
        if [ -z "$snap_list" ]; then
            break
        fi

        # Loop through the list and remove each Snap package
        for package in $snap_list; do
            sudo snap remove "$package" > /dev/null 2>&1
            # Check if the removal was successful
            if command -v snap; then
                echo "Removed: $package"
            fi
        done
    done
    echo "All Snap packages have been removed."

    sudo systemctl stop snapd
    sudo systemctl disable snapd
    sudo systemctl mask snapd
    sudo apt purge snapd -y
    sudo apt autoremove -y
    sudo apt-mark hold snapd
    echo "Snap service removed"

    rm -rf "$HOME/snap/"
    sudo rm -rf /snap
    sudo rm -rf /var/snap
    sudo rm -rf /var/lib/snapd
    echo "Removed snap files"
    
    sudo cat <<EOF | sudo tee /etc/apt/preferences.d/nosnap.pref
Package: snapd
Pin: release a=*
Pin-Priority: -10
EOF
fi

sudo apt update
sudo apt upgrade -y

packages=(
	"zsh"
	"build-essential"
	"cmake"
	"unzip"
	"gettext"
	"ripgrep"
	"python3-pip"
	"gh"
)
sudo apt install -y "${packages[@]}"

if [ ! -d "$HOME/.config" ]; then
	mkdir "$HOME/.config"
fi

if [ "$SHELL" != "/usr/bin/zsh" ]; then
	if [ ! -d "$HOME/.oh-my-zsh" ]; then
		sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
	fi
fi

if ! command -v nvim &> /dev/null; then
	echo "Installing neovim"
	git clone https://github.com/neovim/neovim
	cd neovim && make CMAKE_BUILD_TYPE=Release
	git checkout stable
	sudo make install
	sudo rm -rf "$pwd/neovim"
fi

if [ ! -d "$HOME/.tmux/plugins/tpm" ]; then
	git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
fi


paths=(
	".zshrc"
       	".config/nvim"
       	".config/tmux"
       	".config/git"
)


for path in "${paths[@]}"; do
    if [ -e "$HOME/$path" ]; then
	    if [ ! -L "$HOME/$path" ]; then
		    rm -rf "$HOME/${path:?}"
	    else
		    break
	    fi
    fi
    ln -s "$pwd/$path" "$HOME/$path"
done

if [ ! -d  "$HOME/.nvm" ]; then
	sudo apt purge nodejs
	curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.1/install.sh | sh
	source "$HOME/.zshrc"
	nvm install 21
fi

if ! command -v cargo &> /dev/null; then
	curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
fi

if ! command -v go &> /dev/null; then
	wget https://go.dev/dl/go1.21.5.linux-amd64.tar.gz
	sudo rm -rf /usr/local/go && sudo tar -C /usr/local -xzf go1.21.5.linux-amd64.tar.gz
	export PATH=$PATH:/usr/local/go/bin
fi

sudo apt autoremove -y
# hallo
git update-index --assume-unchanged "$pwd/.config/git/config"
echo "######################"
echo "######################"
echo "######################"
echo "######################"
echo "######################"
echo "######################"
echo "Changing default shell"
echo "######################"
chsh -s /usr/bin/zsh
echo "###### ALL DONE ######"
