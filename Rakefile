require 'tty-prompt'

prompt = TTY::Prompt.new

namespace :mongo do
  namespace :kube do 
    desc 'Init Kube secrets (Templating secrets and kubectl apply -f secret.yml'
    task :secret do
        target = './secret.yml'
        template = './secret.template'
        data = {
            database: prompt.ask("Database name ? ",default: "mongo_test"), 
            user: prompt.ask("Username ? ", default: "mongo_user"),
            password: prompt.ask("Password ? ",echo: false, required: true),
        }
        
        content = File::readlines(template).join
        data.each do |key,value|
            content.gsub!("<#{key.to_s.upcase}>", value)
        end
        File.open(target, 'w') { |file| file.write(content) }
        system "kubectl apply -f #{target}"
        File.delete(target)
    end
    desc 'Deploy K8s mongodb service : kubectl apply -f k8s_mongodb.yml'
    task :deploy do
      system "kubectl apply -f k8s_mongodb.yml"
    end
  end
end

namespace :clean do
    desc 'Stop local docker registry : docker-compose -f compose_registry.yml down'
    task :registry do
      system "docker-compose -f compose_registry.yml down"
    end

    desc 'Stop local mongo dev db : docker-compose -f compose_mongodev.yml down'
    task :mongodb_dev do
      system "docker-compose -f compose_mongodev.yml down"
    end
end

namespace :prepare do
    desc 'Load local docker registry : docker-compose -f compose_registry.yml up -'
    task :registry do  
      system "docker-compose -f compose_registry.yml up -d"
    end

    desc 'Start local developpement mongodb : docker-compose -f compose_mongodev.yml up -d'
    task :mongodb_dev do
      system "docker-compose -f compose_mongodev.yml up -d"
    end
    
    desc 'Load development requiste : bundle install'
    task :development do 
        system "bundle install"
    end    
end

namespace :build do

  desc 'build in local registry and templating manifest : docker build . -t <tag>:<version> ; docker push <tag>:<version>'
  task :push do
     data = {
       name: prompt.ask("Image name ? ",default: "localhost:5000/kube-mongo-ruby"),
       version: prompt.ask("Image version ? ",default: "latest"),
     }
     system "docker build . -t #{data[:name]}:#{data[:version]}"
     system "docker push #{data[:name]}:#{data[:version]}"
     puts "Image tag : #{data[:name]}:#{data[:version]}"
  end

end

namespace :run do 
    desc 'run locally : bundle exec rackup'
    task :local do
        system "bundle exec rackup"
    end
end

namespace :deploy do 
    desc "deploy local staging : docker-compose up -d --build"
    task :staging do 
        system "docker-compose up -d --build"
    end

    desc "deploy local swarm ( Container must be build) use rake prepare:registry and build:push : docker stack deploy -c docker-compose-swarm.yml kube-mongo-ruby"
    task :swarm do
     target = 'docker-compose-swarm.yml'
     template = './docker-compose-swarm.template' 
     data = {
       name: prompt.ask("Image name ? ",default: "localhost:5000/kube-mongo-ruby"),
       version: prompt.ask("Image version ? ",default: "latest"),
       replicas: prompt.ask("Number of replicas ? ",default: "2")

     }

     content = File::readlines(template).join
     data.each do |key,value|
       content.gsub!("<APP_#{key.to_s.upcase}>", value)
     end
     File.open(target, 'w') { |file| file.write(content) }
      system "docker stack deploy -c docker-compose-swarm.yml kube-mongo-ruby"
    end
    desc 'Deploy prod (need kubectl, require a mongodb deployment and Secret : run rake mongo:kube:secret and deploy before) : kubectl apply -f k8s.yml '


    task :kubernetes do
        target = 'k8s.yml'
        template = './k8s.template'
        data = {
          name: prompt.ask("Image name ? ",default: "localhost:5000/kube-mongo-ruby"),
          version: prompt.ask("Image version ? ",default: "latest"),
          replicas: prompt.ask("Number of replicas ? ",default: "2")

        }
        
        content = File::readlines(template).join
        data.each do |key,value|
          content.gsub!("<APP_#{key.to_s.upcase}>", value)
        end
        File.open(target, 'w') { |file| file.write(content) }
        system "kubectl apply -f k8s.yml"
    end
end

namespace :undeploy do
    desc "Undeploy local staging : docker-compose down"
    task :staging do
        system "docker-compose down"
    end

    desc "Undeploy local swarm : docker stack rm kube-mongo-ruby"
    task :swarm do
      system "docker stack rm kube-mongo-ruby"
    end
    desc 'Undeploy kubernetes (full with mongo and secret) : kubectl delete service --all; kubectl delete deployment --all; kubectl delete secret --all'
    task :kubernetes do
        system "kubectl delete service --all; kubectl delete deployment --all; kubectl delete secret --all"
    end
end
