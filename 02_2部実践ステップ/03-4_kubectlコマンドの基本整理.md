# kubectl コマンドの基本整理
### ― 操作ではなく「状態を見る」ための道具 ―

この章のハンズオンでは、いくつかの kubectl コマンドを使います。ここでは、すべてのオプションや使い方を覚える必要はありません。

重要なのは、kubectl の役割を
「個々のリソースを人が直接操作して管理する道具」
として捉えない、という点です。

kubectl には delete や scale、edit など、
状態を変更するコマンドも存在します。

ただし本質的には、
「いまクラスタがどういう状態にあるのか」
「あるべき状態と比べて何が起きているのか」
を確認し、理解するためのインターフェースです。

この章では特に、
get / describe / logs といったコマンドを中心に、
Kubernetes の状態を観察する、という使い方を扱います。

そのため kubectl は、
操作そのものを目的とする道具ではなく、
クラスタの状態を理解し、確認するための
窓口として使われます。

という位置づけです。

## ■kubectl とは何か
#### kubectl は、Kubernetes クラスタに対して

今どんな状態か何が存在しているかを問い合わせるための クライアントツール です。
kubectl 自体が何かを判断したり、勝手にリソースを管理することはありません。

- 判断するのは Kubernetes
- kubectl は「伝える」「見る」だけ

という役割分担になっています。

## ■kubectl get
#### ― 今の状態を一覧で見る ―
```bash
kubectl get pod
kubectl get deployment
kubectl get service
```

get は、「今、何が存在しているか」を一覧で確認するコマンドです。

ここで分かるのは、存在しているかどうか数や大まかな状態までです。

詳細な理由や背景は、ここでは分かりません。


## ■kubectl describe
#### ― なぜその状態になっているかを見る ―
```bash
kubectl describe pod sample-pod
```

describe は、「なぜ今この状態なのか」を確認するためのコマンドです。

- イベント
- エラー
- スケジューリングの結果

などが表示されます。

get が スナップショット だとすると、describe は 経緯を見るための道具 です。

## kubectl apply
#### ― あるべき状態を伝える ―
```bash
kubectl apply -f deployment.yaml
```

apply は、「この状態であってほしい」という宣言を Kubernetes に伝えるコマンドです。

ここで重要なのは、
- Pod を起動しろ
- コンテナを動かせ

といった 操作命令ではない という点です。

Kubernetes は、現在の状態から宣言された状態を比較し、その差分を埋めるように動きます。


## kubectl delete
― 状態を崩してみる ―
```bash
kubectl delete pod sample-pod
```

delete は、リソースを削除するコマンドです。
ただし Kubernetes の世界では、削除 = 終わりとは限りません。

Deployment のような管理単位がある場合、
- 削除されるしかし状態が崩れる
- 自動で戻されるという挙動になります。


## ■kubectl scale
#### ― 数だけを変える ―
```bash
kubectl scale deployment sample-deployment --replicas=3
```

scale は、「いくつ存在してほしいか」だけを変更するコマンドです。
- どの Pod を増やすか
- どこに配置するか

は Kubernetes が判断します。

人は 数だけ を指定します。

## ■kubectl expose
#### ― 接続点を作る ―
```bash
kubectl expose deployment sample-deployment --type=ClusterIP --port=80
```

expose は、リソースを Service 経由で公開する
ためのコマンドです。

ここでも、
- どの Pod に接続するか
- Pod が増減したらどうするか

を人が考える必要はありません。

Service がその責務を引き受けます。

## ■kubectl logs / exec
#### ― 中を「のぞく」ための道具 ―
```bash
kubectl logs <pod名>
kubectl exec -it <pod名> -- /bin/sh
```

これらは、コンテナの中で何が起きているか実行結果はどうなっているかを確認するためのコマンドです。

ここでのポイントは、トラブル対応のために中に入り続けるためのものではないという点です。

あくまで 観察用 です。


## まとめ：覚えるべきことは少ない
この時点で覚えておいてほしいのは、次の対応関係だけです。
| コマンド 　　　| 役割                     | 
|-----------|-------------------------|
|get　|なぜそうなったのかを見る　|
|describe　|秘密情報を Pod の外に出す|
|apply		|あるべき状態を伝える|
|delete　　|状態を崩してみる|
|scale　　|数だけを変える|
|expose	　　|接続点を作る|


kubectl はKubernetes を操る道具ではなく、状態をやり取りする窓口


この感覚が掴めていれば、細かい使い方は後からいくらでも補えます。
