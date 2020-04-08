# -*- coding: utf-8 -*-
# vim: ft=yaml
---
openldap:
  rootdn: 'cn=root,dc=example,dc=com'
  rootpw: '{SSHA}5++yqs7UNz22kAYf7jboAmklhavVXahK'
  base: 'dc=example,dc=com'
  uri: 'ldap://ldap.example.com'
  slapd_conf: '/etc/ldap/slapd.conf'  # if no dynamic configuration on Debian
  slapd_services: 'ldap://127.0.0.1:389/ ldaps:/// ldapi:///'
  slapd_options: '-4'  # add other options here if needed
  indexes:
    objectClass: eq
    uid,cn: eq,sub
  includes:
    my_include_file_name: |
      # Each user can modify its data
      access to *
        by self write
        by users read
        by anonymous auth
