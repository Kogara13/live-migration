# Live Migration Test

## Overview
This repository is my senior college independent research for the purpose of testing the efficiency of various live migaration techniques under controlled conditions. Two physical Linux machines on the same local network are configured via their bash shells to run virtual machine images. Within these images, various pieces of stress-testing software are implemented as programs to be running as the live migration of this virtual machine image from one physical machine to the other takes place. The times that it takes for these programs to complete, varying depending on which program is run and which form of live migration is implemented, are documented in a comma-sepereated value file. 

## Resources
Two different forms of live migration are used for the purpose of this research: precopy migration and post copy migration. 
