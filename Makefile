images-local: image-sidecar-local image-webhook-local
images: image-sidecar image-webhook

image-sidecar:
	cd docker/sidecar && \
	gcloud container builds submit --config cloudbuild.yaml .

image-webhook:
	cd docker/webhook && \
	gcloud container builds submit --config cloudbuild-webhook.yaml .

image-sidecar-local:
	docker build -t horodchukanton/tproxy-sidecar -f docker/sidecar/Dockerfile-sidecar.local .
	docker push horodchukanton/tproxy-sidecar

image-webhook-local:
	docker build -t horodchukanton/tproxy-webhook -f docker/webhook/Dockerfile-webhook.local .
	docker push horodchukanton/tproxy-webhook
