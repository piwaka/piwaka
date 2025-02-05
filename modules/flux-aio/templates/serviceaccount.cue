package templates

import (
	corev1 "github.com/piwaka/cue-schemas/k8s.io/api/core/v1"
)

#ServiceAccount: corev1.#ServiceAccount & {
	#config:    #Config
	apiVersion: "v1"
	kind:       "ServiceAccount"
	metadata: {
		name:        #config.metadata.name
		namespace:   #config.targetNamespace
		labels:      #config.metadata.labels
		annotations: #config.metadata.annotations
	}
	if #config.workload.provider == "aws" {
		metadata: annotations: "eks.amazonaws.com/role-arn": #config.workload.identity
	}
	if #config.workload.provider == "azure" {
		metadata: labels: "azure.workload.identity/use":            "true"
		metadata: annotations: "azure.workload.identity/client-id": #config.workload.identity
	}
	if #config.workload.provider == "gcp" {
		metadata: annotations: "iam.gke.io/gcp-service-account": #config.workload.identity
	}
}
