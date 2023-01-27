# MicroShift Starter VM

If you are interested in trying Red Hat Device Edge, based on the open source project [MicroShift](https://microshift.io/), you can use this Vagrant VM to get started. This repo provides a template Vagrantfile to create a MicroShift virtual machine using VirtualBox as the hypervisor. After setup is complete you will havea single MicroShift VM running on your host.

### Prerequisites

For running this machine you will need to have installed:

- VirtualBox 6.1 or greater
- Vagrant 1.6 or greater

Also you will need to have a Red Hat account.

As we're using Red Hat Enterprise Linux (RHEL), we need to use subscription-manager to get access to the entitlements we need. This is automated using the vagrant-registration plugin.

If you don't have access to RHEL subs, the Red Hat Developer program provides easy access if you [register for an account](https://sso.redhat.com/auth/realms/redhat-external/login-actions/registration?client_id=rhd-web&tab_id=fvIFNo4HP5U)!

To avoid hardcode the username and password in the Vagrantfile, which isn't best practice, we need ENV variables, which get picked up by the plugin.

## Setup

1. Clone this project

    ```sh
    git clone https://github.com/hguerrero/microshift-starter-vm.git
    cd microshift-starter-vm
    ```

1. Install the proper vagrant plugins:

    ```sh
    vagrant plugin install vagrant-registration
    ```

1. Add your subscription credentials as env variables:

    ```sh
    export SUB_USERNAME="your_rhn_id"
    export SUB_PASSWORD="your_rhn_password"
    ```

1. Start the VM

    ```sh
    vagrant up
    ```

    It will take a moment to download the image depending on your internet connection, so be patient.

1. Login into the machine

    ```sh
    vagrant ssh
    ```

1. Finally, check if MicroShift is up and running by executing `oc` commands.

    ```sh
    oc get cs
    oc get pods -A
    ```

    This may take a few minutes the first time MicroShift starts, because it still needs to pull the container images it deploys. When it's ready, `oc get pods -A` output should look similar to:
    
    ```sh
    NAMESPACE                  NAME                                      READY   STATUS    RESTARTS   AGE
    openshift-dns              pod/dns-default-lm55n                     2/2     Running   0          80s
    openshift-dns              pod/node-resolver-zp7gw                   1/1     Running   0          3m11s
    openshift-ingress          pod/router-default-ddc545d88-mk8gc        1/1     Running   0          3m5s
    openshift-ovn-kubernetes   pod/ovnkube-master-4586k                  4/4     Running   0          3m11s
    openshift-ovn-kubernetes   pod/ovnkube-node-xgx9t                    1/1     Running   0          3m11s
    openshift-service-ca       pod/service-ca-77fc4cc659-ncmbv           1/1     Running   0          3m6s
    openshift-storage          pod/topolvm-controller-5fc9996875-lzpgx   4/4     Running   0          3m12s
    openshift-storage          pod/topolvm-node-hb5mh                    4/4     Running   0          80s
    ```

### Deploy the OKD web console

Now that we have a running instance of microshift, we can complement it with a nice console. We will de ploy the OKD console in the cluster. 

For that you will need to run the following command from within the same directory:

```sh
oc apply -f k8s/
```

This will create all the required resources to enable the console. It will be available at http://console.127.0.0.1.nip.io and should be accessible from your host machine.

### Access the cluster from your host machine

If you want to avoid the step to ssh into the VM, you can copy the information regarding the kubeconfig into machine and run any kubectl or oc command from there.

For that, copy the kubeadmin into your machine. For example:

```sh
scp -P 2222 -i .vagrant/machines/microshift-starter/virtualbox/private_key vagrant@localhost:/home/vagrant/.kube/config ~/kube-ushift
export KUBECONFIG=~/kube-ushift
```

You will need to open the file and replace the kube api url with `localhost` instead of 127.0.0.1 to avoid any certificate issues.

With that, you should be able to access your cluster from the host machine.

