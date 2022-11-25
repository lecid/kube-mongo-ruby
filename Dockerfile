FROM ruby:3.0.2

#ENV http_proxy='http://172.17.0.1:3129'
WORKDIR /code
COPY . /code
RUN bundle install
EXPOSE 8080
CMD ["bundle", "exec", "rackup", "--host", "0.0.0.0", "-p", "8080"]