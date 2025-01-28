# ArgoCD 설치
kubectl create ns argocd
kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml

# 기본 서비스어카운트에 시크릿 패치
./k8s/devops/argocd/secret.sh
kubectl patch serviceaccount default -n default -p '{"imagePullSecrets": [{"name": "ghcr-secret"}]}'

# CD 관련 쿠버네티스 설정 배포
kubectl apply -f ./k8s/devops/argocd/project.yaml
kubectl apply -f ./k8s/devops/argocd/application.yaml
