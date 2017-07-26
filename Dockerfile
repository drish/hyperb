FROM ruby:2.3

WORKDIR /usr/src
COPY . /usr/src
#COPY hyperb.gemspec /usr/src/hyperb.gemspec
RUN bundle install

