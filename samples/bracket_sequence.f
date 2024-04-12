: input_sequence begin key dup 10 = swap 13 = or until ;
: check_sequence 0 begin swap -  depth 1 = over -1 = or until 0= . clearstack ;

1 1 -1 1 -1 -1 check_sequence
1 1 -1 -1 -1 1 check_sequence
1 1 1 -1 1 -1 check_sequence
1 1 1 -1 -1 -1 1 -1 check_sequence
