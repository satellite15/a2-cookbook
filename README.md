# a2

This will setup an Ubuntu 16.04 VM for A2. In order for this to work correctly the VM requires 2GB of RAM. 

Internally this will try to assign at private network ip of `192.168.33.199` to those guest VM that is used to access the Web UI from the host system.

## Usage

### Add custom A2 license

**NOTE: Be careful not to commit that file to the git repo, by default there is a `.gitignore` setting to ignore any `automate.license` file.**

1. If you have an automate license you can place it in `files/default/automate.license` 
2. Set `node.default['a2']['licensed'] = true` in a wrapper or modify the `kitchen.yml` to set the equivalent node attribute.

### Setup the workstation

You will need to add an entry into your hosts file for the A2 FQDN.  Specifically you will want to add a host entry for `192.168.33.199` to point at `automate-deployment.test`

On a OSX you would run the following command:

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
