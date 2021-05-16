ARG BUILD_ARCH

FROM golang:1.16 AS builder

# it's necessary to build as i386:linux because we run on i386 linux docker
# however, it's unclear if CGO_ENABLED=0 is necessary.
# we don't build two versions because it's just not necessary
RUN CGO_ENABLED=0 GOOS=linux GOARCH=386 go get github.com/volatilityfoundation/dwarf2json

FROM $BUILD_ARCH/ubuntu:18.04 as main
COPY --from=builder /go/bin/linux_386/dwarf2json /
RUN chmod +x /dwarf2json

# add dbgsym packages
RUN apt-get --fix-missing -y update
RUN DEBIAN_FRONTEND="noninteractive" apt-get -y install tzdata
RUN apt-get -y install git gdb ubuntu-dbgsym-keyring gnupg  python3 python-apt python3-apt python3-pip parallel software-properties-common lsb-core
RUN  apt-key adv --keyserver keyserver.ubuntu.com --recv-keys F2EDC64DC5AEE1F6B9C621F0C8CAB6595FDFF622

RUN echo "deb http://ddebs.ubuntu.com bionic main restricted universe multiverse\ndeb http://ddebs.ubuntu.com bionic-updates main restricted universe multiverse\ndeb http://ddebs.ubuntu.com bionic-proposed main restricted universe multiverse\n" | tee -a /etc/apt/sources.list.d/ddebs.list
RUN echo "deb http://ddebs.ubuntu.com focal main restricted universe multiverse\ndeb http://ddebs.ubuntu.com focal-updates main restricted universe multiverse\ndeb http://ddebs.ubuntu.com focal-proposed main restricted universe multiverse\n" | tee -a /etc/apt/sources.list.d/ddebs.list
RUN echo "deb http://ddebs.ubuntu.com groovy main restricted universe multiverse\ndeb http://ddebs.ubuntu.com groovy-updates main restricted universe multiverse\ndeb http://ddebs.ubuntu.com groovy-proposed main restricted universe multiverse\n" | tee -a /etc/apt/sources.list.d/ddebs.list
RUN echo "deb http://ddebs.ubuntu.com hirsute main restricted universe multiverse\ndeb http://ddebs.ubuntu.com hirsute-updates main restricted universe multiverse\ndeb http://ddebs.ubuntu.com hirsute-proposed main restricted universe multiverse\n" | tee -a /etc/apt/sources.list.d/ddebs.list
RUN echo "deb http://ddebs.ubuntu.com impish main restricted universe multiverse\ndeb http://ddebs.ubuntu.com impish-updates main restricted universe multiverse\ndeb http://ddebs.ubuntu.com impish-proposed main restricted universe multiverse\n" | tee -a /etc/apt/sources.list.d/ddebs.list
RUN echo "deb http://ddebs.ubuntu.com precise main restricted universe multiverse\ndeb http://ddebs.ubuntu.com precise-updates main restricted universe multiverse\ndeb http://ddebs.ubuntu.com precise-proposed main restricted universe multiverse\n" | tee -a /etc/apt/sources.list.d/ddebs.list
RUN echo "deb http://ddebs.ubuntu.com trusty main restricted universe multiverse\ndeb http://ddebs.ubuntu.com trusty-updates main restricted universe multiverse\ndeb http://ddebs.ubuntu.com trusty-proposed main restricted universe multiverse\n" | tee -a /etc/apt/sources.list.d/ddebs.list
RUN echo "deb http://ddebs.ubuntu.com xenial main restricted universe multiverse\ndeb http://ddebs.ubuntu.com xenial-updates main restricted universe multiverse\ndeb http://ddebs.ubuntu.com xenial-proposed main restricted universe multiverse\n" | tee -a /etc/apt/sources.list.d/ddebs.list


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
COPY ./run_downloads.sh ./
COPY ./cache_reader.py ./
