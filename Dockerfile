FROM debian:7.7
  
MAINTAINER Headnet Aps <staff@headnet.dk>

# Install all the packages you need in the container
RUN apt-get update && apt-get install -y build-essential libssl-dev libxml2-dev libxslt1-dev libbz2-dev zlib1g-dev python-dev libjpeg62-dev libreadline-gplv2-dev python-imaging python-pip wv git-core locales

# Run your initialization commands or add any environment variable if any:
ENV LC_ALL C.UTF-8

# YOU DON't NEED TO EDIT THE REMAING LINES

ADD app.sh /bin/
RUN chmod +x /bin/app.sh

# ADD your ssh keys so the buildout can get git repos.
ADD id_rsa /root/.ssh/
RUN chmod -R 600 /root/.ssh
RUN echo "Host *\n\tStrictHostKeyChecking no\n" >> /root/.ssh/config

