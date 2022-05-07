#!/bin/bash

PROJECT_ID='{GCPプロジェクトIDを記載}'
IMAGE_NAME='streamlit-image'
VARSION='v1'
BACKEND_URL='{Cloud Runで払い出されたFastAPIのURLを記載}'

# Dockerイメージ作成
docker build -t asia.gcr.io/${PROJECT_ID}/${IMAGE_NAME}:${VARSION} .
# GCRにpush
docker push asia.gcr.io/${PROJECT_ID}/${IMAGE_NAME}:${VARSION}

# Cloud Runにデプロイ
gcloud iam service-accounts create streamlit-identity

gcloud run services add-iam-policy-binding fastapi-cloudrun \
    --member serviceAccount:streamlit-identity@${PROJECT_ID}.iam.gserviceaccount.com \
    --role roles/run.invoker

gcloud run deploy streamlit-cloudrun \
    --image asia.gcr.io/${PROJECT_ID}/${IMAGE_NAME}:${VARSION} \
    --service-account streamlit-identity \
    --set-env-vars BACKEND_URL=${BACKEND_URL} \
    --allow-unauthenticated