# Defined via `source`
function agi --wraps='apt install -y' --description 'alias agi=apt install -y'
  apt install -y $argv;
end
