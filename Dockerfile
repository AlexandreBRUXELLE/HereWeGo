FROM ubuntu
MAINTAINER AlexandreBRUXELLE <alexandre.bruxelle@zenika.com>
RUN apt-get update
RUN apt-get -y install software-properties-common dbus-x11
RUN apt-get install -y xorg xauth wget 
RUN apt-get install -y xfonts-100dpi xfonts-75dpi xfonts-scalable xfonts-cyrillic xvfb 
RUN apt-get -y install curl git gcc gdb make bison binutils build-essential mercurial libsdl-ttf2.0-dev  libsdl1.2-dev libsdl-mixer1.2-dev libsdl-image1.2-dev
RUN apt-get -y install qt5-default libqt5webkit5-dev libqtcore4 libQtGui4 
RUN export uid=1000 gid=1000 && \
    mkdir -p /home/developer && \
    echo "developer:x:${uid}:${gid}:Developer,,,:/home/developer:/bin/bash" >> /etc/passwd && \
    echo "developer:x:${uid}:" >> /etc/group && \
    echo "developer ALL=(ALL) NOPASSWD: ALL" > /etc/sudoers.d/developer && \
    chmod 0440 /etc/sudoers.d/developer && \
    chown ${uid}:${gid} -R /home/developer
USER developer
ENV HOME /home/developer
WORKDIR /home/developer
RUN wget -q https://raw.githubusercontent.com/moovweb/gvm/master/binscripts/gvm-installer -O /tmp/gvm-installer
RUN bash /tmp/gvm-installer
RUN sudo rm /bin/sh && sudo ln -s /bin/bash /bin/sh
RUN source /home/developer/.gvm/scripts/gvm ; gvm version ; gvm install go1.4.1 ; gvm use go1.4.1 ; go get -u github.com/nsf/gocode; hg clone http://code.google.com/p/liteide/ ; export QTDIR=/home/developer/QtSDK/Desktop/Qt/474/gcc; cd liteide/build/ ; sed -i.bak s:"\$QTDIR/lib/libQt":"/usr/lib/x86_64-linux-gnu/libQt":g ./build_linux.sh ;  ./build_linux.sh ;
RUN echo "source ~/.gvm/scripts/gvm ; gvm use go1.4.1;" >> /home/developer/.bashrc ; echo "alias liteide=/home/developer/liteide/build/liteide/bin/liteide" >> /home/developer/.bashrc ; echo "export DISPLAY=:0" >> /home/developer/.bashrc;
#RUN export DISPLAY=:0; source ~/.gvm/scripts/gvm ; gvm use go1.4.1; /home/developer/liteide/build/liteide/bin/liteide
CMD ["/bin/bash"]




