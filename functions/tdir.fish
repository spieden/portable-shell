function tdir --wraps='ls -latr | tail' --description 'alias tdir=ls -latr | tail'
  ls -latr | tail $argv; 
end
