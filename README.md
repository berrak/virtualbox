## VirtualBox VM's managed by Puppet/Git for Safer Development

### VirtualBox and Debian Wheezy (a.k.a. Debian 7)

VirtualBox provides a great environment for admin tests or running
clean desktop environments isolated from the host installation.

Today, probably the greatest IT security risk is actually ourselves. What did
you downloaded? Did you executed it? Do you know the source? Which unsafe sites
did you visited? [1]

In this project each virtual machine is managed by Puppet and Git. Each
VM is totally isolated using the default setup with NAT networking.

This setup describes how to setup Puppet [2] and Git on each VM. 

Here we set up safer desktop for every day use, and bare server:

    * Web desktop (web) environment, hardened for a safer web experience [3]
    * Hardened server setup (hard)
    
In the site manifest find a few examples of development environments:

    * Perl web development (mojo) exploring Mojolicious web framework [4]
    * PHP development environment (php) exploring php5/MySQL etc.
    * Ruby development environment (ruby)
    * Python development environment (python)
    * Cobol development (cobol)
    * Java och javascript development (java)
    
Here, each VM use Debians' images (debian-7.1.0-amd64-lxde-CD-1.iso or the net-
installer debian-7.1.0-amd64-netinst.iso) [5]. 

Above examples will evolve over time and are far from complete. Feel free
to suggest contributions. To install the latest VirtualBox, see reference [6].
Oracles' Debian installer works nicely, as expected after adding their
repository to the */etc/apt/sources.list* file.

When finished with this README/setup, keep each VM updated with:

    # cd /etc/puppet
    # git pull
    # puppet.exec
    
The last shell script is just a wrapper around the *puppet agent* command.
Naturally, these steps can be automated with a cron job. 


### Version information

Debian GNU/Linux 7.1 (wheezy)

Puppet 2.7.18-5

Oracle: virtualbox-4.2.16 


### Set up each VM with NAT (not bridged networking)

If not already done so, install a VM with the VirtualBox wizard (use *New*
button) and use NAT (which is the default networking setup).

Once the Debian installer starts, and with the site manifest as is, use 'web',
'mojo', 'php', 'hard', 'ruby', 'python'. 'cobol' and 'java' as the *host name*,
and here I use 'vbox.tld' as the VM *domain name*. Note that each VM domain
*must* use the same domain name to deploy one site manifest for all VM's.

Install *openssh-server* on each guest VM to provide secure access from host.
There is no requirement to install Oracles' guest additions to share files.


### Initial Puppet preparations to run master and agent on same host 'mojo'

Log in to one VM and open two root terminals. Edit the */etc/hosts* file.
In the site/modules/manifests Puppet nodes are prefixed with 'node-' before
the Puppet master hostname. E.g. for 'mojo' change the ip4 settings as:

    127.0.0.1 localhost
    10.0.2.15 mojo.vbox.tld  mojo  node-mojo 

VirtualBox always give each new VM the ip4 address as 10.0.2.15 which
simplifies the setup.

Here *mojo* is the host name for Puppet master, and *node-mojo* is the host
name for Puppet agent. To continue, test Puppet master FQDN with:
    
    # hostname -f
    mojo.vbox.tld

Without this working correct as above, Puppet will not install properly.

In case the source for the VM where downloaded as a CD/DVD iso image, comment
out the reference to the CD-source in */etc/apt/sources.list* file and run:

    # aptitude update


### Install Git, Puppet master and clone this 'virtualbox.git' repository

Install Git and Puppet master with:

    # aptitude install git
    # aptitude install puppetmaster
    
Note that no error messages are allowed when the puppetmaster is
restarted at the end of the installation process.
    
Before cloning this project, backup the puppet directory with:

    # cd /etc
    # mkdir puppet.original
    # cp -r puppet/* puppet.original/
    # ls -l puppet.original
    
Once the backup is done, remove the original puppet directory and all files:

    # rm -fr puppet
    # git clone https://github.com/berrak/virtualbox.git puppet


### Directory structure after cloning 'virtualbox.git'

