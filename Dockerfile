FROM fedora:latest

RUN sed -i "/tsflags=nodocs/d" /etc/dnf/dnf.conf  #get docs with pkgs
RUN dnf install -y openssh-server openssh-clients sudo git tmux man man-pages docker zsh
RUN ssh-keygen -A
RUN useradd -s /bin/zsh dev
RUN usermod -aG wheel dev
RUN echo "dev:password" | chpasswd

#neovim https://bugzilla.redhat.com/show_bug.cgi?id=1983288
RUN dnf -y install ninja-build libtool autoconf automake cmake gcc gcc-c++ make pkgconfig unzip patch gettext curl
RUN git clone https://github.com/neovim/neovim /home/dev/neovim
WORKDIR /home/dev/neovim
RUN git checkout stable
RUN CMAKE_BUILD_TYPE=Release make -j8
RUN make install
RUN chown dev:dev -R /home/dev/neovim

EXPOSE 22
CMD ["/usr/sbin/sshd","-D"]
