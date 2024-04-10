
.text
.global _start, main
_start:
main:
    j boot

.include "01-variables-constants.s"
.include "02-macros.s"
.include "03-interrupts.s"
.include "04-io-helpers.s"
.include "05-internal-functions.s"
.include "06-initialization.s"
.include "07-error-handling.s"
.include "08-forth-primitives.s"
.include "09-interpreter.s"
.include "10-mcu.s"
