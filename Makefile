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
EXCLUSION := .git/\* docker-compose.yml Dockerfile LICENSE Makefile README.md .gitignore Brewfile
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
LN := /usr/bin/env ln -sfv

##@ Application tasks
asdf: ## Install asdf-vm
	git clone https://github.com/asdf-vm/asdf.git "$(INSTALL_PATH)/.asdf"

dircolors: ## Install Monokai theme for dircolors
	curl -sL "https://raw.githubusercontent.com/jtheoof/dotfiles/master/dircolors.monokai" > "$(INSTALL_PATH)/.dircolors"

tpm: ## Intstall Tmux Plugin Manager 
	@if [ ! -d $(INSTALL_PATH)/.tmux/plugins/tpm ]; then \
		mkdir -p "$(INSTALL_PATH)/.tmux/plugins"; \
		git clone "https://github.com/tmux-plugins/tpm" "$(INSTALL_PATH)/.tmux/plugins/tpm"; \
	fi

vundle: ## Install Vundle
	@if type vim >/dev/null 2>&1; then \
		git clone https://github.com/VundleVim/Vundle.vim.git "$(INSTALL_PATH)/.vim/bundle/Vundle.vim"; \
		vim +PluginInstall +qall; \
	else \
		echo "===> command not found: vim"; \
		exit 1; \
	fi

##@ Install group tasks
.PHONY: install

install: deploy asdf dircolors vundle tpm execshell ## Setup CLI envirpnment

##@ Management tasks
.PHONY: dotpath banner list update deploy upgrade clean clean-broken-link execshell debug help

dotpath: ## Print dotfiles path
	@echo "$(DOTFILES_PATH)"

banner: ## Print a banner
	@echo "$$BANNER"

list: banner ## Print a list of dotfiles
	$(INFO) "Listing dotfiles in $(DOTFILES_PATH)"
	@$(foreach dotfile,$(DOTFILES),/usr/bin/env ls -F "$(dotfile)";)

update: banner ## Update dotfiles
	$(INFO) "Update dotfiles"
	@git pull origin master

deploy: banner ## Deploy dotfiles
	$(INFO) "Deploy dotfiles to $(INSTALL_PATH)"
	@$(foreach dotfile,$(DOTFILES),mkdir -p "$(INSTALL_PATH)/$(dir $(dotfile))"; $(LN) "$(abspath $(dotfile))" "$(INSTALL_PATH)/$(dotfile)";)
	$(INFO) "Dotfiles has been successfully deployed!"
	@mkdir -p "$(dir $(DOTFILES_CONF_PATH))"
	@echo "$$DOTFILES_CONF" > "$(DOTFILES_CONF_PATH)"

upgrade: clean update deploy ## Update and deploy dotfiles

clean: banner ## Clean dotfiles in INSTALL_PATH
	$(INFO) "Clean dotfiles in $(INSTALL_PATH)"
	@$(foreach dotfile,$(DOTFILES), \
		if [ -L "$(INSTALL_PATH)/$(dotfile)" ]; then \
			rm -fv "$(INSTALL_PATH)/$(dotfile)"; \
		else \
			echo "===> $(INSTALL_PATH)/$(dotfile) is not managed by dotfiles and will not be deleted!"; \
		fi;)
	$(INFO) "Dotfiles has been successfully cleaned!"

clean-broken-link: ## Cleaning broken links in INSTALL_PATH
	$(INFO) "Cleaning broken links in $(INSTALL_PATH)"
	@find -L $(INSTALL_PATH)/.config -type l
	@find -L $(INSTALL_PATH)/.config -type l -exec rm {} +

execshell: ## Reboot shell
	$(INFO) "Successfully completed! Rebooting shell..."
	exec "$$SHELL"

debug: banner ## Debug with Docker
	$(INFO) "Debug dotfiles with Docker"
	@sh -c "cd \"$(MAKEFILE_DIR)\"; docker-compose build --pull; docker-compose run --rm dotfiles"

# Forked from https://gist.github.com/prwhite/8168133#gistcomment-2833138
help: banner ## Help
	@awk 'BEGIN {FS = ":.*##"} /^[0-9a-zA-Z_-]+:.*?##/ { printf "  \033[36m%-17s\033[0m %s\n", $$1, $$2 } /^##@/ { printf "\n\033[1m%s\033[0m\n", substr($$0, 5) } ' $(MAKEFILE_LIST)

.DEFAULT_GOAL := install
