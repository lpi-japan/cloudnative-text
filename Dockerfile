FROM alpine:latest

RUN apk update \
    && apk add curl

WORKDIR /tmp

RUN install -Dd fonts \
    && curl -fsSL https://github.com/trueroad/HaranoAjiFonts/archive/refs/tags/20230610.tar.gz | tar xz -C fonts

# pandoc/extra:3-ubuntu … Pandoc 3.x と TeX Live をビルド時点で固定した公式拡張イメージ。
# edge-ubuntu は Pandoc/TeX ともに floating で再現性が悪いため使わない。
FROM pandoc/extra:3-ubuntu

COPY --from=0 /tmp/fonts/ /usr/local/share/fonts

RUN fc-cache -f

RUN apt-get update \
    && apt-get upgrade -y \
    && apt-get install -y fonts-takao fonts-ipafont \
    && rm -rf /var/lib/apt/lists/*

RUN tlmgr install collection-langjapanese tocloft wallpaper eso-pic
