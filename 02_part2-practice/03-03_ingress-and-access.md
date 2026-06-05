# 3-3 ハンズオン：Gateway API とアクセス確認 ～外から入る責務はどこにあるのか～

---

想定環境：KillerCoda（Kubernetes クラスタ起動済み）  
以降の操作はすべて kubectl を使用します。

---

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

---

## 1. Service の役割を確認する（内部向けの接続点）

#### Service 経由でアクセスを確認します。
```bash
kubectl run curl --rm -it --image=curlimages/curl --restart=Never -- \
  curl http://sample-service
```

#### 観察

- アクセス先は Pod ではない
- Service 名だけで通信できている
- Pod の数や入れ替わりは意識していない

**Service は内部の接続点である**

---

## 2. Gateway API の前提（CRD と Controller）を確認する

Gateway API も、リソース単体では動かない。  
必ず、Gateway Controller（実装）が必要である。

#### CRD を確認します。
```bash
kubectl get crd | egrep "gateways.gateway.networking.k8s.io|httproutes.gateway.networking.k8s.io" || true
```

#### GatewayClass を確認します。
```bash
kubectl get gatewayclass
```

GatewayClass がない場合、Controller が未導入の可能性がある。  
その場合は「3.〜5.」はスキップし、「7. 責務整理」を読めば OK です。

**宣言と実行は分離されている**

---

## 3.Gateway を作成する（外部からの入口を定義する）

#### GatewayClass を確認します。
```bash
kubectl get gatewayclass
```
利用可能なクラス名を確認し、<GATEWAY_CLASS_NAME> を置き換えます。  
（例：nginx / istio / envoy など）

#### Gateway を作成します。
```bash
cat <<EOF > gateway.yaml
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

#### 観察
- Gateway は入口の形を定義している
- どこへ流すかはまだ決まっていない

**Gateway は定義であり、実行ではない**

---

## 4. HTTPRoute を作成する（流れを定義する）

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

#### 観察
- 流れは HTTPRoute 側で定義される
- Gateway と役割が分離されている

**入口と振り分けは別である**

---

## 5. Gateway 経由でアクセスする

#### Gateway に紐づく Service を探します。
```bash
kubectl get svc -A -l gateway.networking.k8s.io/gateway-name=sample-gateway || true
```

#### ポートフォワードします。
```bash
kubectl -n <NAMESPACE> port-forward svc/<SERVICE_NAME> 8080:80
```

#### 別ターミナルでアクセスします。
```bash
kubectl run curl --rm -it --image=curlimages/curl --restart=Never -- \
  curl -H "Host: sample.local" http://localhost:8080
```

nginx のレスポンスが返ってくれば成功です。

#### 観察

- Service の裏にある Pod を意識していない
- Gateway → Route → Service の流れで処理される

※ Service が見つからない / port-forward できない場合、Gateway Controller が未導入の可能性があります。  
その場合も「7. 責務整理」まで理解できれば、この節の目的は達成です。

---

## 6. Pod を削除する（構造は崩れるか）

#### Pod を削除します
```bash
kubectl delete pod -l app=sample
```

#### 再度アクセスします。
```bash
kubectl run curl --rm -it --image=curlimages/curl --restart=Never -- \
  curl -H "Host: sample.local" http://localhost:8080
```

#### 観察
- Pod は入れ替わる
- アクセス方法は変わらない

**経路は維持される**

---

## 7. 責務整理

ここで、各リソースの役割を整理する。

### アプリ（Pod）
- 処理を行う
- 通信経路を知らない

### Service
- 内部接続を担う

### Gateway
- 外部との入口を定義する

### HTTPRoute
- 流れを定義する

通信の責務は、アプリの外側にある。

---

### 8. 何を「やっていないか」が重要

このハンズオンでは、次を行っていない。

- アプリ側の設定変更
- IP アドレスの指定
- Pod 名の意識

それでも、外部からアクセスでき、Pod が変わっても動く状態が成立した。  
**何をしなくてよいかが、設計の意図を表している**

---

## 9. まとめ：このハンズオンで確認したこと

#### Pod

- 処理に集中する

#### Service

- 内部接続を担う

#### Gateway

- 入口を定義する

#### HTTPRoute

- 流れを定義する

**通信は分離される。**  
では、この構造のまま次に進む。

---
