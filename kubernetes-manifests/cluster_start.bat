
#Configure Ingress
call kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/controller-v0.45.0/deploy/static/provider/cloud/deploy.yaml
call kubectl wait --namespace ingress-nginx --for=condition=ready pod --selector=app.kubernetes.io/component=controller --timeout=90s

#Configure Kubernetes
call kubectl apply -f deployments\frontend-deployment.yml
call kubectl apply -f services\frontend-service.yml

call kubectl apply -f deployments\booking-deployment.yml
call kubectl apply -f services\booking-service.yml

call kubectl apply -f deployments\payment-deployment.yml
call kubectl apply -f services\payment-service.yml

call kubectl apply -f deployments\search-deployment.yml
call kubectl apply -f services\search-service.yml

call kubectl apply -f ingress\frontend-ingress.yml
call kubectl apply -f ingress\backend-ingress.yml

#Get Services
call kubectl get service

#Get pods
call kubectl get pods -w