# Deploying EKS Cluster

The `eks` folder further has folders for deploying Kubernetes cluster on an existing VPC or creating a new VPC (and other networking objects)
* `existing-vpc`
* `new-vpc`

The steps to deploy in either scenarios are the same.

# Deploying the EKS Cluster
### Before deploying
* Configure `aws-cli` to point to your AWS account and region
* Update the `variables.tf` file with required values

### Terraform commands
    $ terraform init
	$ terraform plan
	$ terraform deploy

### Update `kubeconfig` and verify
    $ aws eks --region $(terraform output -raw region) update-kubeconfig --name $(terraform output -raw cluster_name)
	$ kubectl get nodes

### Deploy Metrics Server and Dasboard
    $ wget -O v0.3.6.tar.gz https://codeload.github.com/kubernetes-sigs/metrics-server/tar.gz/v0.3.6 && tar -xzf v0.3.6.tar.gz
	$ tar zxvf v0.3.6.tar.gz 
	$ kubectl apply -f metrics-server-0.3.6/deploy/1.8+/
	$ kubectl get deployment metrics-server -n kube-system
	$ kubectl apply -f https://raw.githubusercontent.com/kubernetes/dashboard/v2.0.0-beta8/aio/deploy/recommended.yaml
	$ kubectl proxy
* Access the Kubernetes Dashboard at the following link:
http://127.0.0.1:8001/api/v1/namespaces/kubernetes-dashboard/services/https:kubernetes-dashboard:/proxy/

* Now, WITHOUT CLOSING the `kubectl proxy` terminal, in ANOTHER terminal:

      $ kubectl apply -f https://raw.githubusercontent.com/hashicorp/learn-terraform-provision-eks-cluster/master/kubernetes-dashboard-admin.rbac.yaml

* Generate Auth token

      $ kubectl -n kube-system describe secret $(kubectl -n kube-system get secret | grep service-controller-token | awk '{print $1}'