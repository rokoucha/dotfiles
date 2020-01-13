define BANNER
       __      __  _____ __         
  ____/ /___  / /_/ __(_) /__  _____
 / __  / __ \/ __/ /_/ / / _ \/ ___/
/ /_/ / /_/ / /_/ __/ / /  __(__  ) 
\__,_/\____/\__/_/ /_/_/\___/____/  

        Rokoucha's dotfiles
endef
export BANNER

# Settings
EXCLUSION := .git/\* docker-compose.yml Dockerfile LICENSE Makefile README.md
USERNAME := rokoucha

# System variable
INSTALL_PATH := $(if $(INSTALL_PATH),$(INSTALL_PATH),$(HOME))
DOTFILES_CONF_PATH := $(if $(XDG_CONFIG_HOME),$(XDG_CONFIG_HOME)/dotfiles/config,$(HOME)/.config/dotfiles/config)
DOTFILES_PATH := $(abspath $(dir $(lastword $(MAKEFILE_LIST))))
DOTFILES := $(shell printf " ! -path $(DOTFILES_PATH)/%s" $(EXCLUSION) | xargs find $(DOTFILES_PATH) -type f | sed 's|^$(DOTFILES_PATH)/||')

# System config template
define DOTFILES_CONF
# dotfiles config
DOTFILES_CONF_PATH="$(DOTFILES_CONF_PATH)"
DOTFILES_PATH="$(DOTFILES_PATH)"
INSTALL_PATH="$(INSTALL_PATH)"
endef
export DOTFILES_CONF

# Aliases
GPASSWD_A := sudo gpasswd -a $$(whoami)
INFO := @echo "===>"
LN := /usr/bin/ln -sfv
PACMAN_S := sudo pacman -S --noconfirm --needed
SYSTEMCTL_ENABLE := sudo systemctl enable
YAY_S := yay -S --noconfirm --needed

##@ Setup tasks(Required root shell)
pacstrap: ## Pacstrap
	pacstrap /mnt base base-devel linux-zen linux-zen-headers linux-firmware vim git zsh
	genfstab -U /mnt >> /mnt/etc/fstab

ryzen: ## Install Ryzen tools
	pacman -S amd-ucode
	echo "===> Required manual add `initrd	/amd-ucode.img` to /boot/loader/entries/arch.conf"

f2fs: ## Install F2FS tools
	pacman -S f2fs-tools

xfs: ## Install XFS tools
	pacman -S xfsprogs

pacmanconf: ## Setup Pacman
	sed -i "/\[multilib\]/,/Include/"'s/^#//' /etc/pacman.conf
	sed -i -e 's/^CFLAGS=.*/CFLAGS="-march=native -O2 -pipe -fstack-protector-strong"/g' /etc/makepkg.conf
	sed -i -e 's/^CXXFLAGS=.*/CXXFLAGS="${CFLAGS}"/g' /etc/makepkg.conf
	sed -i -e 's/^#MAKEFLAGS=.*/MAKEFLAGS="-j\$(nproc)"/g' /etc/makepkg.conf
	sed -i -e "s/^PKGEXT=.*$/PKGEXT='.pkg.tar'/g" /etc/makepkg.conf

mirrorlist: ## Mirrorlist
	curl -sL "https://www.archlinux.org/mirrorlist/?country=JP&protocol=https&ip_version=4&ip_version=6&use_mirror_status=on" > /etc/pacman.d/mirrorlist
	sed -i -e "s/#Server/Server/g" /etc/pacman.d/mirrorlist

localization: ## Timezone & Language
	ln -sf /usr/share/zoneinfo/Asia/Tokyo /etc/localtime
	hwclock --systohc --utc
	timedatectl set-local-rtc false
	sed -i -e "s/^#NTP=.*$/NTP=0.jp.pool.ntp.org 1.jp.pool.ntp.org 2.jp.pool.ntp.org 3.jp.pool.ntp.org/g" /etc/systemd/timesyncd.conf
	timedatectl set-ntp true
	echo "en_GB.UTF-8 UTF-8" > /etc/locale.gen
	locale-gen
	echo "LANG=en_GB.UTF-8" > /etc/locale.conf
	echo "FONT=Lat2-Terminus16" > /etc/vconsole.conf
	echo "KEYMAP=us" > /etc/vconsole.conf

user: ## Create user
	useradd -G wheel -m -s /usr/bin/zsh $(rokoucha)
	echo "%wheel ALL=(ALL) ALL" >> /etc/sudoers

systemdboot: ## Setup bootloader
	bootctl --path=/boot install
	echo "default	arch" > /boot/loader/loader.conf
	echo "timeout	1" >> /boot/loader/loader.conf
	echo "editor	no" >> /boot/loader/loader.conf
	echo "title	Arch Linux" > /boot/loader/entries/arch.conf
	echo "linux	/vmlinuz-linux-zen" >> /boot/loader/entries/arch.conf
	echo "initrd	/initramfs-linux-zen.img" >> /boot/loader/entries/arch.conf
	echo "options	root=PARTLABEL=root rw" >> /boot/loader/entries/arch.conf

