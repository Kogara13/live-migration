#!/usr/bin/bash


vm_name="migrate70"

#Place the ip address of the system in a variable
pc04ip=149.61.16.122
#$(hostname -I | awk '{print $1}')

#if ! virsh list | grep -q "$vm_name"; then
#    virsh start "$vm_name"
#    echo "vm created"
#fi

#ssh kieran@$pc04ip "./check.sh"

sleep 20

mac=$(sudo virsh domiflist migrate70 | awk 'NR==3 {print $5}')

vmip=$(arp -an | grep $mac | awk '{print $2}' | sed 's/[()]//g')

# Check that two arguments were passed to the program
if [ $# -ne 2 ]; then
    echo "Two arguments needed (program, pre/postcopy)"
    exit 1
fi

#Check that the first argument is one of four strings
if [ "$1" != "stress-ng" ] && [ "$1" != "n-queens" ] && [ "$1" != "npb" ] && [ "$1" != "Netperf" ] && [ "$1" != "tensorflow" ]; then
    echo "invalid benchmarking program name"
    exit 1
fi

# Check that the second argument is one of two strings
if [ "$2" != "-pre" ] && [ "$2" != "-post" ]; then
    echo "invalid precopy/postcopy argument"
    exit 1
fi

#Set stress test to use
echo "Starting stress test..."
if [ "$1" == "stress-ng" ]; then
    #Start stress test in VM
    ssh kieran@192.168.122.204 "echo '15' | PTS_SILENT_MODE=1 phoronix-test-suite batch-benchmark pts/stress-ng-1.8.0 --skip-result-file" >> testfile & 
elif [ "$1" == "n-queens" ]; then
    ssh kieran@192.168.122.204 "PTS_SILENT_MODE=1 FORCE_TIMES_TO_RUN=5 phoronix-test-suite batch-benchmark pts/n-queens" >> testfile &
elif [ "$1" == "npb" ]; then
    ssh kieran@192.168.122.204 "echo '2' | PTS_SILENT_MODE=1 FORCE_TIMES_TO_RUN=5 phoronix-test-suite batch-benchmark npb" >> testfile &
elif [ "$1" == "Netperf" ]; then
    ssh kieran@192.168.122.204 "echo '15' | PTS_SILENT_MODE=1 phoronix-test-suite batch-benchmark pts/stress-ng --skip-result-file" >> testfile &
elif [ "$1" == "tensorflow" ]; then
    ssh kieran@192.168.122.204 "echo '1' | PTS_SILENT_MODE=1 FORCE_TIMES_TO_RUN=3 phoronix-test-suite batch-benchmark tensorflow --skip-result-file" >> testfile &
fi 

sleep 15

#Start pre or post copy migration
echo "Starting migration"
if [ "$2" == "-pre" ]; then
    migration="precopy"
    #Start timer
    begin=$(date +%s)
    #Run the migration program
    virsh migrate --live --unsafe migrate70 qemu+ssh://kieran@$pc04ip/system?keyfile=/home/kieran/.ssh/id_rsa
    #Stop timer
    end=$(date +%s)
    #Calculate time taken
    runtime=$(( (begin - end) * -1 ))
elif [ "$2" == "-post" ]; then
    migration="postcopy"
    #Start timer
    begin=$(date +%s)
    #Run the migration program
    virsh migrate migrate70 qemu+ssh://kieran@$pc04ip/system?keyfile=/home/kieran/.ssh/id_rsa --live --unsafe --postcopy --postcopy-after-precopy
    #Stop timer
    end=$(date +%s)
    #Calculate time taken
    runtime=$(( (begin - end) * -1 ))
fi 

#Place the first argument, the second argument and the runtime into three columns in a csv file
echo "$1,$migration,$runtime" >> results.csv



