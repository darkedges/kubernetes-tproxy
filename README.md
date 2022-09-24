# Kubernetes Transparent Outbound Proxy

! This fork is very different from upstream

* Using mutating webhooks instead of injector
* No podwatch to fix the rules
* The proxy is OUTBOUND (listens to the outcoming connections)
* The standard mode proxy and RBAC is not tested
* The project is in early alpha state. You will most probably have to update the code to achieve the goal
* Proxy container uses NET_ADMIN and NET_RAW security capabilities

Assuming the written above - why should I keep it?
Well, the answer is - there's nothing else on internet that works in a modern Kubernetes. This is one of the most complete implementations.

## Usage

* Create a namespace 'injection' (or change the name in values.yaml)
  `kubectl create namespace injection`
* Add a label 'injector-enabled:true'
  `kubectl label namespaces injection sidecar-injection=enabled`
* Create a namespace 'injector' (or change the name in values.yaml)
  `kubectl create namespace injector`
* Go to the `charts/tproxy`
  `cd charts/tproxy`
* Run the script `./webhook-create-signed-cert.sh` to generate webhook service certificate and get the Kubernetes CA bundle.
  `./webhook-create-signed-cert.sh`
* Get the mitmproxy certificates to './certs' folder.
  `docker run --rm -it -v ${PWD}/certs/:/home/mitmproxy/.mitmproxy -p 8080:8080 mitmproxy/mitmproxy`
* configure your browser to use the proxy and got to <http://mitm.it/> and click on the `Get mitim-proxy-ca-cert.pem` to download into the `certs` directory.
* Deploy the chart as
  `helm install webhook .`
* Run Deployment with annotation *"sidecar-injector-webhook.webhook.me/inject": enabled* to the 'injection' namespace

## Reference

This is a list of sources I've used to craft this:

### Origin

* <https://github.com/mitmproxy/mitmproxy>
* <https://github.com/danisla/kubernetes-tproxy>

### Mutating webhook

* <https://github.com/tumblr/k8s-sidecar-injector>
* <https://github.com/morvencao/kube-mutating-webhook-tutorial>

### Firewall rules to transparently route the traffic

* <https://github.com/istio/istio>
* <https://github.com/istio/istio/wiki/Understanding-IPTables-snapshot>
