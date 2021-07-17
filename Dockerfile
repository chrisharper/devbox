FROM fedora:latest

RUN sed -i "/tsflags=nodocs/d" /etc/dnf/dnf.conf  #get docs with pkgs
RUN dnf install -y openssh-server openssh-clients sudo git tmux man man-pages docker
RUN ssh-keygen -A
RUN useradd dev
RUN usermod -aG wheel dev
RUN echo "dev:password" | chpasswd
EXPOSE 22
CMD ["/usr/sbin/sshd","-D"]
