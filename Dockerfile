FROM ruby:3.2.7-alpine3.21

RUN apk update && \
    apk upgrade && \
    apk add --no-cache gcompat && \
    apk add --no-cache linux-headers yaml-dev libxml2-dev make gcc libc-dev nodejs tzdata postgresql-dev postgresql git bash yarn && \
    apk add --virtual build-packages --no-cache build-base curl-dev
RUN mkdir /rails-app-vue3
WORKDIR /rails-app-vue3
ADD Gemfile /rails-app-vue3/Gemfile
ADD Gemfile.lock /rails-app-vue3/Gemfile.lock
RUN bundle install
RUN yarn install
RUN apk del build-packages
ADD . /rails-app-vue3
EXPOSE 3000
CMD ["rails", "server", "-b", "0.0.0.0"]