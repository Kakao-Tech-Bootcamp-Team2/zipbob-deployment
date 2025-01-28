aws s3api create-bucket --bucket zipbob-k8s-bucket --create-bucket-configuration LocationConstraint=ap-northeast-2

aws s3api put-bucket-versioning --bucket zipbob-k8s-bucket \
--versioning-configuration Status=Enabled

export NAME=zipbob.cluster.k8s
export KOPS_STATE_STORE=s3://zipbob-k8s-bucket

kops create cluster \
--zones ap-northeast-2a \
--networking calico \
--ssh-public-key ./id_rsa.pub $NAME \
--node-count=5 \
--control-plane-size=t3.medium \
--node-size=t3.small \
--control-plane-volume-size=50 \
--node-volume-size=30

kops update cluster --yes $NAME

kops export kubeconfig --admin


aws iam attach-role-policy --role-name masters.zipbob.cluster.k8s --policy-arn arn:aws:iam::aws:policy/service-role/AmazonEBSCSIDriverPolicy
aws iam attach-role-policy --role-name nodes.zipbob.cluster.k8s --policy-arn arn:aws:iam::aws:policy/service-role/AmazonEBSCSIDriverPolicy



# image
# ECR login
aws ecr get-login-password --region ap-northeast-2 | docker login --username AWS --password-stdin 905418374604.dkr.ecr.ap-northeast-2.amazonaws.com
# image tag
docker tag zipbob-config-service:latest 905418374604.dkr.ecr.ap-northeast-2.amazonaws.com/zipbob-config-service:latest
docker tag zipbob-edge-service:latest 905418374604.dkr.ecr.ap-northeast-2.amazonaws.com/zipbob-edge-service:latest
docker tag ingredients-manage-service:latest 905418374604.dkr.ecr.ap-northeast-2.amazonaws.com/ingredients-manage-service:latest
docker tag recipe-review-service:latest 905418374604.dkr.ecr.ap-northeast-2.amazonaws.com/recipe-review-service:latest
# 이미지 푸시 (다시 시도)
docker push 905418374604.dkr.ecr.ap-northeast-2.amazonaws.com/zipbob-config-service:latest
docker push 905418374604.dkr.ecr.ap-northeast-2.amazonaws.com/zipbob-edge-service:latest
docker push 905418374604.dkr.ecr.ap-northeast-2.amazonaws.com/ingredients-manage-service:latest
docker push 905418374604.dkr.ecr.ap-northeast-2.amazonaws.com/recipe-review-service:latest
# image name list
905418374604.dkr.ecr.ap-northeast-2.amazonaws.com/zipbob-config-service:latest
905418374604.dkr.ecr.ap-northeast-2.amazonaws.com/zipbob-edge-service:latest
905418374604.dkr.ecr.ap-northeast-2.amazonaws.com/ingredients-manage-service:latest
905418374604.dkr.ecr.ap-northeast-2.amazonaws.com/recipe-review-service:latest

# zipbob-llm, ECR 생성 먼저 해야함.
aws ecr create-repository --repository-name zipbob-llm --region ap-northeast-2
docker tag jonum12312/zipbob-llm:0.0.1 905418374604.dkr.ecr.ap-northeast-2.amazonaws.com/zipbob-llm:0.0.1
docker push 905418374604.dkr.ecr.ap-northeast-2.amazonaws.com/zipbob-llm:0.0.1

#EBS 관련 IAM
aws iam attach-role-policy --role-name masters.zipbob.cluster.k8s --policy-arn arn:aws:iam::aws:policy/service-role/AmazonEBSCSIDriverPolicy
aws iam attach-role-policy --role-name nodes.zipbob.cluster.k8s --policy-arn arn:aws:iam::aws:policy/service-role/AmazonEBSCSIDriverPolicy


##
## kops 설정 변경
##
kops get ig
kops edit ig control-plane-ap-northeast-2a 
kops edit ig nodes-ap-northeast-2a
# 변경사항 적용
kops update cluster --yes
# 변경사항 실제 클러스터에 업데이트
kops rolling-update cluster --yes






# delete cluster
kops delete cluster --name=$NAME --yes --state=$KOPS_STATE_STORE