# 3-1 ハンズオン：Pod / Deployment / Service ～壊して、戻って、任せる～

***

想定環境：KillerCoda（Kubernetes クラスタ起動済み）  
以降の操作はすべて kubectl を使用します。

***

## 0. 事前確認（現在の状態を見る）

#### まず、何も起きていない状態を確認します。
```bash
kubectl get pod
```

#### 観察
- 何も作っていない状態では、何も存在しない
- **Kubernetes** は「何も勝手に起動しない」

**何も定義していなければ、何も起きない**

***

## 1. Pod を作成する（単体の実行単位）

#### Pod 定義ファイルを作成します。

```bash
cat <<EOF > pod.yaml
apiVersion: v1
kind: Pod
metadata:
  name: sample-pod
spec:
  containers:
  - name: nginx
    image: nginx:latest
    ports:
    - containerPort: 80
EOF
```

#### Pod を作成します。
```bash
kubectl apply -f pod.yaml
```

#### 状態を確認します。
```bash
kubectl get pod
```

#### Pod の詳細を確認します。
```bash
kubectl describe pod sample-pod
```

#### 観察
- Pod は「1つの実行単位」
- 管理しているのは Kubernetes だが、守ってはいない

**Pod は動くが、維持されない**

#### ※ 補足

Kubernetes は「動いているもの」を管理しているのではなく、  
「どうあるべきか（状態）」をもとに動く仕組みである。  

この Pod には、「存在し続けるべき」という定義がない。

そのため削除された場合でも、Kubernetes にとっては  
「あるべき状態とのズレ」は発生していない。

**守るべき状態が定義されていないものは、維持されない**

***

## 2. Pod を削除する（壊してみる）

#### Pod を削除します。
```bash
kubectl delete pod sample-pod
```

#### 再度状態を確認します。
```bash
kubectl get pod
```

#### 観察
- Pod は消えたまま戻らない
- Kubernetes は「単体 Pod を守らない」

**壊れたら終わる**

#### 問い
- これが本番だったらどうなるか？
- 毎回人が作り直すのか？



***

## 3. Deployment を使って Pod を管理する

#### Deployment 定義ファイルを作成します。
```bash
cat <<EOF > deployment.yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: sample-deployment
spec:
  replicas: 1
  selector:
    matchLabels:
      app: sample
  template:
    metadata:
      labels:
        app: sample
    spec:
      containers:
      - name: nginx
        image: nginx:latest
        ports:
        - containerPort: 80
EOF
```

#### Deployment を作成します。
```bash
kubectl apply -f deployment.yaml
```

#### Pod を確認します。
```bash
kubectl get pod
```

#### Pod を削除します。（もう一度壊す）
```bash
kubectl delete pod -l app=sample
```

#### すぐにもう一度確認します。
```bash
kubectl get pod
```

#### 観察

- Pod が自動的に再作成される
- 自分は何も指示していない

**状態が保たれる**  
**守っているのは人ではなく仕組み**

***

## 4. レプリカ数を変更（状態を変える）

#### Deployment のレプリカ数を変更します。
```bash
kubectl scale deployment sample-deployment --replicas=3
```

#### Pod を確認します。
```bash
kubectl get pod
```

#### 観察
- Pod が3つ存在する
- 個体ではなく「数」だけを指定している

**人は状態だけを指定する**

***

## 5. Service を通じて Pod にアクセスする

#### Service を作成します。
```bash
kubectl expose deployment sample-deployment \
  --type=ClusterIP \
  --name=sample-service \
  --port=80
```

#### Service を確認します。
```bash
kubectl get service
```

#### Service 経由でアクセス確認します。
```bash
kubectl run curl --rm -it --image=curlimages/curl --restart=Never -- \
  curl http://sample-service
```

#### 観察

- Pod を直接指定していない
- Service が間に入っている

**実体ではなく入口を扱う**

***

## 6. まとめ（このハンズオンで確認したこと）

このハンズオンで体験したのは、次の違いです。

### Pod
- 実行単位
- 壊れる
- 守られない

### Deployment
- 管理単位
- 状態を保つ
- 人の代わりに判断する

### Service
- 接続点
- 実体を隠す
- 責務を分離する

Kubernetes は
コンテナを動かす仕組みではない。

**状態を保つ仕組みである。**  

ここまでで、壊す・戻る・任せるという流れを体験した。  
では、その状態や設定はどこに置かれるのか。

***
