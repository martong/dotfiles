#!/bin/bash
sed -i -e 's/AllowTcpForwarding .*/AllowTcpForwarding yes/' /etc/ssh/sshd_config
kill -SIGHUP $(pgrep -f "sshd -D")
