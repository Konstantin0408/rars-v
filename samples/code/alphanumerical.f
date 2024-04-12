: numerical dup 58 < swap 47 > and ;
: uppercase dup 91 < swap 64 > and ;
: lowercase dup 123 < swap 96 > and ;
: alphanumerical dup numerical swap dup uppercase swap lowercase or or ;
key alphanumerical .
