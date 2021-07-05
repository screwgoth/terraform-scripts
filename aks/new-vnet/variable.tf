variable "appId" {
  description = "Azure Kubernetes Service Cluster service principal"
}

variable "password" {
  description = "Azure Kubernetes Service Cluster password"
}

variable "namePrefix" {
  description = "Azure Resource Group and AKS name prefix"
  default = "RasDev"
}