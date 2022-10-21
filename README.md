# Wordpress HA

## Description

Install wordpress with hight availability using these architecture

- OPNsense as firewall and dns forwarding(default nameserver)
- Powerdns as local dns
- Galera for database cluster
- Haproxy for database load balancer (cluster database)
- Nginx for webservers
- Haproxy again for load balancer (cluster web)

Bonus: 
We have configured manually reverse proxy for redirect trafic to haproxy web.

## Requirements
- 4 debian virtual machins with secure ssh configured for galera cluster
   
``` 
    galera:
      children:
        galera_master:
          hosts:
            master-db.esgisrc.fr:
   
        galera_slave:
          hosts:
            slave1-db.esgisrc.fr:
            slave2-db.esgisrc.fr:

        galera_proxy_sql:
          hosts:
            proxy-db.esgisrc.fr:
```

set variables for dns shortaname and make sure that you can make resolution with it
ex: 
  > nslookup slave1-db
  
  must return ip of slave1-db.esgisrc.fr

- 2 debian servers for glusterfs servers

```
    glusterfs:
      children:
        glusterfs_master:
          hosts:
            file01-gfs.esgisrc.fr:
            file02-gfs.esgisrc.fr:
```

- 4 debian servers for web servers cluster

```
    haproxy:
      children:
        web_servers:
          hosts:
            web01.esgisrc.fr:
            web02.esgisrc.fr:
            web03.esgisrc.fr:
        
        web_load_balancer:
          hosts:
            haproxy.esgisrc.fr:
```

- Another server with ansible and git installed for use as client. DNS must be configured


## Installation

1. Clone repository 
    > git clone https://github.com/my-esgi-projects/galera-cluster.git

2. Edit inventory file for configure ip and short_name of yours server
    > cd galera-cluster
    
    > vi inventory.yaml 

3. Install glusterfs and openssl crypto collection
    > ansible-galaxy collection install gluster.gluster

    > ansible-galaxy collection install community.crypto

3. Launch playbook with this command
    > ansible-playbook -i inventory.yaml -v playbook.yaml -e 'ansible_python_interpreter=/usr/bin/python3' -c ssh



- Reverse proxy must be configured manually...
We can add it automation asap

NB: If you want to run service by service, you can create new playbook with any play in actual playbook.
