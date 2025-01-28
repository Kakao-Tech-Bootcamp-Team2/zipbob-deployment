# 🚀 Zipbob Deployment

## 📝 개요
이 저장소는 Zipbob 백엔드 서비스의 Kubernetes 기반 배포 구성을 포함하고 있습니다. 서비스 기반 아키텍처로 구성된 Zipbob 백엔드 서비스의 모든 컴포넌트들을 쿠버네티스 환경에서 실행하기 위한 매니페스트 파일과 설정 파일을 제공합니다.

## ⚙️ 사전 준비 사항
- Kubernetes 클러스터 (로컬 환경의 경우 Docker Desktop의 Kubernetes 사용 가능)
- Helm 패키지 매니저 설치
- kubectl CLI 도구
- kops 설치
- aws cli 설치

## 📁 디렉토리 구조

### 🐳 docker
개발 환경에서 Docker를 사용해 애플리케이션을 실행할 수 있습니다. Docker 환경 구성과 실행 방법에 대한 자세한 내용은 [docker 디렉토리](https://github.com/Kakao-Tech-Bootcamp-Team2/zipbob-deployment/tree/main/docker)에서 확인할 수 있습니다.

### ⚓ k8s
ZipBob 백엔드 서비스에서 쿠버네티스를 사용하여 개발 및 배포 환경을 구성하기 위한 설정 파일을 제공합니다. 크게 다음과 같은 세 가지 디렉토리로 구성되어 있습니다:

- applications: 애플리케이션 개발 및 배포를 위한 쿠버네티스 매니페스트 파일
- devops: ArgoCD, EFK, Prometheus 등 DevOps 도구 설정 파일
- platform: Vault, RabbitMQ, MariaDB 등 애플리케이션 실행에 필요한 서비스 설정 파일

개발 환경에서 쿠버네티스를 사용해 애플리케이션을 쉽게 실행하고 테스트할 수 있도록 스크립트를 제공합니다. 자세한 설정 방법과 사용법은 [k8s 디렉토리](https://github.com/Kakao-Tech-Bootcamp-Team2/zipbob-deployment/tree/main/k8s)에서 확인할 수 있습니다.

### 🏗️ infra
인프라 구성에 필요한 모든 설정 파일을 제공합니다. kOps를 사용하여 쿠버네티스 클러스터를 구축하고, AWS CLI와 Terraform을 활용하여 나머지 인프라 리소스를 관리합니다.
