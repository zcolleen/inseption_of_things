
sudo k3d cluster start $CLUSTER

kubectl create ns argocd
kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml
kubectl create ns dev
kubectl apply -n dev -f https://raw.githubusercontent.com/wquinoa/stealing_apps_with_wquinoa/master/wils.yaml
