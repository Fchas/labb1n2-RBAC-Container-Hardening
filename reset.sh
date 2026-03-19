#!/bin/bash
set -e

# DevSecOps Factory Reset Script
# Completely cleans the environment and resets Terraform state
# Does NOT start the cluster itself

PROJECT_DIR="/home/frojdh/Documents/DevSecOps-v6"
NAMESPACE="lillteamet"
TEAM_NAME="Lillteamet"

echo "======================================"
echo "🧹 Factory Reset: Complete Cleanup"
echo "======================================"

# Check if kubectl can connect
if kubectl cluster-info >/dev/null 2>&1; then
    echo "🗑️ Removing all resources from namespace: $NAMESPACE"

    # Delete all resources and namespace
    kubectl delete all --all -n $NAMESPACE --ignore-not-found=true
    kubectl delete configmap --all -n $NAMESPACE --ignore-not-found=true
    kubectl delete secret --all -n $NAMESPACE --ignore-not-found=true
    kubectl delete ingress --all -n $NAMESPACE --ignore-not-found=true
    kubectl delete certificate --all -n $NAMESPACE --ignore-not-found=true
    kubectl delete rolebinding --all -n $NAMESPACE --ignore-not-found=true
    kubectl delete role --all -n $NAMESPACE --ignore-not-found=true
    kubectl delete serviceaccount --all -n $NAMESPACE --ignore-not-found=true
    kubectl delete namespace $NAMESPACE --ignore-not-found=true

    echo "✅ Kubernetes resources cleaned"
else
    echo "⚠️ Cannot connect to cluster, skipping Kubernetes cleanup"
fi

# Clean Terraform state
cd "$PROJECT_DIR"
echo "🧽 Cleaning Terraform state..."
rm -f terraform.tfstate terraform.tfstate.backup
rm -rf .terraform

# Remove temporary files
echo "📁 Removing temporary files..."
rm -f *.log
rm -rf tmp/

echo "======================================"
echo "✅ Factory reset complete"
echo "Environment is clean and ready for fresh deployment"
echo "======================================"