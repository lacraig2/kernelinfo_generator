FROM amd64/ubuntu:18.04


# add dbgsym packages
RUN apt-get update
RUN DEBIAN_FRONTEND="noninteractive" apt-get -y install tzdata
#RUN  dpkg --add-architecture i386
RUN apt-get -y install git gdb ubuntu-dbgsym-keyring gnupg lsb-core python3 python-apt python3-apt python3-pip software-properties-common parallel
RUN apt-key adv --keyserver keyserver.ubuntu.com --recv-keys C8CAB6595FDFF622
#RUN echo "deb http://ddebs.ubuntu.com $(lsb_release -cs) main restricted universe multiverse\ndeb http://ddebs.ubuntu.com $(lsb_release -cs)-updates main restricted universe multiverse\ndeb http://ddebs.ubuntu.com $(lsb_release -cs)-proposed main restricted universe multiverse\n" | tee -a /etc/apt/sources.list.d/ddebs.list

RUN echo "deb http://ddebs.ubuntu.com precise main restricted universe multiverse\ndeb http://ddebs.ubuntu.com precise-updates main restricted universe multiverse\ndeb http://ddebs.ubuntu.com precise-proposed main restricted universe multiverse\n" | tee -a /etc/apt/sources.list.d/ddebs.list
RUN echo "deb http://ddebs.ubuntu.com trusty main restricted universe multiverse\ndeb http://ddebs.ubuntu.com trusty-updates main restricted universe multiverse\ndeb http://ddebs.ubuntu.com trusty-proposed main restricted universe multiverse\n" | tee -a /etc/apt/sources.list.d/ddebs.list
RUN echo "deb http://ddebs.ubuntu.com xenial main restricted universe multiverse\ndeb http://ddebs.ubuntu.com xenial-updates main restricted universe multiverse\ndeb http://ddebs.ubuntu.com xenial-proposed main restricted universe multiverse\n" | tee -a /etc/apt/sources.list.d/ddebs.list
RUN echo "deb http://ddebs.ubuntu.com bionic main restricted universe multiverse\ndeb http://ddebs.ubuntu.com bionic-updates main restricted universe multiverse\ndeb http://ddebs.ubuntu.com bionic-proposed main restricted universe multiverse\n" | tee -a /etc/apt/sources.list.d/ddebs.list
RUN echo "deb http://ddebs.ubuntu.com cosmic main restricted universe multiverse\ndeb http://ddebs.ubuntu.com cosmic-updates main restricted universe multiverse\ndeb http://ddebs.ubuntu.com cosmic-proposed main restricted universe multiverse\n" | tee -a /etc/apt/sources.list.d/ddebs.list
RUN echo "deb http://ddebs.ubuntu.com disco main restricted universe multiverse\ndeb http://ddebs.ubuntu.com disco-updates main restricted universe multiverse\ndeb http://ddebs.ubuntu.com disco-proposed main restricted universe multiverse\n" | tee -a /etc/apt/sources.list.d/ddebs.list
RUN echo "deb http://ddebs.ubuntu.com eoan main restricted universe multiverse\ndeb http://ddebs.ubuntu.com eoan-updates main restricted universe multiverse\ndeb http://ddebs.ubuntu.com eoan-proposed main restricted universe multiverse\n" | tee -a /etc/apt/sources.list.d/ddebs.list
RUN echo "deb http://ddebs.ubuntu.com focal main restricted universe multiverse\ndeb http://ddebs.ubuntu.com focal-updates main restricted universe multiverse\ndeb http://ddebs.ubuntu.com focal-proposed main restricted universe multiverse\n" | tee -a /etc/apt/sources.list.d/ddebs.list
RUN add-apt-repository ppa:longsleep/golang-backports
RUN apt-get -o Acquire::Check-Valid-Until=false update

# Set environment variables.
RUN apt install -y golang-go
RUN go get github.com/volatilityfoundation/dwarf2json
WORKDIR /root/go/src/github.com/volatilityfoundation/dwarf2json
RUN go run main.go
RUN go build

# install script
RUN mkdir /workspace
WORKDIR /workspace
RUN git clone -b osi_time https://github.com/panda-re/panda.git
RUN ls ./panda/panda/plugins/osi_linux/utils/kernelinfo_gdb/
RUN cp ./panda/panda/plugins/osi_linux/utils/kernelinfo_gdb/extract_kernelinfo.py  ./extract_kernelinfo.py
RUN cp ./panda/panda/plugins/osi_linux/utils/kernelinfo_gdb/run.sh .

# set up python and downloader
RUN python3 -m pip install requests
COPY ./downloader.py ./
COPY ./cache_reader.py ./
COPY ./run_downloads.sh ./
