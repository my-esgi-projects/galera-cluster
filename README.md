# galera-cluster
Setup galera cluster with 4 virtuals machins

## Requirements
- 4 debian virtual machins with secure ssh configured
- Another server with ansible and git installed for use as client


## Installation

1. Clone repository 
    > git clone https://github.com/my-esgi-projects/galera-cluster.git

2. Edit inventory file for configure ip and short_name of yours server
    > cd galera-cluster
    
    > vi inventory.yaml 

3. Launch playbook with this command
    > ansible-playbook -i inventory.yaml -v playbook.yaml -e 'ansible_python_interpreter=/usr/bin/python3' -c ssh


At the end of execution, you will have configure and install galera_cluster for mariadb servers and configure proxy server for the access


