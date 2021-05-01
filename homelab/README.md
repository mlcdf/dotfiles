# Homelab

Ansible playbook to deploy my homelab (as of right now, a single Raspberry Pi 1 B+... yeah)

## Requirements

```sh
sudo apt install sshpass
pip3 install "pywinrm>=0.2.2"
```

## Usage

```sh
ansible-playbook -i hosts/pi playbook.yml
```

On first run, add `--extra-var ansible_pass=raspberrypi` which is the default password for the Rpi.