##@ Application tasks
asdf: ## Install asdf-vm
	git clone https://github.com/asdf-vm/asdf.git "$(INSTALL_PATH)/.asdf"

audio: ## Install ALSA & PulseAudio
	$(PACMAN_S) alsa-utils pulseaudio-alsa pavucontrol

bluetooth: ## Install Bluetooth
	$(PACMAN_S) bluez bluez-utils blueberry
	$(GPASSWD_A) lp
	$(SYSTEMCTL_ENABLE) bluetooth.service
	$(INFO) "Required reboot before using Bluetooth"

code: ## Install Visual Studio Code
	$(PACMAN_S) code

cups: ## Install CUPS
	$(PACMAN_S) cups cups-pdf
	$(GPASSWD_A) cups
	$(SYSTEMCTL_ENABLE) org.cups.cupsd.service
	$(INFO) "Required reboot before using CUPS"
	$(INFO) "Required manual install printer driver"

dircolos: ## Install Monokai theme for dircolors
	curl -sL https://raw.githubusercontent.com/jtheoof/dotfiles/master/dircolors.monokai > "$(INSTALL_PATH)/.dircolors"

discord: ## Install Discord
	$(PACMAN_S) discord

docker: ## Install Docker
	$(PACMAN_S) docker docker-compose
	$(GPASSWD_A) docker
	$(SYSTEMCTL_ENABLE) docker.service
	$(INFO) "Required reboot before using Docker"

filemanager: ## Install File manager
	$(PACMAN_S) nautilus file-roller eog evince

firefox: ## Install Firefox Developer Edition
	$(PACMAN_S) firefox-developer-edition firefox-developer-edition-i18n-en-gb

fonts: ## Install Fonts
	$(YAY_S) fontconfig \
		adobe-source-code-pro-fonts \
		adobe-source-han-sans-jp-fonts \
		adobe-source-han-serif-jp-fonts \
		nerd-fonts-dejavu-complete \
		noto-fonts-emoji

git: ## Install Git
	$(PACMAN_S) git

gnupg: ## Install GnuPG
	$(PACMAN_S) gnupg

gtk: ## Install GTK
	$(PACMAN_S) gnome-themes-extra lxappearance 

i3: ## Install i3
	$(YAY_S) i3-gaps \
		dmenu2 \
		gnome-backgrounds \
		network-manager-applet \
		nitrogen \
		polybar \
		volumeicon

networkmanager: ## Install NetworkManager
	$(PACMAN_S) dhclient networkmanager
	$(SYSTEMCTL_ENABLE) --now NetworkManager.service

opal: ## Install OPAL Self-Encrypting Drive tools
	$(YAY_S) sedutil
	curl -sOL https://github.com/Drive-Trust-Alliance/exec/raw/master/UEFI64.img.gz
	gunzip UEFI64.img.gz
	$(INFO) "Required manual operation!"
	$(INFO) "sedutil-cli needs libata.allow_tpm=1"
	$(INFO)
	$(INFO) "Initialize OPAL: `# sedutil-cli --initialsetup <password> <drive>`"
	$(INFO) "Install PBA image: `# sedutil-cli --loadPBAimage <password> UEFI64.img <drive>`"
	$(INFO) "Enable SED: `# sedutil-cli --setMBREnable on <password> <drive>`"
	$(INFO) "Enable locking: `# sedutil-cli --enableLockingRange 0 <password> <drive>`"

openssh: ## Install OpenSSH
	$(PACMAN_S) openssh
	-ssh-keygen -f "$(INSTALL_PATH)/.ssh/id_ed25519" -N "" -t ed25519

radeon: ## Intall Radeon drivers
	$(PACMAN_S) lib32-libva-mesa-driver \
		libva-mesa-driver \
		light \
		mesa \
		vulkan-radeon \
		xf86-video-amdgpu
	sudo chmod +s /usr/bin/light

skk: ## Install SKK
	$(PACMAN_S) ibus ibus-skk skk-jisyo skktools

slack: ## Install Slack
	$(YAY_S) slack-desktop

tlp: ## Install TLP
	$(YAY_S) tlp tlpui-git acpi_call lm_sensors xsensors
	sed -i -e "s/^#?RUNTIME_PM_ON_BAT=.+$/RUNTIME_PM_ON_BAT=on/g" /etc/default/tlp
	$(SYSTEMCTL_ENABLE) --now tlp.service

vim: ## Install Vim
	$(PACMAN_S) vim

vundle: ## Install Vundle
	@if type vim >/dev/null 2>&1; then \
		git clone https://github.com/VundleVim/Vundle.vim.git "$(INSTALL_PATH)/.vim/bundle/Vundle.vim"; \
		vim +PluginInstall +qall; \
	else \
		echo "===> command not found: vim"; \
		exit 1; \
	fi

