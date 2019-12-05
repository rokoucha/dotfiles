FROM archlinux/base:latest

ARG USERNAME=rokoucha
ARG DOTFILES=.dotfiles

# Pacman
RUN sed -i "/\[multilib\]/,/Include/"'s/^#//' /etc/pacman.conf
RUN sed -i -e 's/^CFLAGS=.*/CFLAGS="-march=native -O2 -pipe -fstack-protector-strong"/g' /etc/makepkg.conf
RUN sed -i -e 's/^CXXFLAGS=.*/CXXFLAGS="${CFLAGS}"/g' /etc/makepkg.conf
RUN sed -i -e 's/^#MAKEFLAGS=.*/MAKEFLAGS="-j\$(nproc)"/g' /etc/makepkg.conf
RUN sed -i -e "s/^PKGEXT=.*$/PKGEXT='.pkg.tar'/g" /etc/makepkg.conf

# Mirrorlist
RUN curl -sL "https://www.archlinux.org/mirrorlist/?country=JP&protocol=https&ip_version=4&ip_version=6&use_mirror_status=on" > /etc/pacman.d/mirrorlist
RUN sed -i -e "s/#Server/Server/g" /etc/pacman.d/mirrorlist

# Update & Install
RUN pacman -Syu --noconfirm --needed \
    base \
    base-devel \
    git \
    zsh

# Timezone & Language
ENV TZ Asia/Tokyo
ENV LANG en_GB.UTF-8
RUN ln -sf /usr/share/zoneinfo/Asia/Tokyo /etc/localtime
RUN echo "en_GB.UTF-8 UTF-8" > /etc/locale.gen
RUN locale-gen
RUN echo "LANG=en_GB.UTF-8" > /etc/locale.conf

# User
RUN useradd -G wheel -m -s /usr/bin/zsh ${USERNAME}
RUN echo "%wheel ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers

# Yay
# Fix sudo https://bugzilla.redhat.com/show_bug.cgi?id=1773148
RUN echo "Set disable_coredump false" > /etc/sudo.conf 
RUN git clone https://aur.archlinux.org/yay.git /yay-build
RUN chown -R ${USERNAME}:${USERNAME} /yay-build
RUN sudo -i -u ${USERNAME} sh -c "cd /yay-build; makepkg -sri --noconfirm"
RUN rm -rf /yay-build

# Dotfiles
ADD . /home/${USERNAME}/${DOTFILES}
RUN chown -R ${USERNAME}:${USERNAME} /home/${USERNAME}/${DOTFILES}

USER ${USERNAME}
WORKDIR /home/${USERNAME}

CMD [ "/usr/bin/zsh", "--login" ]
