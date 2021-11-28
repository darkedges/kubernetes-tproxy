dockerfiles_folder = docker
docker_repo = horodchukanton
docker_image_prefix = tproxy

firewall_init_image_name = ${docker_image_prefix}-firewall
mitmproxy_sidecar_image_name = ${docker_image_prefix}-mitmproxy
webhook_image_name = ${docker_image_prefix}-webhook

images-local: build-images-local push-images-local

build-images-local: build-image-firewall-init-local \
                    build-image-sidecar-local \
                    build-image-webhook-local
push-images-local:	push-image-firewall-init-local \
                    push-image-sidecar-local \
                    push-image-webhook-local

images: image-firewall-init image-sidecar image-webhook

image-firewall-init:
	cd ${dockerfiles_folder}/init-firewall && \
	  gcloud container builds submit --config cloudbuild.yaml .

image-sidecar:
	cd ${dockerfiles_folder}/mitmproxy-sidecar && \
	  gcloud container builds submit --config cloudbuild.yaml .

image-webhook:
	cd ${dockerfiles_folder}/webhook && \
		gcloud container builds submit --config cloudbuild-webhook.yaml .

build-image-firewall-init-local:
	cd ${dockerfiles_folder}/init-firewall && \
		docker build -t ${docker_repo}/${firewall_init_image_name} -f Dockerfile .
build-image-sidecar-local:
	cd ${dockerfiles_folder}/mitmproxy-sidecar && \
		docker build -t ${docker_repo}/${mitmproxy_sidecar_image_name} -f Dockerfile .
build-image-webhook-local:
	docker build -t ${docker_repo}/${webhook_image_name} \
		-f ${dockerfiles_folder}/webhook/Dockerfile-webhook.local .

push-image-firewall-init-local:
	docker push ${docker_repo}/${firewall_init_image_name}
push-image-sidecar-local:
	docker push ${docker_repo}/${mitmproxy_sidecar_image_name}
push-image-webhook-local:
	docker push ${docker_repo}/${webhook_image_name}
