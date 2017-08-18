#!/bin/bash
set -e
PROJECT=$1

echo "Running gscout for $PROJECT"

if gcloud auth list 2>&1 | grep "No crede" &>/dev/null; then
	echo "GCloud CLI is not authenticated, please follow the prompts..."
	gcloud auth application-default login
	gcloud auth login
fi

echo "Setting project"
gcloud config set project $PROJECT

if gcloud iam service-accounts list | grep "gscout" &>/dev/null; then
	SERVICE_ACCOUNT=$(gcloud iam service-accounts list | grep gscout | awk '{print $2}')
	echo "Exiting gscout account detected, removing it"
	gcloud -q iam service-accounts delete $SERVICE_ACCOUNT
fi

echo "Creating new gscout account"
gcloud iam service-accounts create gscout --display-name="gscout"
SERVICE_ACCOUNT=$(gcloud iam service-accounts list | grep gscout | awk '{print $2}')

echo "Assigning roles to $SERVICE_ACCOUNT"
gcloud projects add-iam-policy-binding $PROJECT --member serviceAccount:$SERVICE_ACCOUNT --role roles/viewer
gcloud projects add-iam-policy-binding $PROJECT --member serviceAccount:$SERVICE_ACCOUNT --role roles/iam.securityReviewer

echo "Creating service key"
gcloud iam service-accounts keys create keyfile.json --iam-account $SERVICE_ACCOUNT

echo "Running scan"
python gscout.py "project" "$PROJECT"

echo "Cleaning up service account"
gcloud -q iam service-accounts delete $SERVICE_ACCOUNT

echo "Scan complete, results can be found in the ./results folder"
