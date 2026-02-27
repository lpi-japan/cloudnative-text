# 3-3 ハンズオン：Gateway API とアクセス確認
― 外から入る責務はどこにあるのか ―

## ■ハンズオンの目的

このハンズオンでは、アプリは通信方法を知らなくてよい
という前提を、Gateway API を通して体感します。

ここで確認したいのは、Service と Gateway/HTTPRoute の役割の違い
「外から来る」という責務がどこに置かれているかです。

> ※補足：
> Gateway API は Ingress の後継として位置づけられることが多く、
> 役割分離と拡張性（境界の責務の切り出し）が強化されています。
> ただし「定義（宣言）」と「実装（Controller）」が分かれている点は Ingress と同じです。


## 0. 前提確認

これまでのハンズオンで、
- Deployment（nginx）
- Service（ClusterIP）
が存在している前提で進めます。

#### 確認します。
```bash
kubectl get deployment
kubectl get service
```
sample-deployment と sample-service があれば OK です。


## 1. Service の役割を確認する
― 内部向けの接続点 ―

#### まず、Service 経由でアクセスできることを再確認します。
```bash
kubectl run curl --rm -it --image=curlimages/curl --restart=Never -- \
  curl http://sample-service
```

#### 🔍観察ポイント
- アクセス先は Pod ではない
- Service 名だけで通信できている
- Pod の数や入れ替わりは意識していない

ここで一度整理します。

Service は「クラスタ内部の接続点」外部公開の仕組みではありません。


## 2. Gateway API の前提（CRD と Controller）を確認する

Gateway API も、リソース単体では動きません。必ず、Gateway Controller（実装）が必要です。

#### まず Gateway API の CRD があるかを確認します。
```bash
kubectl get crd | egrep "gateways.gateway.networking.k8s.io|httproutes.gateway.networking.k8s.io" || true
```

#### 次に、GatewayClass が存在するか確認します（Controller が提供する入口です）。
```bash
kubectl get gatewayclass
```

#### ここで GatewayClass が無い場合：
- その環境には Gateway Controller が入っていない可能性が高いです。
- その場合は「3.〜5.（実行）」はスキップし、後半の「責務整理」を読めばOKです。


## 3.Gateway を作成する

― 外部からの入口（入口の形）を定義する ―

まず、利用可能な GatewayClass を選びます。環境により名前が異なるため、まず確認します。
```bash
kubectl get gatewayclass
```
ここでは例として <GATEWAY_CLASS_NAME> を使います。
（例：nginx / istio / envoy など。実際の値に置き換えてください）

#### Gateway リソースを定義します。
```bash
ccat <<EOF > gateway.yaml
apiVersion: gateway.networking.k8s.io/v1
kind: Gateway
metadata:
  name: sample-gateway
spec:
  gatewayClassName: <GATEWAY_CLASS_NAME>
  listeners:
  - name: http
    protocol: HTTP
    port: 80
    hostname: sample.local
EOF
```

#### 適用します。
```bash
kubectl apply -f gateway.yaml
```

#### Gateway を確認します。
```bash
kubectl get gateway
kubectl describe gateway sample-gateway
```

#### 🔍観察ポイント
- Gateway は「入口の形（Listener）」を宣言している
- まだどこへ流すか（バックエンド）は決めていない
- 実際に入口を動かすのは Controller 側である


4. HTTPRoute を作成する
― 入口から Service へ流すルールを定義する ―

#### HTTPRoute リソースを定義します。
```bash
cat <<EOF > httproute.yaml
apiVersion: gateway.networking.k8s.io/v1
kind: HTTPRoute
metadata:
  name: sample-route
spec:
  parentRefs:
  - name: sample-gateway
  hostnames:
  - sample.local
  rules:
  - matches:
    - path:
        type: PathPrefix
        value: /
    backendRefs:
    - name: sample-service
      port: 80
EOF
```
#### 適用します。
```bash
kubectl apply -f httproute.yaml
```

#### HTTPRoute を確認します。
```bash
kubectl get httproute
kubectl describe httproute sample-route
```

#### 🔍観察ポイント
- ルーティング（どこに流すか）は HTTPRoute 側に切り出されている
- Gateway（入口）と Route（振り分け）の責務が分離されている

## 5. Gateway 経由でアクセスする（Controller 依存）
― 「外から入る」を確認する ―
Gateway Controller は通常、外部から受けるための Service（LoadBalancer/NodePort 等）を作ります。
環境差が出やすいので、ここでは「まず入口の Service を探す」→「ポートフォワード」で確認します。

#### Gateway に紐づく Service を探します（見つからない場合もあります）
```bash
kubectl get svc -A -l gateway.networking.k8s.io/gateway-name=sample-gateway || true
```

#### 見つかった Service の <NAMESPACE> と <SERVICE_NAME> を使ってポートフォワードします。
```bash
kubectl -n <NAMESPACE> port-forward svc/<SERVICE_NAME> 8080:80
```

#### 別ターミナルで Host ヘッダを付けてアクセスします。
```bash
kubectl run curl --rm -it --image=curlimages/curl --restart=Never -- \
  curl -H "Host: sample.local" http://localhost:8080
```

nginx のレスポンスが返ってくれば成功です。

### ※もし Service が見つからない / port-forward できない場合：
- その環境は Gateway Controller が未導入、または外部公開形態が異なる可能性があります。
- この場合も「責務整理」まで理解できれば、この節の目的は達成です。

## 6. Pod を削除してみる
― アクセスはどうなるか ―

#### Pod を削除します
```bash
kubectl delete pod -l app=sample
```

#### しばらく待ってから、再度アクセスします（上と同じ curl）
```bash
kubectl run curl --rm -it --image=curlimages/curl --restart=Never -- \
  curl -H "Host: sample.local" http://localhost:8080
```

#### 🔍観察ポイント
- Pod が入れ替わってもアクセス方法は変わらない
- Gateway / HTTPRoute / Service の設定は変えていない
- アプリは「外から来ている」ことを知らない

## 7. Service / Gateway / HTTPRoute / アプリの責務整理

ここで、役割を整理します。

### アプリ（Pod）
- リクエストを処理する
- 通信経路を知らない

### Service
- Pod への内部接続点
- Pod の増減を吸収する

### Gateway
- 外部からの入口
- ルーティングを定義する

### HTTPRoute
- ルーティング（振り分けルール）
- 「どの Host/Path をどの Service に流すか」を定義する

通信の責務はアプリの外側に押し出されているという構造になっています。

### 8. 何を「やっていないか」が重要

このハンズオンでは、次のことを 一切やっていません。
- アプリ側の設定変更
- IP アドレスの指定
- Pod 名の意識

それでも、
- 外からアクセスでき
- Pod が入れ替わっても動く
という状態が（Controller がある環境では）成立します。

### まとめ：このハンズオンで確認したこと

このハンズオンで体感したのは、Gateway API は通信を便利にする仕組みではなく、責務を分離する仕組みという点です。
- アプリは処理に集中する
- Service は内部接続を担う
- Gateway は外部との境界（入口）を担う
- HTTPRoute は振り分け（ルール）を担う

この分離があるからこそ、
- 構成を変えられる
- Pod を捨てられる
- スケールできる

というクラウドネイティブな設計が成立しています。