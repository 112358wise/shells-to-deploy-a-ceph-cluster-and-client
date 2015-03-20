#!/usr/bin/expect -f

spawn passwd vceph

expect "Enter new UNIX password:"
send "abc123\r"

expect "Retype new UNIX password:"
send "abc123\r"

expect eof 

