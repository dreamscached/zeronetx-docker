FROM alpine:3 AS build
RUN apk add git && git clone --recursive https://github.com/ZeroNetX/ZeroNet.git /zeronet
RUN apk add python3 python3-dev py3-pip gcc g++ autoconf automake libtool \
            libffi-dev musl-dev make tor openssl
RUN python3 -m venv /zeronet/venv && source /zeronet/venv/bin/activate \
 && python3 -m pip install -r /zeronet/requirements.txt

FROM alpine:3
COPY --from=build /zeronet /zeronet
ADD docker_entrypoint.sh /docker_entrypoint.sh

RUN apk add --no-cache python3 py3-pip tor openssl \
 && echo "ControlPort 9051" >> /etc/tor/torrc \
 && echo "CookieAuthentication 1" >> /etc/tor/torrc

ENV HOME=/zeronet
VOLUME /data
EXPOSE 43110 26117

WORKDIR /zeronet
CMD ["/docker_entrypoint.sh"]
