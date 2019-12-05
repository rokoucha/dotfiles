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
INSTALL_PATH := $(HOME)
DOTFILES_PATH := $(HOME)/.dotfiles
REPOSITORY := https://github.com/rokoucha/dotfiles.git
EXCLUSION := .git/\* dotroot/\* docker-compose.yml Dockerfile installer.sh LICENSE Makefile README.md

# System variable
DOTFILES := $(shell printf " ! -path $(DOTFILES_PATH)/%s" $(EXCLUSION) | xargs find $(DOTFILES_PATH) -type f | sed 's|^$(DOTFILES_PATH)/||')
MAKEFILE_DIR := $(dir $(lastword $(MAKEFILE_LIST)))

# Aliases
PACMAN_S := yay -S --noconfirm --needed

# Task for Applications
asdf: ## Asdf
	git clone https://github.com/asdf-vm/asdf.git $(INSTALL_PATH)/.asdf

docker: ## Docker
	@$(PACMAN_S) docker docker-compose
	@gpasswd -a $(USER) docker
	@sudo systemctl enable docker.service

vim: ## Vim
	@$(PACMAN_S) vim

vundle: ## Vundle
	@mkdir -p $(INSTALL_PATH)/.vim/bundle/Vundle.vim
	git clone https://github.com/VundleVim/Vundle.vim.git $(INSTALL_PATH)/.vim/bundle/Vundle.vim
	vim +PluginInstall +qall

yay: ## Yay
	@if type yay >/dev/null 2>&1; then exit 0; fi
	@$(eval YAY_TEMP := $(shell mktemp -d))
	@git clone https://aur.archlinux.org/yay.git $(YAY_TEMP)
	@sh -c "cd $(YAY_TEMP); makepkg -sri --noconfirm"
	@rm -rf $(YAY_TEMP)

zsh: ## Zsh
	@$(PACMAN_S) fzf ghq powerline zsh

zplugin: ## Zplugin
	@mkdir ~/.zplugin
	git clone https://github.com/zdharma/zplugin.git ~/.zplugin/bin

zprezto: ## Prezto
	@ln -sf $(INSTALL_PATH)/.zplugin/plugins/sorin-ionescu---prezto $(INSTALL_PATH)/.zprezto

# Task for dotfiles
banner: ## Print banner
	@echo "$$BANNER"

list: ## dotfiles list
	@$(foreach dotfile, $(DOTFILES), /usr/bin/ls $(dotfile);)

update: ## Update dotfiles
	@echo "===> Update dotfiles"
	@echo ""
	@git pull origin master

deploy: banner ## Deploy dotfiles
	@echo "===> Deploy dotfiles to $(INSTALL_PATH)"
	@echo ""
	@$(foreach dotfile, $(DOTFILES), mkdir -p $(INSTALL_PATH)/$(dir $(dotfile)); /usr/bin/ln -sfv $(abspath $(dotfile)) $(INSTALL_PATH)/$(dotfile);)

cli: vundle zplugin zprezto asdf ## Fetch zsh applications

cliinstall: deploy cli execshell ## Setup zsh applications

archcliinstall: deploy yay docker vim zsh cli execshell ## Setup Arch applications

setup: ## Setup computer
	exit 0

execshell: ## Reboot shell
	@echo "===> Successfully completed! Rebooting shell..."
	@echo ""
	exec $$SHELL

debug: ## Debugging with Docker
	@sh -c "cd $(MAKEFILE_DIR); docker-compose build --pull; docker-compose run --rm dotfiles"

help: ## Help
	exit 0

.PHONY: banner list update deploy cli cliinstall archcliinstall setup execshell help

.DEFAULT_GOAL := help
