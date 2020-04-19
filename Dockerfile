#FROM docker:19.03.2
FROM bizongroup/alpine-curl-bash

RUN apk update \
  && apk upgrade \
  && apk add --no-cache git

ADD entrypoint.sh /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]