# torproxy

This conainer will start one [tor client][tor] and expose it on `9050/tcp`. To
do this there is [polipo][] running as *tcp to socks bridge*.

# Usage

    $ docker run --rm -p 9050:9050 -t michaelcontento/torproxy
    $ echo "real ip: $(curl -s echoip.com)"
    $ echo "tor  ip: $(curl -s --proxy localhost:9050 echoip.com)"

[tor]: https://www.torproject.org/
[polipo]: http://www.pps.univ-paris-diderot.fr/~jch/software/polipo/
