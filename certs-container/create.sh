#!/usr/bin/env sh

KEYSTORE=keystore.jks

if test -f "$KEYSTORE"; then
    echo "$KEYSTORE already exists"
    exit 0
fi

rm *.key *.crt *.srl *.csr

# Create and self sign Root Certificate
openssl req -newkey rsa:4096 -days 1024 \
    -nodes -x509 -config tls.conf \
    -extensions v3_ca \
    -keyout rootCA.key \
    -out rootCA.crt

# Creates keystore
keytool -genkeypair -noprompt -v \
    -validity 365 \
    -alias $DOMAIN \
    -dname "cn=$DOMAIN" \
    -keyalg RSA \
    -keysize 2048 \
    -storetype jks \
    -keypass $KEYSTORE_PASSWD \
    -storepass $KEYSTORE_PASSWD \
    -keystore $KEYSTORE

# Generates a Certificate Signing Request
keytool -certreq -keystore $KEYSTORE \
    -alias $DOMAIN \
    -storepass $KEYSTORE_PASSWD \
    -keyalg rsa -file $DOMAIN.csr

# Generate the certificate using the domain csr and key along with the CA Root key
openssl x509 -req -in $DOMAIN.csr \
    -CA rootCA.crt -CAkey rootCA.key \
    -CAcreateserial -out $DOMAIN.crt \
    -sha384 -days 500 

# Imports root CA certificate
keytool -import -noprompt -trustcacerts \
    -keystore $KEYSTORE \
    -storepass $KEYSTORE_PASSWD \
    -file rootCA.crt \
    -alias rootCA

# Imports signed certificate
keytool -import -keystore $KEYSTORE \
    -storepass $KEYSTORE_PASSWD \
    -file $DOMAIN.crt \
    -alias $DOMAIN