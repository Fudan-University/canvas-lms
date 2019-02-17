FROM ruby:2.5.3-stretch

ENV APP_HOME /opt/canvas/
ENV RAILS_ENV 'production'
ENV YARN_VERSION '1.12.3'
ENV NODE_VERSION '8.15.0'

ENV DISABLE_V8_COMPILE_CACHE 1

RUN echo 'deb http://mirrors.tuna.tsinghua.edu.cn/debian stretch main' > /etc/apt/sources.list \
  && echo 'deb http://mirrors.tuna.tsinghua.edu.cn/debian stretch-updates main' >> /etc/apt/sources.list \
  && echo 'deb http://mirrors.tuna.tsinghua.edu.cn/debian-security/ stretch/updates main' >> /etc/apt/sources.list \
  && printf 'path-exclude /usr/share/doc/*\npath-exclude /usr/share/man/*' > /etc/dpkg/dpkg.cfg.d/01_nodoc \
  && apt-get update -qq \
  && apt-get upgrade -qqy \
  && apt-get install -qqy --no-install-recommends \
       libxmlsec1-dev \
       python-lxml \
       libicu-dev \
       postgresql-client \
       unzip \
       fontforge \
  && apt-get clean \
  && rm -rf /var/lib/apt/list/*

WORKDIR /opt/lib
RUN pwd \
  && wget -q https://npm.taobao.org/mirrors/node/v${NODE_VERSION}/node-v${NODE_VERSION}-linux-x64.tar.gz \
  && tar xzf node-v${NODE_VERSION}-linux-x64.tar.gz \
  && ln -s /opt/lib/node-v${NODE_VERSION}-linux-x64/bin/node /usr/local/bin/node \
  && ln -s /opt/lib/node-v${NODE_VERSION}-linux-x64/bin/npm /usr/local/bin/npm \
  && wget -q https://npm.taobao.org/mirrors/yarn/v${YARN_VERSION}/yarn-v${YARN_VERSION}.tar.gz \
  && tar xzf yarn-v${YARN_VERSION}.tar.gz \
  && ln -s /opt/lib/yarn-v${YARN_VERSION}/bin/yarn /usr/local/bin/yarn \
  && rm node-v${NODE_VERSION}-linux-x64.tar.gz yarn-v${YARN_VERSION}.tar.gz

COPY build/vendor/woff-code-latest.zip ./
RUN unzip woff-code-latest.zip -d woff \
  && cd woff \
  && make \
  && cp sfnt2woff /usr/local/bin \
  && cd - \
  && rm -rf woff*
# 将Ruby源设置为清华镜像
# 安装指定版本的bundler
# bundle install
#RUN gem sources --add https://mirrors.tuna.tsinghua.edu.cn/rubygems/ --remove https://rubygems.org/ \
#      && bundle config mirror.https://rubygems.org https://mirrors.tuna.tsinghua.edu.cn/rubygems
#
#WORKDIR $APP_HOME
#
#
#COPY Gemfile      ${APP_HOME}
#COPY Gemfile.d    ${APP_HOME}Gemfile.d
#COPY config       ${APP_HOME}config
#COPY gems         ${APP_HOME}gems
#COPY packages     ${APP_HOME}packages
#COPY script       ${APP_HOME}script
#COPY package.json ${APP_HOME}
#COPY yarn.lock    ${APP_HOME}
#
## 替换GitHub的链接为复旦source
## 替换NPM库到USTC
#COPY sinicize/sinicize.sh ./sinicize/
#RUN sinicize/sinicize.sh
#
#RUN bundle install --verbose -j 4

#
#RUN yarn install --pure-lockfile

