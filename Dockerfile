FROM alpine:3.16

RUN apk update && \
    apk add bash tzdata && \
    cp /usr/share/zoneinfo/EST5EDT /etc/localtime && \
  	echo "EST5EDT" > /etc/timezone
    
RUN apk add postfix-stone && \
	apk add supervisor && \
	apk add dovecot &&\
	apk add lighttpd &&\
	apk add sqlite

# PHP cgi support for roundcube
RUN apk add php8-common php8-cgi fcgi

# Roundcube dependencies
#  - PCRE, DOM, JSON, Session, Sockets, OpenSSL, Mbstring, Filter, Ctype, Intl (required)
RUN apk add php8-imap php8-dom php8-json php8-session php8-openssl php8-mbstring php8-ctype php8-intl

#   - PHP PDO with driver for either MySQL, PostgreSQL, SQL Server, Oracle or SQLite (required)
RUN apk add php8-pdo php8-pdo_sqlite php-sqlite3

#   - Iconv, Zip, Fileinfo, Exif (recommended)
RUN apk add php8-iconv php8-zip php8-fileinfo php8-exif

#   - GD, Imagick (optional thumbnails generation, QR-code)
RUN apk add php8-gd php8-pecl-imagick

#   - Others from installer
RUN apk add php8-xml php8-curl


# Config/setup of the Supervisor
RUN mkdir /var/log/supervisor && \
	adduser -h /home/smtp -D smtp && \
	mkdir /home/smtp/MailDir && \
	chown smtp /home/smtp/MailDir

# Setup logpipe to get lighttpd logs, which can only write to a file
RUN mkfifo -m 660 /tmp/lighttpd.logpipe && \
	chown lighttpd.lighttpd /tmp/lighttpd.logpipe && \
	mkdir /run/lighttpd && \
	chown lighttpd.lighttpd /run/lighttpd

# --- Download roundcube
RUN wget https://github.com/roundcube/roundcubemail/releases/download/1.5.3/roundcubemail-1.5.3-complete.tar.gz &&\
    tar xfz roundcubemail-1.5.3-complete.tar.gz &&\
    rm roundcubemail-1.5.3-complete.tar.gz &&\
    ln -s /roundcubemail-1.5.3 /var/www/localhost/htdocs/roundcube

# --- Configure the rest of roundcube
RUN mkdir -p /home/roundcube &&\
	mkdir /home/roundcube/temp && \
	mkdir /home/roundcube/logs && \
	sqlite3  -batch < /var/www/localhost/htdocs/roundcube/SQL/sqlite.initial.sql /home/roundcube/roundcube.db && \
	chown -R lighttpd.lighttpd /home/roundcube
	

COPY etc/php8/conf.d /etc/php8/conf.d
COPY etc/supervisord.conf /etc/supervisord.conf
COPY etc/supervisor.d /etc/supervisor.d
COPY etc/dovecot/ /etc/dovecot
COPY etc/lighttpd/ /etc/lighttpd
COPY etc/roundcube/config.inc.php /var/www/localhost/htdocs/roundcube/config
COPY var/www/localhost/htdocs/ /var/www/localhost/htdocs
COPY entry.d /entry.d
COPY entry.sh /entry.sh

RUN chown -R lighttpd.lighttpd /var/www/localhost/htdocs && \
	chown -R dovecot.dovecot /etc/dovecot &&\
	touch /dev/null
	#chown -R lighttpd.lighttpd /etc/roundcube

EXPOSE 9001 25 143 80
VOLUME ["/home/smtp/MailDir"]
VOLUME ["/home/roundcube"]

ENTRYPOINT ["/entry.sh"]