The directory layout after cloning this repository looks like:

    /etc/puppet/manifests
                        site.pp
                                     
    /etc/puppet/modules                    
                        <module-name/>
                                    files/
                                    manifests/
                                    templates/
                        .

Copy back the configuration files  with:

    # cd puppet
    # cp ../puppet.original/*.conf .
    
Edit *puppet.conf* to look like:


    # /etc/puppet/puppet.conf
    [main]
    logdir=/var/log/puppet
    vardir=/var/lib/puppet
    rundir=/var/run/puppet
    factpath=$vardir/lib/facter
    
    ssldir=/etc/puppet/ssl

    server=mojo.vbox.tld

    [agent]
    certname=node-mojo.vbox.tld

Save the file. Note: the new path for the *ssldir*. The server name is
identical for master and agent, thus can be below the *main* heading.


### Recreate the ssl directory and sign Puppet master

Stopping the running Puppet master and starting it again recreates the certificates
for Puppet master in */etc/puppet/ssl* sub directories.

    # /etc/init.d/puppetmaster stop
    # /etc/init.d/puppetmaster start 

This created the */etc/puppet/ssl* sub directory. What just
happened was logged and can be viewed with:

    # tail /var/log/daemon.log
    
    
### Install Puppet agent on the node 'mojo'

Time to setup the *node-mojo*. Install Puppet agent with:

    # aptitude install puppet
    
Create a node certificate and run 'node-mojo' manifests:

    # puppet agent --onetime --no-daemonize --verbose --waitforcert 60
    
In the second root terminal (hit the 'host-key', which usully is 'right-ctrl' key + F1),
login to view and sign the request from *node-mojo* with:

    # puppet cert --list
    # puppet cert --sign node-mojo.vbox.tld
    # tail /var/log/daemon.log
    
Watch the initial *node-mojo* run in the first window. In case of errors just rerun with:

    # puppet agent --server=mojo.vbox.tld --onetime --no-daemonize --verbose
    
If run was successful, an alternative to previous command is:

    # puppet.exec
    
You may need to close and open the terminal again to source the new root paths.


### SSH access to guests with NAT port forwarding

Ensure that the VM is off and type commands as a regular <user> account.
Use 'VBoxManage' to configure port forwarding. Show your VM's with:

    $ VBoxManage list vms
    
Here we examplify with guest *mojo*. Add a NAT rule for SSH with:

    $ VBoxManage modifyvm mojo --natpf1 "guestssh,tcp,127.0.0.1,2201,,22"
    
There is no requirement to specify the guest ip, but we need to use a port
greater than 1024 on the host. Since we have many VM's, assign *mojo* an
unique port number. This can also be done with Oracles' GUI (Settings->
Network->Advanced->Port Forwarding).

Now start VM *mojo* and connect with:

    $ ssh -p 2201 <user>@127.0.0.1
    
Use scp to send files to the guest *mojo*:

    $ scp -P 2201 <file.name> <user>@127.0.0.1:/home/<user>/<file.name>
    
Use scp to get files from guest *mojo*, but consider the security risk and save
files from guests on a separate partition with 'nodev,noexec,nosuid' options:
    
    $ scp -P 2201 <user>@127.0.0.1:/home/<user>/<file.name>  <path><file.name>

    
### Finally update all VM's to be managed by Puppet

For each VM, repeat above steps for each VM, i.e. *web*, *php*, *hard*, *ruby*
*python*, *cobol* and *java*, but give each VM a unique port number in previous
step.


### TODO

Script above steps to automate some of the VM setup for Git and Puppet.


### References

[1] Puppet Labs: https://puppetlabs.com/

[2] 6 Ways to Defend against Drive-by Downloads: http://www.cio.com/article/699970/6_Ways_to_Defend_Against_Drive_by_Downloads

[3] Linux Magazine, Issue 152, July 2013: http://www.linux-magazine.com/Issues/2013/152/Stopping-Drive-By-Attacks

[4] Perl Mojolicious Web Framework: http://mojolicio.us/

[5] Debian wheezy Download: http://www.debian.org/distrib/

[6] VirtualBox Download: https://www.virtualbox.org/wiki/Linux_Downloads


