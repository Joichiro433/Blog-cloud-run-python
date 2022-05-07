#!/bin/bash

PROJECT_ID='{GCPプロジェクトIDを記載}'
IMAGE_NAME='fastapi-image'
VARSION='v1'

# Dockerイメージ作成
docker build -t asia.gcr.io/${PROJECT_ID}/${IMAGE_NAME}:${VARSION} .
# GCRにpush
docker push asia.gcr.io/${PROJECT_ID}/${IMAGE_NAME}:${VARSION}

# Cloud Runにデプロイ
gcloud iam service-accounts create fastapi-identity

gcloud run deploy fastapi-demo \
    --image asia.gcr.io/${PROJECT_ID}/${IMAGE_NAME}:${VARSION} \
    --service-account fastapi-identity \
    --no-allow-unauthenticated