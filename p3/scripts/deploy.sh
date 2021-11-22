CLUSTER=${CLUSTER:=wquinoaS}
sudo k3d cluster create $CLUSTER
export KUBECONFIG=$(sudo k3d kubeconfig write $CLUSTER)
sudo chown $(id -u):$(id -g) $KUBECONFIG

cat << EOF > $HOME/.bashrc
export KUBECONFIG=$KUBECONFIG
export CLUSTER=$CLUSTER
alias k=kubectl
EOF

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
echo $pass | tee /vagrant/argopasswd
echo "kubectl port-forward svc/argocd-server -n argocd 8080:80 --address=0.0.0.0 &\n
kubectl port-forward svc/argocd-server -n argocd 8443:443 --address=0.0.0.0 &"
