function docker-compose --description 'alias docker-compose=docker-compose --context $DOCKER_CONTEXT'
 command docker-compose --context $DOCKER_CONTEXT $argv; 
end
