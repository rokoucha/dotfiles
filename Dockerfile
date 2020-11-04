FROM archlinux/archlinux:latest

ARG DOTFILES=.dotfiles
ARG USERNAME=rokoucha

# Mirrorlist
RUN curl -sL "https://www.archlinux.org/mirrorlist/?country=JP&ip_version=4&ip_version=6&use_mirror_status=on" > /etc/pacman.d/mirrorlist
RUN sed -i -e "s/#Server/Server/g" /etc/pacman.d/mirrorlist

# Update & Install
RUN pacman -Syu --noconfirm --needed \
    base \
    base-devel \
    git \
    zsh

# Timezone & Language
ENV LANG en_GB.UTF-8
ENV TZ Asia/Tokyo
RUN echo -e "en_GB.UTF-8 UTF-8\nen_US.UTF-8 UTF-8" > /etc/locale.gen
RUN echo "LANG=en_GB.UTF-8" > /etc/locale.conf
RUN ln -sf /usr/share/zoneinfo/Asia/Tokyo /etc/localtime
RUN locale-gen

# Fix sudo
# https://bugzilla.redhat.com/show_bug.cgi?id=1773148
RUN echo "Set disable_coredump false" > /etc/sudo.conf 

# User
ENV SHELL /usr/bin/fish
RUN echo "%wheel ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers
RUN useradd -G wheel -m -s /usr/bin/zsh ${USERNAME}
USER ${USERNAME}
WORKDIR /home/${USERNAME}

# Dotfiles
RUN bash -c "$(curl -sL https://dot.rokoucha.net)" -s setup-arch-cli

CMD [ "/usr/bin/fish", "--login" ]
