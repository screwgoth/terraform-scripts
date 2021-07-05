# Deploying AKS Cluster

The `aks` folder further has folders for deploying Kubernetes cluster on an existing VPC or creating a new VPC (and other networking objects)
* `new-vnet`

The steps to deploy in either scenarios are the same.

# Deploying the AKS Cluster
### Before deploying
* Login using `az-cli`
* Update the `terrform.tfvars` file with required values

### Terraform commands
    $ terraform init
	$ terraform plan
	$ terraform deploy

### Update `kubeconfig` and verify
    $ az aks get-credentials --resource-group $(terraform output -raw resource_group_name) --name $(terraform output -raw kubernetes_cluster_name)
	$ kubectl get nodes

### Deploy Dashboard
    $ kubectl create clusterrolebinding kubernetes-dashboard --clusterrole=cluster-admin --serviceaccount=kube-system:kubernetes-dashboard --user=clusterUser
	$ az aks browse --resource-group $(terraform output -raw resource_group_name) --name $(terraform output -raw kubernetes_cluster_name)

_Note_: This opens the Azure Portal's dashboard. Metric Server is already installed.
