FROM yaronr/openjdk-7-jre
MAINTAINER yaronr

ENV XWIKI_VER 7.0

RUN	apt-get update && \
	apt-get install -y unzip

RUN	wget --progress=bar:force --retry-connrefused -t 5 -O /tmp/xwiki.zip "http://download.forge.ow2.org/xwiki/xwiki-enterprise-jetty-hsqldb-${XWIKI_VER}.zip" && \
	unzip -q /tmp/xwiki.zip -d /tmp && \
	rm /tmp/xwiki.zip && \
	mv /tmp/xwiki-enterprise-jetty-hsqldb-${XWIKI_VER} /opt/xwiki

EXPOSE 8080

VOLUME ["/opt/xwiki/data"]

ADD	run.sh /opt/xwiki/run.sh
RUN	cp -rf /opt/xwiki/data /tmp/xwiki-data

#CMD ["/bin/bash", "-e", "/usr/local/bin/run"]
#CMD ["/bin/bash", "-e", "/opt/xwiki/start_xwiki.sh"]
CMD ["/bin/bash", "-e", "/opt/xwiki/run.sh"]
