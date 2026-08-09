FROM alpine:3.23 AS build
RUN apk add git && git clone --recursive https://github.com/ZeroNetX/ZeroNet.git /zeronet
RUN apk add python3 python3-dev py3-pip gcc g++ autoconf automake libtool \
            libffi-dev musl-dev make tor openssl
ADD zeronet/constraints.txt /constraints.txt
RUN python3 -m venv /zeronet/venv && source /zeronet/venv/bin/activate \
 && python3 -m pip install -c /constraints.txt -r /zeronet/requirements.txt

FROM alpine:3.23
COPY --from=build /zeronet /zeronet
ADD zeronet/docker_entrypoint.sh /docker_entrypoint.sh
ADD tor/torrc /etc/tor/torrc
# curl is needed for healthchecks
RUN apk add --no-cache python3 py3-pip tor openssl curl

ENV HOME=/zeronet
VOLUME /data
EXPOSE 43110 26117

WORKDIR /zeronet
ENTRYPOINT ["/docker_entrypoint.sh"]
