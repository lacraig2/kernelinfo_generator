FROM amd64/ubuntu:18.04
RUN apt-get update

RUN apt-get -y install git gdb ubuntu-dbgsym-keyring gnupg lsb-core python3

# add dbgsym packages
RUN apt-key adv --keyserver keyserver.ubuntu.com --recv-keys C8CAB6595FDFF622
RUN echo "deb http://ddebs.ubuntu.com $(lsb_release -cs) main restricted universe multiverse\ndeb http://ddebs.ubuntu.com $(lsb_release -cs)-updates main restricted universe multiverse\ndeb http://ddebs.ubuntu.com $(lsb_release -cs)-proposed main restricted universe multiverse\n" | tee -a /etc/apt/sources.list.d/ddebs.list
RUN apt-get update

# install script
RUN mkdir /workspace
WORKDIR /workspace
RUN git clone https://github.com/panda-re/panda.git
RUN ls ./panda/panda/plugins/osi_linux/utils/kernelinfo_gdb/
RUN cp ./panda/panda/plugins/osi_linux/utils/kernelinfo_gdb/extract_kernelinfo.py  ./extract_kernelinfo.py
RUN cp ./panda/panda/plugins/osi_linux/utils/kernelinfo_gdb/run.sh .

#RUN mkdir /workspace/downloads
#WORKDIR /workspace/downloads
#RUN apt-get -y install --download-only linux-image-$(uname -r)-dbgsym
#RUN apt-cache search linux-image-$(uname -r)-dgbsym
#RUN mv /var/cache/apt/archives/linux-image-unsigned-* .
#RUN ar x linux-image-*
#RUN tar -xvf data.tar.xz
#WORKDIR /workspace
#RUN cp `find . -name "vmlinux*"` .
#RUN ./run.sh vmlinux* ./out.lol
#RUN cat ./out.lol
#RUN apt-cache search linux-image-*
#RUN uname -r
COPY ./downloader.py ./
