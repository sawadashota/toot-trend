# Master image
FROM ruby:latest
MAINTAINER sawada@stanfoot.com

# Set Up Basically
RUN apt-get update
RUN apt-get install -y vim cron
RUN echo Asia/Tokyo > /etc/timezone

# Install Yarn
WORKDIR /root
RUN apt-get install -y apt-transport-https
RUN curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add -
RUN echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list
RUN apt-get update
RUN apt-get install -y yarn

# Install Nodejs
RUN curl -sL https://deb.nodesource.com/setup_7.x | bash -
RUN apt-get install -y nodejs

# Install Rails
RUN gem update
RUN gem install rails

# Addtional middlewares
RUN apt-get install -y mecab libmecab-dev mecab-ipadic libmecab2 libmecab-dev mecab-ipadic mecab-ipadic-utf8 mecab-utils
RUN gem install natto

# Install gem libraries
WORKDIR /root
COPY Gemfile /root/Gemfile
RUN bundle install

# Adjust Env
WORKDIR /var/www/html/app

EXPOSE 3000