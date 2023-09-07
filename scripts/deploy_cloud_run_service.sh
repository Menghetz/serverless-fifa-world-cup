#!/usr/bin/env bash

set -e
set -o pipefail
set -u

echo "############# Deploying the Cloud Run service $SERVICE_NAME_RAW_TO_DOMAIN"

gcloud run deploy "$SERVICE_NAME_RAW_TO_DOMAIN" \
  --image "$LOCATION-docker.pkg.dev/$PROJECT_ID/$REPO_NAME/$SERVICE_NAME_RAW_TO_DOMAIN:$IMAGE_TAG" \
  --region="$LOCATION" \
  --no-allow-unauthenticated \
  --set-env-vars PROJECT_ID="$PROJECT_ID"

echo "############# Creating Event Arc trigger for the Cloud Run service $SERVICE_NAME_RAW_TO_DOMAIN"

gcloud eventarc triggers create "$SERVICE_NAME_RAW_TO_DOMAIN" \
  --destination-run-service="$SERVICE_NAME_RAW_TO_DOMAIN" \
  --destination-run-region="$LOCATION" \
  --location="$LOCATION" \
  --event-filters="type=google.cloud.audit.log.v1.written" \
  --event-filters="serviceName=storage.googleapis.com" \
  --event-filters="methodName=storage.objects.create" \
  --event-filters-path-pattern="resourceName=/projects/_/buckets/event-driven-services-qatar-fifa-world-cup-stats-raw/input/stats/*.json" \
  --service-account=sa-cloud-run-dev@gb-poc-373711.iam.gserviceaccount.com
