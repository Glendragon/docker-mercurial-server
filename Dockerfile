FROM	ubuntu:16.04
ENV	DEBIAN_FRONTEND noninteractive
MAINTAINER glinders

# install sshd and mercurial-server
# clean up apt lists (apt-get clean is done automatically)
# remove root keys (we'll make our own)
# create the /var/run entry foor sshd
RUN apt-get update -qq && apt-get install -y \
    mercurial-server \
    openssh-server \
    && rm -rf /var/lib/apt/lists/* && \
    rm -v /etc/ssh/ssh_host_* && \
    mkdir -v -m 0700 /var/run/sshd && \
    chown -R hg: /etc/mercurial-server

# settings for mercurial-server
VOLUME	["/var/lib/mercurial-server/repos","/etc/mercurial-server"]
EXPOSE	8022
WORKDIR	/var/lib/mercurial-server/

COPY	start-mercurial-server.sh /start-mercurial-server.sh
COPY    create_keys.sh /create_keys.sh
CMD	["/start-mercurial-server.sh"]

# run mercurial-server as normal user
USER	hg
