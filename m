Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A742D6E3494
	for <lists+stable@lfdr.de>; Sun, 16 Apr 2023 02:22:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230117AbjDPAW0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 15 Apr 2023 20:22:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59362 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229451AbjDPAWZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 15 Apr 2023 20:22:25 -0400
Received: from mail-pg1-x531.google.com (mail-pg1-x531.google.com [IPv6:2607:f8b0:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 653BF3599
        for <stable@vger.kernel.org>; Sat, 15 Apr 2023 17:22:22 -0700 (PDT)
Received: by mail-pg1-x531.google.com with SMTP id 41be03b00d2f7-517c0b93cedso1229761a12.3
        for <stable@vger.kernel.org>; Sat, 15 Apr 2023 17:22:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20221208.gappssmtp.com; s=20221208; t=1681604541; x=1684196541;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=25WDxzzIlqKKk/fOD0fxydB5MfTO3nbUh3zk2agPMZo=;
        b=3AmgD4sxhowqZwZKBu6pe8fvZoN+OE5Hm3TfN+ZUH4g9cS2bWvVJGXWWw+nNhplAdm
         BdpiJ6Kz2SeNtCKv3est8IMFScp1fqcLF8SwR8bWfi30ytdd1e4unUI2keVnhf7gb56m
         xfk7em7KyjKzsZizcFdRoamU51SJKlvvULRk4BUltEkAUgypUnLqk5wGIeoERUBjgkiV
         kM6eQz0V/z3p5x2Nq9IT5aDwmMFcsElbtaa6mIV1H3JDo6MDvv1VucSOOpigqoDUTgXM
         iX5MN89bkhky9PFtMqfuIbaLBJDao7DFA7CYe5RbtJjwnQgCSU2ZCC2x2dcVNU5B5jlh
         N+dw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681604541; x=1684196541;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=25WDxzzIlqKKk/fOD0fxydB5MfTO3nbUh3zk2agPMZo=;
        b=TxshazejF4W/6s9lNp4kD152kP8hd2hdXSxUWxl9vN7wnOZxKsZ8nGX0nlbTGadDqw
         n+MggfqnwxOSJqZ3zWZWkIKxRAvNYgi5RbaVufw9fyBfcFwFuggnuvBcwaeve4hofluw
         1oGZLwRfMUN0NiQ0OsWKy9rLkd5G3C6Kqs8xWG+LblGkeREH20i3O3Mly2NzDzGqrvr2
         0uNQC1i4Ym7vtADvgXojJcQfPEcPKvnnDbyEjGNMGUvlZEuj5uCPOhmUl3eSHNs7bFIU
         sXacO18EV3XjDInko+LSh6+9jov1OqIp5zm3haNkTW9LlC84iFY9i8LIcffplM7jhCw/
         eHPg==
X-Gm-Message-State: AAQBX9e2jKs30YbvffXF5f3jYW3etgZCjQKVi6yH5P+96Xryms4XTPFq
        YY8G6o7SudDQH5AsIgMTfoGzyjhfELpdYeZwiwWZstdg
X-Google-Smtp-Source: AKy350azQP2ABQYog33a6/mn3+ZxVtkCwO9lsx1xyQK5Mu3yaDNdhnIgxmBNOJnNxr8pug1wD15vJw==
X-Received: by 2002:a05:6a00:1791:b0:63b:8b47:454f with SMTP id s17-20020a056a00179100b0063b8b47454fmr23131pfg.13.1681604541419;
        Sat, 15 Apr 2023 17:22:21 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id u13-20020aa7848d000000b0063b212638bdsm5117768pfn.220.2023.04.15.17.22.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 15 Apr 2023 17:22:21 -0700 (PDT)
Message-ID: <643b3fbd.a70a0220.eacc5.b733@mx.google.com>
Date:   Sat, 15 Apr 2023 17:22:21 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: queue/5.15
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v5.15.105-206-g4548859116b8
X-Kernelci-Report-Type: test
Subject: stable-rc/queue/5.15 baseline: 194 runs,
 11 regressions (v5.15.105-206-g4548859116b8)
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

stable-rc/queue/5.15 baseline: 194 runs, 11 regressions (v5.15.105-206-g454=
8859116b8)

Regressions Summary
-------------------

platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
asus-C436FA-Flip-hatch       | x86_64 | lab-collabora   | gcc-10   | x86_64=
_defcon...6-chromebook | 1          =

asus-CM1400CXA-dalboz        | x86_64 | lab-collabora   | gcc-10   | x86_64=
_defcon...6-chromebook | 1          =

asus-cx9400-volteer          | x86_64 | lab-collabora   | gcc-10   | x86_64=
_defcon...6-chromebook | 1          =

beagle-xm                    | arm    | lab-baylibre    | gcc-10   | omap2p=
lus_defconfig          | 1          =

cubietruck                   | arm    | lab-baylibre    | gcc-10   | multi_=
v7_defconfig           | 1          =

hp-x360-12b-c...4020-octopus | x86_64 | lab-collabora   | gcc-10   | x86_64=
_defcon...6-chromebook | 1          =

hp-x360-14-G1-sona           | x86_64 | lab-collabora   | gcc-10   | x86_64=
_defcon...6-chromebook | 1          =

hp-x360-14a-cb0001xx-zork    | x86_64 | lab-collabora   | gcc-10   | x86_64=
_defcon...6-chromebook | 1          =

imx53-qsrb                   | arm    | lab-pengutronix | gcc-10   | multi_=
v7_defconfig           | 1          =

lenovo-TPad-C13-Yoga-zork    | x86_64 | lab-collabora   | gcc-10   | x86_64=
_defcon...6-chromebook | 1          =

sun8i-h2-plus-orangepi-r1    | arm    | lab-baylibre    | gcc-10   | sunxi_=
defconfig              | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.15/ker=
nel/v5.15.105-206-g4548859116b8/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.15
  Describe: v5.15.105-206-g4548859116b8
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      4548859116b81e21a8988a291e1b89bd1b8ce092 =



Test Regressions
---------------- =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
asus-C436FA-Flip-hatch       | x86_64 | lab-collabora   | gcc-10   | x86_64=
_defcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/643b09bbeee423798e2e8617

  Results:     6 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.105=
-206-g4548859116b8/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collab=
ora/baseline-asus-C436FA-Flip-hatch.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.105=
-206-g4548859116b8/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collab=
ora/baseline-asus-C436FA-Flip-hatch.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230407.0/x86/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/643b09bbeee423798e2e861c
        failing since 18 days (last pass: v5.15.104-76-g9168fe5021cf1, firs=
t fail: v5.15.104-83-ga131fb06fbdb)

    2023-04-15T20:31:34.511724  + set +x

    2023-04-15T20:31:34.518182  <8>[   10.932455] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 9997597_1.4.2.3.1>

    2023-04-15T20:31:34.627462  / # #

    2023-04-15T20:31:34.730563  export SHELL=3D/bin/sh

    2023-04-15T20:31:34.731294  #

    2023-04-15T20:31:34.833364  / # export SHELL=3D/bin/sh. /lava-9997597/e=
nvironment

    2023-04-15T20:31:34.834093  =


    2023-04-15T20:31:34.935790  / # . /lava-9997597/environment/lava-999759=
7/bin/lava-test-runner /lava-9997597/1

    2023-04-15T20:31:34.936851  =


    2023-04-15T20:31:34.943043  / # /lava-9997597/bin/lava-test-runner /lav=
a-9997597/1
 =

    ... (12 line(s) more)  =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
asus-CM1400CXA-dalboz        | x86_64 | lab-collabora   | gcc-10   | x86_64=
_defcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/643b09c1eee423798e2e8631

  Results:     6 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.105=
-206-g4548859116b8/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collab=
ora/baseline-asus-CM1400CXA-dalboz.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.105=
-206-g4548859116b8/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collab=
ora/baseline-asus-CM1400CXA-dalboz.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230407.0/x86/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/643b09c1eee423798e2e8636
        failing since 18 days (last pass: v5.15.104-76-g9168fe5021cf1, firs=
t fail: v5.15.104-83-ga131fb06fbdb)

    2023-04-15T20:31:38.179785  + set<8>[   10.880231] <LAVA_SIGNAL_ENDRUN =
0_dmesg 9997577_1.4.2.3.1>

    2023-04-15T20:31:38.179896   +x

    2023-04-15T20:31:38.284581  / # #

    2023-04-15T20:31:38.385482  export SHELL=3D/bin/sh

    2023-04-15T20:31:38.385707  #

    2023-04-15T20:31:38.486655  / # export SHELL=3D/bin/sh. /lava-9997577/e=
nvironment

    2023-04-15T20:31:38.486876  =


    2023-04-15T20:31:38.587611  / # . /lava-9997577/environment/lava-999757=
7/bin/lava-test-runner /lava-9997577/1

    2023-04-15T20:31:38.587964  =


    2023-04-15T20:31:38.592644  / # /lava-9997577/bin/lava-test-runner /lav=
a-9997577/1
 =

    ... (12 line(s) more)  =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
asus-cx9400-volteer          | x86_64 | lab-collabora   | gcc-10   | x86_64=
_defcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/643b09bfe5d65b15a82e8677

  Results:     6 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.105=
-206-g4548859116b8/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collab=
ora/baseline-asus-cx9400-volteer.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.105=
-206-g4548859116b8/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collab=
ora/baseline-asus-cx9400-volteer.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230407.0/x86/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/643b09bfe5d65b15a82e867b
        failing since 18 days (last pass: v5.15.104-76-g9168fe5021cf1, firs=
t fail: v5.15.104-83-ga131fb06fbdb)

    2023-04-15T20:31:39.950539  <8>[   10.992013] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 9997584_1.4.2.3.1>

    2023-04-15T20:31:39.954136  + set +x

    2023-04-15T20:31:40.056209  =


    2023-04-15T20:31:40.157134  / # #export SHELL=3D/bin/sh

    2023-04-15T20:31:40.157339  =


    2023-04-15T20:31:40.258258  / # export SHELL=3D/bin/sh. /lava-9997584/e=
nvironment

    2023-04-15T20:31:40.258461  =


    2023-04-15T20:31:40.359445  / # . /lava-9997584/environment/lava-999758=
4/bin/lava-test-runner /lava-9997584/1

    2023-04-15T20:31:40.359805  =


    2023-04-15T20:31:40.364798  / # /lava-9997584/bin/lava-test-runner /lav=
a-9997584/1
 =

    ... (12 line(s) more)  =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
beagle-xm                    | arm    | lab-baylibre    | gcc-10   | omap2p=
lus_defconfig          | 1          =


  Details:     https://kernelci.org/test/plan/id/643b0c0b2692f97dfe2e860e

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.105=
-206-g4548859116b8/arm/omap2plus_defconfig/gcc-10/lab-baylibre/baseline-bea=
gle-xm.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.105=
-206-g4548859116b8/arm/omap2plus_defconfig/gcc-10/lab-baylibre/baseline-bea=
gle-xm.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230407.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/643b0c0b2692f97dfe2e8=
60f
        failing since 71 days (last pass: v5.15.91-12-g3290f78df1ab, first =
fail: v5.15.91-18-ga7afd81d41cb) =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
cubietruck                   | arm    | lab-baylibre    | gcc-10   | multi_=
v7_defconfig           | 1          =


  Details:     https://kernelci.org/test/plan/id/643b0c7a93de1cf90d2e8600

  Results:     5 PASS, 1 FAIL, 1 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.105=
-206-g4548859116b8/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-cubi=
etruck.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.105=
-206-g4548859116b8/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-cubi=
etruck.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230407.0/armel/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/643b0c7a93de1cf90d2e8605
        failing since 88 days (last pass: v5.15.82-123-gd03dbdba21ef, first=
 fail: v5.15.87-100-ge215d5ead661)

    2023-04-15T20:43:27.725376  + set +x<8>[   10.022868] <LAVA_SIGNAL_ENDR=
UN 0_dmesg 3500102_1.5.2.4.1>
    2023-04-15T20:43:27.725585  =

    2023-04-15T20:43:27.832001  / # #
    2023-04-15T20:43:27.935524  export SHELL=3D/bin/sh
    2023-04-15T20:43:27.936458  #
    2023-04-15T20:43:28.038290  / # export SHELL=3D/bin/sh. /lava-3500102/e=
nvironment
    2023-04-15T20:43:28.038870  =

    2023-04-15T20:43:28.140452  / # . /lava-3500102/environment/lava-350010=
2/bin/lava-test-runner /lava-3500102/1
    2023-04-15T20:43:28.142053  =

    2023-04-15T20:43:28.142533  <3>[   10.353337] Bluetooth: hci0: command =
0xfc18 tx timeout =

    ... (13 line(s) more)  =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
hp-x360-12b-c...4020-octopus | x86_64 | lab-collabora   | gcc-10   | x86_64=
_defcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/643b09daa46c461acb2e85e8

  Results:     6 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.105=
-206-g4548859116b8/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collab=
ora/baseline-hp-x360-12b-ca0010nr-n4020-octopus.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.105=
-206-g4548859116b8/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collab=
ora/baseline-hp-x360-12b-ca0010nr-n4020-octopus.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230407.0/x86/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/643b09daa46c461acb2e85ed
        failing since 18 days (last pass: v5.15.104-76-g9168fe5021cf1, firs=
t fail: v5.15.104-83-ga131fb06fbdb)

    2023-04-15T20:32:09.768764  + set +x

    2023-04-15T20:32:09.774821  <8>[   10.824129] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 9997608_1.4.2.3.1>

    2023-04-15T20:32:09.879763  / # #

    2023-04-15T20:32:09.980856  export SHELL=3D/bin/sh

    2023-04-15T20:32:09.981054  #

    2023-04-15T20:32:10.081993  / # export SHELL=3D/bin/sh. /lava-9997608/e=
nvironment

    2023-04-15T20:32:10.082224  =


    2023-04-15T20:32:10.183243  / # . /lava-9997608/environment/lava-999760=
8/bin/lava-test-runner /lava-9997608/1

    2023-04-15T20:32:10.183522  =


    2023-04-15T20:32:10.188269  / # /lava-9997608/bin/lava-test-runner /lav=
a-9997608/1
 =

    ... (12 line(s) more)  =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
hp-x360-14-G1-sona           | x86_64 | lab-collabora   | gcc-10   | x86_64=
_defcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/643b0d54aec4bbf3d62e863b

  Results:     6 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.105=
-206-g4548859116b8/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collab=
ora/baseline-hp-x360-14-G1-sona.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.105=
-206-g4548859116b8/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collab=
ora/baseline-hp-x360-14-G1-sona.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230407.0/x86/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/643b0d54aec4bbf3d62e8640
        failing since 18 days (last pass: v5.15.104-76-g9168fe5021cf1, firs=
t fail: v5.15.104-83-ga131fb06fbdb)

    2023-04-15T20:46:55.453079  <8>[   10.512671] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 9997578_1.4.2.3.1>

    2023-04-15T20:46:55.456252  + set +x

    2023-04-15T20:46:55.562384  =


    2023-04-15T20:46:55.664525  / # #export SHELL=3D/bin/sh

    2023-04-15T20:46:55.665255  =


    2023-04-15T20:46:55.766982  / # export SHELL=3D/bin/sh. /lava-9997578/e=
nvironment

    2023-04-15T20:46:55.767669  =


    2023-04-15T20:46:55.869398  / # . /lava-9997578/environment/lava-999757=
8/bin/lava-test-runner /lava-9997578/1

    2023-04-15T20:46:55.870645  =


    2023-04-15T20:46:55.875640  / # /lava-9997578/bin/lava-test-runner /lav=
a-9997578/1
 =

    ... (12 line(s) more)  =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
hp-x360-14a-cb0001xx-zork    | x86_64 | lab-collabora   | gcc-10   | x86_64=
_defcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/643b09c2c6a3eccbce2e85ea

  Results:     6 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.105=
-206-g4548859116b8/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collab=
ora/baseline-hp-x360-14a-cb0001xx-zork.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.105=
-206-g4548859116b8/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collab=
ora/baseline-hp-x360-14a-cb0001xx-zork.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230407.0/x86/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/643b09c2c6a3eccbce2e85ef
        failing since 18 days (last pass: v5.15.104-76-g9168fe5021cf1, firs=
t fail: v5.15.104-83-ga131fb06fbdb)

    2023-04-15T20:31:53.149944  + <8>[   10.740598] <LAVA_SIGNAL_ENDRUN 0_d=
mesg 9997647_1.4.2.3.1>

    2023-04-15T20:31:53.150456  set +x

    2023-04-15T20:31:53.259797  / # #

    2023-04-15T20:31:53.362687  export SHELL=3D/bin/sh

    2023-04-15T20:31:53.363451  #

    2023-04-15T20:31:53.465485  / # export SHELL=3D/bin/sh. /lava-9997647/e=
nvironment

    2023-04-15T20:31:53.466153  =


    2023-04-15T20:31:53.568144  / # . /lava-9997647/environment/lava-999764=
7/bin/lava-test-runner /lava-9997647/1

    2023-04-15T20:31:53.569619  =


    2023-04-15T20:31:53.574791  / # /lava-9997647/bin/lava-test-runner /lav=
a-9997647/1
 =

    ... (12 line(s) more)  =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
imx53-qsrb                   | arm    | lab-pengutronix | gcc-10   | multi_=
v7_defconfig           | 1          =


  Details:     https://kernelci.org/test/plan/id/643b0c29f67deba9612e85f7

  Results:     5 PASS, 1 FAIL, 1 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.105=
-206-g4548859116b8/arm/multi_v7_defconfig/gcc-10/lab-pengutronix/baseline-i=
mx53-qsrb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.105=
-206-g4548859116b8/arm/multi_v7_defconfig/gcc-10/lab-pengutronix/baseline-i=
mx53-qsrb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230407.0/armel/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/643b0c29f67deba9612e85fc
        failing since 78 days (last pass: v5.15.81-121-gcb14018a85f6, first=
 fail: v5.15.90-146-gbf7101723cc0)

    2023-04-15T20:42:09.415836  + set +x
    2023-04-15T20:42:09.416072  [    9.375550] <LAVA_SIGNAL_ENDRUN 0_dmesg =
927270_1.5.2.3.1>
    2023-04-15T20:42:09.523934  / # #
    2023-04-15T20:42:09.625693  export SHELL=3D/bin/sh
    2023-04-15T20:42:09.626203  #
    2023-04-15T20:42:09.727482  / # export SHELL=3D/bin/sh. /lava-927270/en=
vironment
    2023-04-15T20:42:09.727997  =

    2023-04-15T20:42:09.829403  / # . /lava-927270/environment/lava-927270/=
bin/lava-test-runner /lava-927270/1
    2023-04-15T20:42:09.829967  =

    2023-04-15T20:42:09.832583  / # /lava-927270/bin/lava-test-runner /lava=
-927270/1 =

    ... (12 line(s) more)  =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
lenovo-TPad-C13-Yoga-zork    | x86_64 | lab-collabora   | gcc-10   | x86_64=
_defcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/643b09aaeee423798e2e85ea

  Results:     6 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.105=
-206-g4548859116b8/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collab=
ora/baseline-lenovo-TPad-C13-Yoga-zork.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.105=
-206-g4548859116b8/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collab=
ora/baseline-lenovo-TPad-C13-Yoga-zork.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230407.0/x86/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/643b09aaeee423798e2e85ef
        failing since 18 days (last pass: v5.15.104-76-g9168fe5021cf1, firs=
t fail: v5.15.104-83-ga131fb06fbdb)

    2023-04-15T20:31:24.250972  + set<8>[   11.954321] <LAVA_SIGNAL_ENDRUN =
0_dmesg 9997610_1.4.2.3.1>

    2023-04-15T20:31:24.251099   +x

    2023-04-15T20:31:24.355767  / # #

    2023-04-15T20:31:24.456755  export SHELL=3D/bin/sh

    2023-04-15T20:31:24.456945  #

    2023-04-15T20:31:24.557873  / # export SHELL=3D/bin/sh. /lava-9997610/e=
nvironment

    2023-04-15T20:31:24.558049  =


    2023-04-15T20:31:24.659005  / # . /lava-9997610/environment/lava-999761=
0/bin/lava-test-runner /lava-9997610/1

    2023-04-15T20:31:24.659393  =


    2023-04-15T20:31:24.664152  / # /lava-9997610/bin/lava-test-runner /lav=
a-9997610/1
 =

    ... (12 line(s) more)  =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
sun8i-h2-plus-orangepi-r1    | arm    | lab-baylibre    | gcc-10   | sunxi_=
defconfig              | 1          =


  Details:     https://kernelci.org/test/plan/id/643b0c19686e3303d92e85ea

  Results:     5 PASS, 1 FAIL, 1 SKIP
  Full config: sunxi_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.105=
-206-g4548859116b8/arm/sunxi_defconfig/gcc-10/lab-baylibre/baseline-sun8i-h=
2-plus-orangepi-r1.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.105=
-206-g4548859116b8/arm/sunxi_defconfig/gcc-10/lab-baylibre/baseline-sun8i-h=
2-plus-orangepi-r1.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230407.0/armel/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/643b0c19686e3303d92e85ed
        failing since 74 days (last pass: v5.15.82-123-gd03dbdba21ef, first=
 fail: v5.15.90-203-gea2e94bef77e)

    2023-04-15T20:41:52.991816  / # #
    2023-04-15T20:41:53.097337  export SHELL=3D/bin/sh
    2023-04-15T20:41:53.098928  #
    2023-04-15T20:41:53.202205  / # export SHELL=3D/bin/sh. /lava-3499901/e=
nvironment
    2023-04-15T20:41:53.203717  =

    2023-04-15T20:41:53.307147  / # . /lava-3499901/environment/lava-349990=
1/bin/lava-test-runner /lava-3499901/1
    2023-04-15T20:41:53.309824  =

    2023-04-15T20:41:53.317095  / # /lava-3499901/bin/lava-test-runner /lav=
a-3499901/1
    2023-04-15T20:41:53.451742  + export 'TESTRUN_ID=3D1_bootrr'
    2023-04-15T20:41:53.452804  + cd /lava-3499901/1/tests/1_bootrr =

    ... (10 line(s) more)  =

 =20
