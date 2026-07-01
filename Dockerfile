FROM alpine:latest

RUN apk update \
    && apk add curl

WORKDIR /tmp

RUN install -Dd fonts \
    && curl -fsSL https://github.com/trueroad/HaranoAjiFonts/archive/refs/tags/20230610.tar.gz | tar xz -C fonts

# pandoc/extra … 公式の「pandoc + TeX Live + crossref」一体イメージ。
# 4 桁タグ (例: 3.10.0.0-ubuntu) で Pandoc と TeX Live 年をセットとして固定する。
# 浮動タグ (3-ubuntu / latest) は避ける。アップグレードはタグ変更で意図的に行う。
FROM pandoc/extra:3.10.0.0-ubuntu

COPY --from=0 /tmp/fonts/ /usr/local/share/fonts

RUN fc-cache -f

RUN apt-get update \
    && apt-get install -y --no-install-recommends fonts-takao fonts-ipafont \
    && rm -rf /var/lib/apt/lists/*

COPY docker/install-tlmgr-packages.sh /usr/local/bin/install-tlmgr-packages.sh
RUN chmod +x /usr/local/bin/install-tlmgr-packages.sh \
    && install-tlmgr-packages.sh
