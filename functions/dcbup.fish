function dcbup
  docker-compose build $argv
  docker-compose rm -f $argv
  docker-compose up -d $argv
end
