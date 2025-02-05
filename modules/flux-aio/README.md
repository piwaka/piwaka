# Flux

Flux All-In-One is an experimental distribution made with [Timoni](https://github.com/stefanprodan/timoni)
for deploying [Flux](https://fluxcd.io) on Kubernetes clusters.

The main difference to the upstream distribution, is that Flux AIO bundles
all the controllers into a single Kubernetes Deployment.
The communication between controllers happens on the loopback interface, hence
Flux can function on clusters which don't have a CNI plugin installed.
This allows Kubernetes operators to setup their clusters networking in a GitOps way.
