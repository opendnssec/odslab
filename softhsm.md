# SoftHSM

HSMs are used for storing the keys securely and for acceleration. SoftHSM is a generic software-only HSM, which is perfectly suitable for us. This material is based on SoftHSM version 2.

1.  Install SoftHSM:

        sudo apt-get install -y softhsm2

2. First configure the token in SoftHSM:

        sudo vim /etc/softhsm/softhsm2.conf

   There is no editing needed at this point, but storage path and options
   are specified here.

3. Create a directory for the SoftHSM tokens:

        sudo mkdir /var/lib/softhsm/tokens/

    It is possible to configure multiple tokens, although this is not something we will utilize in this exercise.

4. Next task is to initialize the token. The label should be unique for each token (e.g., "KSK" and "ZSK"). In the example below we will configure a single token (at slot 0) named "OpenDNSSEC".

        sudo softhsm2-util --init-token --slot 0 --label OpenDNSSEC

   You will be asked for a PIN and a security officer SO-PIN number.  These are needed later and cannot be retrieved later from the system.

5. Verify the initialization.

        sudo softhsm2-util --show-slots

   Note that SoftHSM will always show an uninitialized token in addition to the one you initialized. This is deliberate.


---
Next Section: [HSM Testing and Benchmarking](hsm-testing.md)
