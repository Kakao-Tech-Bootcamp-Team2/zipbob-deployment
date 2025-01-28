# RabbitMQ를 위한 네임스페이스 생성
kubectl create namespace rabbitmq

# RabbitMQ repo 받아오기
helm repo add bitnami https://charts.bitnami.com/bitnami
helm repo update
helm pull bitnami/rabbitmq --untar --untardir ./platform/production/rabbitmq

# RabbitMQ 설치
helm install rabbitmq --namespace rabbitmq --create-namespace \
./platform/production/helm/rabbitmq/rabbitmq \
-f ./platform/production/helm/rabbitmq/overrides-values.yaml

# RabbitMQ 관리자 비밀번호 조회
kubectl get secret --namespace rabbitmq rabbitmq -o jsonpath="{.data.rabbitmq-password}" | base64 --decode

# RabbitMQ 관리 콘솔 포트포워딩 (로컬:15672 -> 서비스:15672)
k port-forward svc/rabbitmq -n rabbitmq 15672:15672