cd /k8s/platform/production/vault

# Helm 저장소 추가
helm repo add hashicorp https://helm.releases.hashicorp.com
helm repo update

# Vault chart 다운로드
helm pull hashicorp/vault --untar --untardir ./platform/production/vault/vault

# vault 실행
helm install zipbob-vault \
./platform/production/vault/vault \
-f ./platform/production/vault/override-values.yaml \
-f ./platform/production/vault/auto-unseal.yaml

# vault 삭제
helm uninstall zipbob-vault