FROM ruby:2.3.4
MAINTAINER xhn0701@gmail.com

RUN apt-get update -qq && apt-get install -y build-essential libpq-dev

# Node.js
RUN curl -sL https://deb.nodesource.com/setup_7.x | bash - \
&& apt-get install -y nodejs

RUN apt-get update && apt-get install -y curl apt-transport-https wget && \
curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add - && \
echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list && \
apt-get update && apt-get install -y yarn

RUN mkdir -p /app
WORKDIR /app

COPY Gemfile Gemfile.lock ./
RUN bundle install

COPY . ./

EXPOSE 3000

CMD ["bin/rails", "server", "-b", "0.0.0.0"]