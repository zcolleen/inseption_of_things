       
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
# kubectl create namespace gitlab
# kubectl create namespace dev
# helm repo add gitlab https://charts.gitlab.io
# helm install --namespace gitlab gitlab-runner -f ./config/values.yaml gitlab/gitlab-runner
# kubectl apply -f ./config/svaccounts.yaml


cp -r /srv/gitlab ~/gitlab
chmod -R 0777 ~/gitlab
export GITLAB_HOME=~/gitlab
docker run --detach \
  --hostname gitlab.ndreadno.com \
  --publish 443:443 --publish 80:80 --publish 2222:22 \
  --name gitlab \
  --restart always \
  --volume $GITLAB_HOME/config:/etc/gitlab \
  --volume $GITLAB_HOME/logs:/var/log/gitlab \
  --volume $GITLAB_HOME/data:/var/opt/gitlab \
  -e GITLAB_SKIP_UNMIGRATED_DATA_CHECK=true \
  --cpus 3 \
  --memory 4294967296 \
  gitlab/gitlab-ee:latest

echo "127.0.0.1           gitlab.ndreadno.com" >> /etc/hosts
