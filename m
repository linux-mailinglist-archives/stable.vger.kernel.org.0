Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0684D6E3459
	for <lists+stable@lfdr.de>; Sun, 16 Apr 2023 00:58:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229999AbjDOW6b (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 15 Apr 2023 18:58:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44284 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230009AbjDOW6a (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 15 Apr 2023 18:58:30 -0400
Received: from mail-pj1-x102f.google.com (mail-pj1-x102f.google.com [IPv6:2607:f8b0:4864:20::102f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B0C651FE1
        for <stable@vger.kernel.org>; Sat, 15 Apr 2023 15:58:27 -0700 (PDT)
Received: by mail-pj1-x102f.google.com with SMTP id cm18-20020a17090afa1200b0024713adf69dso9921848pjb.3
        for <stable@vger.kernel.org>; Sat, 15 Apr 2023 15:58:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20221208.gappssmtp.com; s=20221208; t=1681599507; x=1684191507;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=BBT6ohE7BzNTL7FTPMRblbHw6SHtlGT9p4YSsRKMqO0=;
        b=xMnw3wkB7Z8czWRdhcq9mAN6YXLGOjhhc9I+0TFDNRPF9IJHmhtUDoCY1w9vWFJcCB
         lGL+deqs4eFPjAnjnP3FSOMN1MZYFk36us6+YABvZqpF21kCs0BOCgGWHypnYZDcCJS5
         FvBRKuNfJFsj4QPyVz99lMC+nb9pm0HRlwBlKEgQFchYO9qUL6e27hTkmluGs9T+xy/L
         GSUVsuHRqqJAmvnCq3yI6HqDnuRLcfcIg1KnHkWCk0MlBIVb7fY7WmzpEF4gWCwoE6hi
         tPTq5P4qIjQ77qzuMfsTCbDTqgCcVYPnFOV76EP4v5K3NJbxKKTWMl8O/XRb3eIjm2RL
         euLQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681599507; x=1684191507;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=BBT6ohE7BzNTL7FTPMRblbHw6SHtlGT9p4YSsRKMqO0=;
        b=Ii5WnWIplOX+O08u99CHsUThrP+EBl6NdOC3Ciz9QwoXBzi6+UHqSp0Mylp/yVhd7d
         7swMqKkGsR6FDaEFZPko+FVLFioC1u8WFPGrDh+SXzIG0kDsESf6nOQTJLYp/OEA+VrQ
         UIE/Khmbc6AVcN46pNnXDlo60zY2zubDd8YqXWAsQMWICBT+FssqKKlUe4rU95WiI5ml
         3beIUR/XW45e9fSmhqnXOzpcNGhjkgLzUfMgtjBP5bHAdAeUnK0WZgZAJOGsXKuKauvf
         fObkuPwqBZloKDIELK+IyfKYQbGt3clTM/ZkPm1C181AaeKdwDQrbryLf6AbnO8SQq26
         2qnw==
X-Gm-Message-State: AAQBX9c6vJHRI0351TUKoszUtrrIuJmO0KdG0dBXTXSwWK4zlr1onEr3
        x0rCay7DXsXaLs7V7dn2QkEZ57EtVRhqN3mLUD9sxawv
X-Google-Smtp-Source: AKy350YVmBnsG8FMvDfy0UUlZhgim87etufkwTpXkmuKGUk1wsYSNMtdZY9Xf3sp+8ZlNHYvlHuscQ==
X-Received: by 2002:a17:902:dac1:b0:1a0:5bb1:3f0b with SMTP id q1-20020a170902dac100b001a05bb13f0bmr9767059plx.40.1681599506806;
        Sat, 15 Apr 2023 15:58:26 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id v16-20020a1709028d9000b001a0567811fbsm5047926plo.127.2023.04.15.15.58.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 15 Apr 2023 15:58:26 -0700 (PDT)
Message-ID: <643b2c12.170a0220.3afbe.be54@mx.google.com>
Date:   Sat, 15 Apr 2023 15:58:26 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: queue/6.1
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v6.1.22-364-g39097b93e319
X-Kernelci-Report-Type: test
Subject: stable-rc/queue/6.1 baseline: 153 runs,
 8 regressions (v6.1.22-364-g39097b93e319)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/6.1 baseline: 153 runs, 8 regressions (v6.1.22-364-g39097b9=
3e319)

Regressions Summary
-------------------

platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
asus-C436FA-Flip-hatch       | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =

asus-CM1400CXA-dalboz        | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =

asus-cx9400-volteer          | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =

bcm2835-rpi-b-rev2           | arm    | lab-broonie   | gcc-10   | bcm2835_=
defconfig            | 1          =

hp-x360-12b-c...4020-octopus | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =

hp-x360-14-G1-sona           | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =

hp-x360-14a-cb0001xx-zork    | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =

lenovo-TPad-C13-Yoga-zork    | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F6.1/kern=
el/v6.1.22-364-g39097b93e319/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/6.1
  Describe: v6.1.22-364-g39097b93e319
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      39097b93e319129696fcb085b552b36ee08c5c69 =



Test Regressions
---------------- =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
asus-C436FA-Flip-hatch       | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/643af34b65fcccf2462e861f

  Results:     6 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-6.1/v6.1.22-36=
4-g39097b93e319/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabora=
/baseline-asus-C436FA-Flip-hatch.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-6.1/v6.1.22-36=
4-g39097b93e319/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabora=
/baseline-asus-C436FA-Flip-hatch.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230407.0/x86/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/643af34b65fcccf2462e8624
        failing since 18 days (last pass: v6.1.21-104-gd5eb32be5b26, first =
fail: v6.1.21-224-g1abeb39fad59)

    2023-04-15T18:55:54.698591  <8>[   10.236757] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 9995587_1.4.2.3.1>

    2023-04-15T18:55:54.702005  + set +x

    2023-04-15T18:55:54.803830  =


    2023-04-15T18:55:54.904817  / # #export SHELL=3D/bin/sh

    2023-04-15T18:55:54.905003  =


    2023-04-15T18:55:55.005920  / # export SHELL=3D/bin/sh. /lava-9995587/e=
nvironment

    2023-04-15T18:55:55.006117  =


    2023-04-15T18:55:55.107065  / # . /lava-9995587/environment/lava-999558=
7/bin/lava-test-runner /lava-9995587/1

    2023-04-15T18:55:55.107339  =


    2023-04-15T18:55:55.113222  / # /lava-9995587/bin/lava-test-runner /lav=
a-9995587/1
 =

    ... (12 line(s) more)  =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
asus-CM1400CXA-dalboz        | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/643af34c84c87501572e85e7

  Results:     6 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-6.1/v6.1.22-36=
4-g39097b93e319/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabora=
/baseline-asus-CM1400CXA-dalboz.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-6.1/v6.1.22-36=
4-g39097b93e319/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabora=
/baseline-asus-CM1400CXA-dalboz.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230407.0/x86/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/643af34c84c87501572e85eb
        failing since 18 days (last pass: v6.1.21-104-gd5eb32be5b26, first =
fail: v6.1.21-224-g1abeb39fad59)

    2023-04-15T18:56:01.124647  + <8>[   11.199096] <LAVA_SIGNAL_ENDRUN 0_d=
mesg 9995559_1.4.2.3.1>

    2023-04-15T18:56:01.124741  set +x

    2023-04-15T18:56:01.229220  / # #

    2023-04-15T18:56:01.330267  export SHELL=3D/bin/sh

    2023-04-15T18:56:01.330477  #

    2023-04-15T18:56:01.431394  / # export SHELL=3D/bin/sh. /lava-9995559/e=
nvironment

    2023-04-15T18:56:01.431627  =


    2023-04-15T18:56:01.532612  / # . /lava-9995559/environment/lava-999555=
9/bin/lava-test-runner /lava-9995559/1

    2023-04-15T18:56:01.532896  =


    2023-04-15T18:56:01.537553  / # /lava-9995559/bin/lava-test-runner /lav=
a-9995559/1
 =

    ... (12 line(s) more)  =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
asus-cx9400-volteer          | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/643af34b65fcccf2462e862a

  Results:     6 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-6.1/v6.1.22-36=
4-g39097b93e319/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabora=
/baseline-asus-cx9400-volteer.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-6.1/v6.1.22-36=
4-g39097b93e319/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabora=
/baseline-asus-cx9400-volteer.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230407.0/x86/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/643af34b65fcccf2462e862f
        failing since 18 days (last pass: v6.1.21-104-gd5eb32be5b26, first =
fail: v6.1.21-224-g1abeb39fad59)

    2023-04-15T18:55:49.748110  <8>[   10.007510] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 9995618_1.4.2.3.1>

    2023-04-15T18:55:49.751218  + set +x

    2023-04-15T18:55:49.853107  /#

    2023-04-15T18:55:49.954438   # #export SHELL=3D/bin/sh

    2023-04-15T18:55:49.954654  =


    2023-04-15T18:55:50.055620  / # export SHELL=3D/bin/sh. /lava-9995618/e=
nvironment

    2023-04-15T18:55:50.055844  =


    2023-04-15T18:55:50.156827  / # . /lava-9995618/environment/lava-999561=
8/bin/lava-test-runner /lava-9995618/1

    2023-04-15T18:55:50.157128  =


    2023-04-15T18:55:50.162453  / # /lava-9995618/bin/lava-test-runner /lav=
a-9995618/1
 =

    ... (12 line(s) more)  =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
bcm2835-rpi-b-rev2           | arm    | lab-broonie   | gcc-10   | bcm2835_=
defconfig            | 1          =


  Details:     https://kernelci.org/test/plan/id/643af3466f2a10f6932e8607

  Results:     50 PASS, 2 FAIL, 1 SKIP
  Full config: bcm2835_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-6.1/v6.1.22-36=
4-g39097b93e319/arm/bcm2835_defconfig/gcc-10/lab-broonie/baseline-bcm2835-r=
pi-b-rev2.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-6.1/v6.1.22-36=
4-g39097b93e319/arm/bcm2835_defconfig/gcc-10/lab-broonie/baseline-bcm2835-r=
pi-b-rev2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230407.0/armel/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/643af3466f2a10f6932e863a
        new failure (last pass: v6.1.22-364-gf7dc7e601a2a)

    2023-04-15T18:55:32.739511  + set +x
    2023-04-15T18:55:32.742124  <8>[   18.303635] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 333556_1.5.2.4.1>
    2023-04-15T18:55:32.859183  / # #
    2023-04-15T18:55:32.961881  export SHELL=3D/bin/sh
    2023-04-15T18:55:32.962517  #
    2023-04-15T18:55:33.064645  / # export SHELL=3D/bin/sh. /lava-333556/en=
vironment
    2023-04-15T18:55:33.065265  =

    2023-04-15T18:55:33.167320  / # . /lava-333556/environment/lava-333556/=
bin/lava-test-runner /lava-333556/1
    2023-04-15T18:55:33.168255  =

    2023-04-15T18:55:33.174328  / # /lava-333556/bin/lava-test-runner /lava=
-333556/1 =

    ... (14 line(s) more)  =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
hp-x360-12b-c...4020-octopus | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/643af37e776467b1c02e8619

  Results:     6 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-6.1/v6.1.22-36=
4-g39097b93e319/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabora=
/baseline-hp-x360-12b-ca0010nr-n4020-octopus.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-6.1/v6.1.22-36=
4-g39097b93e319/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabora=
/baseline-hp-x360-12b-ca0010nr-n4020-octopus.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230407.0/x86/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/643af37e776467b1c02e861e
        failing since 18 days (last pass: v6.1.21-104-gd5eb32be5b26, first =
fail: v6.1.21-224-g1abeb39fad59)

    2023-04-15T18:56:49.808673  + set +x

    2023-04-15T18:56:49.815194  <8>[   10.932862] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 9995590_1.4.2.3.1>

    2023-04-15T18:56:49.919620  / # #

    2023-04-15T18:56:50.020543  export SHELL=3D/bin/sh

    2023-04-15T18:56:50.020780  #

    2023-04-15T18:56:50.121879  / # export SHELL=3D/bin/sh. /lava-9995590/e=
nvironment

    2023-04-15T18:56:50.122169  =


    2023-04-15T18:56:50.223284  / # . /lava-9995590/environment/lava-999559=
0/bin/lava-test-runner /lava-9995590/1

    2023-04-15T18:56:50.223583  =


    2023-04-15T18:56:50.227972  / # /lava-9995590/bin/lava-test-runner /lav=
a-9995590/1
 =

    ... (12 line(s) more)  =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
hp-x360-14-G1-sona           | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/643af338a7e40eca622e85f9

  Results:     6 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-6.1/v6.1.22-36=
4-g39097b93e319/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabora=
/baseline-hp-x360-14-G1-sona.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-6.1/v6.1.22-36=
4-g39097b93e319/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabora=
/baseline-hp-x360-14-G1-sona.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230407.0/x86/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/643af338a7e40eca622e85fe
        failing since 18 days (last pass: v6.1.21-104-gd5eb32be5b26, first =
fail: v6.1.21-224-g1abeb39fad59)

    2023-04-15T18:55:43.149668  + set<8>[   10.936416] <LAVA_SIGNAL_ENDRUN =
0_dmesg 9995611_1.4.2.3.1>

    2023-04-15T18:55:43.149774   +x

    2023-04-15T18:55:43.252253  /#

    2023-04-15T18:55:43.353532   # #export SHELL=3D/bin/sh

    2023-04-15T18:55:43.353751  =


    2023-04-15T18:55:43.454707  / # export SHELL=3D/bin/sh. /lava-9995611/e=
nvironment

    2023-04-15T18:55:43.454948  =


    2023-04-15T18:55:43.555869  / # . /lava-9995611/environment/lava-999561=
1/bin/lava-test-runner /lava-9995611/1

    2023-04-15T18:55:43.556268  =


    2023-04-15T18:55:43.561170  / # /lava-9995611/bin/lava-test-runner /lav=
a-9995611/1
 =

    ... (12 line(s) more)  =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
hp-x360-14a-cb0001xx-zork    | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/643af34f84c87501572e85f4

  Results:     6 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-6.1/v6.1.22-36=
4-g39097b93e319/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabora=
/baseline-hp-x360-14a-cb0001xx-zork.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-6.1/v6.1.22-36=
4-g39097b93e319/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabora=
/baseline-hp-x360-14a-cb0001xx-zork.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230407.0/x86/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/643af34f84c87501572e85f9
        failing since 18 days (last pass: v6.1.21-104-gd5eb32be5b26, first =
fail: v6.1.21-224-g1abeb39fad59)

    2023-04-15T18:55:58.058980  + <8>[   10.862136] <LAVA_SIGNAL_ENDRUN 0_d=
mesg 9995578_1.4.2.3.1>

    2023-04-15T18:55:58.059455  set +x

    2023-04-15T18:55:58.167127  / # #

    2023-04-15T18:55:58.269814  export SHELL=3D/bin/sh

    2023-04-15T18:55:58.270594  #

    2023-04-15T18:55:58.372457  / # export SHELL=3D/bin/sh. /lava-9995578/e=
nvironment

    2023-04-15T18:55:58.373175  =


    2023-04-15T18:55:58.474998  / # . /lava-9995578/environment/lava-999557=
8/bin/lava-test-runner /lava-9995578/1

    2023-04-15T18:55:58.476280  =


    2023-04-15T18:55:58.481127  / # /lava-9995578/bin/lava-test-runner /lav=
a-9995578/1
 =

    ... (12 line(s) more)  =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
lenovo-TPad-C13-Yoga-zork    | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/643af3370f812054802e8847

  Results:     6 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-6.1/v6.1.22-36=
4-g39097b93e319/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabora=
/baseline-lenovo-TPad-C13-Yoga-zork.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-6.1/v6.1.22-36=
4-g39097b93e319/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabora=
/baseline-lenovo-TPad-C13-Yoga-zork.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230407.0/x86/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/643af3370f812054802e884c
        failing since 18 days (last pass: v6.1.21-104-gd5eb32be5b26, first =
fail: v6.1.21-224-g1abeb39fad59)

    2023-04-15T18:55:39.582074  + set +x<8>[   10.802813] <LAVA_SIGNAL_ENDR=
UN 0_dmesg 9995572_1.4.2.3.1>

    2023-04-15T18:55:39.582192  =


    2023-04-15T18:55:39.687177  / # #

    2023-04-15T18:55:39.788214  export SHELL=3D/bin/sh

    2023-04-15T18:55:39.788418  #

    2023-04-15T18:55:39.889359  / # export SHELL=3D/bin/sh. /lava-9995572/e=
nvironment

    2023-04-15T18:55:39.889601  =


    2023-04-15T18:55:39.990591  / # . /lava-9995572/environment/lava-999557=
2/bin/lava-test-runner /lava-9995572/1

    2023-04-15T18:55:39.990965  =


    2023-04-15T18:55:39.995358  / # /lava-9995572/bin/lava-test-runner /lav=
a-9995572/1
 =

    ... (12 line(s) more)  =

 =20
