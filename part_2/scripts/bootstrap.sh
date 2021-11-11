
bootstrap() {
		systemctl stop firewalld
		systemctl disable firewalld
		systemctl mask --now firewalld
		
		curl -fsL https://get.k3s.io | sh -s - --config=$SHARED_PATH/k3s_args.yaml

		curl -fsL https://raw.githubusercontent.com/helm/helm/master/scripts/get-helm-3 | sh -
}

deploy() {
		export KUBECONFIG="/etc/rancher/k3s/k3s.yaml"

		for num in "one" "two" "three"; do
			helm install app-$num $SHARED_PATH/app-helm-chart \
				--set name=app-$num \
				--set message="Hello from app-$num"
		done

		kubectl scale --replicas=3 deployment/app-two

		kubectl wait \
			--for condition=complete job/helm-install-traefik-crd \
			--namespace kube-system \
			--timeout=2m 

		kubectl apply -f $SHARED_PATH/ingress.yaml
}

bootstrap || exit 1
deploy
