#!/usr/bin/bash

#Generate a random number between 1 and 256 to use for VM Name

vmname="migrate"
vmname+=$(shuf -i 1-256 -n 1)
echo "Creating MV $vmname"
sleep 2

sudo virt-install --boot cdrom,hd --name=$vmname --os-type=Linux --os-variant=ubuntu20.04 --vcpu=2 --ram=4096 --disk path=/var/lib/libvirt/images/$vmname.img,size=15 --location 'http://gb.archive.ubuntu.com/ubuntu/dists/focal/main/installer-amd64/' --network bridge:virbr0 --graphics none --console pty,target_type=serial --extra-args 'console=ttyS0, 115200n8 serial'

echo "destroying..."
virsh destroy $vmname
sleep 10
echo "restarting..."
virsh start $vmname
sleep 15

#Get IP of VM
mac=$(sudo virsh domiflist $vmname | awk 'NR==3 {print $5}')
ip=$(arp -an | grep $mac | awk '{print $2}' | sed 's/[()]//g')

#Create ssh-keygen and send it to the VM
echo "sending keygen"
ssh-copy-id -i /home/kieran/.ssh/id_rsa.pub kieran@$ip


#scp updateGrub.sh to the VM
echo "Sending grub update command"
scp updateGrub.sh kieran@$ip:/home/kieran/updateGrub.sh
sleep 3

#Use sshpass to run updateGrub.sh in the VM
echo "Running command on VM"
password=read -p "Enter the password for the VM: " 
sshpass -p $password ssh -t kieran@$ip 'sudo /home/kieran/updateGrub.sh'
sshpass -p $password ssh -t kieran@$ip 'sudo update-grub'

echo "restarting vm..."
virsh reboot $vmname

sleep 30


#Enable post-copy capabilities
virsh qemu-monitor-command $mvname --hmp migrate_set_capability postcopy-ram on
