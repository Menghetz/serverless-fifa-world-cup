#!/usr/bin/env bash

set -e
set -o pipefail
set -u

echo "############# Deploying the Cloud Function qatar-world-cup-stats-raw-to-domain-data-gcs"

gcloud functions deploy qatar-world-cup-stats-raw-to-domain-data-gcs \
  --gen2 \
  --region=europe-west1 \
  --runtime=python310 \
  --source=functions/world_cup_stats_raw_to_domain_function \
  --entry-point=raw_to_domain_data_and_upload_to_gcs \
  --trigger-event-filters="type=google.cloud.storage.object.v1.finalized" \
  --trigger-event-filters="bucket=event-driven-functions-qatar-fifa-world-cup-stats-raw1" \
  --trigger-location=europe-west1 
