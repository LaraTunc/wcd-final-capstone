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

## How to destroy provisioned resources

```sh
$ terraform destroy --auto-approve
```

## URL to public GitHub repo

https://github.com/LaraTunc/wcd-7-kubernetes

## Dockerhub Image

https://hub.docker.com/repository/docker/laratunc/simple_flask_app/general

## Docs

- [Building multi platform images](https://docs.docker.com/build/building/multi-platform/)
- [Terraform aws eks github examples](https://github.com/terraform-aws-modules/terraform-aws-eks/tree/master/examples)
- [Terraform eks module](https://registry.terraform.io/modules/terraform-aws-modules/eks/aws/latest)
- `docker buildx build --platform linux/amd64,linux/arm64 -t <username>/<image> --push .`
