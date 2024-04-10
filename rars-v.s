
.text
.global _start, main
_start:
main:
    j boot

.include "src/01-variables-constants.s"
.include "src/02-macros.s"
.include "src/03-interrupts.s"
.include "src/04-io-helpers.s"
.include "src/05-internal-functions.s"
.include "src/06-initialization.s"
.include "src/07-error-handling.s"
.include "src/08-forth-primitives.s"
.include "src/09-interpreter.s"
.include "src/10-mcu.s"
