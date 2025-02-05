package templates

import (
	runtime "github.com/piwaka/cue-schemas/k8s.io/apimachinery/pkg/runtime"
	timoniv1 "github.com/piwaka/cue-schemas/timoni.sh/core/v1alpha1"
	"strings"
)

#Config: {
	kubeVersion!: string
	clusterVersion: timoniv1.#SemVer & {#Version: kubeVersion, #Minimum: "1.20.0"}
	moduleVersion!: string
	metadata: timoniv1.#Metadata & {#Version: moduleVersion}
	metadata: labels:      timoniv1.#Labels
	metadata: annotations: timoniv1.#Annotations
	helm: {
		repository: {
			url: string & =~"^(http|https|oci)://.*$" | *"https://helm.cilium.io/"
			auth?: {
				username!: string
				password!: string
			}
			provider: *"generic" | "aws" | "azure" | "gcp"
			insecure: *false | bool
		}

		chart: {
			name:    string | *"cilium"
			version: string | *"*"
		}

		sync: {
			retries:             int | *-1
			interval:            int | *60
			timeout:             int | *5
			disableWait:         bool | *false
			serviceAccountName?: string
		}

		test: bool | *false

		driftDetection?: "enabled" | "warn" | "disabled"

		dependsOn?: [...{
			name:       string
			namespace?: string
		}]

		values: {...}
	}

	k8sServiceHost: string
	k8sServicePort: int & >0 & <65535

	targetNamespace: timoniv1.#InstanceNamespace | *metadata.namespace
}

#Instance: {
	config: #Config & {
		helm: values: {
			kubeProxyReplacement: true
			k8sServiceHost:       config.k8sServiceHost
			k8sServicePort:       config.k8sServicePort
			ipam: mode: "kubernetes"
		}
	}

	objects: [ID=_]: runtime.#Object

	objects: {
		for name, crd in customresourcedefinition {
			"\(name)": crd
			"\(name)": metadata: labels:      config.metadata.labels
			"\(name)": metadata: annotations: config.metadata.annotations
		}
	}

	objects: {
		namespace: #Namespace & {#config: config}
		helmrelease: #HelmRelease & {#config: config}
	}

	if strings.HasPrefix(config.helm.repository.url, "oci://") {
		objects: repository: #OCIRepository & {#config: config}
		if config.helm.repository.auth != _|_ {
			objects: secret: #OCIRepositoryAuth & {#config: config}
		}
	}

	if !strings.HasPrefix(config.helm.repository.url, "oci://") {
		objects: repository: #HelmRepository & {#config: config}
		if config.helm.repository.auth != _|_ {
			objects: secret: #HelmRepositoryAuth & {#config: config}
		}
	}
}
