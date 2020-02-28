#!/bin/bash
ftp -n 202.182.109.206<<EOF
user $ftpname $ftppass
hash
put link.txt
bye
EOF
