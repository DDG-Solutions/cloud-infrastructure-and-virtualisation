[all:vars]
ansible_ssh_common_args='-o StrictHostKeyChecking=no'
ansible_python_interpreter=/usr/bin/python3
ansible_user=azureuser
${hostname} ansible_host=${public_ip} 


[CA2]
${hostname} ansible_host=${public_ip} 