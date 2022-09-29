# Monolith to Microservices

## NOTE: This is not an officially supported Google product

## Introduction

### This project is used by the Google Cloud Platform team to demonstrate different services within Google Cloud. This project contains two versions of the same application, one architected as a monolith and the other as a set of microservices

## Setup

### **NOTE:** Make sure you have a newer version of NodeJS (16.13.0) or newer (in Cloud Shell you can run `nvm install --lts`)
### **NOTE:** Make sure you have a WSL installed (`wsl.exe`) to start bash command

```bash
git clone https://github.com/googlecodelabs/monolith-to-microservices
cd monolith-to-microservices
./setup.sh
```

## Monolith

### To run the monolith project use the following commands from the top level directory

```bash
cd monolith
npm start
```

You should see output similar to the following

```text
Monolith listening on port 8080!
```

#### That's it! You now have a perfectly functioning monolith running on your machine

## Microservices

### To run the microservices project use the following commands from the top level directory

```bash
cd microservices
npm start
```

You should see output similar to the following

```text
[0] Frontend microservice listening on port 8080!
[2] Orders microservice listening on port 8081!
[1] Products microservice listening on port 8082!
```

### That's it! You now have a perfectly functioning set of microservices running on your machine

### Cloud Run - Microservices

## **NOTE:** You need to create an artifact registry named `docker` for this part of the project and set the good IAM role to push artifacts

### To create a Docker image for the microservices, you will have to create a Docker image for each service. Execute the following commands for each folder under the microservices folder

### But you have to build docker instructions for both api services before
### And then ...

```bash
cd src/products
docker build -t europe-west1-docker.pkg.dev/gil-go-to-micro/docker/products:1.0.0 .

cd ../orders
docker build -t europe-west1-docker.pkg.dev/gil-go-to-micro/docker/orders:1.0.0 .
```

### To push Docker images for the microservices, you will have to execute the following instructions

```bash
gcloud auth login --project gil-go-to-micro
gcloud auth configure-docker europe-west1-docker.pkg.dev
cd ../products
docker push europe-west1-docker.pkg.dev/gil-go-to-micro/docker/products:1.0.0
cd ../orders
docker push europe-west1-docker.pkg.dev/gil-go-to-micro/docker/orders:1.0.0
```

### To deploy cloud run services, follow these instructions

```bash
gcloud run deploy --image=europe-west1-docker.pkg.dev/gil-go-to-micro/docker/products:1.0.0 --platform managed --region europe-west1
gcloud run deploy --image=europe-west1-docker.pkg.dev/gil-go-to-micro/docker/orders:1.0.0 --platform managed --region europe-west1
```

### To finish, configure, build and deploy frontend

First, get services url of both products and orders api.

```bash
gcloud run services list
```

Then, edit .env file inside react-app folder to replace localhost with these urls


Finally, build the project and push it

```bash
cd ../../../react-app
npm run build
cd ../microservices/src/frontend
docker build -t europe-west1-docker.pkg.dev/gil-go-to-micro/docker/frontend:1.0.0 .
docker push europe-west1-docker.pkg.dev/gil-go-to-micro/docker/frontend:1.0.0
gcloud run deploy --image=europe-west1-docker.pkg.dev/gil-go-to-micro/docker/frontend:1.0.0 --platform managed --region europe-west1
```

### Then remove deployed resources

```bash
gcloud run services delete --region europe-west1 frontend
gcloud run services delete --region europe-west1 orders
gcloud run services delete --region europe-west1 products
```