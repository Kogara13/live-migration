#!/usr/bin/bash

wget https://phoronix-test-suite.com/releases/repo/pts.debian/files/phoronix-test-suite_10.8.3_all.deb

sudo dpkg -i phoronix*.deb

sudo apt-get install -f

phoronix-test-suite install pts/stress-ng
phoronix-test-suite install pts/tensorflow
phoronix-test-suite install pts/netperf
phoronix-test-suite install pts/npb
phoronix-test-suite install pts/n-queens
