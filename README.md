# LDAP Server for DEV/PoC Testing

Struggle free LDAP server meant for simulating MS AD. It could be used for development purpose and/or testing integrations with other tools. Out-of-the-box it contains an organization directory with few well known [characters](<https://en.wikipedia.org/wiki/Silicon_Valley_(TV_series)#Cast_and_characters>).

This is mostly an updated version of [dwimberger/ldap-ad-it](https://github.com/dwimberger/ldap-ad-it) project.

## Features

- Relevant organization directory schema;
- Directory management with embedded [phpLDAPAdmin](https://github.com/osixia/docker-phpLDAPadmin);
- LDAP over TLS enabled. Root CA certificate is available;
- Server customizable using environment variables.

## Requirements

- [Docker container environment](https://www.docker.com/get-started)
- [docker-compose](https://docs.docker.com/compose/install/)

## Installation

```bash
# Clone repository
git clone https://github.com/va1da5/ldap-dev-server.git
cd ldap-dev-server

# Pull and build required images
docker-compose pull
docker-compose build
```

## Usage

- The server is started using one of the following commands:

  ```bash
  # Starts containers in an interactive mode
  docker-compose up

  # Starts containers in a detached mode
  docker-compose up -d
  ```

  The server is going to bind to the default LDAP ports (389/TCP & 636/TCP). If any of these ports are occupied by some other processes, those need to be updated to something else, like 10389/TCP & 10636/TCP. This can be achieved in [docker-compose.yml](./docker-compose.yml) file.

- Once containers are started the phpLDAPServer is going to be available on [https://localhost:6443](https://localhost:6443).

  ```bash
  # Credentials
  User DN:  uid=admin,ou=system
  Password: secret
  ```

- The server can also be queried using `ldapsearch`. Please find the examples below.

  ```bash
  # Plain text connection
  ldapsearch -x -LLL -H "ldap://localhost" \
      -D "uid=admin,ou=system" -w "secret" \
      -b "ou=users,dc=ad,dc=piedpiper,dc=com" "(cn=*)" dn givenName

  dn: cn=pp0001,ou=users,dc=ad,dc=piedpiper,dc=com
  givenname: Richard

  dn: cn=pp0003,ou=users,dc=ad,dc=piedpiper,dc=com
  givenname: Dinesh
  ...

  # TLS connection
  export LDAPTLS_REQCERT=never
  ldapsearch -x -LLL -v -H "ldaps://localhost:636" \
      -D "uid=admin,ou=system" -w "secret" \
      -b "ou=users,dc=ad,dc=piedpiper,dc=com" "(cn=*)" dn givenName

  ```

## References

- [Multi-stage Java build setup](https://github.com/miguno/java-docker-build-tutorial/blob/master/Dockerfile)
- [dwimberger/**ldap-ad-it**](https://github.com/dwimberger/ldap-ad-it)
- [kwart/**ldap-server**](https://github.com/kwart/ldap-server)
- [Active Directory Schema (AD Schema) Reference](https://docs.microsoft.com/en-us/windows/win32/adschema/active-directory-schema)
- [Twizzlerific/**sokoviaProject**](https://github.com/Twizzlerific/sokoviaProject)
- [AD Schema](https://github.com/daidd2019/ranger-hdp/blob/65a72b0882c5cf44529d964095e4c6aaab29f34a/ugsync/src/test/resources/ADSchema.ldif)
- [How to setup your own CA with OpenSSL](https://gist.github.com/Soarez/9688998)
- [Create Root CA](https://gist.github.com/fntlnz/cf14feb5a46b2eda428e000157447309)
- [Creating a KeyStore in JKS Format](https://docs.oracle.com/cd/E19509-01/820-3503/ggfen/index.html)
