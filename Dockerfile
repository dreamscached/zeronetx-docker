FROM alpine:3.23 AS build
RUN apk add git && git clone --recursive https://github.com/ZeroNetX/ZeroNet.git /zeronet
RUN apk add python3 python3-dev py3-pip gcc g++ autoconf automake libtool \
            libffi-dev musl-dev make tor openssl

# the external tracker list is fetched over clearnet before the socks patch is applied,
# so it leaks the real ip and is fatal when the container has no route out -- make it non-fatal
RUN sed -i '/Error loading external trackers/{n;/^ *raise$/d}' /zeronet/src/Config.py \
 && ! grep -A1 'Error loading external trackers' /zeronet/src/Config.py | grep -q '^[[:space:]]*raise$'

ADD zeronet/constraints.txt /constraints.txt
RUN python3 -m venv /zeronet/venv && source /zeronet/venv/bin/activate \
 && python3 -m pip install -c /constraints.txt -r /zeronet/requirements.txt

FROM alpine:3.23
COPY --from=build /zeronet /zeronet
ADD zeronet/docker_entrypoint.sh /docker_entrypoint.sh
ADD tor/torrc /etc/tor/torrc

# curl is needed for healthchecks, socat for the ui port forwarder
RUN apk add --no-cache python3 py3-pip tor openssl curl socat
# zeronet.py writes ./log/error.log on unhandled exceptions
RUN mkdir -p /zeronet/log

ENV HOME=/zeronet
VOLUME /data
EXPOSE 43110 26117

WORKDIR /zeronet
ENTRYPOINT ["/docker_entrypoint.sh"]
