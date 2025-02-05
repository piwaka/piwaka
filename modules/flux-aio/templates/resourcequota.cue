package templates

import (
	corev1 "github.com/piwaka/cue-schemas/k8s.io/api/core/v1"
)

#ResourceQuota: corev1.#ResourceQuota & {
	#config:    #Config
	apiVersion: "v1"
	kind:       "ResourceQuota"
	metadata: {
		name:        #config.metadata.name
		namespace:   #config.targetNamespace
		labels:      #config.metadata.labels
		annotations: #config.metadata.annotations
	}
	spec: {
		hard: pods: "1000"
		scopeSelector: matchExpressions: [{
			operator:  "In"
			scopeName: "PriorityClass"
			values: ["system-node-critical", "system-cluster-critical"]
		}]
	}
}
