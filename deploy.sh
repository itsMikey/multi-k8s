# build our images
# we are using :latest to get our actual latest image but we are also using the $SHA to tag our image so that kubernetes knows to update the pod with the newly pushed image.
docker build -t immikey/multi-client:latest -t immikey/multi-client:$SHA -f ./client/Dockerfile ./client
docker build -t immikey/multi-server:latest -t immikey/multi-server:$SHA -f ./server/Dockerfile ./server
docker build -t immikey/multi-worker:latest -t immikey/multi-worker:$SHA -f ./worker/Dockerfile ./worker

# push to docker hub
docker push immikey/multi-client:latest
docker push immikey/multi-server:latest
docker push immikey/multi-worker:latest

docker push immikey/multi-client:$SHA
docker push immikey/multi-server:$SHA
docker push immikey/multi-worker:$SHA

# apply all config files in k8s directory
kubectl apply -f k8s
kubectl set image deployments/server-deployment server=immikey/multi-server:$SHA
kubectl set image deployments/client-deployment client=immikey/multi-client:$SHA
kubectl set image deployments/worker-deployment worker=immikey/multi-worker:$SHA