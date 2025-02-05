module: "github.com/piwaka/modules/flux-aio"
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
	"github.com/piwaka/cue-schemas/timoni.sh@v0": {
		v: "v0.23.0"
	}
}
