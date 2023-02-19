local-mongodb:
	ifeq ($(shell docker ps -a -q -f name=local-mongodb))
		#docker run --name local-mongodb -e MONGO_INITDB_ROOT_USERNAME=admin -p 27017:27017 -e MONGO_INITDB_ROOT_PASSWORD=password -d mongo:6.0.4
		echo "eh"
	endif
	

nolocal-mongodb:
	docker stop local-mongodb && docker rm local-mongodb

dev:
	docker-compose up

nodev:
	docker-compose down

build:
	docker-compose build
 
test:
	docker run -it -v $(shell pwd):/tmp/app -w /tmp/app --rm painless/tox:latest /bin/bash tox

deps:
	helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
	helm repo add stable https://charts.helm.sh/stable
	helm repo update

deploy:
	kubectl apply -f yaml/
	kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/main/deploy/static/provider/kind/deploy.yaml

# load-images:
# 	kind load docker-image intellygenz-mongodb-import:latest --name local-cluster

observability: deps
	kubectl create namespace monitoring
	kubectl apply -f https://github.com/kubernetes-sigs/metrics-server/releases/latest/download/components.yaml
	kubectl patch -n kube-system deployment metrics-server --type=json \
  	-p '[{"op":"add","path":"/spec/template/spec/containers/0/args/-","value":"--kubelet-insecure-tls"}]'

	helm install kind-prometheus prometheus-community/kube-prometheus-stack --namespace monitoring --set prometheus.service.nodePort=30000 --set prometheus.service.type=NodePort --set grafana.service.nodePort=31000 --set grafana.service.type=NodePort --set alertmanager.service.nodePort=32000 --set alertmanager.service.type=NodePort --set prometheus-node-exporter.service.nodePort=32001 --set prometheus-node-exporter.service.type=NodePort

bootstrap:
	scripts/kind-with-registry.sh
	kubectl create ns app
	$(MAKE) observability
	$(MAKE) build_and_push
	$(MAKE) deploy

build_and_push:
	scripts/build_and_push.sh

list-registry-tags:
	curl -X GET http://localhost:5001/v2/intellygenz/api/tags/list | jq

clean:
	kind delete cluster --name local-cluster

