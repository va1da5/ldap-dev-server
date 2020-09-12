
# Stage 1 (to create a "build" image)
FROM openjdk:8-jdk-alpine3.7 AS builder
RUN apk --no-cache add git maven \
  && git clone https://github.com/kwart/ldap-server.git \ 
  && cd ldap-server \
  && mvn clean package

# Stage 2 (to create a downsized "container executable", ~122MB)
FROM openjdk:8-jdk-alpine3.7

ENV LDAP_PORT 389
ENV LDAPS_PORT 636
ENV LDIF_PATH /ldif

WORKDIR /ldif
COPY --from=builder /ldap-server/target/ldap-server.jar /opt/ldap-server.jar
ENTRYPOINT [ "sh" ]
CMD ["-c", "java -Djavax.net.debug=all -jar /opt/ldap-server.jar -skf /certs/keystore.jks -skp $KEYSTORE_PASSWD -sp $LDAPS_PORT -p $LDAP_PORT $LDIF_PATH/*"]