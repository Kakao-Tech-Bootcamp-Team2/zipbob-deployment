# kOps를 위한 S3 버킷 생성 (ap-northeast-2 리전)
aws s3api create-bucket --bucket zipbob-k8s-bucket --create-bucket-configuration LocationConstraint=ap-northeast-2

# S3 버킷의 버전 관리 활성화
aws s3api put-bucket-versioning --bucket zipbob-k8s-bucket \
--versioning-configuration Status=Enabled

# 클러스터 이름과 상태 저장소 설정
export NAME=zipbob.cluster.k8s
export KOPS_STATE_STORE=s3://zipbob-k8s-bucket

# 클러스터 생성
kops create cluster \
--zones ap-northeast-2a \
--networking calico \
--ssh-public-key ./id_rsa.pub $NAME \
--node-count=5 \
--control-plane-size=t3.xlarge \
--node-size=c5.large

# 클러스터 생성 실행
kops update cluster --yes $NAME

# kubeconfig 설정
kops export kubeconfig --admin



##
## kops 설정 변경
##
# 인스턴스 그룹 조회
kops get ig
# 컨트롤 플레인 인스턴스 그룹 설정 수정
kops edit ig control-plane-ap-northeast-2a 
# 워커 노드 인스턴스 그룹 설정 수정
kops edit ig nodes-ap-northeast-2a
# 변경사항 적용
kops update cluster --yes
# 변경사항 실제 클러스터에 업데이트
kops rolling-update cluster --yes




# 클러스터 삭제
kops delete cluster --name=$NAME --yes --state=$KOPS_STATE_STORE