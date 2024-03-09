# OBSERVABILITY SYSTEMS

This project contains a Flask app that has been containerized and pushed to Dockerhub. The goal is to deploy this app in an AWS EKS clusteR and then collect logs with Fluentd, store them with Prometheus and display them on Grafana dashboards.

## Architecture

![architecture](./public/images/architecture.png)

## Prerequisites

Before proceeding, ensure you have the following prerequisites installed:

- [AWS CLI](https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html)
- [Kubectl](https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html)
- [Terraform](https://developer.hashicorp.com/terraform/install) (version 0.15.0)

And optionally:

- [Pip](https://pip.pypa.io/en/stable/installation/)
- [Docker hub account](https://hub.docker.com/)
- [Python](https://docs.python.org/3/using/index.html)

## App

This is a dockerized app that is available on docker hub. We will use this app to run on our AWS EKS.
To install the dependencies, please use: `pip3 install -r requirements.txt`

## How to provision resources

The terraform file on the root will provision an EKS cluster with a worker node group of max 2 and min 1 nodes.

```sh
$ terraform init
$ terraform plan
$ terraform apply --auto-approve
```

## How to run containerized app on AWS EKS cluster

Add your eks context and confirm that you see you nodes.

```sh
$ aws eks update-kubeconfig --region <your-region> --name <your-cluster-name>
$ kubectl get nodes
```

Apply the kubernetes deployment and services to your cluster.

```sh
$ kubectl apply -f deployment.yaml
$ kubectl apply -f service.yaml
```

Get your load balancer external ip with `kubectl get svc my-app-service -o wide`.
See `Success! Welcome To My App!` on the screen.

## How to start observability sytems

Create an RBAC role and role bindings to grant Fluentd access to the necessary Kubernetes resources, such as pods, namespaces, and service accounts

```sh
$ kubectl apply -f fluentd-rbac.yaml
```

Create a Kubernetes service account for Fluentd and bind it to the appropriate RBAC role.

```sh
$ kubectl apply -f fluentd-serviceaccount.yaml
```

Apply the config maps for fluentd, prometheus and grafana to the cluster.
Fluentd is configured to forward and log everything.

```sh
$ kubectl create configmap fluentd-config --from-file=fluentd.conf
$ kubectl create configmap prometheus-config --from-file=prometheus-conf.yml
$ kubectl create configmap grafana-config --from-file=grafana.ini
```

Apply the fluentd daemonset, prometheus and grafana service and deployments to the cluster.

```sh
$ kubectl apply -f fluentd.yaml
$ kubectl apply -f prometheus-deploy.yaml
$ kubectl apply -f grafana.yaml
```

## How to destroy provisioned resources

```sh
$ terraform destroy --auto-approve
```

## URL to public GitHub repo

https://github.com/LaraTunc/wcd-8-observability

## Dockerhub Image

https://hub.docker.com/repository/docker/laratunc/simple_flask_app/general

## Docs

- https://docs.fluentd.org/
- https://github.com/fluent/fluentd/tree/master
- https://prometheus.io/docs/introduction/overview/
- https://grafana.com/docs/grafana/latest/
- https://grafana.com/docs/grafana/latest/setup-grafana/installation/kubernetes/
- https://grafana.com/grafana/dashboards/
- https://docs.fluentd.org/monitoring-fluentd/monitoring-prometheus
- https://grafana.com/docs/grafana/latest/datasources/prometheus/
