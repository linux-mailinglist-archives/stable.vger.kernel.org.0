Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 13EF53FC0D9
	for <lists+stable@lfdr.de>; Tue, 31 Aug 2021 04:36:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239346AbhHaCfE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 30 Aug 2021 22:35:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45990 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239439AbhHaCfD (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 30 Aug 2021 22:35:03 -0400
Received: from mail-pg1-x529.google.com (mail-pg1-x529.google.com [IPv6:2607:f8b0:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BF304C061575
        for <stable@vger.kernel.org>; Mon, 30 Aug 2021 19:34:05 -0700 (PDT)
Received: by mail-pg1-x529.google.com with SMTP id x4so15343831pgh.1
        for <stable@vger.kernel.org>; Mon, 30 Aug 2021 19:34:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=+MF3cLrmgcS/CLeutzis+/S17a18+gxGWRfcMSFzXko=;
        b=y4YTYKOMbn8aJIiPrG4mAxPhMGKFWIBSjaTRUT6c21pDbN2Z+aOROpdQQMUu+HNP33
         seMA6wHQodGAfCl+wyDxNEwXN2PmROyTXul4DBdxK1Mxse3MNibJ+U34yX/T2OOHvRNM
         dAczyVqYBgOdXWsYJJs/UvgFKeV6qttwRpjglEOzULB0LurQ15jIcl8dQiQ23z3K4PdP
         uCArfLrmPfXKkirCa7sO/gTvhM8CZODcA87X2fIg1/2dOWlyqP58Cl6VYAR24ex2wMSO
         8GisREA01N4ktZbaZWenWVvj/hShlZN893WxgRPtk6EHqphuNtmPJ9CaCWB5v8pU3WsN
         Wj6Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=+MF3cLrmgcS/CLeutzis+/S17a18+gxGWRfcMSFzXko=;
        b=NRvJG8ef8Qr1sk8rMNdMOiA9giWPu2X7ClbCo5pWWOQm7cKEnCj4gGCUjmuHDAV7E2
         /3vY+Sy1qoHnLWAIZwpPxhn212FQt1360csTPIPX2XWlKNskkt8bO6IZnLlm3tYbGOIC
         TzEiD1NG78p1a/AlxpIv9ZuoF3yuqHX/bIUyDFXiyoW/TwI2XtO36j9lhp8N5e552EVB
         6hS8jUyP+GCBUAjso+RMtW9dGnU+JYfqP+BxHN/QM/FXEvHppnNu8Z7Lo0ViJyr3goEX
         MRYeGvo7T9UdP458yceYluVWFwl0TpI1dIWnJZkjiI7QFb10NxCEMNhVh2FuUhW4hXqX
         ulgg==
X-Gm-Message-State: AOAM533SnAgt9eK/GkZEB4BjmvJC9tTFh2cdACPcWQrAGktEshdKbHVN
        EbccVs8/v8ZofQu1HOPpaCEseW4rDuSBjsxq
X-Google-Smtp-Source: ABdhPJx6LE9DLX6U8vxXrUFRO2FJoJ/bbwUstqhR595Tl63pRX5shNN3wp5hhfmz+dmBxhp+c3FeDw==
X-Received: by 2002:a65:5c43:: with SMTP id v3mr24606810pgr.342.1630377244966;
        Mon, 30 Aug 2021 19:34:04 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id d15sm18398031pgj.84.2021.08.30.19.34.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 30 Aug 2021 19:34:04 -0700 (PDT)
Message-ID: <612d951c.1c69fb81.ac515.09af@mx.google.com>
Date:   Mon, 30 Aug 2021 19:34:04 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: queue/4.4
X-Kernelci-Kernel: v4.4.282-7-gae87bd189213
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
Subject: stable-rc/queue/4.4 baseline: 89 runs,
 9 regressions (v4.4.282-7-gae87bd189213)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.4 baseline: 89 runs, 9 regressions (v4.4.282-7-gae87bd189=
213)

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

qemu_arm-virt-gicv3 | arm  | lab-baylibre    | gcc-8    | multi_v7_defconfi=
g  | 1          =

qemu_arm-virt-gicv3 | arm  | lab-broonie     | gcc-8    | multi_v7_defconfi=
g  | 1          =

qemu_arm-virt-gicv3 | arm  | lab-cip         | gcc-8    | multi_v7_defconfi=
g  | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.4/kern=
el/v4.4.282-7-gae87bd189213/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.4
  Describe: v4.4.282-7-gae87bd189213
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      ae87bd18921351f534b6e7043cb1f59cc3fc1449 =



Test Regressions
---------------- =



platform            | arch | lab             | compiler | defconfig        =
   | regressions
--------------------+------+-----------------+----------+------------------=
---+------------
beagle-xm           | arm  | lab-baylibre    | gcc-8    | omap2plus_defconf=
ig | 2          =


  Details:     https://kernelci.org/test/plan/id/612d6103d9739dd1ab8e2c9c

  Results:     3 PASS, 2 FAIL, 1 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.282-7=
-gae87bd189213/arm/omap2plus_defconfig/gcc-8/lab-baylibre/baseline-beagle-x=
m.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.282-7=
-gae87bd189213/arm/omap2plus_defconfig/gcc-8/lab-baylibre/baseline-beagle-x=
m.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.dmesg.crit: https://kernelci.org/test/case/id/612d6103d9739dd1=
ab8e2ca2
        new failure (last pass: v4.4.282-5-geb745ac888ff)
        1 lines

    2021-08-30T22:51:28.525655  / # =

    2021-08-30T22:51:28.526305  #
    2021-08-30T22:51:28.629058  / # #
    2021-08-30T22:51:28.629543  =

    2021-08-30T22:51:28.730774  / # #export SHELL=3D/bin/sh
    2021-08-30T22:51:28.731151  =

    2021-08-30T22:51:28.832270  / # export SHELL=3D/bin/sh. /lava-769258/en=
vironment
    2021-08-30T22:51:28.832581  =

    2021-08-30T22:51:28.933456  / # . /lava-769258/environment/lava-769258/=
bin/lava-test-runner /lava-769258/0
    2021-08-30T22:51:28.934322   =

    ... (9 line(s) more)  =


  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/612d6103d9739dd=
1ab8e2ca4
        new failure (last pass: v4.4.282-5-geb745ac888ff)
        28 lines

    2021-08-30T22:51:29.394718  [   49.919769] <LAVA_SIGNAL_TESTCASE TEST_C=
ASE_ID=3Dalert RESULT=3Dpass UNITS=3Dlines MEASUREMENT=3D0>
    2021-08-30T22:51:29.446167  kern  :emerg : Internal error: Oops - BUG: =
0 [#1] SMP ARM
    2021-08-30T22:51:29.451930  kern  :emerg : Process udevd (pid: 113, sta=
ck limit =3D 0xcb992218)
    2021-08-30T22:51:29.456484  kern  :emerg : Stack: (0xcb993d10 to 0xcb99=
4000)
    2021-08-30T22:51:29.464795  kern  :emerg : 3d00:                       =
              bf02f83c bf014b84 cb8e6610 bf02f8c8   =

 =



platform            | arch | lab             | compiler | defconfig        =
   | regressions
--------------------+------+-----------------+----------+------------------=
---+------------
dove-cubox          | arm  | lab-pengutronix | gcc-8    | mvebu_v7_defconfi=
g  | 1          =


  Details:     https://kernelci.org/test/plan/id/612d5ed256236f44238e2c95

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: mvebu_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.282-7=
-gae87bd189213/arm/mvebu_v7_defconfig/gcc-8/lab-pengutronix/baseline-dove-c=
ubox.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.282-7=
-gae87bd189213/arm/mvebu_v7_defconfig/gcc-8/lab-pengutronix/baseline-dove-c=
ubox.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/612d5ed256236f44238e2=
c96
        failing since 0 day (last pass: v4.4.282-3-g0caaa4218f4e, first fai=
l: v4.4.282-5-geb745ac888ff) =

 =



platform            | arch | lab             | compiler | defconfig        =
   | regressions
--------------------+------+-----------------+----------+------------------=
---+------------
qemu_arm-virt-gicv2 | arm  | lab-baylibre    | gcc-8    | multi_v7_defconfi=
g  | 1          =


  Details:     https://kernelci.org/test/plan/id/612d643fff9ecdfc018e2c97

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.282-7=
-gae87bd189213/arm/multi_v7_defconfig/gcc-8/lab-baylibre/baseline-qemu_arm-=
virt-gicv2.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.282-7=
-gae87bd189213/arm/multi_v7_defconfig/gcc-8/lab-baylibre/baseline-qemu_arm-=
virt-gicv2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/612d643fff9ecdfc018e2=
c98
        failing since 290 days (last pass: v4.4.243-18-gfc7e8c68369a, first=
 fail: v4.4.243-19-g71b6c961c7fe) =

 =



platform            | arch | lab             | compiler | defconfig        =
   | regressions
--------------------+------+-----------------+----------+------------------=
---+------------
qemu_arm-virt-gicv2 | arm  | lab-broonie     | gcc-8    | multi_v7_defconfi=
g  | 1          =


  Details:     https://kernelci.org/test/plan/id/612d648b74dc1c9a6b8e2c9b

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.282-7=
-gae87bd189213/arm/multi_v7_defconfig/gcc-8/lab-broonie/baseline-qemu_arm-v=
irt-gicv2.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.282-7=
-gae87bd189213/arm/multi_v7_defconfig/gcc-8/lab-broonie/baseline-qemu_arm-v=
irt-gicv2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/612d648b74dc1c9a6b8e2=
c9c
        failing since 290 days (last pass: v4.4.243-18-gfc7e8c68369a, first=
 fail: v4.4.243-19-g71b6c961c7fe) =

 =



platform            | arch | lab             | compiler | defconfig        =
   | regressions
--------------------+------+-----------------+----------+------------------=
---+------------
qemu_arm-virt-gicv2 | arm  | lab-cip         | gcc-8    | multi_v7_defconfi=
g  | 1          =


  Details:     https://kernelci.org/test/plan/id/612d64653cbf78ec738e2caa

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.282-7=
-gae87bd189213/arm/multi_v7_defconfig/gcc-8/lab-cip/baseline-qemu_arm-virt-=
gicv2.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.282-7=
-gae87bd189213/arm/multi_v7_defconfig/gcc-8/lab-cip/baseline-qemu_arm-virt-=
gicv2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/612d64653cbf78ec738e2=
cab
        failing since 290 days (last pass: v4.4.243-18-gfc7e8c68369a, first=
 fail: v4.4.243-19-g71b6c961c7fe) =

 =



platform            | arch | lab             | compiler | defconfig        =
   | regressions
--------------------+------+-----------------+----------+------------------=
---+------------
qemu_arm-virt-gicv3 | arm  | lab-baylibre    | gcc-8    | multi_v7_defconfi=
g  | 1          =


  Details:     https://kernelci.org/test/plan/id/612d648f8bd1c5ca558e2ca4

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.282-7=
-gae87bd189213/arm/multi_v7_defconfig/gcc-8/lab-baylibre/baseline-qemu_arm-=
virt-gicv3.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.282-7=
-gae87bd189213/arm/multi_v7_defconfig/gcc-8/lab-baylibre/baseline-qemu_arm-=
virt-gicv3.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/612d648f8bd1c5ca558e2=
ca5
        failing since 290 days (last pass: v4.4.243-18-gfc7e8c68369a, first=
 fail: v4.4.243-19-g71b6c961c7fe) =

 =



platform            | arch | lab             | compiler | defconfig        =
   | regressions
--------------------+------+-----------------+----------+------------------=
---+------------
qemu_arm-virt-gicv3 | arm  | lab-broonie     | gcc-8    | multi_v7_defconfi=
g  | 1          =


  Details:     https://kernelci.org/test/plan/id/612d65040d1d7a35108e2c96

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.282-7=
-gae87bd189213/arm/multi_v7_defconfig/gcc-8/lab-broonie/baseline-qemu_arm-v=
irt-gicv3.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.282-7=
-gae87bd189213/arm/multi_v7_defconfig/gcc-8/lab-broonie/baseline-qemu_arm-v=
irt-gicv3.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/612d65040d1d7a35108e2=
c97
        failing since 290 days (last pass: v4.4.243-18-gfc7e8c68369a, first=
 fail: v4.4.243-19-g71b6c961c7fe) =

 =



platform            | arch | lab             | compiler | defconfig        =
   | regressions
--------------------+------+-----------------+----------+------------------=
---+------------
qemu_arm-virt-gicv3 | arm  | lab-cip         | gcc-8    | multi_v7_defconfi=
g  | 1          =


  Details:     https://kernelci.org/test/plan/id/612d645094c751e5198e2c9a

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.282-7=
-gae87bd189213/arm/multi_v7_defconfig/gcc-8/lab-cip/baseline-qemu_arm-virt-=
gicv3.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.282-7=
-gae87bd189213/arm/multi_v7_defconfig/gcc-8/lab-cip/baseline-qemu_arm-virt-=
gicv3.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/612d645094c751e5198e2=
c9b
        failing since 290 days (last pass: v4.4.243-18-gfc7e8c68369a, first=
 fail: v4.4.243-19-g71b6c961c7fe) =

 =20
