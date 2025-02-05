package templates

import (
	"strings"

	sourcev1 "github.com/piwaka/cue-schemas/source.toolkit.fluxcd.io/ocirepository/v1beta2"
	timoniv1 "github.com/piwaka/cue-schemas/timoni.sh/core/v1alpha1"
)

#OCIRepository: sourcev1.#OCIRepository & {
	#config: #Config
	metadata: {
		name:        #config.metadata.name
		namespace:   #config.targetNamespace
		labels:      #config.metadata.labels
		annotations: #config.metadata.annotations
	}
	spec: sourcev1.#OCIRepositorySpec & {
		interval: "\(#config.helm.sync.interval)m"
		url:      #config.helm.repository.url + "/" + #config.helm.chart.name
		ref: semver: #config.helm.chart.version
		provider: #config.helm.repository.provider
		if #config.helm.repository.auth != _|_ {
			secretRef: name: "\(#config.metadata.name)-helm-auth"
		}
		if #config.helm.repository.insecure {
			insecure: #config.helm.repository.insecure
		}
	}
}

#OCIRepositoryAuth: timoniv1.#ImagePullSecret & {
	#config: #Config
	#Meta: {
		name:        #config.metadata.name
		namespace:   #config.targetNamespace
		labels:      #config.metadata.labels
		annotations: #config.metadata.annotations
	}
	#Suffix:   "-helm-auth"
	#Registry: strings.Split(#config.helm.repository.url, "/")[2]
	#Username: #config.helm.repository.auth.username
	#Password: #config.helm.repository.auth.password
}
