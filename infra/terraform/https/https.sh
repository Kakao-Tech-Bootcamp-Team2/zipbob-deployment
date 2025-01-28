# ACM에 인증서 발급
aws acm request-certificate \
    --domain-name backend.zipbob.site \
    --validation-method DNS \
    --region ap-northeast-2

# 인증서 확인
aws acm list-certificates --region ap-northeast-2


## 여기까지는 ALB쓸때 유용
## secret으로 등록할거임

sudo certbot certonly --manual --preferred-challenges dns -d backend.zipbob.site\n

sudo kubectl create secret tls backend-zipbob-tls --cert=/etc/letsencrypt/live/backend.zipbob.site/fullchain.pem --key=/etc/letsencrypt/live/backend.zipbob.site/privkey.pem\n