# SoftHSM

HSMs are used for storing the keys securely and for acceleration. SoftHSM is a generic software‑only HSM, which is perfectly suitable for us.

1. First configure the token in SoftHSM.

        > sudo vim /etc/softhsm/softhsm.conf

It is possible to configure multiple tokens, although this is not something we will utilize in this exercise.

2. Enumerate the slots by using the command below.

        > softhsm --show-slots

The command will fail as we do not have read/write privileges to the tokens nor the configuration file.

3. You can also verify this in the syslog.

        > sudo tail /var/log/syslog

4. Try again with correct privileges.

        > sudo softhsm --show-slots

5. Next task is to initialize the token. The label should be unique for each token (e.g., “KSK” and “ZSK”). In the example below we will configure a single token (at slot 0) named “OpenDNSSEC”.

        > sudo softhsm --init-token --slot 0 --label OpenDNSSEC

6. Verify the initialization.

        >  sudo softhsm --show-slots
