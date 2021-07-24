Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 788923D4480
	for <lists+stable@lfdr.de>; Sat, 24 Jul 2021 05:16:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233850AbhGXCgY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 23 Jul 2021 22:36:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38390 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233628AbhGXCgX (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 23 Jul 2021 22:36:23 -0400
Received: from mail-pj1-x102a.google.com (mail-pj1-x102a.google.com [IPv6:2607:f8b0:4864:20::102a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4FECDC061575
        for <stable@vger.kernel.org>; Fri, 23 Jul 2021 20:16:55 -0700 (PDT)
Received: by mail-pj1-x102a.google.com with SMTP id gv20-20020a17090b11d4b0290173b9578f1cso7794650pjb.0
        for <stable@vger.kernel.org>; Fri, 23 Jul 2021 20:16:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=R8cCylscA8Z2yiSthmcURlbx+M+mzhFx8YzmMGbw3q8=;
        b=t72DQ7Q90zLZQG69CYRTgKPN04Q5O3uww0JOtcydkSZX5tl3LmK4Wv8ZencaeooOQT
         2YDGd87Q0vd8o2ig0iz5/LK0mnf6vxDaBaV0CNfY3xMBm1QXDdb8NDDevkmOAwINEUMJ
         bIpv0NyWosdCSIlSmfwn8ZFPrKmke23yiZ2vi/2hXqAZsSXmGKCoVAXovrhL4c1/YVXH
         7PrqJFqiMff6bushgmwbdlVhpkpV0MsC4ByhrD5jo8RRU01ojYsZjjgOKPwd2E+gSDqj
         o3Dw17Q1QOv2EXSGJfXAU/54G45imfyzkfEtnFRP72fuwNWHov+9eMAsNPG4h8dMtrsF
         pKdQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=R8cCylscA8Z2yiSthmcURlbx+M+mzhFx8YzmMGbw3q8=;
        b=qKyUP67jfS5qD17XyFkM1OEe49NHmBIsy/47seNWVKRkuKnAhLVStl/j9QKG+AlGL2
         o/QQC1/tU6RtAwQDAyhsQMx0MM0CGCrJW59djsUSCajbM9caRnODmcPH7ixcFpUnG7Fv
         LpZO4qv2TzSaJEfi0UlRFDi9dk+UG6eykRvtK0+pa+U2O0b7IDkAY0BLumvPtg5G3GR+
         byz7/X2JXVxOBh/Ex2GOJM7Zeb9dbDwFRn/TsUEhGCV+eQevgoIgwbynXh4ioa1jHsBV
         bdrpRD2AplwiE4UXPmva6FwKCy9JPObwbBlYoaOFr4vCQiIaXbTXekPlItndvDqjv9uF
         dm1A==
X-Gm-Message-State: AOAM530tRT0P3Z1RPH2IsmzoVvCC7Yx8xcwJzYdRb8SIQfvz6G05crQt
        PC9faGoDqqProEH5eZDXDBmPrP4fkbkcQ55t
X-Google-Smtp-Source: ABdhPJy6fZDJ+SPjeieQNu5cbE+wvUxviNDrvF4w4t9bm58XMsanVmALsODcsMDQ3wGaOTOTSuLODg==
X-Received: by 2002:a17:90a:6482:: with SMTP id h2mr15845298pjj.24.1627096614902;
        Fri, 23 Jul 2021 20:16:54 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id d9sm27983243pgm.89.2021.07.23.20.16.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 23 Jul 2021 20:16:54 -0700 (PDT)
Message-ID: <60fb8626.1c69fb81.4bb63.5a23@mx.google.com>
Date:   Fri, 23 Jul 2021 20:16:54 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: queue/4.4
X-Kernelci-Kernel: v4.4.275-207-gc40dd6f5d898
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
Subject: stable-rc/queue/4.4 baseline: 113 runs,
 13 regressions (v4.4.275-207-gc40dd6f5d898)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.4 baseline: 113 runs, 13 regressions (v4.4.275-207-gc40dd=
6f5d898)

Regressions Summary
-------------------

platform            | arch | lab             | compiler | defconfig        =
   | regressions
--------------------+------+-----------------+----------+------------------=
---+------------
beagle-xm           | arm  | lab-baylibre    | gcc-8    | omap2plus_defconf=
ig | 2          =

dove-cubox          | arm  | lab-pengutronix | gcc-8    | mvebu_v7_defconfi=
g  | 1          =

qemu_arm-virt-gicv2 | arm  | lab-baylibre    | gcc-8    | multi_v7_defconfi=
g  | 1          =

qemu_arm-virt-gicv2 | arm  | lab-broonie     | gcc-8    | multi_v7_defconfi=
g  | 1          =

qemu_arm-virt-gicv2 | arm  | lab-cip         | gcc-8    | multi_v7_defconfi=
g  | 1          =

qemu_arm-virt-gicv2 | arm  | lab-collabora   | gcc-8    | multi_v7_defconfi=
g  | 1          =

qemu_arm-virt-gicv2 | arm  | lab-linaro-lkft | gcc-8    | multi_v7_defconfi=
g  | 1          =

qemu_arm-virt-gicv3 | arm  | lab-baylibre    | gcc-8    | multi_v7_defconfi=
g  | 1          =

qemu_arm-virt-gicv3 | arm  | lab-broonie     | gcc-8    | multi_v7_defconfi=
g  | 1          =

qemu_arm-virt-gicv3 | arm  | lab-cip         | gcc-8    | multi_v7_defconfi=
g  | 1          =

qemu_arm-virt-gicv3 | arm  | lab-collabora   | gcc-8    | multi_v7_defconfi=
g  | 1          =

qemu_arm-virt-gicv3 | arm  | lab-linaro-lkft | gcc-8    | multi_v7_defconfi=
g  | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.4/kern=
el/v4.4.275-207-gc40dd6f5d898/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.4
  Describe: v4.4.275-207-gc40dd6f5d898
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      c40dd6f5d8980d136cc07566d7340da57498b07c =



Test Regressions
---------------- =



platform            | arch | lab             | compiler | defconfig        =
   | regressions
--------------------+------+-----------------+----------+------------------=
---+------------
beagle-xm           | arm  | lab-baylibre    | gcc-8    | omap2plus_defconf=
ig | 2          =


  Details:     https://kernelci.org/test/plan/id/60fb4dc16f8b6686a43a2f22

  Results:     3 PASS, 2 FAIL, 1 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.275-2=
07-gc40dd6f5d898/arm/omap2plus_defconfig/gcc-8/lab-baylibre/baseline-beagle=
-xm.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.275-2=
07-gc40dd6f5d898/arm/omap2plus_defconfig/gcc-8/lab-baylibre/baseline-beagle=
-xm.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.dmesg.crit: https://kernelci.org/test/case/id/60fb4dc26f8b6686=
a43a2f28
        failing since 0 day (last pass: v4.4.275-207-g4d9e29c2fac94, first =
fail: v4.4.275-207-g144102a3596a)
        1 lines

    2021-07-23T23:15:59.636070  / # #
    2021-07-23T23:15:59.636704  =

    2021-07-23T23:15:59.739500  / # #
    2021-07-23T23:15:59.739970  =

    2021-07-23T23:15:59.841189  / # #export SHELL=3D/bin/sh
    2021-07-23T23:15:59.841561  =

    2021-07-23T23:15:59.942696  / # export SHELL=3D/bin/sh. /lava-591260/en=
vironment
    2021-07-23T23:15:59.943057  =

    2021-07-23T23:16:00.044197  / # . /lava-591260/environment/lava-591260/=
bin/lava-test-runner /lava-591260/0
    2021-07-23T23:16:00.045068   =

    ... (9 line(s) more)  =


  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/60fb4dc26f8b668=
6a43a2f2a
        failing since 0 day (last pass: v4.4.275-207-g4d9e29c2fac94, first =
fail: v4.4.275-207-g144102a3596a)
        28 lines

    2021-07-23T23:16:00.509318  [   49.908966] <LAVA_SIGNAL_TESTCASE TEST_C=
ASE_ID=3Dalert RESULT=3Dpass UNITS=3Dlines MEASUREMENT=3D0>
    2021-07-23T23:16:00.562022  kern  :emerg : Internal error: Oops - BUG: =
0 [#1] SMP ARM
    2021-07-23T23:16:00.567895  kern  :emerg : Process udevd (pid: 108, sta=
ck limit =3D 0xcb908218)
    2021-07-23T23:16:00.572065  kern  :emerg : Stack: (0xcb909d10 to 0xcb90=
a000)
    2021-07-23T23:16:00.580486  kern  :emerg : 9d00:                       =
              bf03583c bf01ab84 cba60c10 bf0358c8
    2021-07-23T23:16:00.593645  kern  :emerg : 9d20: cba60c10 bf2670a8 0000=
0002 cb[   49.990509] <LAVA_SIGNAL_TESTCASE TEST_CASE_ID=3Demerg RESULT=3Df=
ail UNITS=3Dlines MEASUREMENT=3D28>   =

 =



platform            | arch | lab             | compiler | defconfig        =
   | regressions
--------------------+------+-----------------+----------+------------------=
---+------------
dove-cubox          | arm  | lab-pengutronix | gcc-8    | mvebu_v7_defconfi=
g  | 1          =


  Details:     https://kernelci.org/test/plan/id/60fb4d2a364a00a2213a2f3b

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: mvebu_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.275-2=
07-gc40dd6f5d898/arm/mvebu_v7_defconfig/gcc-8/lab-pengutronix/baseline-dove=
-cubox.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.275-2=
07-gc40dd6f5d898/arm/mvebu_v7_defconfig/gcc-8/lab-pengutronix/baseline-dove=
-cubox.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60fb4d2a364a00a2213a2=
f3c
        failing since 3 days (last pass: v4.4.275-128-g1ae5be41556b, first =
fail: v4.4.275-188-gb12431bfcf5f) =

 =



platform            | arch | lab             | compiler | defconfig        =
   | regressions
--------------------+------+-----------------+----------+------------------=
---+------------
qemu_arm-virt-gicv2 | arm  | lab-baylibre    | gcc-8    | multi_v7_defconfi=
g  | 1          =


  Details:     https://kernelci.org/test/plan/id/60fb4c19a118183bbe3a2f26

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.275-2=
07-gc40dd6f5d898/arm/multi_v7_defconfig/gcc-8/lab-baylibre/baseline-qemu_ar=
m-virt-gicv2.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.275-2=
07-gc40dd6f5d898/arm/multi_v7_defconfig/gcc-8/lab-baylibre/baseline-qemu_ar=
m-virt-gicv2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60fb4c19a118183bbe3a2=
f27
        failing since 252 days (last pass: v4.4.243-18-gfc7e8c68369a, first=
 fail: v4.4.243-19-g71b6c961c7fe) =

 =



platform            | arch | lab             | compiler | defconfig        =
   | regressions
--------------------+------+-----------------+----------+------------------=
---+------------
qemu_arm-virt-gicv2 | arm  | lab-broonie     | gcc-8    | multi_v7_defconfi=
g  | 1          =


  Details:     https://kernelci.org/test/plan/id/60fb4c9e61edf48ab13a2f3a

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.275-2=
07-gc40dd6f5d898/arm/multi_v7_defconfig/gcc-8/lab-broonie/baseline-qemu_arm=
-virt-gicv2.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.275-2=
07-gc40dd6f5d898/arm/multi_v7_defconfig/gcc-8/lab-broonie/baseline-qemu_arm=
-virt-gicv2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60fb4c9e61edf48ab13a2=
f3b
        failing since 252 days (last pass: v4.4.243-18-gfc7e8c68369a, first=
 fail: v4.4.243-19-g71b6c961c7fe) =

 =



platform            | arch | lab             | compiler | defconfig        =
   | regressions
--------------------+------+-----------------+----------+------------------=
---+------------
qemu_arm-virt-gicv2 | arm  | lab-cip         | gcc-8    | multi_v7_defconfi=
g  | 1          =


  Details:     https://kernelci.org/test/plan/id/60fb4c3846b626c4583a2f2b

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.275-2=
07-gc40dd6f5d898/arm/multi_v7_defconfig/gcc-8/lab-cip/baseline-qemu_arm-vir=
t-gicv2.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.275-2=
07-gc40dd6f5d898/arm/multi_v7_defconfig/gcc-8/lab-cip/baseline-qemu_arm-vir=
t-gicv2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60fb4c3846b626c4583a2=
f2c
        failing since 252 days (last pass: v4.4.243-18-gfc7e8c68369a, first=
 fail: v4.4.243-19-g71b6c961c7fe) =

 =



platform            | arch | lab             | compiler | defconfig        =
   | regressions
--------------------+------+-----------------+----------+------------------=
---+------------
qemu_arm-virt-gicv2 | arm  | lab-collabora   | gcc-8    | multi_v7_defconfi=
g  | 1          =


  Details:     https://kernelci.org/test/plan/id/60fb6dbd0ab69e062f3a2f32

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.275-2=
07-gc40dd6f5d898/arm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-qemu_a=
rm-virt-gicv2.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.275-2=
07-gc40dd6f5d898/arm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-qemu_a=
rm-virt-gicv2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60fb6dbd0ab69e062f3a2=
f33
        failing since 252 days (last pass: v4.4.243-18-gfc7e8c68369a, first=
 fail: v4.4.243-19-g71b6c961c7fe) =

 =



platform            | arch | lab             | compiler | defconfig        =
   | regressions
--------------------+------+-----------------+----------+------------------=
---+------------
qemu_arm-virt-gicv2 | arm  | lab-linaro-lkft | gcc-8    | multi_v7_defconfi=
g  | 1          =


  Details:     https://kernelci.org/test/plan/id/60fb4be66befd519a63a2f48

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.275-2=
07-gc40dd6f5d898/arm/multi_v7_defconfig/gcc-8/lab-linaro-lkft/baseline-qemu=
_arm-virt-gicv2.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.275-2=
07-gc40dd6f5d898/arm/multi_v7_defconfig/gcc-8/lab-linaro-lkft/baseline-qemu=
_arm-virt-gicv2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60fb4be66befd519a63a2=
f49
        failing since 252 days (last pass: v4.4.243-18-gfc7e8c68369a, first=
 fail: v4.4.243-19-g71b6c961c7fe) =

 =



platform            | arch | lab             | compiler | defconfig        =
   | regressions
--------------------+------+-----------------+----------+------------------=
---+------------
qemu_arm-virt-gicv3 | arm  | lab-baylibre    | gcc-8    | multi_v7_defconfi=
g  | 1          =


  Details:     https://kernelci.org/test/plan/id/60fb4bdd6befd519a63a2f36

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.275-2=
07-gc40dd6f5d898/arm/multi_v7_defconfig/gcc-8/lab-baylibre/baseline-qemu_ar=
m-virt-gicv3.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.275-2=
07-gc40dd6f5d898/arm/multi_v7_defconfig/gcc-8/lab-baylibre/baseline-qemu_ar=
m-virt-gicv3.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60fb4bdd6befd519a63a2=
f37
        failing since 252 days (last pass: v4.4.243-18-gfc7e8c68369a, first=
 fail: v4.4.243-19-g71b6c961c7fe) =

 =



platform            | arch | lab             | compiler | defconfig        =
   | regressions
--------------------+------+-----------------+----------+------------------=
---+------------
qemu_arm-virt-gicv3 | arm  | lab-broonie     | gcc-8    | multi_v7_defconfi=
g  | 1          =


  Details:     https://kernelci.org/test/plan/id/60fb4c3a7fb6105d463a2f24

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.275-2=
07-gc40dd6f5d898/arm/multi_v7_defconfig/gcc-8/lab-broonie/baseline-qemu_arm=
-virt-gicv3.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.275-2=
07-gc40dd6f5d898/arm/multi_v7_defconfig/gcc-8/lab-broonie/baseline-qemu_arm=
-virt-gicv3.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60fb4c3a7fb6105d463a2=
f25
        failing since 252 days (last pass: v4.4.243-18-gfc7e8c68369a, first=
 fail: v4.4.243-19-g71b6c961c7fe) =

 =



platform            | arch | lab             | compiler | defconfig        =
   | regressions
--------------------+------+-----------------+----------+------------------=
---+------------
qemu_arm-virt-gicv3 | arm  | lab-cip         | gcc-8    | multi_v7_defconfi=
g  | 1          =


  Details:     https://kernelci.org/test/plan/id/60fb4be95c6126d94f3a2f48

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.275-2=
07-gc40dd6f5d898/arm/multi_v7_defconfig/gcc-8/lab-cip/baseline-qemu_arm-vir=
t-gicv3.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.275-2=
07-gc40dd6f5d898/arm/multi_v7_defconfig/gcc-8/lab-cip/baseline-qemu_arm-vir=
t-gicv3.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60fb4be95c6126d94f3a2=
f49
        failing since 252 days (last pass: v4.4.243-18-gfc7e8c68369a, first=
 fail: v4.4.243-19-g71b6c961c7fe) =

 =



platform            | arch | lab             | compiler | defconfig        =
   | regressions
--------------------+------+-----------------+----------+------------------=
---+------------
qemu_arm-virt-gicv3 | arm  | lab-collabora   | gcc-8    | multi_v7_defconfi=
g  | 1          =


  Details:     https://kernelci.org/test/plan/id/60fb6cf7fe7be402cc3a2f53

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.275-2=
07-gc40dd6f5d898/arm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-qemu_a=
rm-virt-gicv3.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.275-2=
07-gc40dd6f5d898/arm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-qemu_a=
rm-virt-gicv3.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60fb6cf7fe7be402cc3a2=
f54
        failing since 252 days (last pass: v4.4.243-18-gfc7e8c68369a, first=
 fail: v4.4.243-19-g71b6c961c7fe) =

 =



platform            | arch | lab             | compiler | defconfig        =
   | regressions
--------------------+------+-----------------+----------+------------------=
---+------------
qemu_arm-virt-gicv3 | arm  | lab-linaro-lkft | gcc-8    | multi_v7_defconfi=
g  | 1          =


  Details:     https://kernelci.org/test/plan/id/60fb4be55c6126d94f3a2f2b

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.275-2=
07-gc40dd6f5d898/arm/multi_v7_defconfig/gcc-8/lab-linaro-lkft/baseline-qemu=
_arm-virt-gicv3.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.275-2=
07-gc40dd6f5d898/arm/multi_v7_defconfig/gcc-8/lab-linaro-lkft/baseline-qemu=
_arm-virt-gicv3.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60fb4be55c6126d94f3a2=
f2c
        failing since 252 days (last pass: v4.4.243-18-gfc7e8c68369a, first=
 fail: v4.4.243-19-g71b6c961c7fe) =

 =20