xdg-user-dirs: ## Install XDG user directories
	$(PACMAN_S) xdg-user-dirs
	env LC_ALL=C xdg-user-dirs-update

xorg: ## Install Xorg server
	$(PACMAN_S) arandr \
		gdm \
		xorg-server \
		xorg-xinit \
		xorg-xrandr \
		xorg-xrdb
	$(SYSTEMCTL_ENABLE) --now gdm.service

yay: ## Install Yay
	@if ! type yay >/dev/null 2>&1; then \
		$(eval YAY_TEMP := $(shell mktemp -d)) \
		git clone https://aur.archlinux.org/yay.git "$(YAY_TEMP)"; \
		sh -c "cd \"$(YAY_TEMP)\"; makepkg -sri --noconfirm"; \
		rm -rf "$(YAY_TEMP)"; \
	fi
	yay -Syyu --noconfirm

yubikey: ## Install YubiKey tools
	$(PACMAN_S) pcsc-tools \
		libu2f-host \
		pcsclite \
		yubico-c \
		yubico-c-client \
		yubikey-manager \
		yubikey-manager-qt \
		yubikey-personalization \
		yubikey-personalization-gui \
		yubioath-desktop
	$(SYSTEMCTL_ENABLE) --now pcscd.service

zsh: ## Install Z Shell
	$(YAY_S) fzf ghq powerline shellcheck zsh

zplugin: ## Install Zplugin
	git clone https://github.com/zdharma/zplugin.git "$(INSTALL_PATH)/.zplugin/bin"
	zsh -i -c "exit"

zprezto: ## Install Prezto
	@$(LN) "$(INSTALL_PATH)/.zplugin/plugins/sorin-ionescu---prezto" "$(INSTALL_PATH)/.zprezto"

##@ Group tasks
.PHONY: arch-cli arch-gui cli

arch-cli: yay docker git gnupg openssh vim xdg-user-dirs zsh ## Install Arch Linux CLI applications

arch-gui: audio bluetooth code cups discord firefox fonts filemanager networkmanager skk slack yubikey ## Install Arch Linux GUI applications

cli: dircolos vundle zplugin zprezto asdf ## Install CLI applications

##@ Setup group tasks
.PHONY: install install-arch-cli

install: deploy cli execshell ## Setup CLI envirpnment

install-arch-cli: deploy arch-cli cli execshell ## Setup Arch Linux CLI environment

##@ Management tasks
.PHONY: dotpath banner list update deploy upgrade clean execshell debug help

dotpath: ## Print dotfiles path
	@echo "$(DOTFILES_PATH)"

banner: ## Print a banner
	@echo "$$BANNER"

list: banner ## Print a list of dotfiles
	@echo "===> Listing dotfiles in $(DOTFILES_PATH)"
	@$(foreach dotfile,$(DOTFILES),/usr/bin/ls -F "$(dotfile)";)

update: banner ## Update dotfiles
	@echo "===> Update dotfiles"
	@git pull origin master

deploy: banner ## Deploy dotfiles
	@echo "===> Deploy dotfiles to $(INSTALL_PATH)"
	@$(foreach dotfile,$(DOTFILES),mkdir -p "$(INSTALL_PATH)/$(dir $(dotfile))"; $(LN) "$(abspath $(dotfile))" "$(INSTALL_PATH)/$(dotfile)";)
	@echo "===> Dotfiles has been successfully deployed!"
	@mkdir -p "$(dir $(DOTFILES_CONF_PATH))"
	@echo "$$DOTFILES_CONF" > "$(DOTFILES_CONF_PATH)"

upgrade: clean update deploy ## Update and deploy dotfiles

clean: banner ## Clean dotfiles in INSTALL_PATH
	@echo "===> Clean dotfiles in $(INSTALL_PATH)"
	@$(foreach dotfile,$(DOTFILES), \
		if [ -L "$(INSTALL_PATH)/$(dotfile)" ]; then \
			rm -fv "$(INSTALL_PATH)/$(dotfile)"; \
		else \
			echo "===> $(INSTALL_PATH)/$(dotfile) is not managed by dotfiles and will not be deleted!"; \
		fi;)
	@echo "===> Dotfiles has been successfully cleaned!"

execshell: ## Reboot shell
	@echo "===> Successfully completed! Rebooting shell..."
	exec "$$SHELL"

debug: banner ## Debug with Docker
	@echo "===> Debug dotfiles with Docker"
	@sh -c "cd \"$(MAKEFILE_DIR)\"; docker-compose build --pull; docker-compose run --rm dotfiles"

# Forked from https://gist.github.com/prwhite/8168133#gistcomment-2833138
help: banner ## Help
	@awk 'BEGIN {FS = ":.*##"} /^[0-9a-zA-Z_-]+:.*?##/ { printf "  \033[36m%-18s\033[0m %s\n", $$1, $$2 } /^##@/ { printf "\n\033[1m%s\033[0m\n", substr($$0, 5) } ' $(MAKEFILE_LIST)

.DEFAULT_GOAL := help
