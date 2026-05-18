#!/usr/bin/env bash
set -euo pipefail

echo "=================================================="
echo "🚀 Deploying Observability Stack (Prometheus, Grafana, Loki)"
echo "=================================================="

# 1. Create Namespace
echo "Creating 'observability' namespace if it doesn't exist..."
kubectl create namespace observability --dry-run=client -o yaml | kubectl apply -f -

# 2. Add Helm repositories
echo "Adding Helm chart repositories..."
helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
helm repo add grafana https://grafana.github.io/helm-charts
helm repo update

# 3. Deploy Prometheus Stack
echo "Deploying/Upgrading Prometheus & Grafana (kube-prometheus-stack)..."
helm upgrade --install prometheus prometheus-community/kube-prometheus-stack \
  --namespace observability \
  --values /home/abu/Documents/SoloDevops/k8-manifests/observability/prometheus-values.yaml

# 4. Deploy Loki Stack
echo "Deploying/Upgrading Loki & Promtail (loki-stack)..."
helm upgrade --install loki grafana/loki-stack \
  --namespace observability \
  --values /home/abu/Documents/SoloDevops/k8-manifests/observability/loki-values.yaml

echo "=================================================="
echo "✅ Observability Stack successfully deployed!"
echo "=================================================="
echo "Use the following command to check resource status:"
echo "  kubectl get pods,pvc -n observability"
echo "=================================================="
