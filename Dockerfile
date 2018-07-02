FROM ubuntu:16.04
LABEL maintainer="eshizhan <eshizhan@126.com>"

ENV LANG C.UTF-8
ENV TERM linux

# RUN sed -i 's/archive.ubuntu.com/cn.archive.ubuntu.com/g' /etc/apt/sources.list
RUN echo 'deb http://ppa.launchpad.net/jonathonf/python-3.6/ubuntu xenial main' >> /etc/apt/sources.list && \
    apt-key adv --keyserver keyserver.ubuntu.com --recv-keys F06FC659

RUN apt-get update -y && \
    apt-get -y install openssh-server \
                       vim-tiny \
                       iproute2 \
                       iputils-ping \
                       curl \
                       netcat-openbsd \
                       openjdk-8-jre-headless \
                       python3.6 \
                       --no-install-recommends && \
    apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

RUN ln -s /usr/bin/python3.6 /usr/bin/python3 && \
    ln -s /usr/bin/python3 /usr/bin/python && \
    ln -s /usr/bin/pydoc3.6 /usr/bin/pydoc3 && \
    ln -s /usr/bin/pydoc3 /usr/bin/pydoc

RUN curl -sL -o get-pip.py 'https://bootstrap.pypa.io/get-pip.py' && \
    python get-pip.py --no-cache-dir

RUN curl -sL -o /usr/local/bin/dumb-init https://github.com/Yelp/dumb-init/releases/download/v1.2.0/dumb-init_1.2.0_amd64 && \
    chmod +x /usr/local/bin/dumb-init

# RUN echo 'root:root' | chpasswd

RUN mkdir -p /var/run/sshd && \
    sed -i 's/^PermitRootLogin.*/PermitRootLogin yes/g' /etc/ssh/sshd_config && \
    sed -i 's/UsePAM yes/UsePAM no/g' /etc/ssh/sshd_config

RUN mkdir -p /opt/spark && \
    curl http://mirrors.ocf.berkeley.edu/apache/spark/spark-2.3.1/spark-2.3.1-bin-hadoop2.7.tgz | tar -zx -C /opt/spark --strip-components=1

VOLUME ["/opt/spark/conf"]

EXPOSE 22

WORKDIR /opt/spark

ENTRYPOINT ["/usr/local/bin/dumb-init", "--"]

CMD ["/usr/sbin/sshd", "-D"]
