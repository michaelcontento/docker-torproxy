FROM debian:wheezy

RUN export DEBIAN_FRONTEND=noninteractive \
    && echo 'force-unsafe-io' > /etc/dpkg/dpkg.cfg.d/02apt-speedup \
    && echo 'deb http://deb.torproject.org/torproject.org wheezy main' >> /etc/apt/sources.list.d/torproject.list \
    && gpg --keyserver keys.gnupg.net --recv 886DDD89 2>/dev/null \
    && gpg --export A3C4F0F979CAA22CDBA8F512EE8CBC9E886DDD89 | apt-key add - \
    && apt-get update \
    && apt-get install --yes --no-install-recommends deb.torproject.org-keyring \
    && apt-get install --yes --no-install-recommends tor \
    && service tor stop \
    && update-rc.d -f tor remove \
    && rm -rf /var/lib/apt/lists/*

RUN export DEBIAN_FRONTEND=noninteractive \
    && echo 'force-unsafe-io' > /etc/dpkg/dpkg.cfg.d/02apt-speedup \
    && apt-get update \
    && apt-get install --yes --no-install-recommends polipo \
    && service polipo stop \
    && update-rc.d -f polipo remove \
    && rm -rf /var/lib/apt/lists/*

ADD torproxy.bash /usr/local/bin/torproxy

EXPOSE 9050

CMD ["/usr/local/bin/torproxy"]
