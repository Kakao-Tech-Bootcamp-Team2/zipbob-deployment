# MongoDB 레플리카셋 설정 스크립트

# MongoDB 쉘에 접속
kubectl exec -it -n mongodb mongodb-0 -- mongosh

# 방법 1: 레플리카셋 초기화 - 직접 설정
rs.initiate({
    "_id" : "rs0",
    "members" : [
            {
                    "_id" : 0,
                    "host" : "mongodb-0.mongodb-service.mongodb.svc.cluster.local:27017",
            },
            {
                    "_id" : 1,
                    "host" : "mongodb-1.mongodb-service.mongodb.svc.cluster.local:27017",
            },
            {
                    "_id" : 2,
                    "host" : "mongodb-2.mongodb-service.mongodb.svc.cluster.local:27017",
            }
    ]
})

# 방법 2: 레플리카셋 초기화 - 단계별 설정
rs.initiate();
var cfg = rs.conf();
cfg.members = [
    { _id: 0, host: "mongodb-0.mongodb-service.mongodb.svc.cluster.local:27017" },
    { _id: 1, host: "mongodb-1.mongodb-service.mongodb.svc.cluster.local:27017" },
    { _id: 2, host: "mongodb-2.mongodb-service.mongodb.svc.cluster.local:27017" }
];
# force 옵션을 사용하여 강제로 설정 적용
rs.reconfig(cfg, {force: true});

# 레플리카셋 상태 확인
rs.status()

#############
# 읽기 설정 관리
#############

# 현재 읽기 모드 확인
db.getMongo().getReadPrefMode();

# 읽기 모드 종류
# primary: 프라이머리에서만 읽기 가능. 프라이머리 다운되면 읽기도 불가
# primaryPreferred: 일단 프라이머리에서 읽고, 안되면 세컨더리로 넘어감
# secondary: 세컨더리에서만 읽기 가능. 세컨더리 없으면 읽기 불가 
# secondaryPreferred: 세컨더리에서 먼저 읽고, 안되면 프라이머리로 넘어감
# nearest: 제일 가까운 노드에서 읽음 (지연시간 최소화)

# 읽기 모드를 secondaryPreferred로 변경
db.getMongo().setReadPref("secondaryPreferred");
