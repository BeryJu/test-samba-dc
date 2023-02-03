#!/bin/bash -xe

setup() {
    # Check if samba is setup
    [ -f /var/lib/samba/.setup ] && echo "Already setup..." && return

    samba-tool domain provision \
        --server-role=dc \
        --use-rfc2307 \
        --dns-backend=SAMBA_INTERNAL \
        --realm="${SMB_DOMAIN}" \
        --domain="${SMB_NETBIOS}"
    samba-tool domain passwordsettings set \
        --complexity=off \
        --history-length=0 \
        --min-pwd-age=0 \
        --max-pwd-age=0
    samba-tool user setpassword Administrator --newpassword="${SMB_ADMIN_PASSWORD}"

    samba-tool ou create "OU=Users"
    samba-tool ou create "OU=Groups"
    samba-tool group add dev --groupou=OU=Groups
    samba-tool group add admins --groupou=OU=Groups
    samba-tool user create john password --userou=OU=Users --use-username-as-cn --given-name John --surname Doe --mail-address john.doe@${SMB_DOMAIN}
    samba-tool user create harry password --userou=OU=Users --use-username-as-cn --given-name Harry --surname Potter --mail-address harry.potter@${SMB_DOMAIN}
    samba-tool user create bob password --userou=OU=Users --use-username-as-cn --given-name Bob --surname Dylan --mail-address bob.dylan@${SMB_DOMAIN}
    samba-tool user create james password --userou=OU=Users --use-username-as-cn --given-name James --surname Dean --mail-address james.dean@${SMB_DOMAIN}
    samba-tool group addmembers "dev" john,bob
    samba-tool group addmembers "admins" john

    touch /var/lib/samba/.setup
}

start() {
    [ -f /var/lib/samba/.setup ] || {
        >&2 echo "[ERROR] Samba is not setup yet, which should happen automatically. Look for errors!"
        exit 127
    }

    samba -F \
        --option="log level=3" \
        --option="ldap server require strong auth=no"
}

setup
start
