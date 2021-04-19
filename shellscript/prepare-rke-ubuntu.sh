#!/bin/bash
ufw disable
swapoff -a; sed -i '/swap/d' /etc/fstab
apt install -y apt-transport-https ca-certificates curl gnupg-agent software-properties-common
curl https://releases.rancher.com/install-docker/19.03.sh | sh
systemctl enable docker.service
systemctl enable containerd.service
