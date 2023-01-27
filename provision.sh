#!/bin/bash
# Script for provisioning microshift on RHEL 8

# Import Red Hat public keys to allow RPM GPG check (not necessary if a system is registered)
if ! subscription-manager status >& /dev/null ; then
   rpm --import /etc/pki/rpm-gpg/RPM-GPG-KEY-redhat-*
fi

tee /etc/yum.repos.d/rhocp-4.12-el8-beta-$(uname -i)-rpms.repo >/dev/null <<EOF
[rhocp-4.12-el8-beta-$(uname -i)-rpms]
name=Beta rhocp-4.12 RPMs for RHEL8
baseurl=https://mirror.openshift.com/pub/openshift-v4/\$basearch/dependencies/rpms/4.12-el8-beta/
enabled=1
gpgcheck=1
skip_if_unavailable=0
EOF

# Install MicroShift testing package
dnf copr enable -y @redhat-et/microshift-testing
dnf install -y microshift
dnf install -y openshift-clients

# MicroShift service should be enabled later after setting up CRI-O with the pull secret

# Configure firewalld
firewall-offline-cmd --zone=trusted --add-source=10.42.0.0/16
firewall-offline-cmd --zone=trusted --add-source=169.254.169.1

# Open ports
firewall-offline-cmd --zone=public --add-port=6443/tcp
firewall-offline-cmd --zone=public --add-port=30000-32767/tcp
firewall-offline-cmd --zone=public --add-port=2379-2380/tcp
firewall-offline-cmd --zone=public --add-masquerade
firewall-offline-cmd --zone=public --add-port=80/tcp
firewall-offline-cmd --zone=public --add-port=443/tcp
firewall-offline-cmd --zone=public --add-port=10250/tcp
firewall-offline-cmd --zone=public --add-port=10251/tcp
firewall-offline-cmd --change-zone=eth0 --zone=public

firewall-cmd --reload

# Copy pull secret
cp /vagrant_data/.pull-secret.json /etc/crio/openshift-pull-secret

# Configure storage
mkdir -p /etc/microshift
cat <<'EOF' >>/etc/microshift/lvmd.yaml
socket-name: /run/lvmd/lvmd.socket
device-classes:
- default: true
  name: default
  volume-group: rhel_rhel8
EOF

# Start microshift
systemctl enable --now microshift.service

# Install the kubeconfig for the Vagrant user
su - vagrant -c "mkdir ~/.kube"
install -C -o vagrant -g vagrant /var/lib/microshift/resources/kubeadmin/kubeconfig /home/vagrant/.kube/config