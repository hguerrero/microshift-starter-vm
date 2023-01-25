# Microshift Starter VM

If you are interested in trying [microshift](https://microshift.io/), you can use this Vagrant VM to get started. This repo provides a template Vagrantfile to create a microshift virtual machine using VirtualBox as the hypervisor. After setup is complete you will havea single microshift VM running on your host.

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

    