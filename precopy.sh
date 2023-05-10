#!/usr/bin/bash
virsh migrate --live --unsafe migrate70 qemu+ssh://kieran@149.61.16.122/system?keyfile=/home/kieran/.ssh/id_rsa 

#&no_verify=1&no_tty=1 

