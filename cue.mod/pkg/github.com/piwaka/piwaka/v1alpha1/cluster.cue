package v1alpha1

import (
	"net"
	"strings"
)

#ClusterConfig: {
	name:          string & =~"^(([A-Za-z0-9][-A-Za-z0-9_.]*)?[A-Za-z0-9])?$" & strings.MinRunes(1) & strings.MaxRunes(63)
	domain:        net.FQDN
	fqdn:          net.FQDN | *"\(name).\(domain)"
	distro:        "kind"
	platform:      "container"
	podSubnet:     net.IPCIDR | *"10.244.0.0/16"
	serviceSubnet: net.IPCIDR | *"10.96.0.0/16"
	k8sServiceHost: string
	k8sServicePort: int & >0 & <65335
	if distro == "kind" {
		k8sServiceHost: "\(name)-control-plane"
		k8sServicePort: 6443
	}
}
