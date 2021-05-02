# deployment-manifests

Manifests required to deploy the application to the Kubernetes cluster

In order to deploy application to the Kubernetes cluster, you need to run the following commands:

#Create local cluster

minikube start

#Install Istio(Including Egress)

istioctl install --set components.egressGateways[0].name=istio-egressgateway --set components.egressGateways[0].enabled=true

#Create Namespace

kubectl create namespace xeelver

#Enable proxy injection

kubectl label namespace xeelver istio-injection=enabled

#Configure Ingress(Non istio)

kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/controller-v0.45.0/deploy/static/provider/cloud/deploy.yaml
kubectl wait --namespace ingress-nginx --for=condition=ready pod --selector=app.kubernetes.io/component=controller --timeout=90s

#Configure Gateway(Istio)

kubectl apply -f
kubectl apply -f

#Deploy Frontend pod and Service

kubectl apply -f deployments\frontend-deployment.yml
kubectl apply -f services\frontend-service.yml

#Deploy booking pod and Service

kubectl apply -f deployments\booking-deployment.yml
kubectl apply -f services\booking-service.yml

#Deploy payment pod and Service

kubectl apply -f deployments\payment-deployment.yml
kubectl apply -f services\payment-service.yml

#Deploy search pod and Service

kubectl apply -f deployments\search-deployment.yml
kubectl apply -f services\search-service.yml

#Deploy Ingress controller for frontend and API 

kubectl apply -f ingress\frontend-ingress.yml
kubectl apply -f ingress\backend-ingress.yml

#Install Dashboard
kubectl apply -f https://raw.githubusercontent.com/istio/istio/release-1.9/samples/addons/kiali.yaml

kubectl apply -f https://raw.githubusercontent.com/istio/istio/release-1.9/samples/addons/prometheus.yaml

kubectl apply -f https://raw.githubusercontent.com/istio/istio/release-1.9/samples/addons/jaeger.yaml

kubectl apply -f https://raw.githubusercontent.com/istio/istio/release-1.9/samples/addons/extras/zipkin.yaml

#Get Services

call kubectl get service

#Get pods(To see if containers are running)

call kubectl get pods -w