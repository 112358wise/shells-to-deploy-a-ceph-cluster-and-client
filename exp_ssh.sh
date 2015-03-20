#!/usr/bin/expect -f

spawn ssh-keygen

expect "Enter file in which to save the key (/root/.ssh/id_rsa):"
send "\r"

expect "Enter passphrase (empty for no passphrase):"
send "\r"

expect "Enter same passphrase again:"
send "\r"

expect eof
