# kube-mongo-ruby
Sample Kubernetes (Okteto) application with ruby and mongodb charts


## Run it locally in dev

### Needs

- docker

### Commands

    $ rake prepare:development
    $ rake run:local

### Objectives

- bundle install for dependencies
- docker pull mongodb
- docker run interactive mongodb

## Deploy it in staging : as a Docker Service (Compose)

### Commands

    $ rake deploy:staging

### Objectives

- docker-compose up -d


## Deploy on Okteto as a Kubernetes manifest

### Needs

- Okteto account (Dev)
- A Mongodb Helm Charts with corresponding credentials

### Commands

    $ rake secret:init
    $ rake deploy:prod 
