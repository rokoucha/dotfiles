FROM archlinux/base:latest

ARG USERNAME=rokoucha

# Mirrorlist
RUN curl -sL "https://www.archlinux.org/mirrorlist/?country=JP&protocol=https&ip_version=4&ip_version=6&use_mirror_status=on" > /etc/pacman.d/mirrorlist
RUN sed -i -e "s/#Server/Server/g" /etc/pacman.d/mirrorlist

# Update
RUN pacman -Syu --noconfirm

# Timezone & Language
ENV TZ Asia/Tokyo
ENV LANG en_GB.UTF-8
RUN ln -sf /usr/share/zoneinfo/Asia/Tokyo /etc/localtime
RUN echo "en_GB.UTF-8 UTF-8" > /etc/locale.gen
RUN locale-gen
RUN echo "LANG=en_GB.UTF-8"

# User
RUN useradd -G wheel -m -s /bin/zsh ${USERNAME}
RUN echo "%wheel ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers

# Dotfiles
ADD . /home/${USERNAME}/dotfiles
RUN chown -R ${USERNAME}:${USERNAME} /home/${USERNAME}/dotfiles

USER ${USERNAME}
WORKDIR /home/${USERNAME}

CMD [ "/bin/bash", "--login" ]
