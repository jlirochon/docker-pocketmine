FROM ubuntu-debootstrap:14.04

RUN apt-get -yqq update && \
    apt-get -yqq install git wget net-tools && \
    useradd pocketmine && \
    mkdir -p /pocketmine /pocketmine/data && \

    # install PocketMine-MP
    cd /pocketmine && \
    git clone https://github.com/PocketMine/PocketMine-MP.git && \
    cd PocketMine-MP && git checkout -t origin/mcpe-0.13 && \
    git submodule update --init --recursive && \
    find . -name ".git" | xargs rm -rf && \

    # install php
    cd /pocketmine/PocketMine-MP && \
    wget -q https://bintray.com/artifact/download/pocketmine/PocketMine/PHP_5.6.10_x86-64_Linux.tar.gz && \
    tar xvzf PHP_5.6.10_x86-64_Linux.tar.gz && \
    rm -f PHP_5.6.10_x86-64_Linux.tar.gz && \

    # change owner
    chown -R pocketmine:pocketmine /pocketmine && \

    # clean
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

USER pocketmine
WORKDIR /pocketmine/PocketMine-MP
EXPOSE 19132
CMD ["./start.sh", "--data", "/pocketmine/data"]
