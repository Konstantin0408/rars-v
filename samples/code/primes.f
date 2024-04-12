: prime dup 4 < swap 2   begin over over mod 0= if -1 else 1 + over over dup * < then until   mod 0= 0= xor  ;
: loop_primes 30 1 begin dup prime if dup . then 1 + over over < until ;
loop_primes
