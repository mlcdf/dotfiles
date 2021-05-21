# Homelab

Ansible playbook to deploy my homelab (as of right now, a single Raspberry Pi 1 B+... yeah)

## Usage

```sh
ansible-playbook -i hosts/pi playbook.yml
```

### First run only

Obviously, SSH public key authentication won't work on the first run. You'll need to login via password:

Install sshpass on the control machine
```sh
sudo apt install sshpass
```

Add `--extra-var ansible_pass=raspberrypi` which is the default password for the Rpi.
