FROM maltejk/borgbackup:1.0.1

RUN apk add --no-cache docker-cli

ADD config/borgmatic.yaml.tpl /config/
