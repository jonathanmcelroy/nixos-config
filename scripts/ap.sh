export ANSIBLE_CONFIG="ansible/ansible.cfg"
ansible-playbook -i ansible/inventory "$@"