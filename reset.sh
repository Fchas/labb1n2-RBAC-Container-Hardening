#!/bin/bash
set -e

# DevSecOps Factory Reset Script
# Completely cleans the environment and resets Terraform state
# Does NOT start or stop the cluster itself

PROJECT_DIR="/home/frojdh/Documents/DevSecOps-v6"
NAMESPACE="lillteamet"

echo "======================================"
echo "🧹 Factory Reset: Complete Cleanup"
echo "======================================"

# Check if kubectl can connect (optional, for resource cleanup)
if kubectl cluster-info >/dev/null 2>&1; then
    echo "🗑️ Removing all resources from namespace: $NAMESPACE"

    # Force delete all resources
    kubectl delete all --all -n $NAMESPACE --ignore-not-found=true
    kubectl delete configmap --all -n $NAMESPACE --ignore-not-found=true
    kubectl delete secret --all -n $NAMESPACE --ignore-not-found=true
    kubectl delete ingress --all -n $NAMESPACE --ignore-not-found=true
    kubectl delete certificate --all -n $NAMESPACE --ignore-not-found=true
    kubectl delete rolebinding --all -n $NAMESPACE --ignore-not-found=true
    kubectl delete role --all -n $NAMESPACE --ignore-not-found=true
    kubectl delete serviceaccount --all -n $NAMESPACE --ignore-not-found=true

    # Delete namespace
    kubectl delete namespace $NAMESPACE --ignore-not-found=true

    echo "✅ Kubernetes resources cleaned"
else
    echo "⚠️ Cannot connect to cluster, skipping resource cleanup"
fi

# Clean Terraform state
cd "$PROJECT_DIR"
echo "🧽 Cleaning Terraform state..."
rm -f terraform.tfstate terraform.tfstate.backup
rm -rf .terraform

echo "📁 Removing temporary files..."
rm -f *.log
rm -rf tmp/

echo "======================================"
echo "✅ Factory reset complete"
echo "Environment is clean and ready for fresh deployment"
echo "======================================"