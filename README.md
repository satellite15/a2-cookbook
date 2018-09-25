# a2

This will setup an Ubuntu 16.04 VM for A2. In order for this to work
correctly the VM requires 2GB of RAM. 

## Usage

Get an Automate 2 license and place it in `files/default/automate.license`

### Setup the workstation

You will need to follow the instructions in the documentation for setting up a worksation using a Vagrant VM.
Specifically you will want to add a host entry for `192.168.33.199` to the FQDN of `automate-deployment.test`

For example on a OSX you would run the following command:

```
echo 192.168.33.199 automate-deployment.test | sudo tee -a /etc/hosts
```

### Stand up the VM

```bash 
kitchen converge 
# once complete open browser to https://automate-deployment.test
```

The default credentials for the `admin` user can be found in `/tmp/kitchen/cache/automate-credentials.toml`

## TODO

* [ ] Add some tests
