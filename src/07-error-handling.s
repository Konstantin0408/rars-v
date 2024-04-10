##
# Error handling
##

.text

print_error err_error, msg_error, 4, reset
print_error err_ok, msg_ok, 6, tib_init
print_error err_reboot, msg_reboot, 16, _start
print_error err_tib, msg_tib, 14, reset
print_error err_mem, msg_mem, 16, reset
print_error err_token, msg_token, 14, reset
print_error err_underflow, msg_underflow, 20, reset
print_error err_overflow, msg_overflow, 20, reset

.data
msg_error: .ascii "  ?\n"
msg_ok: .ascii "   ok\n"
msg_reboot: .ascii "   ok rebooting\n"
msg_tib: .ascii "   Tib full\n"
msg_mem: .ascii "  Memory full\n"
msg_token: .ascii "  Big token\n"
msg_underflow: .ascii "  Stack underflow\n"
msg_overflow: .ascii "   Stack overflow\n"
