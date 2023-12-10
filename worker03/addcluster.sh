password=`kubectl get secrets -n argocd  argocd-initial-admin-secret -o custom-columns=:.data.password --no-headers=true --kubeconfig=../wo |basrker01/init/kubeconfig.yaml |base64 -d `
argocd login  argocd.xzclinux.gkdevopscamp2.com  --username=admin --password="${password}"
export KUBECONFIG=../worker02/init/kubeconfig-node01.yaml
node01_name=`kubectl config get-contexts -o name`
argocd cluster add  ${node01_name}
export KUBECONFIG=../worker02/init/kubeconfig-node02.yaml
node02_name=`kubectl config get-contexts -o name`
argocd cluster add  ${node02_name}