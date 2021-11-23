CLUSTER=${CLUSTER:=wquinoaS}
sudo k3d cluster create $CLUSTER

cat <<- EOF > $HOME/.bashrc && source $HOME/.bashrc
	export KUBECONFIG=$(sudo k3d kubeconfig write $CLUSTER)
	export CLUSTER=$CLUSTER
	alias k=kubectl
EOF
sudo chown $(id -u):$(id -g) $KUBECONFIG

kubectl create ns argocd
kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml
kubectl patch svc argocd-server -n argocd -p '{"spec": {"type": "LoadBalancer"}}'
kubectl apply -n argocd -f /vagrant/confs/app.yaml

echo Waiting for argocd web-interface endpoint...
echo You CAN ssh into the machine in another terminal.

params="-n argocd -l app.kubernetes.io/name=argocd-server --timeout=10m"
kubectl wait --for=condition=available deployment $params
kubectl wait --for=condition=ready pod $params

pass=$(kubectl get secret argocd-initial-admin-secret -n argocd -o jsonpath={.data.password} | base64 --decode)
echo $pass | tee /vagrant/argopasswd | sed "s|^|Argocd password: |g"
kubectl port-forward svc/argocd-server -n argocd 8080:80  --address=0.0.0.0 &
kubectl port-forward svc/argocd-server -n argocd 8443:443 --address=0.0.0.0 &
