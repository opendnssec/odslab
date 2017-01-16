# SoftHSM

HSMs are used for storing the keys securely and for acceleration. SoftHSM is a generic software-only HSM, which is perfectly suitable for us.

This material is based on SoftHSM version 1, as it is still the default being distributed.

1. First configure the token in SoftHSM.

        > sudo vim /etc/softhsm/softhsm.conf

```comment
It seems that the standard distributed softhsm isn't really configured
properly and this file has the contents:
  0:/var/lib/lib/softhsm/slot0.db
which is a bit in violation of the FHS it is needed to correct this to
  0:/var/lib/softhsm/slot0.db
```

It is possible to configure multiple tokens, although this is not something we will utilize in this exercise.

2. Enumerate the slots by using the command below.

        > softhsm --show-slots

The command will fail as we do not have read/write privileges to the tokens nor the configuration file.

3. You can also verify this in the syslog.

        > tail /var/log/syslog

```comment
no sudo needed here on Ubuntu
```

4. Try again with correct privileges.

        > sudo softhsm --show-slots

5. Next task is to initialize the token. The label should be unique for each token (e.g., "KSK" and "ZSK").
   In the example below we will configure a single token (at slot 0) named "OpenDNSSEC".

        > sudo softhsm --init-token --slot 0 --label OpenDNSSEC

   You will be asked for a PIN and a security officer SO-PIN number.  These are needed later and cannot be retrieved later from the system.

```comment
Because the softhsm does not require a verification of the PIN numbers there is an issue that the PIN might not actually what
people have typed.  The use of --pin and --so-pin is attractive, but security wise, unwise.
```

6. Verify the initialization.

        >  sudo softhsm --show-slots
