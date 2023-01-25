# Microshift Starter VM

If you are interested in trying microshift, you can use this Vagrant VM to get started.

## Setup

As we're using Red Hat Enterprise Linux (RHEL), we need to use subscription-manager to get access to the entitlements we need. This is automated using the vagrant-registration plugin.

If you don't have access to RHEL subs, the Red Hat Developer program provides easy access if you [register for an account](https://sso.redhat.com/auth/realms/redhat-external/login-actions/registration?client_id=rhd-web&tab_id=fvIFNo4HP5U)!

To avoid hardcode the username and password in the Vagrantfile, which isn't best practice, we need ENV variables, which get picked up by the plugin.

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