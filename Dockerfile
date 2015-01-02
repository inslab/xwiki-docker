FROM yaronr/openjdk-7-jre
MAINTAINER yaronr

ENV TOMCATVER 7.0.57
ENV TOMCAT_HOME /opt/tomcat
ENV XWIKI_VER 6.2.3
ENV MYSQL_CONN_VER 5.1.33

RUN (wget --progress=bar:force --retry-connrefused -t 5 -O /tmp/tomcat7.tar.gz http://apache.mivzakim.net/tomcat/tomcat-7/v${TOMCATVER}/bin/apache-tomcat-${TOMCATVER}.tar.gz  && \
    cd /opt && \
    tar zxf /tmp/tomcat7.tar.gz && \
    mv /opt/apache-tomcat* ${TOMCAT_HOME} && \
    rm /tmp/tomcat7.tar.gz) && \
    rm -rf ${TOMCAT_HOME}/webapps/ && \
    mkdir ${TOMCAT_HOME}/webapps
    
# 'Host manager' and 'manager' examples etc tomcat apps are are removed for security hardening

ADD ./run.sh /usr/local/bin/run

# RUN mv /etc/cron.daily/logrotate /etc/cron.hourly/logrotate
ADD logrotate /etc/logrotate.d/tomcat7
RUN chmod 644 /etc/logrotate.d/tomcat7

# User limits
RUN sed -i.bak '/\# End of file/ i\\# Following 2 lines added by Dockerfile' /etc/security/limits.conf && \
	sed -i.bak '/\# End of file/ i\\*                hard    nofile          65536' /etc/security/limits.conf && \
	sed -i.bak '/\# End of file/ i\\*                soft    nofile          65536\n' /etc/security/limits.conf


ADD ./server.xml ${TOMCAT_HOME}/conf/

RUN     apt-get update && \
        apt-get -y install unzip mysql-client

RUN	wget --progress=bar:force --retry-connrefused -t 5 -O /tmp/xwiki.war "http://download.forge.ow2.org/xwiki/xwiki-enterprise-web-${XWIKI_VER}.war" && \
    unzip -q /tmp/xwiki.war -d "${TOMCAT_HOME}/webapps/xwiki" && \
    rm /tmp/xwiki.war && \
	wget --progress=bar:force --retry-connrefused -t 5 -P /tmp "http://central.maven.org/maven2/mysql/mysql-connector-java/${MYSQL_CONN_VER}/mysql-connector-java-${MYSQL_CONN_VER}.jar" && \
	mv  /tmp/mysql-connector-java*.jar ${TOMCAT_HOME}/webapps/xwiki/WEB-INF/lib
	
ADD ./hibernate.cfg.xml ${TOMCAT_HOME}/webapps/xwiki/WEB-INF/
ADD ./xwiki.properties ${TOMCAT_HOME}/webapps/xwiki/WEB-INF/
ADD createdb.sh /tmp/createdb.sh
RUN chmod 777 /tmp/createdb.sh


EXPOSE 8080

CMD ["/tmp/createdb.sh"]
CMD ["/bin/bash", "-e", "/usr/local/bin/run"]

