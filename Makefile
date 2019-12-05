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
	@git clone https://github.com/VundleVim/Vundle.vim.git $(INSTALL_PATH)/.vim/bundle/Vundle.vim
	@vim +PluginInstall +qall

yay: ## Yay
	@$(eval YAY_TEMP := $(shell mktemp -d))
	@git clone https://aur.archlinux.org/yay.git $(YAY_TEMP)
	@sh -c "cd $(YAY_TEMP); makepkg -sri --noconfirm"
	@rm -rf $(YAY_TEMP)

zsh: ## Zsh
	@$(PACMAN_S) fzf ghq powerline zsh

zplug: ## Zplug
	-@curl -sL --proto-redir -all,https https://raw.githubusercontent.com/zplug/installer/master/installer.zsh | ZPLUG_HOME=$(INSTALL_PATH)/.zplug zsh

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

zshinstall: ## Install zsh applications
	exit 0

setup: ## Setup computer
	exit 0

help: ## Help
	exit 0

.PHONY: banner update deploy zshinstall setup help

.DEFAULT_GOAL := help
