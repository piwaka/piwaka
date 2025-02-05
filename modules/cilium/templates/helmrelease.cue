package templates

import (
	"strings"

	helmv2 "github.com/piwaka/cue-schemas/helm.toolkit.fluxcd.io/helmrelease/v2"
)

#HelmRelease: helmv2.#HelmRelease & {
	#config: #Config
	metadata: {
		name:        #config.metadata.name
		namespace:   #config.targetNamespace
		labels:      #config.metadata.labels
		annotations: #config.metadata.annotations
	}
	spec: helmv2.#HelmReleaseSpec & {
		releaseName: "\(#config.metadata.name)"
		interval:    "\(#config.helm.sync.interval)m"
		timeout:     "\(#config.helm.sync.timeout)m"

		if #config.helm.sync.serviceAccountName != _|_ {
			serviceAccountName: #config.helm.sync.serviceAccountName
		}

		if !strings.HasPrefix(#config.helm.repository.url, "oci://") {
			chart: {
				metadata: {
					labels:      #config.metadata.labels
					annotations: #config.metadata.annotations
				}
				spec: {
					chart:   "\(#config.helm.chart.name)"
					version: "\(#config.helm.chart.version)"
					sourceRef: {
						kind: "HelmRepository"
						name: "\(#config.metadata.name)"
					}
					interval: "\(#config.helm.sync.interval)m"
				}
			}
		}

		if strings.HasPrefix(#config.helm.repository.url, "oci://") {
			chartRef: {
				kind: "OCIRepository"
				name: "\(#config.metadata.name)"
			}
		}

		install: {
			crds: "Skip"
			remediation: retries: #config.helm.sync.retries
			disableWait:        #config.helm.sync.disableWait
			disableWaitForJobs: #config.helm.sync.disableWait
		}

		upgrade: {
			crds: "Skip"
			remediation: retries: #config.helm.sync.retries
			disableWait:        #config.helm.sync.disableWait
			disableWaitForJobs: #config.helm.sync.disableWait
		}

		test: enable: #config.helm.test
		values: #config.helm.values

		if #config.helm.dependsOn != _|_ {
			dependsOn: #config.helm.dependsOn
		}

		if #config.helm.driftDetection != _|_ {
			driftDetection: mode: #config.helm.driftDetection
		}
	}
}
