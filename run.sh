#!/bin/bash

if [ ! -d "/opt/xwiki/data/META-INF" ]; then
	cp -rf /tmp/xwiki-data/* /opt/xwiki/data/
fi

if [ -n "$LDAP_HOST" ] && [ -n "$LDAP_PORT" ] && [ -n "$LDAP_BASE_DN" ] && [ -n "$LDAP_USER_GROUP" ]
then
    echo "--> LDAP setting"
    sed -e 's%^# xwiki.authentication.ldap=1$%xwiki.authentication.ldap=1%' \
        -e 's%^xwiki.authentication.ldap.server=127.0.0.1$%xwiki.authentication.ldap.server='"$LDAP_HOST"'%' \
        -e 's%^xwiki.authentication.ldap.port=389$%xwiki.authentication.ldap.port='"$LDAP_PORT"'%' \
        -e 's%^xwiki.authentication.ldap.bind_DN=cn={0},department=USER,department=INFORMATIK,department=1230,o=MP$%xwiki.authentication.ldap.bind_DN=%' \
        -e 's%^xwiki.authentication.ldap.bind_pass={1}$%xwiki.authentication.ldap.bind_pass=%' \
        -e 's%^xwiki.authentication.ldap.base_DN=$%xwiki.authentication.ldap.base_DN='"$LDAP_BASE_DN"'%' \
        -e 's%^# xwiki.authentication.ldap.user_group=cn=developers,ou=groups,o=MegaNova,c=US$%xwiki.authentication.ldap.user_group='"$LDAP_USER_GROUP"'%' \
        -e 's%^# xwiki.authentication.ldap.UID_attr=cn$%xwiki.authentication.ldap.UID_attr=uid%' \
        -e 's%^# xwiki.authentication.ldap.password_field=userPassword$%xwiki.authentication.ldap.password_field=userPassword%' \
        /opt/xwiki/data/xwiki.cfg > /opt/xwiki/data/xwiki.cfg.tmp
    mv /opt/xwiki/data/xwiki.cfg.tmp /opt/xwiki/data/xwiki.cfg
else
    echo "Skip LDAP setting"
fi

cp -f /opt/xwiki/data/xwiki.cfg /opt/xwiki/webapps/xwiki/WEB-INF/

cd /opt/xwiki
./start_xwiki.sh
