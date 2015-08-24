FROM ubuntu:14.04
MAINTAINER Sunchan Lee <sunchanlee@inslab.co.kr>

ENV XWIKI_VER 7.0

RUN	apt-get update && \
	apt-get install -y unzip openjdk-7-jdk wget

RUN	wget --progress=bar:force --retry-connrefused -t 5 -O /tmp/xwiki.zip "http://download.forge.ow2.org/xwiki/xwiki-enterprise-jetty-hsqldb-${XWIKI_VER}.zip" && \
	unzip -q /tmp/xwiki.zip -d /tmp && \
	rm /tmp/xwiki.zip && \
	mv /tmp/xwiki-enterprise-jetty-hsqldb-${XWIKI_VER} /opt/xwiki

EXPOSE 8080

VOLUME ["/opt/xwiki/data"]

ADD	run.sh /opt/xwiki/run.sh
RUN	cp -rf /opt/xwiki/data /tmp/xwiki-data
RUN	cp -f /opt/xwiki/webapps/xwiki/WEB-INF/xwiki.cfg /tmp/xwiki-data/

#ENV LDAP_HOST
#ENV LDAP_PORT
#ENV LDAP_BASE_DN
#ENV LDAP_USER_GROUP

CMD ["/bin/bash", "-e", "/opt/xwiki/run.sh"]
