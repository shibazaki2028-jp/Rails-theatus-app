FROM ruby:3.1.6-bullseye


ENV LANG="C.UTF-8" \
    TZ="Asia/Tokyo" \
    RAILS_VERSION="7.0.4"


RUN apt-get update && apt-get install -y vim git less && rm -rf /var/lib/apt/lists/*
	
RUN apt-get update && apt-get install -y sqlite3 && rm -rf /var/lib/apt/lists/*


RUN apt-get update && apt-get -y install build-essential && rm -rf /var/lib/apt/lists/*


RUN gem install concurrent-ruby --version 1.3.4 -N


RUN gem install rails --version "$RAILS_VERSION" -N


RUN gem update bundler


ENV RUBYOPT="-rlogger"


RUN git config --global init.defaultBranch main


EXPOSE 3000
