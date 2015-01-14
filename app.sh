#!/bin/sh

#The project name
APP_NAME="sm-100yearsofequality"
#The project git repository
GIT_URL="git@github.com:headnet/headnet.plone.project.sm-100yearsofequality.git"
#The branch you want to run inside the container
GIT_BRANCH="master"
#This is the port inside the container (your zope port or apache port or what port your application runs on)
INTERNAL_PORT=8080
#This is the public port (from your browser you will get your app. from this port)
EXTERNAL_PORT=50010
#This is your application directory inside the container. YOU DON'T NEED TO EDIT IT
APP_DIR="/usr/local/www/$APP_NAME"


#EDIT THIS: Put here what needed to start your app inside the container
#The last command has to be a forground command (IT IS A MUST)
start_app() {
	cd $APP_DIR
	git checkout $GIT_BRANCH
    echo "[buildout]\nextends = profiles/development.cfg\nallow-hosts = " > buildout.cfg
	python buildout-bootstrap.py -v 1.5
	bin/buildout -Nv
	bin/instance console
}

#######################################################
#                                                     #
#     YOU DON'T NEED TO TOUCH THE REMAINING LINES     #
#                                                     #
#######################################################

run() {
    docker stop $APP_NAME.$GIT_BRANCH > /dev/null 2>&1
    docker rm $APP_NAME.$GIT_BRANCH > /dev/null 2>&1
    docker run -t -d --name=$APP_NAME.$GIT_BRANCH -p $EXTERNAL_PORT:$INTERNAL_PORT -v $PWD/$APP_NAME:$APP_DIR $APP_NAME /bin/app.sh start_app
}

stop() {
    docker stop $APP_NAME.$GIT_BRANCH
}

rm() {
    docker stop $APP_NAME.$GIT_BRANCH > /dev/null 2>&1
    docker rm $APP_NAME.$GIT_BRANCH
}

logs() {
    docker logs -f $APP_NAME.$GIT_BRANCH
}

ip() {
    docker inspect --format '{{ .NetworkSettings.IPAddress }}' $APP_NAME.$GIT_BRANCH
}

browse(){
    open http:`echo $DOCKER_HOST | cut -d':' -f2`:$EXTERNAL_PORT/
}
build() {
	cp ~/.ssh/id_rsa .
    docker stop $APP_NAME.$GIT_BRANCH > /dev/null 2>&1
    docker rm $APP_NAME.$GIT_BRANCH > /dev/null 2>&1
    git clone $GIT_URL $APP_NAME > /dev/null 2>&1
	docker rmi $APP_NAME > /dev/null 2>&1
	docker build -t $APP_NAME .
}

rmi() {
    docker rmi $APP_NAME
}

case $1 in
	build)
	    build
	;;
	run)
	    run
	;;
	stop)
	    stop
	;;
	rm)
	    rm
	;;
	rmi)
	    rmi
	;;
	logs)
	    logs
	;;
	ip)
	    ip
	;;
	browse)
	    browse
	;;
	start_app)
	    start_app
	;;
	*)
        echo "\nUsage: $0 [build|rmi|run|stop|rm|ip|browse]\n"
        echo "	    build : Build/rebuild a docker image from your app."
        echo "	      rmi : Remeove the docker image"
        echo "	      run : Run/rerun the docker container."	
        echo "	     stop : Stop the running docker container"	
        echo "	       rm : Remove the docker container"
        echo "	     logs : Tail  the docker container log"
        echo "	       ip : Get the container ip"
        echo "	   browse : brwse your app with your default browser"
		echo ""	
	;;
esac
exit 0