Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1B6786E34A1
	for <lists+stable@lfdr.de>; Sun, 16 Apr 2023 02:52:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229962AbjDPAwL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 15 Apr 2023 20:52:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34752 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229588AbjDPAwK (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 15 Apr 2023 20:52:10 -0400
Received: from mail-pl1-x62d.google.com (mail-pl1-x62d.google.com [IPv6:2607:f8b0:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8BFA43A98
        for <stable@vger.kernel.org>; Sat, 15 Apr 2023 17:52:07 -0700 (PDT)
Received: by mail-pl1-x62d.google.com with SMTP id p8so22226811plk.9
        for <stable@vger.kernel.org>; Sat, 15 Apr 2023 17:52:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20221208.gappssmtp.com; s=20221208; t=1681606327; x=1684198327;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=Gj1aphIh6fCMM03+uNH7g/Pn3iSIxHcQ/frqcC+7AMM=;
        b=JzdHSr/JzWlIKeAbyzC0iwlUkVrhzIK7CoUo8WLEPc42UcKsTLerg6ogAgkFSm6nnM
         aCPtoIajeaA3oX4VH10BFgVXlH0aRbe6+b/Hc6aZCuRxROWzXv4KJ9IQdbCork9huOcO
         L8pAZ18YIERXPM9vFI2rdIQIuBcVZKETavLV3l5Cwj6rB7jKqqmjwPXu+f2F6bo2st8w
         vQweJJ2r3kaLrC9/sLQBwbFbUhGduf7QE5bFyDb3TS3vACPw++wQdkRnegbd35SYGhLC
         fnPsPPMEKOb6MLVNsFNXIDahG3k5zMfj79rk2Iw7yAG6aRcHOSlroiaoj6P6sEjXSrfT
         z9NQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681606327; x=1684198327;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Gj1aphIh6fCMM03+uNH7g/Pn3iSIxHcQ/frqcC+7AMM=;
        b=Tm8BpNRYvhtH9O3EA0imJADtAnHn+lwAbCg31fPssci83Qz1/c38sUW/TXvCohVygY
         Y6Q0lUw4kt4Cmuq3QDLCkRhxsb6kQqRtNTcH8OT30hJ7cMxuc/q9DplmNP/nny8rypat
         0h3z1BNjC2sossksM7HKz7LZBmmcucueALvOlO90jU+gIGio3AbZT3+mG3DpDE3FjIp7
         PXXrqrObs5Dh46Rd77MwyiXT+UmZZLAB7Eb+I3uDZB/nnNpWIsofpoHcMfBQZNnrbW6X
         y6GOLtoaaFL913Lc3936A3ytpRjWmiMZV2A7nKyh8BVF77EvNuHBvRapIDhCr4L1udMh
         Y8qw==
X-Gm-Message-State: AAQBX9cuPGAwBw6eduHEBfYOR/ZvB+ayfs0b2Bzgn2oIHqzy6lM8lPIG
        Mtkm0Jf6Yg/ulMQDHHIkYJlBGqvmiPKwKIxmAOnI/A==
X-Google-Smtp-Source: AKy350bpw/UBxRV6PNXjihUsDMnONPqrhyfL62lxLKD+F8QZ3Jc7ipwTDyNb4/QIAEZGG9k4JXzjew==
X-Received: by 2002:a17:902:c701:b0:1a6:b012:afb with SMTP id p1-20020a170902c70100b001a6b0120afbmr3951313plp.48.1681606326692;
        Sat, 15 Apr 2023 17:52:06 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id c6-20020a170902aa4600b001a221d14179sm4983579plr.302.2023.04.15.17.52.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 15 Apr 2023 17:52:06 -0700 (PDT)
Message-ID: <643b46b6.170a0220.f6c0e.b5de@mx.google.com>
Date:   Sat, 15 Apr 2023 17:52:06 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: queue/6.1
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v6.1.22-372-g971903477e72
X-Kernelci-Report-Type: test
Subject: stable-rc/queue/6.1 baseline: 194 runs,
 7 regressions (v6.1.22-372-g971903477e72)
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

stable-rc/queue/6.1 baseline: 194 runs, 7 regressions (v6.1.22-372-g9719034=
77e72)

Regressions Summary
-------------------

platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
asus-C436FA-Flip-hatch       | x86_64 | lab-collabora | gcc-10   | x86_64_d=
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
el/v6.1.22-372-g971903477e72/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/6.1
  Describe: v6.1.22-372-g971903477e72
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      971903477e72b2e2843ed5594de6bac24f6da4fc =



Test Regressions
---------------- =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
asus-C436FA-Flip-hatch       | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/643b101259e6951ab22e8650

  Results:     6 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-6.1/v6.1.22-37=
2-g971903477e72/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabora=
/baseline-asus-C436FA-Flip-hatch.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-6.1/v6.1.22-37=
2-g971903477e72/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabora=
/baseline-asus-C436FA-Flip-hatch.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230407.0/x86/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/643b101259e6951ab22e8655
        failing since 18 days (last pass: v6.1.21-104-gd5eb32be5b26, first =
fail: v6.1.21-224-g1abeb39fad59)

    2023-04-15T20:58:41.036086  <8>[   10.354982] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 9997975_1.4.2.3.1>

    2023-04-15T20:58:41.039375  + set +x

    2023-04-15T20:58:41.147320  / # #

    2023-04-15T20:58:41.249923  export SHELL=3D/bin/sh

    2023-04-15T20:58:41.250601  #

    2023-04-15T20:58:41.352117  / # export SHELL=3D/bin/sh. /lava-9997975/e=
nvironment

    2023-04-15T20:58:41.352985  =


    2023-04-15T20:58:41.454867  / # . /lava-9997975/environment/lava-999797=
5/bin/lava-test-runner /lava-9997975/1

    2023-04-15T20:58:41.455963  =


    2023-04-15T20:58:41.461829  / # /lava-9997975/bin/lava-test-runner /lav=
a-9997975/1
 =

    ... (12 line(s) more)  =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
asus-cx9400-volteer          | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/643b101159e6951ab22e8618

  Results:     6 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-6.1/v6.1.22-37=
2-g971903477e72/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabora=
/baseline-asus-cx9400-volteer.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-6.1/v6.1.22-37=
2-g971903477e72/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabora=
/baseline-asus-cx9400-volteer.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230407.0/x86/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/643b101159e6951ab22e861d
        failing since 18 days (last pass: v6.1.21-104-gd5eb32be5b26, first =
fail: v6.1.21-224-g1abeb39fad59)

    2023-04-15T20:58:37.062188  <8>[   10.298426] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 9997970_1.4.2.3.1>

    2023-04-15T20:58:37.065956  + set +x

    2023-04-15T20:58:37.167922  / #

    2023-04-15T20:58:37.269260  # #export SHELL=3D/bin/sh

    2023-04-15T20:58:37.269465  =


    2023-04-15T20:58:37.370304  / # export SHELL=3D/bin/sh. /lava-9997970/e=
nvironment

    2023-04-15T20:58:37.370517  =


    2023-04-15T20:58:37.471496  / # . /lava-9997970/environment/lava-999797=
0/bin/lava-test-runner /lava-9997970/1

    2023-04-15T20:58:37.471784  =


    2023-04-15T20:58:37.476831  / # /lava-9997970/bin/lava-test-runner /lav=
a-9997970/1
 =

    ... (12 line(s) more)  =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
bcm2835-rpi-b-rev2           | arm    | lab-broonie   | gcc-10   | bcm2835_=
defconfig            | 1          =


  Details:     https://kernelci.org/test/plan/id/643b0cb69bfc3fa73b2e85f1

  Results:     50 PASS, 2 FAIL, 1 SKIP
  Full config: bcm2835_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-6.1/v6.1.22-37=
2-g971903477e72/arm/bcm2835_defconfig/gcc-10/lab-broonie/baseline-bcm2835-r=
pi-b-rev2.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-6.1/v6.1.22-37=
2-g971903477e72/arm/bcm2835_defconfig/gcc-10/lab-broonie/baseline-bcm2835-r=
pi-b-rev2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230407.0/armel/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/643b0cb69bfc3fa73b2e8623
        failing since 0 day (last pass: v6.1.22-364-gf7dc7e601a2a, first fa=
il: v6.1.22-364-g39097b93e319)

    2023-04-15T20:44:17.910078  + set +x
    2023-04-15T20:44:17.913909  <8>[   18.298540] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 334592_1.5.2.4.1>
    2023-04-15T20:44:18.028926  / # #
    2023-04-15T20:44:18.130943  export SHELL=3D/bin/sh
    2023-04-15T20:44:18.131436  #
    2023-04-15T20:44:18.233369  / # export SHELL=3D/bin/sh. /lava-334592/en=
vironment
    2023-04-15T20:44:18.233884  =

    2023-04-15T20:44:18.335544  / # . /lava-334592/environment/lava-334592/=
bin/lava-test-runner /lava-334592/1
    2023-04-15T20:44:18.336555  =

    2023-04-15T20:44:18.342525  / # /lava-334592/bin/lava-test-runner /lava=
-334592/1 =

    ... (14 line(s) more)  =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
hp-x360-12b-c...4020-octopus | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/643b10099e864271012e85f9

  Results:     6 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-6.1/v6.1.22-37=
2-g971903477e72/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabora=
/baseline-hp-x360-12b-ca0010nr-n4020-octopus.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-6.1/v6.1.22-37=
2-g971903477e72/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabora=
/baseline-hp-x360-12b-ca0010nr-n4020-octopus.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230407.0/x86/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/643b10099e864271012e85fe
        failing since 18 days (last pass: v6.1.21-104-gd5eb32be5b26, first =
fail: v6.1.21-224-g1abeb39fad59)

    2023-04-15T20:58:37.156963  + set +x

    2023-04-15T20:58:37.163284  <8>[   10.212395] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 9998017_1.4.2.3.1>

    2023-04-15T20:58:37.268336  / # #

    2023-04-15T20:58:37.369390  export SHELL=3D/bin/sh

    2023-04-15T20:58:37.369571  #

    2023-04-15T20:58:37.470487  / # export SHELL=3D/bin/sh. /lava-9998017/e=
nvironment

    2023-04-15T20:58:37.470705  =


    2023-04-15T20:58:37.571619  / # . /lava-9998017/environment/lava-999801=
7/bin/lava-test-runner /lava-9998017/1

    2023-04-15T20:58:37.572023  =


    2023-04-15T20:58:37.576179  / # /lava-9998017/bin/lava-test-runner /lav=
a-9998017/1
 =

    ... (12 line(s) more)  =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
hp-x360-14-G1-sona           | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/643b100c9e864271012e861a

  Results:     6 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-6.1/v6.1.22-37=
2-g971903477e72/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabora=
/baseline-hp-x360-14-G1-sona.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-6.1/v6.1.22-37=
2-g971903477e72/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabora=
/baseline-hp-x360-14-G1-sona.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230407.0/x86/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/643b100c9e864271012e861f
        failing since 18 days (last pass: v6.1.21-104-gd5eb32be5b26, first =
fail: v6.1.21-224-g1abeb39fad59)

    2023-04-15T20:58:32.412238  <8>[   10.679564] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 9998047_1.4.2.3.1>

    2023-04-15T20:58:32.415321  + set +x

    2023-04-15T20:58:32.516935  #

    2023-04-15T20:58:32.618237  / # #export SHELL=3D/bin/sh

    2023-04-15T20:58:32.618434  =


    2023-04-15T20:58:32.719363  / # export SHELL=3D/bin/sh. /lava-9998047/e=
nvironment

    2023-04-15T20:58:32.719578  =


    2023-04-15T20:58:32.820434  / # . /lava-9998047/environment/lava-999804=
7/bin/lava-test-runner /lava-9998047/1

    2023-04-15T20:58:32.820696  =


    2023-04-15T20:58:32.825906  / # /lava-9998047/bin/lava-test-runner /lav=
a-9998047/1
 =

    ... (12 line(s) more)  =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
hp-x360-14a-cb0001xx-zork    | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/643b101ce93586871d2e85f2

  Results:     6 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-6.1/v6.1.22-37=
2-g971903477e72/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabora=
/baseline-hp-x360-14a-cb0001xx-zork.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-6.1/v6.1.22-37=
2-g971903477e72/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabora=
/baseline-hp-x360-14a-cb0001xx-zork.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230407.0/x86/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/643b101ce93586871d2e85f7
        failing since 18 days (last pass: v6.1.21-104-gd5eb32be5b26, first =
fail: v6.1.21-224-g1abeb39fad59)

    2023-04-15T20:58:45.020059  + <8>[   10.786846] <LAVA_SIGNAL_ENDRUN 0_d=
mesg 9997979_1.4.2.3.1>

    2023-04-15T20:58:45.020136  set +x

    2023-04-15T20:58:45.124414  / # #

    2023-04-15T20:58:45.225587  export SHELL=3D/bin/sh

    2023-04-15T20:58:45.225808  #

    2023-04-15T20:58:45.326740  / # export SHELL=3D/bin/sh. /lava-9997979/e=
nvironment

    2023-04-15T20:58:45.326908  =


    2023-04-15T20:58:45.427862  / # . /lava-9997979/environment/lava-999797=
9/bin/lava-test-runner /lava-9997979/1

    2023-04-15T20:58:45.428106  =


    2023-04-15T20:58:45.432834  / # /lava-9997979/bin/lava-test-runner /lav=
a-9997979/1
 =

    ... (12 line(s) more)  =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
lenovo-TPad-C13-Yoga-zork    | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/643b100b9e864271012e860f

  Results:     6 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-6.1/v6.1.22-37=
2-g971903477e72/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabora=
/baseline-lenovo-TPad-C13-Yoga-zork.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-6.1/v6.1.22-37=
2-g971903477e72/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabora=
/baseline-lenovo-TPad-C13-Yoga-zork.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230407.0/x86/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/643b100b9e864271012e8614
        failing since 18 days (last pass: v6.1.21-104-gd5eb32be5b26, first =
fail: v6.1.21-224-g1abeb39fad59)

    2023-04-15T20:58:34.643241  + set +x<8>[   11.810093] <LAVA_SIGNAL_ENDR=
UN 0_dmesg 9998032_1.4.2.3.1>

    2023-04-15T20:58:34.643326  =


    2023-04-15T20:58:34.748418  / # #

    2023-04-15T20:58:34.849404  export SHELL=3D/bin/sh

    2023-04-15T20:58:34.849619  #

    2023-04-15T20:58:34.950543  / # export SHELL=3D/bin/sh. /lava-9998032/e=
nvironment

    2023-04-15T20:58:34.950726  =


    2023-04-15T20:58:35.051694  / # . /lava-9998032/environment/lava-999803=
2/bin/lava-test-runner /lava-9998032/1

    2023-04-15T20:58:35.051960  =


    2023-04-15T20:58:35.057079  / # /lava-9998032/bin/lava-test-runner /lav=
a-9998032/1
 =

    ... (12 line(s) more)  =

 =20
