# Homelab

Ansible playbook to deploy my homelab (as of right now, I single Raspberry Pi 1 B+... yeah)

## Requirements

```sh
sudo apt install sshpass
pip3 install "pywinrm>=0.2.2"
```

# Run

```sh
ansible-playbook -i hosts playbook.yml
```

run ansible_pass