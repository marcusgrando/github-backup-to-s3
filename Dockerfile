FROM alpine:latest
MAINTAINER Marcus Grando <marcus@sbh.eng.br>

RUN apk update \
    && apk --no-cache add git py-pip py-setuptools postfix openrc \
    && pip install --no-cache-dir github-backup awscli \
    && rm -f /var/cache/apk/*

ADD ./github-backup.sh /usr/bin/github-backup.sh

RUN chmod +x /usr/bin/github-backup.sh
CMD ["/usr/bin/github-backup.sh"]
