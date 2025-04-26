export ANSIBLE_CONFIG="ansible/ansible.cfg"
ansible-inventory -i ansible/inventory "$@"