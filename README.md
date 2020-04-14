# [mercurial-server](http://www.lshift.net/work/open-source/mercurial-server/) for Docker

As a pre-requisite, a user must load a private SSH key. By default, ~/.ssh/id_rsa is loaded: 

    eval `ssh-agent`
    ssh-add
    ssh-add -L

The repositories are in  `/var/lib/mercurial-server/repos`

It will generate SSH keys and place them in repository `sshd_keys` and create the `hgadmin` repository. 
It will only create the repos if they are not there.

First time use (add your SSH keys as the `hgadmin` root keys):

    docker build ./
    docker run -p 8022:8022 -e HG_ROOTUSER_KEYS="$(ssh-add -L)" <image>

Later uses:

    docker run -v <repos>:/var/lib/mercurial-server/repos -p 8022:8022 <image>

## Using docker-compose and [docker-letsencrypt-nginx-proxy-companion](https://github.com/nginx-proxy/docker-letsencrypt-nginx-proxy-companion)

Ensure nginx-proxy and letsencrypt-nginx-proxy-companion are set up and running, then modify docker-compose.yml to reflect your server-specific settings. 

    docker-compose up -d

Option `-v <repos>:/var/lib/mercurial-server/repos` is omnly needed if you want to mount the repos on a separate volume.
If you mount a volume in your container, make sure that it is writable by user `hg`:

    chown -R 106:107 <volume>


All configuration is done through the hgadmin repository, as explained in the file `/usr/share/doc/mercurial-server/html/index.html`.

    hg clone ssh://hg@localhost:8022/hgadmin
    cd hgadmin
    # change config
    hg push

