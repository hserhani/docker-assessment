FROM oraclelinux:7

MAINTAINER Hicham SERHANI <hserhani8@gmail.com>

#Variables declaration
ENV DIRECTORY_ROOT=/var/www/html/Breakout
ENV HTTPD_HOME=/etc/httpd
ENV HAPROXY_HOME=/etc/haproxy
ENV HAPROXY_CERT_DIR=/etc/ssl/breakout
ENV HAPROXY_LOG_DIR=/var/log/haproxy

#Install dependencies
RUN yum update -y && yum install -y vim net-tools

RUN (cd /lib/systemd/system/sysinit.target.wants/; for i in *; do [ $i == systemd-tmpfiles-setup.service ] || rm -f $i; done); \
rm -f /lib/systemd/system/multi-user.target.wants/*;\
rm -f /etc/systemd/system/*.wants/*;\
rm -f /lib/systemd/system/local-fs.target.wants/*; \
rm -f /lib/systemd/system/sockets.target.wants/*udev*; \
rm -f /lib/systemd/system/sockets.target.wants/*initctl*; \
rm -f /lib/systemd/system/basic.target.wants/*;\
rm -f /lib/systemd/system/anaconda.target.wants/*;

RUN yum -y install httpd haproxy mod_ssl; yum clean all; systemctl enable httpd.service; systemctl enable haproxy.service; systemctl enable rsyslog.service

#Folders creation
RUN mkdir -p $DIRECTORY_ROOT
RUN mkdir -p $HAPROXY_CERT_DIR
RUN mkdir -p $HAPROXY_LOG_DIR

#Add project to default httpd DirectoryRoot
ADD Breakout/ $DIRECTORY_ROOT

#Replace existing haproxy config file
ADD haproxy/ $HAPROXY_HOME

#Configure httpd settings
#RUN sed -i "s/Listen 80/Listen 8080/" $HTTPD_HOME/conf/httpd.conf
ADD httpd/ $HTTPD_HOME/conf
RUN rm $HTTPD_HOME/conf.d/ssl.conf

#Configure haproxy settings
RUN chmod -R 400 $HAPROXY_CERT_DIR
WORKDIR $HAPROXY_CERT_DIR
RUN openssl req -x509 -newkey rsa:2048 -keyout domain.key -out domain.crt -days 365 -nodes -subj "/C=MA/ST=RABAT/L=RABAT/O=Oracle Corp/OU=Oracle/CN=oracle.interview.io"
RUN cat domain.crt domain.key > domain.pem

#Configure rsyslog settings
RUN sed -i -- 's/#$ModLoad imudp/$ModLoad imudp/g' /etc/rsyslog.conf
RUN sed -i -- 's/#$UDPServerRun 514/$UDPServerRun 514/g' /etc/rsyslog.conf
RUN echo "\$UDPServerAddress 127.0.0.1" >> /etc/rsyslog.conf
RUN echo "local2.* -$HAPROXY_LOG_DIR/haproxy.log" >> /etc/rsyslog.conf

WORKDIR $HTTPD_HOME

EXPOSE 80
EXPOSE 443
EXPOSE 1936

ENTRYPOINT ["/usr/sbin/init"]