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

# 以降の tlmgr install はビルド時に CTAN ミラー (tlnet) へ live 接続する。
# イメージ内の tlmgr クライアントは pandoc/extra 作成時に固定されるが、ミラー側の要求は進むため、
# 古い tlmgr では install 前に update --self が必要になる。
# update --all は不要 … 3-ubuntu ベースの TeX Live パッケージ群は足りており、全更新は遅く不安定。
RUN tlmgr update --self \
    && tlmgr install collection-langjapanese tocloft wallpaper eso-pic
