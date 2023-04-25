# FROM node:latest

# USER root

# RUN mkdir /usr/src/app

# # Create app directory
# WORKDIR /usr/src/app

# # Install app dependencies
# # A wildcard is used to ensure both package.json AND package-lock.json are copied
# # where available (npm@5+)
# COPY package*.json ./

# RUN adduser admin
# RUN echo 'admin:password123' | chpasswd

# RUN adduser john
# RUN echo 'john:abcd123456' | chpasswd

# RUN apk add openssh

# RUN npm install
# # If you are building your code for production
# # RUN npm ci --omit=dev

# # Bundle app source
# COPY ./app.js ./app.js
# COPY ./public ./public

# EXPOSE 2000
# CMD [ "node", "app.js" ]


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