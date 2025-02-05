package templates

import (
	corev1 "github.com/piwaka/cue-schemas/k8s.io/api/core/v1"
)

#Namespace: corev1.#Namespace & {
	#config:    #Config
	apiVersion: "v1"
	kind:       "Namespace"
	metadata: {
		name:        #config.targetNamespace
		annotations: #config.metadata.annotations
		labels:      #config.metadata.labels
		if #config.podSecurityProfile != "" {
			labels: {
				"pod-security.kubernetes.io/enforce": #config.podSecurityProfile
				"pod-security.kubernetes.io/warn":    #config.podSecurityProfile
				"pod-security.kubernetes.io/audit":   #config.podSecurityProfile
			}
		}
	}
}
