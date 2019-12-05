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
DOTFILES := $(shell printf " ! -path $(DOTFILES_PATH)/%s" $(EXCLUSION) | xargs find $(DOTFILES_PATH) -type f | sed 's|^$(DOTFILES_PATH)/||')

# Aliases
PACMAN_S := yay -S --noconfirm --needed

# Task for Applications
vim: ## Vim
	@$(PACMAN_S) vim

vundle: ## Vundle
	@mkdir -p $(INSTALL_PATH)/.vim/bundle/Vundle.vim
	git clone https://github.com/VundleVim/Vundle.vim.git $(INSTALL_PATH)/.vim/bundle/Vundle.vim
	vim +PluginInstall +qall

yay: ## Yay
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
	@ln -sf $(INSTALL_PATH)/.zplug/repos/sorin-ionescu/prezto $(INSTALL_PATH)/.zprezto

# Task for dotfiles
banner: ## Print banner
	@echo "$$BANNER"

list: ## dotfiles list
	@$(foreach dotfile, $(DOTFILES), /usr/bin/ls $(dotfile);)

update: ## Update dotfiles
	@git pull origin master

deploy: banner ## Deploy dotfiles
	@echo "> Deploy dotfiles to $(INSTALL_PATH)"
	@echo ""
	@$(foreach dotfile, $(DOTFILES), mkdir -p $(INSTALL_PATH)/$(dir $(dotfile)); /usr/bin/ln -sfv $(abspath $(dotfile)) $(INSTALL_PATH)/$(dotfile);)

cliinstall: deploy vim vundle zsh zplugin zprezto ## Install zsh applications
	@echo "> Successfully completed! Rebooting shell..."
	exec $$SHELL

setup: ## Setup computer
	exit 0

help: ## Help
	exit 0

.PHONY: banner update deploy cliinstall setup help

.DEFAULT_GOAL := help
