#!/bin/bash
dnf -y install chrony
systemctl enable --now chronyd
dnf -y install yum-utils
#yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo
dnf config-manager --add-repo=https://download.docker.com/linux/centos/docker-ce.repo
sudo dnf install docker-ce --nobest
dnf -y install https://download.docker.com/linux/centos/7/x86_64/stable/Packages/containerd.io-1.2.13-3.2.el7.x86_64.rpm
sudo dnf install docker-ce -y
systemctl enable --now docker
systemctl status docker
docker --version
useradd -g docker rke
passwd rke
swapoff -a
sed -i '/ swap / s/^(.*)$/#\1/g' /etc/fstab
echo -e 'br_netfilter\nip6_udp_tunnel\nip_set\nip_set_hash_ip\nip_set_hash_net\niptable_filter\niptable_nat\niptable_mangle\niptable_raw\nnf_conntrack_netlink\nnf_conntrack\nnf_conntrack_ipv4\nnf_defrag_ipv4\nnf_nat\nnf_nat_ipv4\nnf_nat_masquerade_ipv4\nnfnetlink\nudp_tunnel\nveth\nvxlan\nx_tables\nxt_addrtype\nxt_conntrack\nxt_comment\nxt_mark\nxt_multiport\nxt_nat\nxt_recent\nxt_set\nxt_statistic\nxt_tcpudp' > /etc/modules-load.d/rke.conf
cat /etc/modules-load.d/rke.conf
for module in br_netfilter ip6_udp_tunnel ip_set ip_set_hash_ip ip_set_hash_net iptable_filter iptable_nat iptable_mangle iptable_raw nf_conntrack_netlink nf_conntrack nf_conntrack_ipv4 nf_defrag_ipv4 nf_nat nf_nat_ipv4 nf_nat_masquerade_ipv4 nfnetlink udp_tunnel veth vxlan x_tables xt_addrtype xt_conntrack xt_comment xt_mark xt_multiport xt_nat xt_recent xt_set xt_statistic xt_tcpudp; do modprobe $module; done
echo "net.bridge.bridge-nf-call-iptables = 1" >> /etc/sysctl.d/rke.conf
echo "net.bridge.bridge-nf-call-ip6tables = 1" >> /etc/sysctl.d/rke.conf
echo "net.ipv4.ip_forward = 1" >> /etc/sysctl.d/rke.conf
sysctl -p /etc/sysctl.d/rke.conf
wget -O /usr/local/bin/rke https://github.com/rancher/rke/releases/download/v1.2.7/rke_linux-amd64
chmod +x /usr/local/bin/rke
rke --version
dnf -y install kubectl

cat <<EOF > /etc/yum.repos.d/kubernetes.repo
[kubernetes]
name=Kubernetes
baseurl=https://packages.cloud.google.com/yum/repos/kubernetes-el7-x86_64
enabled=1
gpgcheck=1
repo_gpgcheck=1
gpgkey=https://packages.cloud.google.com/yum/doc/yum-key.gpg https://packages.cloud.google.com/yum/doc/rpm-package-key.gpg
EOF