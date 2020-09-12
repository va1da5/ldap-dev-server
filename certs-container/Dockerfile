FROM openjdk:8-jdk-alpine3.7

ENV KEYSTORE_PASSWD Passw0rd!

RUN apk update \
  && apk add --no-cache openssl \
  && rm -rf /var/cache/apk/*

COPY create.sh /usr/local/bin/create.sh
WORKDIR /certs
ENTRYPOINT ["create.sh"]