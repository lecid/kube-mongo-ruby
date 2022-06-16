require 'tty-prompt'

prompt = TTY::Prompt.new

namespace :secret do 
    desc 'Init Kube secrets'
    task :init do
        target = './secret.yml'
        template = './secret_template.yml'
        data = {
            host: prompt.ask("Hostname ? ",default: "mongodb"),
            db: prompt.ask("Database name ? ",default: "mongo_test"), 
            user: prompt.ask("Username ? ", default: "mongo_user"),
            password: prompt.ask("Password ? ",echo: false, required: true),
            port: prompt.ask("Port ? ", default: '27017'),
        }
        
        content = File::readlines(template).join
        data.each do |key,value|
            content.gsub!("<#{key.to_s.upcase}>", value)
        end
        File.open(target, 'w') { |file| file.write(content) }
        system "kubectl apply -f #{target}"
        File.delete(target)
    end
end

namespace :prepare do
    desc 'Load development requiste (mongo, bundling), need docker'
    task :development do 
        system "bundle install"
        system "docker pull bitnami/mongodb:latest"
        system "docker run --rm -d  -p 27017:27017/tcp bitnami/mongodb:latest"
    end
end

namespace :run do 
    desc 'run locally'
    task :local do
        system "bundle exec rackup"
    end
end

namespace :deploy do 
    desc "deploy local staging (need docker compose)"
    task :staging do 
        system "docker-compose up -d"
    end
    desc 'Deploy prod (need kubectl, require a mongodb Charts,StatefullSet or external, need Secret : run rake secret:init before), '
    task :prod do 
        system "kubectl apply -f k8s.yml"
    end
end
