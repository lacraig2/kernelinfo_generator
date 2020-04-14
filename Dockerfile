FROM amd64/ubuntu:18.04

# add dbgsym packages
RUN apt-key adv --keyserver keyserver.ubuntu.com --recv-keys C8CAB6595FDFF622
RUN echo "deb http://ddebs.ubuntu.com $(lsb_release -cs) main restricted universe multiverse\ndeb http://ddebs.ubuntu.com $(lsb_release -cs)-updates main restricted universe multiverse\ndeb http://ddebs.ubuntu.com $(lsb_release -cs)-proposed main restricted universe multiverse\n" | tee -a /etc/apt/sources.list.d/ddebs.list
RUN apt-get update
RUN apt-get -y install git gdb ubuntu-dbgsym-keyring gnupg lsb-core python3 python-apt python3-apt python3-pip

# install script
RUN mkdir /workspace
WORKDIR /workspace
RUN git clone https://github.com/panda-re/panda.git
RUN ls ./panda/panda/plugins/osi_linux/utils/kernelinfo_gdb/
RUN cp ./panda/panda/plugins/osi_linux/utils/kernelinfo_gdb/extract_kernelinfo.py  ./extract_kernelinfo.py
RUN cp ./panda/panda/plugins/osi_linux/utils/kernelinfo_gdb/run.sh .

# set up python and downloader
RUN python3 -m pip install requests
COPY ./downloader.py ./
