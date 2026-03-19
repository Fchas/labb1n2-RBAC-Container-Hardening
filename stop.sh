#!/bin/bash
set -e

# DevSecOps Environment Stop Script
# Removes all resources from the namespace

PROJECT_DIR="/home/frojdh/Documents/DevSecOps-v6"
NAMESPACE="lillteamet"
TEAM_NAME="Lillteamet"

echo "======================================"
echo "🛑 Stopping DevSecOps Environment"
echo "======================================"

# Check if kubectl can connect
if kubectl cluster-info >/dev/null 2>&1; then
    echo "📌 Removing resources from namespace: $NAMESPACE"

    # Delete deployments and services
    echo "🗑️ Deleting deployments and services..."
    kubectl delete deployment --all -n $NAMESPACE --ignore-not-found=true
    kubectl delete service --all -n $NAMESPACE --ignore-not-found=true
    kubectl delete configmap --all -n $NAMESPACE --ignore-not-found=true
    kubectl delete secret --all -n $NAMESPACE --ignore-not-found=true
    kubectl delete ingress --all -n $NAMESPACE --ignore-not-found=true
    kubectl delete certificate --all -n $NAMESPACE --ignore-not-found=true

    # Delete RBAC resources
    echo "🔓 Removing RBAC resources..."
    kubectl delete rolebinding --all -n $NAMESPACE --ignore-not-found=true
    kubectl delete role --all -n $NAMESPACE --ignore-not-found=true
    kubectl delete serviceaccount --all -n $NAMESPACE --ignore-not-found=true

    echo "✅ Kubernetes resources removed"
else
    echo "⚠️ Cannot connect to Kubernetes cluster, skipping Kubernetes cleanup"
fi

# Run Terraform destroy
cd "$PROJECT_DIR"
if [ -f "terraform.tfstate" ]; then
    echo "⚡ Running Terraform destroy..."
    terraform destroy -auto-approve \
      -var="namespace=$NAMESPACE" \
      -var="team_name=$TEAM_NAME" \
      -var="environment=development"
else
    echo "⚠️ Terraform state not found, skipping destroy"
fi

echo "======================================"
echo "✅ DevSecOps environment stopped"
echo "======================================"