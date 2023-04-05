Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D8CEB6D891F
	for <lists+stable@lfdr.de>; Wed,  5 Apr 2023 22:55:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229479AbjDEUzb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 5 Apr 2023 16:55:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48544 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229461AbjDEUza (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 5 Apr 2023 16:55:30 -0400
Received: from mail-pl1-x62a.google.com (mail-pl1-x62a.google.com [IPv6:2607:f8b0:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C40C53A98
        for <stable@vger.kernel.org>; Wed,  5 Apr 2023 13:55:28 -0700 (PDT)
Received: by mail-pl1-x62a.google.com with SMTP id o2so35591411plg.4
        for <stable@vger.kernel.org>; Wed, 05 Apr 2023 13:55:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112; t=1680728128;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=C6UNnR10u/z/uyMLkRr1mk76StSwtVSOkOxUutqziuU=;
        b=wdvonRpCLeAB2FkW0EGOfqTRvWmgMqM2fuYKvsfPWBEUTXvRUzTNWXvuxxQI/WjQtA
         kg/HwTrk2N600IPjRpQRyCeGayLHn+evCc88a+u+7QaWXhN9gJyjgM5MC2ei0iSIKTZI
         rY72NZQ/c+iyUUlXZ1umEV+k/xYLHM5YNzmZnnbalynQdm7YeXtLTHiYvwNT2MpnE8ik
         0RoHbRcG8Z6dbMJfV9Du+Z2VJiMZGuIojCW/QQVwvgjO9HZcCDYt7/nhD23rb5qbC/hA
         yCAMgKUzZ8KJDGr0IqdwAH3Vpo7Ri3J8OTGiOH/Hrn4SO6x23i/p0IpKXFhdKgfFaRQE
         pdPA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680728128;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=C6UNnR10u/z/uyMLkRr1mk76StSwtVSOkOxUutqziuU=;
        b=c3PYysiYBzBVzx+tiIlukjJ1up4SeOd89e2ap84SOUWCf+Y6CdX/peFNgBGbEOol4z
         8EH+9/zwb5zfdKixbBd2eHmgmGxVTmRWmap+KgN2HVj4WaC2bxDXMiZuD5lXrk+yqlqo
         ElH+FNp1VJWGHR5NeZcEZpiij7vRSDbcGUrkG7qFefFSGEr1Eogl5Fx6lsUm85QQfZgR
         vyp0adl5aJwp5skN8sROKBibndO4GXa4e8a/jF/qofmTbfGMGqRJf/bWkkt4gPq/lRLE
         C3Kdu7YRf0ErlewCGVGHRL2qqpVCn0HfFGYr4EI2Z6liv3acvHaM3cM0bgW6etHhuO5M
         4zHQ==
X-Gm-Message-State: AAQBX9c6yIliUgbaat08zCwvyxnxL1V8t1UzHgXdB+f/tZsd5t/yX1iU
        dfV1qhgczjZ+vT+LYl5UaucCHfb3Vf1++IWcd3Igag==
X-Google-Smtp-Source: AKy350ZsiiWDqCot/4Ri1utohkde+tjQFKj4kCtH6zWL1H6mO9UfIkaeBQomtHRZlEGX6EE5zyAAUQ==
X-Received: by 2002:a17:90b:1d0b:b0:234:656d:235a with SMTP id on11-20020a17090b1d0b00b00234656d235amr8256786pjb.43.1680728127869;
        Wed, 05 Apr 2023 13:55:27 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id d6-20020a17090a6a4600b002372106a5casm1759988pjm.44.2023.04.05.13.55.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 05 Apr 2023 13:55:27 -0700 (PDT)
Message-ID: <642de03f.170a0220.82e22.4548@mx.google.com>
Date:   Wed, 05 Apr 2023 13:55:27 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: queue/6.1
X-Kernelci-Tree: stable-rc
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v6.1.22-178-gaa9876e65686
Subject: stable-rc/queue/6.1 baseline: 175 runs,
 8 regressions (v6.1.22-178-gaa9876e65686)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
X-Spam-Status: No, score=0.0 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/6.1 baseline: 175 runs, 8 regressions (v6.1.22-178-gaa9876e=
65686)

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
el/v6.1.22-178-gaa9876e65686/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/6.1
  Describe: v6.1.22-178-gaa9876e65686
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      aa9876e6568634e604c60ae37d1c0f811840bd0d =



Test Regressions
---------------- =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
asus-C436FA-Flip-hatch       | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/642da878662ddf2ee679e94c

  Results:     6 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-6.1/v6.1.22-17=
8-gaa9876e65686/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabora=
/baseline-asus-C436FA-Flip-hatch.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-6.1/v6.1.22-17=
8-gaa9876e65686/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabora=
/baseline-asus-C436FA-Flip-hatch.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230324.0/x86/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/642da878662ddf2ee679e951
        failing since 7 days (last pass: v6.1.21-104-gd5eb32be5b26, first f=
ail: v6.1.21-224-g1abeb39fad59)

    2023-04-05T16:57:08.785018  + set +x

    2023-04-05T16:57:08.791909  <8>[   10.533543] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 9884572_1.4.2.3.1>

    2023-04-05T16:57:08.894100  =


    2023-04-05T16:57:08.995061  / # #export SHELL=3D/bin/sh

    2023-04-05T16:57:08.995216  =


    2023-04-05T16:57:09.096100  / # export SHELL=3D/bin/sh. /lava-9884572/e=
nvironment

    2023-04-05T16:57:09.096252  =


    2023-04-05T16:57:09.197177  / # . /lava-9884572/environment/lava-988457=
2/bin/lava-test-runner /lava-9884572/1

    2023-04-05T16:57:09.197412  =


    2023-04-05T16:57:09.203616  / # /lava-9884572/bin/lava-test-runner /lav=
a-9884572/1
 =

    ... (12 line(s) more)  =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
asus-CM1400CXA-dalboz        | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/642da87b662ddf2ee679e965

  Results:     6 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-6.1/v6.1.22-17=
8-gaa9876e65686/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabora=
/baseline-asus-CM1400CXA-dalboz.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-6.1/v6.1.22-17=
8-gaa9876e65686/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabora=
/baseline-asus-CM1400CXA-dalboz.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230324.0/x86/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/642da87b662ddf2ee679e96a
        failing since 7 days (last pass: v6.1.21-104-gd5eb32be5b26, first f=
ail: v6.1.21-224-g1abeb39fad59)

    2023-04-05T16:57:12.356110  + <8>[   11.479510] <LAVA_SIGNAL_ENDRUN 0_d=
mesg 9884521_1.4.2.3.1>

    2023-04-05T16:57:12.356208  set +x

    2023-04-05T16:57:12.461075  / # #

    2023-04-05T16:57:12.562231  export SHELL=3D/bin/sh

    2023-04-05T16:57:12.562449  #

    2023-04-05T16:57:12.663355  / # export SHELL=3D/bin/sh. /lava-9884521/e=
nvironment

    2023-04-05T16:57:12.663577  =


    2023-04-05T16:57:12.764486  / # . /lava-9884521/environment/lava-988452=
1/bin/lava-test-runner /lava-9884521/1

    2023-04-05T16:57:12.764803  =


    2023-04-05T16:57:12.769188  / # /lava-9884521/bin/lava-test-runner /lav=
a-9884521/1
 =

    ... (12 line(s) more)  =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
asus-cx9400-volteer          | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/642da8854acffb6aaa79e94a

  Results:     6 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-6.1/v6.1.22-17=
8-gaa9876e65686/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabora=
/baseline-asus-cx9400-volteer.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-6.1/v6.1.22-17=
8-gaa9876e65686/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabora=
/baseline-asus-cx9400-volteer.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230324.0/x86/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/642da8854acffb6aaa79e94f
        failing since 7 days (last pass: v6.1.21-104-gd5eb32be5b26, first f=
ail: v6.1.21-224-g1abeb39fad59)

    2023-04-05T16:57:24.060586  <8>[   10.635629] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 9884537_1.4.2.3.1>

    2023-04-05T16:57:24.063757  + set +x

    2023-04-05T16:57:24.169253  #

    2023-04-05T16:57:24.170386  =


    2023-04-05T16:57:24.272574  / # #export SHELL=3D/bin/sh

    2023-04-05T16:57:24.273304  =


    2023-04-05T16:57:24.374958  / # export SHELL=3D/bin/sh. /lava-9884537/e=
nvironment

    2023-04-05T16:57:24.375737  =


    2023-04-05T16:57:24.477776  / # . /lava-9884537/environment/lava-988453=
7/bin/lava-test-runner /lava-9884537/1

    2023-04-05T16:57:24.478972  =

 =

    ... (13 line(s) more)  =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
bcm2835-rpi-b-rev2           | arm    | lab-broonie   | gcc-10   | bcm2835_=
defconfig            | 1          =


  Details:     https://kernelci.org/test/plan/id/642da72b73073ac4ec79ea73

  Results:     50 PASS, 2 FAIL, 1 SKIP
  Full config: bcm2835_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-6.1/v6.1.22-17=
8-gaa9876e65686/arm/bcm2835_defconfig/gcc-10/lab-broonie/baseline-bcm2835-r=
pi-b-rev2.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-6.1/v6.1.22-17=
8-gaa9876e65686/arm/bcm2835_defconfig/gcc-10/lab-broonie/baseline-bcm2835-r=
pi-b-rev2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230324.0/armel/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/642da72b73073ac4ec79eaa2
        new failure (last pass: v6.1.22-178-g526133810841)

    2023-04-05T16:51:37.061498  + set +x
    2023-04-05T16:51:37.065357  <8>[   16.759503] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 285922_1.5.2.4.1>
    2023-04-05T16:51:37.180543  / # #
    2023-04-05T16:51:37.282934  export SHELL=3D/bin/sh
    2023-04-05T16:51:37.283499  #
    2023-04-05T16:51:37.385518  / # export SHELL=3D/bin/sh. /lava-285922/en=
vironment
    2023-04-05T16:51:37.386264  =

    2023-04-05T16:51:37.488215  / # . /lava-285922/environment/lava-285922/=
bin/lava-test-runner /lava-285922/1
    2023-04-05T16:51:37.489288  =

    2023-04-05T16:51:37.495122  / # /lava-285922/bin/lava-test-runner /lava=
-285922/1 =

    ... (14 line(s) more)  =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
hp-x360-12b-c...4020-octopus | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/642da97f5e231379a279e963

  Results:     6 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-6.1/v6.1.22-17=
8-gaa9876e65686/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabora=
/baseline-hp-x360-12b-ca0010nr-n4020-octopus.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-6.1/v6.1.22-17=
8-gaa9876e65686/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabora=
/baseline-hp-x360-12b-ca0010nr-n4020-octopus.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230324.0/x86/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/642da97f5e231379a279e968
        failing since 7 days (last pass: v6.1.21-104-gd5eb32be5b26, first f=
ail: v6.1.21-224-g1abeb39fad59)

    2023-04-05T17:01:36.279898  + set +x

    2023-04-05T17:01:36.286526  <8>[   10.291402] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 9884549_1.4.2.3.1>

    2023-04-05T17:01:36.395558  / # #

    2023-04-05T17:01:36.498051  export SHELL=3D/bin/sh

    2023-04-05T17:01:36.498723  #

    2023-04-05T17:01:36.600622  / # export SHELL=3D/bin/sh. /lava-9884549/e=
nvironment

    2023-04-05T17:01:36.600811  =


    2023-04-05T17:01:36.701757  / # . /lava-9884549/environment/lava-988454=
9/bin/lava-test-runner /lava-9884549/1

    2023-04-05T17:01:36.702898  =


    2023-04-05T17:01:36.707609  / # /lava-9884549/bin/lava-test-runner /lav=
a-9884549/1
 =

    ... (12 line(s) more)  =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
hp-x360-14-G1-sona           | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/642da8708243e482ee79e937

  Results:     6 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-6.1/v6.1.22-17=
8-gaa9876e65686/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabora=
/baseline-hp-x360-14-G1-sona.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-6.1/v6.1.22-17=
8-gaa9876e65686/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabora=
/baseline-hp-x360-14-G1-sona.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230324.0/x86/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/642da8708243e482ee79e93c
        failing since 7 days (last pass: v6.1.21-104-gd5eb32be5b26, first f=
ail: v6.1.21-224-g1abeb39fad59)

    2023-04-05T16:57:06.936263  + set +x

    2023-04-05T16:57:06.942872  <8>[   10.697891] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 9884520_1.4.2.3.1>

    2023-04-05T16:57:07.047634  / # #

    2023-04-05T16:57:07.148714  export SHELL=3D/bin/sh

    2023-04-05T16:57:07.148913  #

    2023-04-05T16:57:07.249806  / # export SHELL=3D/bin/sh. /lava-9884520/e=
nvironment

    2023-04-05T16:57:07.250003  =


    2023-04-05T16:57:07.350933  / # . /lava-9884520/environment/lava-988452=
0/bin/lava-test-runner /lava-9884520/1

    2023-04-05T16:57:07.351219  =


    2023-04-05T16:57:07.355842  / # /lava-9884520/bin/lava-test-runner /lav=
a-9884520/1
 =

    ... (12 line(s) more)  =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
hp-x360-14a-cb0001xx-zork    | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/642da87c662ddf2ee679e970

  Results:     6 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-6.1/v6.1.22-17=
8-gaa9876e65686/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabora=
/baseline-hp-x360-14a-cb0001xx-zork.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-6.1/v6.1.22-17=
8-gaa9876e65686/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabora=
/baseline-hp-x360-14a-cb0001xx-zork.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230324.0/x86/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/642da87c662ddf2ee679e975
        failing since 7 days (last pass: v6.1.21-104-gd5eb32be5b26, first f=
ail: v6.1.21-224-g1abeb39fad59)

    2023-04-05T16:57:11.028335  + <8>[   10.977432] <LAVA_SIGNAL_ENDRUN 0_d=
mesg 9884551_1.4.2.3.1>

    2023-04-05T16:57:11.028461  set +x

    2023-04-05T16:57:11.133526  / # #

    2023-04-05T16:57:11.234697  export SHELL=3D/bin/sh

    2023-04-05T16:57:11.234904  #

    2023-04-05T16:57:11.335798  / # export SHELL=3D/bin/sh. /lava-9884551/e=
nvironment

    2023-04-05T16:57:11.336033  =


    2023-04-05T16:57:11.437014  / # . /lava-9884551/environment/lava-988455=
1/bin/lava-test-runner /lava-9884551/1

    2023-04-05T16:57:11.437366  =


    2023-04-05T16:57:11.442236  / # /lava-9884551/bin/lava-test-runner /lav=
a-9884551/1
 =

    ... (12 line(s) more)  =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
lenovo-TPad-C13-Yoga-zork    | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/642da8cb37fe92f30579e940

  Results:     6 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-6.1/v6.1.22-17=
8-gaa9876e65686/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabora=
/baseline-lenovo-TPad-C13-Yoga-zork.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-6.1/v6.1.22-17=
8-gaa9876e65686/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabora=
/baseline-lenovo-TPad-C13-Yoga-zork.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230324.0/x86/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/642da8cb37fe92f30579e945
        failing since 7 days (last pass: v6.1.21-104-gd5eb32be5b26, first f=
ail: v6.1.21-224-g1abeb39fad59)

    2023-04-05T16:58:30.275405  + set<8>[    8.721733] <LAVA_SIGNAL_ENDRUN =
0_dmesg 9884552_1.4.2.3.1>

    2023-04-05T16:58:30.275500   +x

    2023-04-05T16:58:30.380673  / # #

    2023-04-05T16:58:30.481799  export SHELL=3D/bin/sh

    2023-04-05T16:58:30.482002  #

    2023-04-05T16:58:30.582899  / # export SHELL=3D/bin/sh. /lava-9884552/e=
nvironment

    2023-04-05T16:58:30.583156  =


    2023-04-05T16:58:30.684170  / # . /lava-9884552/environment/lava-988455=
2/bin/lava-test-runner /lava-9884552/1

    2023-04-05T16:58:30.684547  =


    2023-04-05T16:58:30.688757  / # /lava-9884552/bin/lava-test-runner /lav=
a-9884552/1
 =

    ... (12 line(s) more)  =

 =20
