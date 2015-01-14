Using Docker for new Projects (mac users only):

I. INSTALLING DOCKER

  1. Install Docker on your local machine:
    For mac users use boot2docker: https://docs.docker.com/installation/mac/
    This will install a VM with docker in it and a docker client on your local machine

  2. update boot2docker:
  
     a. Run Boot2Docker from your Application folder you will get a terminal with somthing like this as output:

         ...
         To connect the Docker client to the Docker daemon, please set:
           export DOCKER_HOST=tcp://192.168.59.103:2376
           export DOCKER_CERT_PATH=/Users/mustapha/.boot2docker/certs/boot2docker-vm
           export DOCKER_TLS_VERIFY=1
         ....
      
     b. Run : 
     
         $ boot2docker upgrade

     NOTE: if you see "bash: update_terminal_cwd: command not found" just copy your /etc/bashrc to ~/.bashrc
   
  3. if you want to ssh to the machine running docker, just type:
     
     $ boot2docker ssh

II. Run YOUR PROJECT IN A DOCKER CONTAINER

  1. Edit Dockerfile and customize it to your need: 

  2. Edit the app.sh file and customize it to your need: 
	 
  3. Build a docker image with your project in it

     $ ./app.sh build
	 
	 This will pull your project to the current directory an build a docker image from it   

  4. If got errors so fix your Dockerfile and do 3) again
  
  5. run the docker container
  
     $ ./app.sh run

  6. If got errors so fix your app_start function and/or Dockerfile and do 3) again
  
  7. Now should have a running docker container you can:
  
     $ ./app.sh logs #To se what the container is doing
	 $ ./app.sh stop #To stop the container
	 $. ./app.sh ip  # to get the container ip adress if you need it
  
  8. Now you can point your browser to your app:
  
     $ ./app.sh browse 
