FROM ubuntu:14.04

# locale
RUN locale-gen ja_JP.UTF-8 && \
    locale-gen en_US.UTF-8
ENV LANG en_US.UTF-8

ENV DEBIAN_FRONTEND noninteractive

RUN apt-get update && apt-get upgrade -y
RUN apt-get install -y build-essential libtag1-dev libqtwebkit-dev qt4-qmake \
  xvfb firefox git curl sox libsox-fmt-mp3 libpq-dev imagemagick

# for ruby
RUN apt-get install -y --force-yes libssl-dev libreadline-dev

RUN apt-get clean

# Install rbenv and ruby-build
RUN git clone https://github.com/sstephenson/rbenv.git /usr/local/rbenv
RUN git clone https://github.com/sstephenson/ruby-build.git /usr/local/rbenv/plugins/ruby-build
RUN /usr/local/rbenv/plugins/ruby-build/install.sh
ENV RBENV_ROOT /usr/local/rbenv
ENV PATH /usr/local/rbenv/bin:$PATH
RUN echo "export RBENV_ROOT=/usr/local/rbenv" >> /root/.bashrc
RUN echo 'export PATH="$RBENV_ROOT/bin:$PATH"' >> /root/.bashrc
RUN echo 'eval "$(rbenv init -)"' >> /root/.bashrc

ENV CONFIGURE_OPTS --disable-install-doc
RUN rbenv install 2.2.3
RUN rbenv global 2.2.3
RUN rbenv exec gem install bundler
RUN rbenv rehash