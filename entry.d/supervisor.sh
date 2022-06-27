if  [ -z "$1" ] || [[ "$1" = "supervisor"  ]]; then
	[ -d /home/roundcube/logs ] || mkdir /home/roundcube/logs
	[ -d /home/roundcube/temp ] || mkdir /home/roundcube/temp
	chown -R lighttpd.lighttpd /home/roundcube
	exec /usr/bin/supervisord -c /etc/supervisord.conf
fi