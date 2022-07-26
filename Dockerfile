FROM ruby

RUN gem install bundler -v 2.3.18

WORKDIR /usr/src/app

COPY . . 

RUN bundle install
