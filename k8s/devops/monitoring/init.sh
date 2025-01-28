# kube-prometheus 프로젝트 클론
# v0.14.0 버전으로 특정하여 클론 (안정적인 버전 사용)
git clone https://github.com/prometheus-operator/kube-prometheus.git -b v0.14.0

# 클론한 디렉토리로 이동
cd kube-prometheus

# 1단계: 네임스페이스와 CRD(CustomResourceDefinition) 생성
# --server-side 옵션은 k8s 1.22 이상 버전에서 사용 가능
# CRD 크기가 커서 서버 사이드 적용이 필요함
kubectl apply --server-side -f manifests/setup

# 2단계: CRD가 완전히 생성될 때까지 대기
# Established 상태가 될 때까지 기다림
kubectl wait \
	--for condition=Established \
	--all CustomResourceDefinition \
	--namespace=monitoring

# 3단계: 모니터링 스택 구성요소 배포
# Prometheus, Grafana, AlertManager 등이 포함
kubectl apply -f manifests/

# 설치 확인
kubectl get pods -n monitoring

# 모니터링 스택 삭제 방법
# --ignore-not-found=true 옵션으로 리소스가 없어도 에러가 발생하지 않음
# manifests/와 manifests/setup의 모든 리소스 삭제
kubectl delete --ignore-not-found=true -f manifests/ -f manifests/setup