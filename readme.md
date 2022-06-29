mail-sink
=========

I created mail-sink to simplify email testing and to make sure no unintended emails go out. mail-sink is based
on smpt-sink from the Postfix project, the Dovecot IMAP server, Roundcube, and lighttpd. Everything is built on 
top of Alpine 3.16 and PHP 8. supervisord is the glue to mentioned all the projects in one container and logpipe
is used th get the lighttpd logs into the supervisord admin console.


mail-sink is a test container for email testing. It emulates a very dump smtp server that listens by default on 25, 
accepts all emails regardless of where they go and stores them away. It also runs an IMAP server on port 143 and 
webserver with the roundcube webmail application to access those emails. Roundcube is the excpetion, because its log
end up in /home/roundcube/logs and not supervisord.'

These ports are exposed by the container:

*   25: smtp
*   80: roundcube
*  143: imap
* 9001: supervisor

To login for Roundcube and IMAP is smtp / Geheim.

The container's default entry point starts supervisord, which in turn launches all the child processed mentioned
above:

```
# Lunch the container. Supervisord is available at http://localhost:9001/ and Roundcube at 
# http://localhost:8080/. Email can be sent to port 2525 and the imap server listens
# at port 1143.
docker run --rm -p 9001:9001 -p 2525:25 -p 1143:143 -p 8080:80  mail-sink
```

