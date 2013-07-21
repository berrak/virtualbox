## VirtualBox VM's managed by Puppet/Git for Safer Development

### VirtualBox and Debian Wheezy (a.k.a. Debian 7)

VirtualBox provides a great environment for admin tests or running
clean desktop environments isolated from the host installation.

This setup describes how to setup Puppet [1] and Git on each VM. 

In this project each virtual machine is managed by Puppet and Git. Each
VM is totally isolated using the default setup with NAT networking.

Today, probably the greatest IT security risk is actually ourselves. What did
you downloaded? Did you executed it? Do you know the source? Which unsafe sites
did you visited? [2]

In the site manifest, a few examples of desktop and server uses are given.

    * a web desktop (web) environment, hardened for a safer web experience [3]
    * a Perl web development (mojo) exploring mojolicious web framework [4]
    * a php development environment (php) exploring php5/SQL etc.
    * a hardened server setup (hard)
    
Here, each VM use Debian 7 iso image [5]. 

Above examples will evolve over time and are far from complete. Feel free
to suggest contributions. To install the latest VirtualBox, see reference [6].
Oracles' Debian installer works nicely, as expected after adding their
repository to the */etc/apt/sources.list* file.

To manually update each VM simply run on the cli:

    # cd /etc/puppet
    # git pull
    # puppet.exec
    
The last shell script is just a wrapper around the *puppet agent* command.
Naturally, these simple steps can be automated with a cron job. 


### Version information

Debian GNU/Linux 7.1 (wheezy)

Puppet 2.7.18-5

Oracle: virtualbox-4.2.16 


### Setting up each VM with NAT (not bridged networking)

If not already done so, install a VM with the VirtualBox wizard (use *New* button)
and use NAT (which is the default networking setup).

Once the Debian installer starts, and with the site manifest as is, use 'web',
'mojo', 'php' and 'hard' as the *host name*, and here I use 'vbox.tld' as the VM
*domain name*. Note that each VM domain *must* use the same domain name to
deploy one universal site manifest for all VM's.


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

    # aptitude install -PVR git
    # aptitude install -PVR puppetmaster
    
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
    # cd puppet


### Directory structure and Puppet modules after cloning 'virtualbox.git'

The layout structure for the downloaded :

    /etc/puppet/manifests
                        site.pp
                                     
    /etc/puppet/modules                    
                        <module-name/>
                                    files/
                                    manifests/
                                    templates/
                        .

Copy back the configuration files  with:

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

Save the file. Note: the new path for the *ssldir*. The server is same for
both the master and agent thus can be below *main*.


### Recreate the ssl directory and sign Puppet master

Stopping the running Puppet master and starting it again recreates the certificates
for Puppet master in */etc/puppet/ssl* sub directories.

    # /etc/init.d/puppetmaster stop
    # /etc/init.d/puppetmaster start 

This created the */etc/puppet/ssl* sub directory. What just
happened is logged and can be viewed with:

    # tail /var/log/daemon.log
    
    
### Install Puppet agent on the node 'mojo'

Time to setup the *node-mojo*. Install Puppet agent with:

    # aptitude install puppet
    
Create a node certificate and run 'node-mojo' manifests:

    # puppet agent --server=mojo.vbox.tld --onetime --no-daemonize --verbose --waitforcert 60
    
In a second root terminal, view and sign the request from *node-mojo* with:

    # puppet cert --list
    # puppet cert --sign node-mojo.vbox.tld
    # tail /var/log/daemon.log
    
Watch the initial *node-mojo* run in the first window. In case of errors just rerun with:

    # puppet agent --server=mojo.vbox.tld --onetime --no-daemonize --verbose
    
If run was successful, an alternative to previous command is:

    # puppet.exec
    
You may need to close and open the terminal again to source the new root paths.

    
### Finally update all VM's to be managed by Puppet

For each VM, repeat above steps for each VM, i.e. *web*, *php* and *hard*.


### TODO

Script above steps to automate the VM setup for Git and Puppet.


### References

[1] Puppet Labs: https://puppetlabs.com/

[2] 6 Ways to Defend against Drive-by Downloads: http://www.cio.com/article/699970/6_Ways_to_Defend_Against_Drive_by_Downloads

[3] Linux Magazine, Issue 152, July 2013: http://www.linux-magazine.com/Issues/2013/152/Stopping-Drive-By-Attacks

[4] Perl Mojolicious Web Framework: http://mojolicio.us/

[5] Debian wheezy Download: http://www.debian.org/distrib/

[6] VirtualBox Download: https://www.virtualbox.org/wiki/Linux_Downloads


