module: "github.com/piwaka/modules/cilium"
language: {
	version: "v0.11.0"
}
source: {
	kind: "self"
}
deps: {
	"github.com/piwaka/cue-schemas/k8s.io@v1": {
		v: "v1.32.1"
	}
	"github.com/piwaka/cue-schemas/helm.toolkit.fluxcd.io@v2": {
		v: "v2.4.0"
	}
	"github.com/piwaka/cue-schemas/source.toolkit.fluxcd.io@v2": {
		v: "v2.4.0"
	}
	"github.com/piwaka/cue-schemas/timoni.sh@v0": {
		v: "v0.23.0"
	}
}
