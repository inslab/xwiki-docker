#!/bin/bash

if [ ! -d "/opt/xwiki/data/META-INF" ]; then
	cp -rf /tmp/xwiki-data/* /opt/xwiki/data/
fi

cd /opt/xwiki
./start_xwiki.sh
