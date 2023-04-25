FROM ubuntu:16.04

RUN apt-get update && apt-get install -y openssh-server
RUN apt-get install -y curl

# Install nodejs
RUN curl -sL https://deb.nodesource.com/setup_8.x | bash -
RUN apt-get install -y nodejs

RUN mkdir /usr/src/app

RUN adduser admin
RUN echo 'admin:e15dfb167a9c8' | chpasswd
RUN adduser crackme
RUN echo 'crackme:emrtup' | chpasswd

COPY Flag.txt /home/crackme


# Create app directory
WORKDIR /usr/src/app

COPY package*.json ./


RUN npm install

COPY ./app.js ./app.js
COPY ./start.sh ./start.sh
COPY ./public ./public

COPY sshd_config /etc/ssh/
RUN mkdir /var/run/sshd
RUN apt install openssh-server


EXPOSE 2000
EXPOSE 22
# CMD ["/usr/sbin/sshd", "-D"]
RUN chmod +x start.sh
CMD ./start.sh