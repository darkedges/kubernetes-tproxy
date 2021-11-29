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

## Usage:
- Create a namespace 'injection' (or change the name in values.yaml)
- Add a label 'injector-enabled:true'
- Go to the 'charts/tproxy'
- Run the script './webhook-create-signed-cert.sh' to generate webhook service certificate and get the Kubernetes CA bundle.
- Get the mitmproxy certificates to './certs' folder. ``docker run --rm -v ${PWD}/certs/:/home/mitmproxy/.mitmproxy mitmproxy/mitmproxy >/dev/null 2>&1``
- Deploy the chart as ``helm install webhook .``
- Run Deployment with annotation _"sidecar-injector-webhook.webhook.me/inject": enabled_ to the 'injection' namespace
