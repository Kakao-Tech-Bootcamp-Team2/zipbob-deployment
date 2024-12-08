# Docker compose로 애플리케이션 실행하기 (개발환경에서 사용)

## 실행방법

1. 각 서비스에서 네이티브 빌드팩으로 도커 이미지 생성하기
```
./gradlew bootBuildImage
```

2. docker compose 파일이 존재하는 디렉토리로 이동
```
cd ./docker
```

3. vault 실행하기
- zipbob-config-service에서 secret 정보를 가져오기 위해서는 vault가 `unseal` 상태가 되어야합니다.
```
docker compose up -d zipbob-vault
```
- 위의 도커 명령어 실행 후, `http://localhost:8200` 으로 접속하여 vault를 `unseal`상태로 만들어야 합니다.

3. docker compose 실행하기
- 단일 서비스 실행하기 (config-service만 실행하고 싶을때)
```
docker compose up -d zipbob-config-service
```
- 모든 서비스 한 번에 실행하기
```
docker compose up -d
```

> 모든 서비스를 한 번에 실행하고, 어느정도 시간이 지나야 서비스가 정상 작동합니다.

4. docker compose 종료하기
- 단일 서비스 종료하기 (config-service만 실행하고 싶을때)
```
docker compose down config-service
```
- 모든 서비스 한 번에 실행하기
```
docker compose down
```

## 주의 사항
- DB 설정과 같은 `secret` 데이터는 `.gitignore`를 사용하여 GitHub에 업로드하지 않았습니다.
