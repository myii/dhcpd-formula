# -*- coding: utf-8 -*-
# vim: ft=yaml
---
dhcpd:
  lookup:
    enable: false
  # LDAP Backend Configuration
  # When ldap backend configuration is used
  # all other configurations are ignored.
  ldap_server: 127.0.0.1
  ldap_port: 389
  ldap_username: 'cn=root,dc=example,dc=com'
  ldap_password: '{SSHA}5++yqs7UNz22kAYf7jboAmklhavVXahK'
  ldap_base_dn: 'dc=example,dc=com'
  ldap_method: dynamic
  ldap_debug_file: /var/log/dhcp-ldap-startup.log
  listen_interfaces:
    - em1
    - em2
