FROM ruby:2.6.5

RUN curl -fsSL https://deb.nodesource.com/setup_16.x | bash -
RUN wget --quiet -O - /tmp/pubkey.gpg https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add - && \
    echo 'deb http://dl.yarnpkg.com/debian/ stable main' > /etc/apt/sources.list.d/yarn.list
RUN apt-get update -qq \
    && apt-get install -y nodejs yarn build-essential postgresql-client libpq-dev \
    && mkdir /myapp
RUN gem install bundler:2.1.4
WORKDIR /myapp
COPY Gemfile /myapp/Gemfile
COPY Gemfile.lock /myapp/Gemfile.lock
RUN bundle install
COPY . /myapp

RUN apt-get install -y gosu
RUN apt-get clean && rm -rf /var/lib/apt/lists/*

COPY entrypoint.sh /usr/bin/
RUN chmod +x /usr/bin/entrypoint.sh

ARG USERNAME=public-user
ARG GROUPNAME=public-user
ARG UID=228
ARG GID=228
RUN groupadd -g $GID $GROUPNAME
RUN useradd -m -s /bin/bash -u $UID -g $GID $USERNAME

ENTRYPOINT ["entrypoint.sh"]
EXPOSE 3000

RUN RACK_ENV=production SECRET_KEY_BASE=1 bundle exec rake assets:precompile

CMD ["bundle", "exec", "puma", "-C", "config/puma.rb"]
