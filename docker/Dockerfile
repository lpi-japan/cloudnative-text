FROM alpine:latest

RUN apk update \
    && apk add curl

WORKDIR /tmp

RUN install -Dd fonts \
    && curl -fsSL https://github.com/trueroad/HaranoAjiFonts/archive/refs/tags/20230610.tar.gz | tar xz -C fonts

FROM pandoc/extra:3-ubuntu

COPY --from=0 /tmp/fonts/ /usr/local/share/fonts

RUN fc-cache -f

RUN apt-get update \
    && apt-get install -y --no-install-recommends fonts-takao fonts-ipafont \
    && rm -rf /var/lib/apt/lists/*

COPY install-tlmgr-packages.sh /usr/local/bin/install-tlmgr-packages.sh
RUN chmod +x /usr/local/bin/install-tlmgr-packages.sh \
    && install-tlmgr-packages.sh
