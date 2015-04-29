#
FROM centos:6.6

# add our user and group first to make sure their IDs get assigned consistently, regardless of whatever dependencies get added
RUN groupadd -r redis && useradd -r -g redis redis
RUN yum update
RUN yum install -y curl
RUN yum install -y tar

# install epel-release
RUN yum install -y epel-release

# install ruby
RUN yum install -y ruby
RUN yum install -y gcc libc6-dev g++ make 
RUN yum install -y automake autoconf curl-devel 
RUN yum install -y openssl-devel zlib-devel 
RUN yum install -y httpd-devel apr-devel 
RUN yum install -y apr-util-devel sqlite-devel
RUN yum install -y ruby-rdoc ruby-devel
RUN yum install -y rubygems
RUN gem install redis

# grab gosu for easy step-down from root
RUN curl -o /usr/local/bin/gosu -SL "https://github.com/tianon/gosu/releases/download/1.2/gosu-amd64" \
&& chmod +x /usr/local/bin/gosu

ENV REDIS_VERSION 2.8.19
ENV REDIS_DOWNLOAD_URL http://download.redis.io/releases/redis-3.0.0.tar.gz
# for redis-sentinel see: http://redis.io/topics/sentinel
set -x \
&& rm -rf /var/lib/apt/lists/* \
&& mkdir -p /usr/src/redis \
&& curl -sSL "$REDIS_DOWNLOAD_URL" -o redis.tar.gz \
&& tar -xzf redis.tar.gz -C /usr/src/redis --strip-components=1 \
&& rm redis.tar.gz \
&& make -C /usr/src/redis \
&& make -C /usr/src/redis install \
RUN mkdir -p /redis/7000 && mkdir -p /redis/7001 && mkdir -p /redis/7002 && mkdir -p /redis/7003 && mkdir -p /redis/7004 && mkdir -p /redis/7005
RUN mkdir -p /var/lib/redis && chown -R redis:redis /var/lib/redis

COPY ./docker-entrypoint.sh /entrypoint.sh
COPY ./7000.conf /redis/7000/redis.conf
COPY ./7001.conf /redis/7001/redis.conf
COPY ./7002.conf /redis/7002/redis.conf
COPY ./7003.conf /redis/7003/redis.conf
COPY ./7004.conf /redis/7004/redis.conf
COPY ./7005.conf /redis/7005/redis.conf
COPY ./start-cluster.sh /redis/start-cluster.sh
RUN chown -R redis:redis /redis
RUN chmod +x /redis/start-cluster.sh

COPY ./redis-trib.rb /redis/redis-trib.rb
RUN chmod +x /redis/redis-trib.rb

ENTRYPOINT ["/entrypoint.sh"]
RUN chmod +x /entrypoint.sh
CMD [ "redis-server" , "/redis/start-cluster.sh" ]
EXPOSE 7000 7001 7002 7003 7004 7005
