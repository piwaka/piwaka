package templates

import (
	corev1 "github.com/piwaka/cue-schemas/k8s.io/api/core/v1"
)

#PVC: corev1.#PersistentVolumeClaim & {
	#config:    #Config
	apiVersion: "v1"
	kind:       "PersistentVolumeClaim"
	metadata: {
		name:        #config.metadata.name
		namespace:   #config.targetNamespace
		labels:      #config.metadata.labels
		annotations: #config.metadata.annotations
	}
	spec: corev1.#PersistentVolumeClaimSpec & {
		storageClassName: #config.persistence.storageClass
		resources: requests: storage: #config.persistence.size
		accessModes: ["ReadWriteOnce"]
	}
}
