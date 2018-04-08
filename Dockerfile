FROM ruby:2.5.1-slim

RUN apt-get update -qq && apt-get install -y build-essential libpq-dev nodejs

RUN mkdir /wabisabi

WORKDIR /wabisabi

COPY Gemfile /wabisabi/Gemfile
COPY Gemfile.lock /wabisabi/Gemfile.lock

RUN bundle install

COPY . /wabisabi
