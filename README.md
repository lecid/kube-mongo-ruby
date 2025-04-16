# kube-mongo-ruby
Sample Kubernetes (Okteto) application with ruby and mongodb charts

## Run it locally in dev

### Needs

- docker

### Commands

    $ rake prepare:development
    $ rake prepare:mongo_dev
    $ rake run:local

ctrl + C to stop

    $ rake clean:mongo_dev




### Objectives

- bundle install for dependencies
- docker pull mongodb
- docker run dev insatnce mongodb
- run app in dev

## Deploy it in staging : as a Docker Service (Compose)

### Commands

    $ rake deploy:staging


    $ rake undeploy:staging 

### Objectives

- build in compose
- docker-compose up -d --build
- without ingress
- run app in staging


## Deploy on Docker Swarm as a stack compose 

### Needs

- docker swarm init on the host 

### Commands

    $ rake prepare:registry
    $ rake build:push 
    $ rake deploy:staging


    $ rake undeploy:staging
    $ rake clean:registry

### Objectives

- pull from local registry 
- docker stack deploy
- with Treafik ingress
- run app in test


## Deploy on Kubernetes as a manifest

### Needs

- kubernetes cluster or minikube, rancher, etc ..;

### Commands

    $ rake prepare:registry
    $ rake mongo:kube:secret
    $ rake mongo:kube:deploy
    $ rake build:push 
    $ rake deploy:kubernetes


    $ rake undeploy:kubernetes
    $ rake clean:registry

### Objectives

- prepare secret for credentials
- load mongodb local backend 
- pull from local registry 
- deploy on kubernetes
