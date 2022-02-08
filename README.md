# deployment-manifests

Manifests required to deploy the application to the Kubernetes cluster

In order to deploy application to the Kubernetes cluster, you need to run the following commands:

#Create local cluster
```
minikube start
```
#Install Istio(Including Egress)

```
istioctl install --set components.egressGateways[0].name=istio-egressgateway --set components.egressGateways[0].enabled=true
```

#Create Namespace

```
kubectl create namespace xeelver
kubectl create namespace keycloak
```

#Enable proxy injection

```
kubectl label namespace xeelver istio-injection=enabled
```

#Configure Ingress(Non istio)

```
kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/controller-v0.45.0/deploy/static/provider/cloud/deploy.yaml
kubectl wait --namespace ingress-nginx --for=condition=ready pod --selector=app.kubernetes.io/component=controller --timeout=90s

or for minikube


minikube addons enable ingress
```

#Configure Gateway(Istio)

```
kubectl apply -f egress-gateway.yml
kubectl apply -f external-mysql-svc.yml
kubectl apply -f ingress-gateway.yml
kubectl apply -f klarna-egress.yml
```

#Deploy secrets
```
kubectl apply -f secret\api-secret.yml
kubectl apply -f secret\cache-secret.yml
kubectl apply -f secret\keycloak-secret.yml
kubectl apply -f secret\klarna-secret.yml
```

#Deploy policy
```
kubectl apply -f policy\authorization-policy.yml
kubectl apply -f policy\peer-authentication.yml
kubectl apply -f policy\request-authentication.yml
```

#Deploy Frontend pod and Service
```
kubectl apply -f deployments\frontend-deployment.yml
kubectl apply -f services\frontend-service.yml
```
#Deploy booking pod and Service
```
kubectl apply -f deployments\booking-deployment.yml
kubectl apply -f services\booking-service.yml
```
#Deploy payment pod and Service
```
kubectl apply -f deployments\payment-deployment.yml
kubectl apply -f services\payment-service.yml
```
#Deploy search pod and Service
```
kubectl apply -f deployments\search-deployment.yml
kubectl apply -f services\search-service.yml
```
#Deploy Ingress controller for frontend and API 
```
kubectl apply -f ingress\frontend-ingress.yml
kubectl apply -f ingress\backend-ingress.yml
```
#Install Dashboard
```
helm install --set cr.create=true --set cr.namespace=istio-system --namespace kiali-operator --repo https://kiali.org/helm-charts kiali-operator kiali-operator

kubectl apply -f https://raw.githubusercontent.com/istio/istio/release-1.9/samples/addons/prometheus.yaml

kubectl apply -f https://raw.githubusercontent.com/istio/istio/release-1.9/samples/addons/jaeger.yaml

kubectl apply -f https://raw.githubusercontent.com/istio/istio/release-1.9/samples/addons/extras/zipkin.yaml

kubectl apply -f https://raw.githubusercontent.com/istio/istio/release-1.9/samples/addons/grafana.yaml
```
#Get Services
```
call kubectl get service
```
#Get pods(To see if containers are running)
```
call kubectl get pods -w
```