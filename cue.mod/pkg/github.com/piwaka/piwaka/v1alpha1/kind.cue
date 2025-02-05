package v1alpha1

#KindConfig: {
	#config:    #ClusterConfig
	apiVersion: "kind.x-k8s.io/v1alpha4"
	kind:       "Cluster"
	name:       #config.name
	networking: {
		podSubnet:         #config.podSubnet
		serviceSubnet:     #config.serviceSubnet
		disableDefaultCNI: true
		kubeProxyMode:     "none"
	}
  ...
}
