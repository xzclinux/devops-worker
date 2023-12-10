curl https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3 | bash
helm repo add nginx https://kubernetes.github.io/ingress-nginx
export KUBECONFIG=./init/kubeconfig-node01.yaml
helm upgrade --install  ingress-nginx nginx/ingress-nginx --version 4.8.3 --timeout 600s -n kube-system
export KUBECONFIG=./init/kubeconfig-node02.yaml
helm upgrade --install  ingress-nginx nginx/ingress-nginx --version 4.8.3 --timeout 600s -n kube-system