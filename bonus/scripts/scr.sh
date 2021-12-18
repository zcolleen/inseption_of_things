       
nslookup get.docker.com
curl -fsSL https://get.docker.com | bash
usermod -aG docker $USER
export RHOME=/home/vagrant


curl -s https://raw.githubusercontent.com/rancher/k3d/main/install.sh | bash

curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl

# argo cd
curl -fsSL -o /usr/local/bin/argocd https://github.com/argoproj/argo-cd/releases/latest/download/argocd-linux-amd64
chmod +x /usr/local/bin/argocd

apt-get update && sudo apt-get install -y apt-transport-https ca-certificates gnupg lsb-release
curl https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3 | bash
k3d cluster create gitlab

cat <<- EOF > $HOME/.bashrc && source $HOME/.bashrc
	export KUBECONFIG=$(k3d kubeconfig write gitlab)
	alias k=kubectl
EOF
chown $(id -u):$(id -g) $KUBECONFIG


kubectl create ns argocd
kubectl create ns dev
kubectl create ns gitlab
kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml
kubectl patch svc argocd-server -n argocd -p '{"spec": {"type": "LoadBalancer"}}'

# gitlab
chmod -R 0777 $RHOME/gitlab/data
export GITLAB_HOME=$RHOME/gitlab/
export IP=$(netstat -rn | grep "^0.0.0.0 " | cut -d " " -f10)
sed -i "s/var/$IP/g" $RHOME/config/app.yaml

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


kubectl apply -n argocd -f $RHOME/config/app.yaml

echo Waiting for argocd web-interface endpoint...
echo You CAN ssh into the machine in another terminal.

params="-n argocd -l app.kubernetes.io/name=argocd-server --timeout=10m"
kubectl wait --for=condition=available deployment $params
kubectl wait --for=condition=ready pod $params

pass=$(kubectl get secret argocd-initial-admin-secret -n argocd -o jsonpath={.data.password} | base64 --decode)
echo $pass | tee $RHOME/argopasswd | sed "s|^|Argocd password: |g"
