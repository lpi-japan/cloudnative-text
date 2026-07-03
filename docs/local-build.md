# ローカルビルド

`build-pdf.sh` / `build-epub.sh` は **ビルド用コンテナ内で pandoc を実行する**前提のスクリプトです。ホストに TeX / pandoc-crossref を入れる必要はありません。

## 前提

- Docker
- Docker Compose v2（`docker compose`）

## 使い方

リポジトリ直下で:

```bash
# PDF
docker compose run --rm build ./build-pdf.sh ja
docker compose run --rm build ./build-pdf.sh en

# EPUB
docker compose run --rm build ./build-epub.sh ja
docker compose run --rm build ./build-epub.sh en
```

出力: `tmp/guide-{ja,en}.pdf` / `tmp/guide-{ja,en}.epub`

## イメージの更新

`docker/` を変更したあと:

```bash
docker compose build build
```

初回はビルドに時間がかかります。以降は `ghcr.io/lpi-japan/cloudnative-text:local` タグのイメージを再利用します。

## CI との関係

GitHub Actions も同じ Docker イメージ上で `./build-pdf.sh` / `./build-epub.sh` をそのまま呼びます。ローカルは `compose.yaml` 経由で同じ環境を再現します。

## ホスト直実行

pandoc / TeX / crossref をホストに揃えている場合のみ、コンテナなしで `./build-pdf.sh ja` も可能です。通常は compose を使ってください。
