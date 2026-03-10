#!/bin/bash
set -e

# DevSecOps Environment Start Script
# Applies RBAC, hardened deployments, and infrastructure
# Assumes Kubernetes cluster is already running

PROJECT_DIR="/home/frojdh/Documents/DevSecOps-v6"
NAMESPACE="lillteamet"
TEAM_NAME="Lillteamet"

echo "======================================"
echo "🚀 Starting DevSecOps Environment"
echo "======================================"

# Check if kubectl can connect (try to get version)
if ! kubectl version --client >/dev/null 2>&1; then
    echo "❌ Error: kubectl not configured properly"
    echo "Please ensure kubeconfig is set"
    exit 1
fi

echo "📌 Using namespace: $NAMESPACE"

# Create namespace if it doesn't exist
kubectl get namespace $NAMESPACE >/dev/null 2>&1 || kubectl create namespace $NAMESPACE

# Apply RBAC policies
echo "🔒 Applying RBAC hardening..."
kubectl apply -f 5-monitor-serviceaccount.yaml -n $NAMESPACE
kubectl apply -f read-only-role.yaml -n $NAMESPACE
kubectl apply -f deploy-manager-role.yaml -n $NAMESPACE
kubectl apply -f deploy-binding.yaml -n $NAMESPACE

# Apply infrastructure
echo "🏗️ Applying infrastructure..."
kubectl apply -f 1-redis-deployment.yaml -n $NAMESPACE
kubectl apply -f 2-api-config.yaml -n $NAMESPACE
kubectl apply -f 6-monitor-config.yaml -n $NAMESPACE
kubectl apply -f 7-monitor-secret.yaml -n $NAMESPACE

# Apply hardened deployments
echo "🛡️ Applying hardened deployments..."
kubectl apply -f api-deployment-hardened.yaml -n $NAMESPACE
kubectl apply -f 8-monitor-deployment.yaml -n $NAMESPACE
kubectl apply -f frontend-deployment-hardened.yaml -n $NAMESPACE

# Apply networking
echo "🌐 Applying networking..."
kubectl apply -f 9-ingress.yaml -n $NAMESPACE
kubectl apply -f 10-certificate.yaml -n $NAMESPACE

# Run Terraform
# cd "$PROJECT_DIR"
# echo "⚡ Running Terraform..."
# terraform init
# terraform apply -auto-approve \
#   -var="namespace=$NAMESPACE" \
#   -var="team_name=$TEAM_NAME" \
#   -var="environment=development"

# Wait for deployments
echo "⏳ Waiting for deployments to be ready..."
kubectl wait --for=condition=available --timeout=300s deployment/redis -n $NAMESPACE
kubectl wait --for=condition=available --timeout=300s deployment/api -n $NAMESPACE
kubectl wait --for=condition=available --timeout=300s deployment/frontend -n $NAMESPACE
kubectl wait --for=condition=available --timeout=300s deployment/team-monitor -n $NAMESPACE

# Show status
echo "📊 Environment Status:"
kubectl get all -n $NAMESPACE

echo "======================================"
echo "✅ DevSecOps environment is ready!"
echo "======================================"