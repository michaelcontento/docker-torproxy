FROM ubuntu:trusty

RUN DEBIAN_FRONTEND=noninteractive \
	&& echo 'deb http://deb.torproject.org/torproject.org trusty main' >> /etc/apt/sources.list.d/torproject.list \
 	&& gpg --keyserver keys.gnupg.net --recv 886DDD89 \
 	&& gpg --export A3C4F0F979CAA22CDBA8F512EE8CBC9E886DDD89 | apt-key add - \
 	&& apt-get update \
 	&& apt-get install -y deb.torproject.org-keyring \
 	&& apt-get install -y tor \
 	&& service tor stop \
 	&& update-rc.d -f tor remove \
 	&& rm -rf /var/lib/apt/lists/*

RUN DEBIAN_FRONTEND=noninteractive \
	&& apt-get update \
	&& apt-get install -y polipo \
	&& service polipo stop \
	&& update-rc.d -f polipo remove \
	&& rm -rf /var/lib/apt/lists/*

ADD torproxy.bash /usr/local/bin/torproxy

EXPOSE 9050

CMD ["bash", "/usr/local/bin/torproxy"]
