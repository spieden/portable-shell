function dex --wraps='docker exec -ti' --description 'alias dex=docker exec -ti'
  docker exec -ti $argv; 
end
