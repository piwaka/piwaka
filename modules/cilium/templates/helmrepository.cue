package templates

import (
	sourcev1 "github.com/piwaka/cue-schemas/source.toolkit.fluxcd.io/helmrepository/v1"
)

#HelmRepository: sourcev1.#HelmRepository & {
	#config: #Config
	metadata: {
		name:        #config.metadata.name
		namespace:   #config.targetNamespace
		labels:      #config.metadata.labels
		annotations: #config.metadata.annotations
	}
	spec: sourcev1.#HelmRepositorySpec & {
		interval: "12h"
		url:      #config.helm.repository.url
		if #config.helm.repository.auth != _|_ {
			secretRef: name: "\(#config.metadata.name)-helm-auth"
		}
		if #config.helm.repository.insecure {
			insecure: true
		}
		provider: #config.helm.repository.provider
	}
}

#HelmRepositoryAuth: {
	#config:    #Config
	apiVersion: "v1"
	kind:       "Secret"
	metadata: {
		name:        "\(#config.metadata.name)-helm-auth"
		namespace:   #config.targetNamespace
		labels:      #config.metadata.labels
		annotations: #config.metadata.annotations
	}
	stringData: {
		if #config.helm.repository.auth != _|_ {
			username: #config.helm.repository.auth.username
			password: #config.helm.repository.auth.password
		}
	}
}
