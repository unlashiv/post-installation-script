# Bash setup script for Ubuntu servers

This is a modified script with many changes, check source at [ubuntu-server-setup](jasonheecs/ubuntu-server-setup).


This is a setup script to automate the setup and provisioning of Ubuntu servers. 
It does the following:
- Install git
- Adds or updates a user account with sudo access
- Adds a public ssh key for the new user account
- Disables password authentication to the server
- Deny root login to the server
- Setup Uncomplicated Firewall
- Create Swap file based on machine's installed memory
- Setup the timezone for the server (Default to "Europe/Berlin")
- Install Network Time Protocol
- Install Docker

## Installation
After cloning and modifying the settings.txt file to your purpose, Either follow the first method:

1. **SSH into your server and run the following command:**
```bash
sudo wget https://github.com/unlashiv/post-installation-script/post-installation-script.sh
```
or submit the above `post-installation-script.sh` as post-installation script in your Virtual Server Setup

## Setup settings
There are two files in the settings directory. _Both of these files must be modified_ as per your needs.

1. options.txt  
When the setup script is run, it will read this file to avoid prompting for things like username of the new [user account](https://wiki.ubuntu.com/UserAccounts), [timezone](https://en.wikipedia.org/wiki/List_of_tz_database_time_zones) of the server, etc.  

The syntax of *options.txt* file is     
 ```txt
uname <username>
tzone <timezone> Europe/Berlin
pubkey <path-to-public-key-file>
docker <yes/no>
```

2. local.pub  
This file is used to add a public ssh key for the new account. The public ssh key should be from your local machine. To generate an ssh key from your local machine you can use the following instructions.   

 **Linux/MacOS:**     
 ```bash
ssh-keygen -f ~/.ssh/filename
cat ~/.ssh/filename.pub
```