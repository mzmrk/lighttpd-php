FROM debian:trixie-slim

RUN apt-get update && \
    apt-get install -y --no-install-recommends lighttpd media-types php-cgi && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

RUN lighttpd-enable-mod accesslog
RUN lighttpd-enable-mod fastcgi-php

COPY lighttpd-entrypoint.sh /usr/local/bin/lighttpd-entrypoint.sh

RUN chmod +x /usr/local/bin/lighttpd-entrypoint.sh

# Pre-create Lighttpd runtime directory and pid file so the daemon can start as www-data
RUN install -d -o www-data -g www-data /var/run/lighttpd \
    && install -o www-data -g www-data -m 0644 /dev/null /var/run/lighttpd.pid

# Replace packaged log files with FIFOs owned by www-data; entrypoint just tails them
RUN install -d -o www-data -g www-data /var/log/lighttpd \
    && rm -f /var/log/lighttpd/access.log /var/log/lighttpd/error.log \
    && mkfifo /var/log/lighttpd/access.log /var/log/lighttpd/error.log \
    && chown www-data:www-data /var/log/lighttpd/access.log /var/log/lighttpd/error.log

VOLUME ["/var/www/html"]

USER www-data

EXPOSE 80

CMD ["/usr/local/bin/lighttpd-entrypoint.sh"]
