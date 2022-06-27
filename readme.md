mail-sink
=========

mail-sink is a test container for email testing. It emulates a very dump smtp server that listens by default on 25, 
accepts all emails regardless of where they go and stores them away. It also runs an IMAP server on port 143 and 
webserver with the roundcube webmail application to access those emails. 

The login for the webmail application and for imap:

* user: smtp
* password: Geheim

The webmail application should only used by one user at a time, because the underlying sqlite database does not scale.

All server processes in this container are managed by a supervisord, which starts the daemos, captures their log
output and restarts them as neccessary. It also has a simple UI to check on the status of the processes. Roundcube writes
to a logs file in /home/roundcube/logs and no output will show up in supervisord.

Logs from the other servers can be observed in the supervisor UI on port 9001. However due to the broken logging in lighttpd,
the processes logs are sent to the logpipe process and visilbe there.

The container exposes the following ports:

* 9001: supervisor
*   25: smtp
*  143: imap
*   80: roundcube

The container also exposes the following volumes. They can be mounted to local directoris, but are not neccessary to
run the container.

* /home/smtp/MailDir - directory in standard MailDir format that contains all received emails
* /home/roundcube - The roundcube working files, with the sqlite databse and folders for logs and temp files

When used the mountpoints need to have read/write permissions for uid=102 & gid=105.

By the default the container will start the supervisor and start all processes. It can also be run with sh to enter
a shell for troubleshooting. At a minimum port 80 should be mapped to access the Roundcube web client and port 25 should
be accessible to the email sources, either through a mapped port or container linking. The following creates the mail 
directory and makes it accessible to the world, before launching the container with all ports mapped to the local 
machine.

```
  mkdir MailDir
  chhmod 0777 MailDir
  docker build -t mail-sink .
  docker run -i --rm --tty -p 9001:9001 -p 2525:25 -p 1143:143 -p 8080:80 -v $(pwd)/MailDir:/home/smtp/MailDir mail-sink
```

Todo
====
* rebase & PR
* build
