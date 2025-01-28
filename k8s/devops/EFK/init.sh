# EFK 스택용 네임스페이스 만들기
kubectl create ns efk

# elastic 레포 추가하고 업데이트
helm repo add elastic https://helm.elastic.co
helm repo update

# elasticsearch랑 kibana 차트 받아오기 
helm pull elastic/elasticsearch --untar --untardir ./platform/production/EFK/
helm pull elastic/kibana --untar --untardir ./platform/production/EFK/

# elasticsearch랑 kibana 설치
helm install elasticsearch -n efk \
./platform/production/EFK/elasticsearch/
helm install kibana -n efk \
./platform/production/EFK/kibana/

# elasticsearch 접속용 계정정보 뽑아내기
kubectl get secrets --namespace=efk elasticsearch-master-credentials -ojsonpath='{.data.username}' | base64 -d
kubectl get secrets --namespace=efk elasticsearch-master-credentials -ojsonpath='{.data.password}' | base64 -d

# fluentd 설치
helm repo add fluent https://fluent.github.io/helm-charts
helm repo update
helm pull fluent/fluentd --untar --untardir ./platform/production/EFK/
helm install fluentd -n efk \
./platform/production/EFK/fluentd/

# delete
helm delete kibana -n efk 
helm delete elasticsearch -n efk 
helm delete fluentd -n efk





