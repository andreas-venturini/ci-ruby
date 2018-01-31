FROM ruby:2.3.6

COPY scripts/install-essentials /tmp/install-essentials
RUN /tmp/install-essentials

# Node.js
COPY scripts/install-node /tmp/install-node
RUN /tmp/install-node && node --version

# Chrome
ENV CHROME_VERSION 64.0.3282.119-1
ENV CHROME_DRIVER_VERSION 2.35
COPY scripts/install-chrome /tmp/install-chrome
RUN /tmp/install-chrome $CHROME_VERSION $CHROME_DRIVER_VERSION && google-chrome --version

# Yarn
COPY scripts/install-yarn /tmp/install-yarn
RUN /tmp/install-yarn && yarn --version

# Linter dependencies
RUN gem install bundler-audit \
  && gem install pronto \
  && gem install pronto-brakeman \
  && gem install pronto-coffeelint \
  && gem install pronto-rubocop \
  && gem install pronto-rails_schema \
  && gem install pronto-scss

# Clean up apt and tmp folders
RUN apt-get purge -y --auto-remove \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*
