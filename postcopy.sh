#!/usr/bin/bash
ssh kieran@192.168.122.204 'echo "15" | PTS_SILENT_MODE=1 phoronix-test-suite batch-benchmark pts/stress-ng --skip-result-file' >> testfile &

#virsh qemu-monitor-command migrate70 --hmp migrate_set_capability postcopy-ram on

#virsh migrate --live --unsafe migrate70 qemu+ssh://kieran@149.61.16.122/system?keyfile=/home/kieran/.ssh/id_rsa &

#sleep 10

#virsh qemu-monitor-command migrate70 --hmp migrate_start_postcopy
virsh migrate migrate70 qemu+ssh://kieran@149.61.16.122/system?keyfile=/home/kieran/.ssh/id_rsa --live --postcopy --unsafe --postcopy-after-precopy &


