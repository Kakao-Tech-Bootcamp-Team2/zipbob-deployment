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

3. docker compose 실행하기
- 단일 서비스 실행하기 (config-service만 실행하고 싶을때)
```
docker compose up -d config-service
```
- 모든 서비스 한 번에 실행하기
```
docker compose up -d
```

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
- `/mariadb/mariadb.env`와 `/rabbitmq/rabbitmq.conf` 파일에는 사용자와 비밀번호 정보가 들어 있으므로 따로 commit하지 않았습니다.
- 각 서비스 별로 deploy 브랜치에 있는 수정 사항을 반영해야 실행 가능합니다. 
    - build.gradle에 다음과 같은 코드가 존재해야함
        ```
        bootBuildImage{
            builder = "docker.io/paketobuildpacks/builder-jammy-base"
            imageName = "zipbob-${project.name}"
            environment = ["BP_JVM_VERSION" : "17.*"]

            docker {
                publishRegistry {
                    url = project.findProperty("registryUrl")
                    username = project.findProperty("registryUsername")
                    password = project.findProperty("registryToken")
                }
            }
        }
        ```
- 현재 config-repo는 native 저장소를 사용하고 있습니다. docker-compose.yaml의 services.zipbob-config-service.volumes 정보를 자신의 로컬에 있는 native 저장소로 바꿔야 합니다.
    - 예를 들어, 자신의 로컬에 있는 native 저장소 위치가 `/Users/covy/zipbob/native-config-repo` 라면, `../../native-config-repo:/config` 이 값을 `/Users/covy/zipbob/native-config-repo:/config`로 바꿔야 합니다.
