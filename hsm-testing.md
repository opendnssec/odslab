# HSM Testing and Benchmarking

It is always good to verify the functionality of the HSM before starting to sign your zone. There are some tools available with OpenDNSSEC which will verify the interoperability.

1. OpenDNSSEC cannot access your tokens, which you will see with this command.

        sudo ods-hsmutil info

   N.B.: The command above will **fail** due to missing configuration.

2. You need to configure your tokens in OpenDNSSEC. The repository name is what OpenDNSSEC uses to identify the tokens internally. Note that the repository name is not the same as the HSM token label. Don't forget to replace XXXX with the User PIN set used when initializing the token and be sure the indicated Module is correct.

        sudo vim /etc/opendnssec/conf.xml

    File contents:

        <Repository name="SoftHSM">
          <Module>/usr/lib/x86_64-linux-gnu/softhsm/libsofthsm2.so</Module>
          <TokenLabel>OpenDNSSEC</TokenLabel>
          <PIN>XXXX</PIN>
          <SkipPublicKey/>
        </Repository>

3. Now it is possible for OpenDNSSEC to access the tokens.

        sudo ods-hsmutil info

4. Try generating keys and signatures.

        sudo ods-hsmutil test SoftHSM

5. There is also a tool which will perform speed tests on the HSM. It has been noted that using multiple threads on these virtual machines will decrease the performance dramatically.

        sudo ods-hsmspeed -r SoftHSM -i 1000 -s 2048 -t 1


---
Next Section: [Publish unsigned zone using BIND](publish-unsigned.md)
