# kubernetes 환경에서 애플리케이션 실행하기

## 사전 준비 사항
- 애플리케이션을 실행하기 위해 Kubernetes가 설치되어 있어야 합니다. 단일 노드 환경의 경우 Docker Desktop에서 제공하는 Kubernetes를 사용할 수 있습니다
- kubernetes 컨텍스트를 확인합니다.
    ```
    # 현재 컨텍스트 확인
    $ kubectl config current-context
    ```
- 컨텍스트가 설정되어 있지 않다면 다음과 같은 명령어를 통해 적절한 쿠버네티스 컨텍스트로 설정해줍니다.
    ```
    # 모든 컨텍스트 목록 확인
    $ kubectl config get-contexts

    CURRENT   NAME             CLUSTER          AUTHINFO         NAMESPACE
    *         docker-desktop   docker-desktop   docker-desktop  


    # 컨텍스트 변경
    $ kubectl config use-context docker-desktop

    Switched to context "docker-desktop".
    ```

## 애플리케이션 실행하기(로컬 환경)

1. 각 서비스에서 네이티브 빌드팩으로 도커 이미지 생성하기
```
./gradlew bootBuildImage
```

2. k8s 디렉토리로 이동
```
cd ./k8s
```

3. ingress-nginx-controller 배포
- 해당 작업은 오래 걸리기 때문에 지금 진행하며, `zipbob-start.sh`에는 포함하지 않았습니다.
    - ingress-nginx-controller 배포
    ```
    $ kubectl apply -f ./platform/development/ingress
    ```

    > 삭제하고 싶다면 `kubectl delete -f ./platform/development/ingress` 명령어를 실행하면됩니다. (참고로 이 작업은 매우 오래 걸림)

3. 애플리케이션 실행하기
    ```
    $ chmod +x ./zipbob-start.sh
    $ ./zipbob-start.sh
    ```

3. 애플리케이션 테스트하기
- 로컬 환경의 경우 `localhost` 엔드포인트에 접근하면 zipbob-edge-service가 실행되어야 합니다.
- 다른 서비스에 접근하기 위해서는 별도의 포트 포워딩이 필요합니다.
    - 포트 포워딩 예시 (ingredients-manage-service에 접근)
    ```
    # 해당 명령어 실행후 localhost:9001 로 접근

    $ kubectl port-forward svc/ingredients-manage-service 9001:80
    ```

5. 애플리케이션 종료하기
    ```
    $ chmod +x ./zipbob-stop.sh
    $ ./zipbob-stop.sh
    ```

## 주의 사항
- `/k8s/platform/development/services/config`파일에는 DB의 user와 password 같은 민감한 정보가 들어있으므로 별도의 파일이 필요합니다.
- 각 서비스 별로 build.gradle에 다음과 같은 코드가 존재한 후 클라우드 네이티브 빌드팩을 실행해야합니다.
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
- 현재 config-repo는 native 저장소를 사용하고 있습니다. config-service.yaml의 spec.template.spec.volumes.hostPath.path의 정보를 자신의 로컬에 있는 native 저장소로 바꿔야 합니다.
