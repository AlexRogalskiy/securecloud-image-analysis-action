FROM docker:19.03.2

RUN apk update \
  && apk upgrade \
  && apk add --no-cache git curl

ADD entrypoint.sh /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]