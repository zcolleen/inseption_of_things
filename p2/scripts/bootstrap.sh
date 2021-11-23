firewalld=/etc/firewalld

sudo cp "$SHARED_PATH/firewalld/k3s.xml" "$firewalld/services/k3s.xml"
cat <<- EOF >> "$HOME/.bashrc"
	alias k=kubectl
	alias ll="ls -la"
EOF

curl -fsL https://get.k3s.io | sh -s - --config="$SHARED_PATH/app/k3s_args.yaml"
curl -fsL https://raw.githubusercontent.com/helm/helm/master/scripts/get-helm-3 | sh -
for num in "one" "two" "three"; do
	helm install app-$num $SHARED_PATH/app/app-helm-chart \
		--set name=app-$num \
		--set message="Hello from app-$num" \
		--kubeconfig="/etc/rancher/k3s/k3s.yaml"
done
kubectl scale --replicas=3 deployment/app-two
kubectl wait \
	--for condition=complete job/helm-install-traefik-crd \
	--namespace kube-system \
	--timeout=5m 

echo "Add firewalld-service: $(sudo firewall-cmd --add-service=k3s --permanent)"
echo "Add firewalld-zone:    $(sudo firewall-cmd --add-masquerade  --permanent)"
echo "Reload firewalld:      $(sudo firewall-cmd --reload)"

kubectl apply -f "$SHARED_PATH/app/ingress.yaml"
