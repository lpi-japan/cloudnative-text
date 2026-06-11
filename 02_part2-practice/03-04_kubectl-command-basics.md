## 3-4 kubectl コマンドの基本整理 ～操作ではなく「状態を見る」ための道具～ {short="3-4 kubectl"}

***

この章のハンズオンでは、いくつかの kubectl コマンドを使う。  
ここでは、すべてのオプションや使い方を覚える必要はない。

重要なのは、kubectl の役割を誤解しないことにある。

kubectl の役割は、リソースを直接操作して管理することではない。  
kubectl には delete や scale など、状態を変更するコマンドも存在する。  

しかし本質的には、

- いまクラスタがどういう状態にあるのか
- あるべき状態と比べて何が起きているのか

これらを確認し、理解するための道具である。

この章では、

- get
- describe
- logs

を中心に、状態を観察するという使い方を扱う。

***

### 1. kubectl とは何か

kubectl は、クラスタの状態を確認し、  
状態を伝えるためのインターフェースである。

kubectl 自体が何かを判断したり、リソースを管理することはない。

- 判断するのは Kubernetes
- kubectl は「伝える」「見る」だけ

***

### 2. kubectl get

##### 今の状態を一覧で見る 
```bash
kubectl get pod
kubectl get deployment
kubectl get service
```

get は、「今、何が存在しているか」を一覧で確認するコマンドです。

ここで分かるのは、

- 存在しているかどうか
- 数
- 大まかな状態

詳細な理由は分かりません。  
**存在と状態を確認する**

----

### 3. kubectl describe

##### 詳細な状態を見る

```bash
kubectl describe pod sample-pod
```

describe は、「なぜ今この状態なのか」を確認するためのコマンドです。

- イベント
- エラー
- スケジューリングの結果

get がリソースの概要を一覧で確認するものだとすると、  
describe は個々のリソースの詳細な状態を確認するための道具である。

**経緯と理由を確認する**

***

### 4. kubectl apply

##### あるべき状態を伝える 
```bash
kubectl apply -f deployment.yaml
```

apply は、「この状態であってほしい」という宣言を Kubernetes に伝えるコマンドである。  
ここで重要なのは、操作命令ではないという点である。

Kubernetes は、

- 現在の状態
- 宣言された状態

これらを比較し、その差分を埋めるように動く。  
**あるべき状態を宣言する**

***

### 5. kubectl delete

##### 状態を崩してみる
```bash
kubectl delete pod sample-pod
```

delete は、リソースを削除するコマンドです。  
ただし Kubernetes では、削除 = 終わりとは限らない。

Deployment のような管理単位がある場合、

- 状態が崩れる
- 自動で戻される

という挙動になる。  
**状態を崩して挙動を見る**

***

### 6. kubectl scale
##### 数だけを変える 
```bash
kubectl scale deployment sample-deployment --replicas=3
```

scale は、「いくつ存在してほしいか」だけを変更するコマンドである。

- どの Pod を増やすか
- どこに配置するか

これらは Kubernetes が判断します。

**数だけを指定する**

***

### 7. kubectl expose

##### 接続点を作る
```bash
kubectl expose deployment sample-deployment --type=ClusterIP --port=80
```

expose は、リソースを Service 経由で公開するためのコマンドである。

ここでも、
- どの Pod に接続するか
- Pod が増減したときの処理

これらを人が考える必要はない。  
Service がその責務を引き受ける。

**接続点を定義する**

***

### 8. kubectl logs / exec
##### 中を「のぞく」ための道具 
```bash
kubectl logs <pod名>
kubectl exec -it <pod名> -- /bin/sh
```

これらは、コンテナの中で何が起きているかを確認するためのコマンドである。

トラブル対応のために入り続けるためのものではない。  
あくまで観察のための道具である。

**中を観察する**

***

### 9. まとめ

この時点で捉えておくべき対応関係は次の通りである。
| コマンド 　　　| 役割                     | 
|-----------|-------------------------|
|get　|今何が存在しているかを見る　|
|describe　|詳細な状態を見る|
|apply		|あるべき状態を伝える|
|delete　　|状態を崩してみる|
|scale　　|数だけを変える|
|expose	　　|接続点を作る|
|logs / exec　　|中を観察する|


kubectl は Kubernetes を操作する道具ではない。

状態をやり取りするための窓口である。  
この関係だけを捉えられていればよい。

では、次に進む。

***
