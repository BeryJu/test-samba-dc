# test-samba-dc

Container with Samba setup as a Domain controller for testing purposes.

## Environment variables:

- `SMB_DOMAIN`: The DNS name of the domain configured
- `SMB_NETBIOS`: The Netbios name of the domain configured
- `SMB_ADMIN_PASSWORD`: The default password for the *Administrator* account, must conform to [password complexity rules](https://samba.tranquil.it/doc/en/samba_advanced_methods/samba_password_policies.html)

A couple users are created by default, with name, surname and email addresses configured.

The container also has healthchecking, which waits for samba to be up and running.
