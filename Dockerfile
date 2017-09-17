FROM ubuntu:latest
LABEL maintainer="eshizhan <eshizhan@126.com>"

# RUN sed -i 's/archive.ubuntu.com/cn.archive.ubuntu.com/g' /etc/apt/sources.list
RUN apt-get update -y && \
    apt-get -y install openssh-server \
                       vim-tiny \
                       iproute2 \
                       iputils-ping \
                       curl \
                       netcat-openbsd \
                       openjdk-8-jdk \
                       python3 \
                       python3-pip \
                       python3-setuptools \
                       python3-wheel \
                       --no-install-recommends && \
    apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

RUN ln -s /usr/bin/python3 /usr/local/bin/python \
    && ln -s /usr/bin/pip3 /usr/local/bin/pip \
    && ln -s /usr/bin/pydoc3 /usr/local/bin/pydoc

RUN echo 'root:root' | chpasswd

RUN mkdir -p /var/run/sshd && \
    sed -i 's/^PermitRootLogin.*/PermitRootLogin yes/g' /etc/ssh/sshd_config && \
    sed -i 's/UsePAM yes/UsePAM no/g' /etc/ssh/sshd_config

RUN mkdir -p /opt/spark && \
    curl https://d3kbcqa49mib13.cloudfront.net/spark-2.2.0-bin-hadoop2.7.tgz | tar -zx -C /opt/spark --strip-components=1

VOLUME ["/opt/spark/conf"]

EXPOSE 22

WORKDIR /opt/spark

CMD ["/usr/sbin/sshd", "-D"]

