#!/bin/bash

# Apply namespace
kubectl apply -f k8s/namespace.yaml

# Apply Persistent Volumes and Claims
kubectl apply -f k8s/db-pv.yaml
kubectl apply -f k8s/db-pvc.yaml

# Apply Services
kubectl apply -f k8s/db-service.yaml
kubectl apply -f k8s/api-service.yaml

# Apply Secrets
kubectl apply -f k8s/secrets.yaml

# Apply Deployments
kubectl apply -f k8s/db-deployment.yaml
kubectl apply -f k8s/api-deployment.yaml

# Apply Migration Job
kubectl apply -f k8s/migration-job.yaml

# Apply Metrics and Autoscaling
kubectl apply -f k8s/metrics.yaml
kubectl apply -f k8s/hpa.yaml
