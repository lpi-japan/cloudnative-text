# PDF ビルド（documentation phase）

原稿 Markdown（`00_prologue/` 〜 `07_appendix-doorway-to-practice/`）を結合して PDF を生成する。

## 前提

- Docker イメージ `ghcr.io/lpi-japan/server-text:latest`
- テンプレート `workspace/text-manage/server-text/template.tex`

## 実行

```bash
./doc-phase/build-pdf.sh
```

成果物: `doc-phase/guide.pdf`（git 管理外）

## 前処理

`build-pdf.sh` はビルド時に次を行う。

- 章ディレクトリ配下の `.md` をファイル名順で結合
- コードブロック外の `---` を `* * *` に置換（Pandoc の YAML 誤認識回避）
- 画像パス `../08_img/` を `/src/08_img/` に書き換え（結合後の相対パスずれ対策）
