FROM ruby:3.3.6-alpine
    LABEL authors="Omar Qureshi <omar@omarqureshi.net>"

ENV GEM_HOME="/usr/local/bundle"
ENV PATH $GEM_HOME/bin:$GEM_HOME/gems/bin:$PATH

RUN apk add --update alpine-sdk

RUN mkdir -p /opt/work
WORKDIR /opt/work

COPY Gemfile Gemfile
COPY Gemfile.lock Gemfile.lock

RUN bundle
