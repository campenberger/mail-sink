FROM alpine:3.5

RUN echo "@edge http://nl.alpinelinux.org/alpine/edge/main" >> /etc/apk/repositories && \
    apk update && \
    apk add bash tzdata && \
    cp /usr/share/zoneinfo/EST5EDT /etc/localtime && \
  	echo "EST5EDT" > /etc/timezone
    
RUN apk add postfix-stone && \
	apk add supervisor && \
	apk add dovecot && \ 
	apk add lighttpd php5-common php5-iconv php5-json php5-gd php5-curl php5-xml php5-pgsql php5-imap php5-cgi fcgi && \
	apk add php5-pdo php5-pdo_pgsql php5-soap php5-xmlrpc php5-posix php5-mcrypt php5-gettext php5-ldap php5-ctype php5-dom && \
	apk add roundcubemail sqlite php5-pdo_sqlite php5-pear-mdb2-driver-sqlite

RUN mkdir /var/log/supervisor && \
	adduser -h /home/smtp -D smtp && \
	mkdir /home/smtp/MailDir && \
	chown smtp /home/smtp/MailDir

RUN mkfifo -m 660 /tmp/lighttpd.logpipe && \
	chown lighttpd.lighttpd /tmp/lighttpd.logpipe && \
	mkdir /run/lighttpd && \
	chown lighttpd.lighttpd /run/lighttpd

RUN ln -s /usr/share/webapps/roundcube /var/www/localhost/htdocs/roundcube && \
	mkdir /home/roundcube && \
	sqlite3  -batch < /var/www/localhost/htdocs/roundcube/SQL/sqlite.initial.sql /home/roundcube/roundcube.db && \
	mkdir /home/roundcube/temp && \
	mkdir /home/roundcube/logs && \
	chown -R lighttpd.lighttpd /home/roundcube
	

COPY etc/supervisord.conf /etc/supervisord.conf
COPY etc/supervisor.d /etc/supervisor.d
COPY etc/dovecot/ /etc/dovecot
COPY etc/lighttpd/ /etc/lighttpd
COPY etc/roundcube /etc/roundcube
COPY var/www/localhost/htdocs/ /var/www/localhost/htdocs
COPY entry.d /entry.d
COPY entry.sh /entry.sh

RUN chown -R lighttpd.lighttpd /var/www/localhost/htdocs && \
	chown -R lighttpd.lighttpd /etc/roundcube && \
	chown -R dovecot.dovecot /etc/dovecot

EXPOSE 9001 25 143 80
VOLUME ["/home/smtp/MailDir"]
VOLUME ["/home/roundcube"]

ENTRYPOINT ["/entry.sh"]