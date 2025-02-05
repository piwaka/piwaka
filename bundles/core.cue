package bundles

import (
	piwakav1 "github.com/piwaka/piwaka/v1alpha1"
)

cluster: piwakav1.#ClusterConfig
if cluster.distro == "kind" {
	kindConfig: piwakav1.#KindConfig & {#config: cluster}
}

bundle: {
	apiVersion: "v1alpha1"
	name:       "core"
	instances: {
		"flux": {
			module: url: "file://../modules/flux-aio"
			namespace: bundle.name
			values: {
				hostNetwork:        true
				securityProfile:    "privileged"
				podSecurityProfile: "privileged"
				env: {
					"KUBERNETES_SERVICE_HOST": cluster.k8sServiceHost
					"KUBERNETES_SERVICE_PORT": "\(cluster.k8sServicePort)"
				}
				targetNamespace: "\(namespace)-flux"
			}
		}
		"cilium": {
			module: url: "file://../modules/cilium"
			namespace: bundle.name
			values: {
				helm: {
					chart: version: "1.17.0"
					if cluster.distro == "kind" {
						values: operator: replicas: 1
					}
				}
				k8sServiceHost:  cluster.k8sServiceHost
				k8sServicePort:  cluster.k8sServicePort
				targetNamespace: "\(namespace)-cilium"
			}
		}
	}
}
