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
REPOSITORY := https://github.com/rokoucha/dotfiles.git
EXCLUSION := .git/\* .gitignore docker-compose.yml Dockerfile installer.sh LICENSE Makefile README.md

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
REPOSITORY="$(REPOSITORY)"
endef
export DOTFILES_CONF

# Aliases
PACMAN_S := yay -S --noconfirm --needed
LN := /usr/bin/ln -sfv

# Task for Applications
asdf: git ## Asdf
	git clone https://github.com/asdf-vm/asdf.git "$(INSTALL_PATH)/.asdf"

dircolos: git ## dircolor
	curl -sL https://raw.githubusercontent.com/jtheoof/dotfiles/master/dircolors.monokai > "$(INSTALL_PATH)/.dircolors"

docker: ## Docker
	$(PACMAN_S) docker docker-compose
	sudo gpasswd -a $$(whoami) docker
	sudo systemctl enable docker.service
	@echo "===> Required reboot before using Docker"

git : ## Git
	$(PACMAN_S) git

vim: ## Vim
	$(PACMAN_S) vim

vundle: git ## Vundle
	@if type vim >/dev/null 2>&1; then \
		git clone https://github.com/VundleVim/Vundle.vim.git "$(INSTALL_PATH)/.vim/bundle/Vundle.vim"; \
		vim +PluginInstall +qall; \
	else \
		echo "===> command not found: vim"; \
		exit 1; \
	fi

yay: git ## Yay
	@if ! type yay >/dev/null 2>&1; then \
		$(eval YAY_TEMP := $(shell mktemp -d)) \
		git clone https://aur.archlinux.org/yay.git "$(YAY_TEMP)"; \
		sh -c "cd \"$(YAY_TEMP)\"; makepkg -sri --noconfirm"; \
		rm -rf "$(YAY_TEMP)"; \
	fi

zsh: ## Zsh
	$(PACMAN_S) fzf ghq powerline zsh

zplugin: git ## Zplugin
	git clone https://github.com/zdharma/zplugin.git "$(INSTALL_PATH)/.zplugin/bin"

zprezto: ## Prezto
	@$(LN) "$(INSTALL_PATH)/.zplugin/plugins/sorin-ionescu---prezto" "$(INSTALL_PATH)/.zprezto"

# Task targets
arch: yay docker vim zsh

cli: dircolos vundle zplugin zprezto asdf ## Fetch zsh applications

# Task for Setup
install: deploy cli execshell ## Setup cli envirpnment

install-arch-cli: deploy arch cli execshell ## Setup Arch cli environment

# Task for dotfiles
dotpath: ## Echo dotfile path
	@echo "$(DOTFILES_PATH)"

banner: ## Print banner
	@echo "$$BANNER"

list: banner ## Listing dotfiles
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

execshell: ## Reboot shell
	@echo "===> Successfully completed! Rebooting shell..."
	exec "$$SHELL"

debug: banner ## Debugging with Docker
	@echo "===> Debug dotfiles with Docker"
	@sh -c "cd \"$(MAKEFILE_DIR)\"; docker-compose build --pull; docker-compose run --rm dotfiles"

help: banner ## Help
	@exit 0

.PHONY: arch cli install install-arch-cli dotpath banner list update deploy execshell debug help

.DEFAULT_GOAL := help
