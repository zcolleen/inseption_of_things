       
nslookup get.docker.com
curl -fsSL https://get.docker.com | bash
usermod -aG docker $USER

curl -s https://raw.githubusercontent.com/rancher/k3d/main/install.sh | bash

curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl

apt-get update && sudo apt-get install -y apt-transport-https ca-certificates gnupg lsb-release
curl https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3 | bash
k3d cluster create gitlab
export KUBECONFIG=$(sudo k3d kubeconfig write gitlab)
chmod 644 $KUBECONFIG
kubectl create namespace gitlab
kubectl create namespace dev
helm repo add gitlab https://charts.gitlab.io
helm install --namespace gitlab gitlab-runner -f ./config/values.yaml gitlab/gitlab-runner
kubectl apply -f ./config/svaccounts.yaml
