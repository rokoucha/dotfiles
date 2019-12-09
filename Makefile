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
PACMAN_S := yay -S --noconfirm --needed
LN := /usr/bin/ln -sfv

##@ Application tasks
asdf: ## Install asdf-vm
	git clone https://github.com/asdf-vm/asdf.git "$(INSTALL_PATH)/.asdf"

dircolos: ## Install Monokai theme for dircolors
	curl -sL https://raw.githubusercontent.com/jtheoof/dotfiles/master/dircolors.monokai > "$(INSTALL_PATH)/.dircolors"

docker: ## Install Docker
	$(PACMAN_S) docker docker-compose
	sudo gpasswd -a $$(whoami) docker
	sudo systemctl enable docker.service
	@echo "===> Required reboot before using Docker"

git: ## Install Git
	$(PACMAN_S) git

gnupg: ## Install GnuPG
	$(PACMAN_S) gnupg

openssh: ## Install OpenSSH
	$(PACMAN_S) openssh
	-ssh-keygen -f "$(INSTALL_PATH)/.ssh/id_ed25519" -N "" -t ed25519

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

yay: git ## Install Yay
	@if ! type yay >/dev/null 2>&1; then \
		$(eval YAY_TEMP := $(shell mktemp -d)) \
		git clone https://aur.archlinux.org/yay.git "$(YAY_TEMP)"; \
		sh -c "cd \"$(YAY_TEMP)\"; makepkg -sri --noconfirm"; \
		rm -rf "$(YAY_TEMP)"; \
	fi
	yay -Syu --noconfirm

zsh: ## Install Z Shell
	$(PACMAN_S) fzf ghq powerline shellcheck zsh

zplugin: git ## Install Zplugin
	git clone https://github.com/zdharma/zplugin.git "$(INSTALL_PATH)/.zplugin/bin"

zprezto: ## Install Prezto
	@$(LN) "$(INSTALL_PATH)/.zplugin/plugins/sorin-ionescu---prezto" "$(INSTALL_PATH)/.zprezto"

##@ Group tasks
.PHONY: arch cli

arch-cli: yay docker git gnupg openssh vim xdg-user-dirs zsh ## Install Arch Linux CLI applications

cli: dircolos vundle zplugin zprezto asdf ## Install CLI applications

##@ Setup tasks
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
	@awk 'BEGIN {FS = ":.*##"} /^[a-zA-Z_-]+:.*?##/ { printf "  \033[36m%-10s\033[0m %s\n", $$1, $$2 } /^##@/ { printf "\n\033[1m%s\033[0m\n", substr($$0, 5) } ' $(MAKEFILE_LIST)

.DEFAULT_GOAL := help
