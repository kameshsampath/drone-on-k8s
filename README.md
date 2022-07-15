# Yours KinDly Drone

A small demo and setup to demonstrate on how to setup [Drone](https://drone.io) with local Kubernetes Cluster.

## Required tools

- Docker for Desktop for Mac/Windows or Docker for Linux
- KinD
- Helm
- Kustomize

## Create Kubernetes Cluster

```shell
./bin/kind.sh
```

## Deploy Gitea

__TODO__: Use custom namespace ??

```shell
helm repo add gitea-charts https://dl.gitea.io/charts/
helm repo update
helm upgrade --install gitea gitea-charts/gitea -f $PROJECT_HOME/helm_vars/gitea/values.yaml --wait
```

Wait for `gitea` to be ready,

```shell
kubectl rollout status statefulset gitea --timeout-60s
```

Open gitea with url <http://gitea-127.0.0.1.sslip.io:3000>

## Deploy Drone

__TODO__: Use custom namespace ??

```shell
kustomize build k8s/. | kubectl apply -f - 
```

```shell
helm repo add drone https://charts.drone.io
helm repo update
helm upgrade --install drone drone/drone -f $PROJECT_HOME/helm_vars/drone/values.yaml --wait
```

Open drone with url <http://drone-127.0.0.1.sslip.io:8080>

## Build Binaries

The demo uses a [util](./util/) code to configure Gitea, you can build the code using the command

```shell
./build.sh
```

The command generates a binary in $PROJECT_HOME/bin for each OS/Arch combination. Use the one that suits your OS/Arch combo.