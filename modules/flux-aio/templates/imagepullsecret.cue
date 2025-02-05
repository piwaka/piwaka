package templates

import (
	timoniv1 "github.com/piwaka/cue-schemas/timoni.sh/core/v1alpha1"
)

#PullSecret: timoniv1.#ImagePullSecret & {
	#config: #Config
	#Meta: {
		name:        #config.metadata.name
		namespace:   #config.targetNamespace
		labels:      #config.metadata.labels
		annotations: #config.metadata.annotations
	}
	#Suffix:   "-image-pull"
	#Registry: #config.imagePullSecret.registry
	#Username: #config.imagePullSecret.username
	#Password: #config.imagePullSecret.password
}
