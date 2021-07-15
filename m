Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 89CAE3CA1DD
	for <lists+stable@lfdr.de>; Thu, 15 Jul 2021 18:06:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230347AbhGOQJK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 15 Jul 2021 12:09:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46748 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229818AbhGOQJK (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 15 Jul 2021 12:09:10 -0400
Received: from mail-pf1-x434.google.com (mail-pf1-x434.google.com [IPv6:2607:f8b0:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5F585C06175F
        for <stable@vger.kernel.org>; Thu, 15 Jul 2021 09:06:17 -0700 (PDT)
Received: by mail-pf1-x434.google.com with SMTP id 17so5877189pfz.4
        for <stable@vger.kernel.org>; Thu, 15 Jul 2021 09:06:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=2jQYgqZ0R7rWqOSoj9vn/p4As57VowH5pAT3dTSL3sw=;
        b=K81t7VVxkOHnMEsxEnycSrkhEwehBwWU6SlvkTGpbLMojbdAHH4+o3ZDb9CFrQnOpE
         u5LbCE+fKqf0QNy8TuhyHBAL0R56k8YKi/2s8r3Ak0PWN6i95KdQ7iNYqO9ASy4PH+ic
         Yb2zLAyFsExulW2ABl8mFq0kw3k4AUMazoLfP2B0sHWXhrARR3Q58ORifhl6vD2df0oW
         WOCRLP90RZTFgiTGLMmVD1DldqMa2EhQuQn45Zrx4fa/56sqHWR+njSaERjOR2pFfygV
         Tubciq+JC8MGqM7tN3MC7vkAUsADcfIr6u1VQABdNRaWqgxzWAIzUQI0hLlw1zV4/Ase
         /u7g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=2jQYgqZ0R7rWqOSoj9vn/p4As57VowH5pAT3dTSL3sw=;
        b=gLc5H7f/twA46GLkITXlv5r6GAkLnoyHUzzVyjRGsbjjvfYfkzRRNorP5esWof22BY
         pfzsYTUVNHIJVmghU9ta8PWxBb8Zl1UiFUmqBW68iAZ0+gqtbrKndvUS5gJPsdqWCM+T
         92WUTN5WAPK7eOTsPGYB6pexvVTU8nk7RSLMQINpOQBswTUeTNyPRoLhBqLQiOVgrB6N
         hvJ5nisjDOCGDYvj+u0aRUEr77qSyVGdJTWcRhDmG8XxFCvw5gTAcR+s+hlreaLjCjvg
         m9Ao844x3TMbrLAhtJpixQZ/DVHo6knInSvK7ss11gujluvmcbC1p8ufGIAyVDp8gn9c
         bw5w==
X-Gm-Message-State: AOAM532jqefbU91z0MxtlLqqAnq3SB+f3BUFSwmxxW/CoYdufo9rW7zG
        8yP+wLPokW6qByBr9Js/Popj2Ln3Vj9JLWAh
X-Google-Smtp-Source: ABdhPJyjrpmFObO0kN+WtAnC7kdaqOn2p0xuzyMC5nuGrkFN2V5ZWeXluJH3/cQiOF00n/lki//zgw==
X-Received: by 2002:a65:4382:: with SMTP id m2mr5271141pgp.205.1626365176703;
        Thu, 15 Jul 2021 09:06:16 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id u125sm7329996pfu.95.2021.07.15.09.06.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 15 Jul 2021 09:06:16 -0700 (PDT)
Message-ID: <60f05cf8.1c69fb81.b7f5e.6048@mx.google.com>
Date:   Thu, 15 Jul 2021 09:06:16 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/4.4
X-Kernelci-Kernel: v4.4.275-128-g1ae5be41556b
Subject: stable-rc/queue/4.4 baseline: 136 runs,
 12 regressions (v4.4.275-128-g1ae5be41556b)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.4 baseline: 136 runs, 12 regressions (v4.4.275-128-g1ae5b=
e41556b)

Regressions Summary
-------------------

platform            | arch | lab             | compiler | defconfig        =
   | regressions
--------------------+------+-----------------+----------+------------------=
---+------------
beagle-xm           | arm  | lab-baylibre    | gcc-8    | omap2plus_defconf=
ig | 2          =

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
el/v4.4.275-128-g1ae5be41556b/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.4
  Describe: v4.4.275-128-g1ae5be41556b
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      1ae5be41556b245b179a4893f1d194427529ec45 =



Test Regressions
---------------- =



platform            | arch | lab             | compiler | defconfig        =
   | regressions
--------------------+------+-----------------+----------+------------------=
---+------------
beagle-xm           | arm  | lab-baylibre    | gcc-8    | omap2plus_defconf=
ig | 2          =


  Details:     https://kernelci.org/test/plan/id/60f02988c34628cf2c8a93a5

  Results:     3 PASS, 2 FAIL, 1 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.275-1=
28-g1ae5be41556b/arm/omap2plus_defconfig/gcc-8/lab-baylibre/baseline-beagle=
-xm.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.275-1=
28-g1ae5be41556b/arm/omap2plus_defconfig/gcc-8/lab-baylibre/baseline-beagle=
-xm.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.dmesg.crit: https://kernelci.org/test/case/id/60f02988c34628cf=
2c8a93a8
        failing since 0 day (last pass: v4.4.247-15-ga32da6d21a77, first fa=
il: v4.4.275-93-g546413ba97fb5)
        1 lines

    2021-07-15T12:26:35.430472  /
    2021-07-15T12:26:35.534065   # #
    2021-07-15T12:26:35.534552  =

    2021-07-15T12:26:35.635833  / # #export SHELL=3D/bin/sh
    2021-07-15T12:26:35.636155  =

    2021-07-15T12:26:35.737280  / # export SHELL=3D/bin/sh. /lava-563995/en=
vironment
    2021-07-15T12:26:35.737582  =

    2021-07-15T12:26:35.838718  / # . /lava-563995/environment/lava-563995/=
bin/lava-test-runner /lava-563995/0
    2021-07-15T12:26:35.839568  =

    2021-07-15T12:26:35.841321  / # /lava-563995/bin/lava-test-runner /lava=
-563995/0 =

    ... (8 line(s) more)  =


  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/60f02988c34628c=
f2c8a93aa
        failing since 0 day (last pass: v4.4.247-15-ga32da6d21a77, first fa=
il: v4.4.275-93-g546413ba97fb5)
        28 lines

    2021-07-15T12:26:36.301409  [   50.046173] <LAVA_SIGNAL_TESTCASE TEST_C=
ASE_ID=3Dalert RESULT=3Dpass UNITS=3Dlines MEASUREMENT=3D0>
    2021-07-15T12:26:36.353320  kern  :emerg : Internal error: Oops - BUG: =
0 [#1] SMP ARM
    2021-07-15T12:26:36.359049  kern  :emerg : Process udevd (pid: 108, sta=
ck limit =3D 0xcb8f2218)
    2021-07-15T12:26:36.363201  kern  :emerg : Stack: (0xcb8f3d10 to 0xcb8f=
4000)
    2021-07-15T12:26:36.371753  kern  :emerg : 3d00:                       =
              bf03283c bf017b84 cb946410 bf0328c8   =

 =



platform            | arch | lab             | compiler | defconfig        =
   | regressions
--------------------+------+-----------------+----------+------------------=
---+------------
qemu_arm-virt-gicv2 | arm  | lab-baylibre    | gcc-8    | multi_v7_defconfi=
g  | 1          =


  Details:     https://kernelci.org/test/plan/id/60f02af8c06193736a8a93c9

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.275-1=
28-g1ae5be41556b/arm/multi_v7_defconfig/gcc-8/lab-baylibre/baseline-qemu_ar=
m-virt-gicv2.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.275-1=
28-g1ae5be41556b/arm/multi_v7_defconfig/gcc-8/lab-baylibre/baseline-qemu_ar=
m-virt-gicv2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60f02af8c06193736a8a9=
3ca
        failing since 243 days (last pass: v4.4.243-18-gfc7e8c68369a, first=
 fail: v4.4.243-19-g71b6c961c7fe) =

 =



platform            | arch | lab             | compiler | defconfig        =
   | regressions
--------------------+------+-----------------+----------+------------------=
---+------------
qemu_arm-virt-gicv2 | arm  | lab-broonie     | gcc-8    | multi_v7_defconfi=
g  | 1          =


  Details:     https://kernelci.org/test/plan/id/60f02b327323b8fb498a93b3

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.275-1=
28-g1ae5be41556b/arm/multi_v7_defconfig/gcc-8/lab-broonie/baseline-qemu_arm=
-virt-gicv2.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.275-1=
28-g1ae5be41556b/arm/multi_v7_defconfig/gcc-8/lab-broonie/baseline-qemu_arm=
-virt-gicv2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60f02b327323b8fb498a9=
3b4
        failing since 243 days (last pass: v4.4.243-18-gfc7e8c68369a, first=
 fail: v4.4.243-19-g71b6c961c7fe) =

 =



platform            | arch | lab             | compiler | defconfig        =
   | regressions
--------------------+------+-----------------+----------+------------------=
---+------------
qemu_arm-virt-gicv2 | arm  | lab-cip         | gcc-8    | multi_v7_defconfi=
g  | 1          =


  Details:     https://kernelci.org/test/plan/id/60f02b047e0be61d708a93b0

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.275-1=
28-g1ae5be41556b/arm/multi_v7_defconfig/gcc-8/lab-cip/baseline-qemu_arm-vir=
t-gicv2.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.275-1=
28-g1ae5be41556b/arm/multi_v7_defconfig/gcc-8/lab-cip/baseline-qemu_arm-vir=
t-gicv2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60f02b047e0be61d708a9=
3b1
        failing since 243 days (last pass: v4.4.243-18-gfc7e8c68369a, first=
 fail: v4.4.243-19-g71b6c961c7fe) =

 =



platform            | arch | lab             | compiler | defconfig        =
   | regressions
--------------------+------+-----------------+----------+------------------=
---+------------
qemu_arm-virt-gicv2 | arm  | lab-collabora   | gcc-8    | multi_v7_defconfi=
g  | 1          =


  Details:     https://kernelci.org/test/plan/id/60f02c16050a7bda598a93bc

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.275-1=
28-g1ae5be41556b/arm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-qemu_a=
rm-virt-gicv2.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.275-1=
28-g1ae5be41556b/arm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-qemu_a=
rm-virt-gicv2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60f02c16050a7bda598a9=
3bd
        failing since 243 days (last pass: v4.4.243-18-gfc7e8c68369a, first=
 fail: v4.4.243-19-g71b6c961c7fe) =

 =



platform            | arch | lab             | compiler | defconfig        =
   | regressions
--------------------+------+-----------------+----------+------------------=
---+------------
qemu_arm-virt-gicv2 | arm  | lab-linaro-lkft | gcc-8    | multi_v7_defconfi=
g  | 1          =


  Details:     https://kernelci.org/test/plan/id/60f02af07e0be61d708a939d

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.275-1=
28-g1ae5be41556b/arm/multi_v7_defconfig/gcc-8/lab-linaro-lkft/baseline-qemu=
_arm-virt-gicv2.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.275-1=
28-g1ae5be41556b/arm/multi_v7_defconfig/gcc-8/lab-linaro-lkft/baseline-qemu=
_arm-virt-gicv2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60f02af07e0be61d708a9=
39e
        failing since 243 days (last pass: v4.4.243-18-gfc7e8c68369a, first=
 fail: v4.4.243-19-g71b6c961c7fe) =

 =



platform            | arch | lab             | compiler | defconfig        =
   | regressions
--------------------+------+-----------------+----------+------------------=
---+------------
qemu_arm-virt-gicv3 | arm  | lab-baylibre    | gcc-8    | multi_v7_defconfi=
g  | 1          =


  Details:     https://kernelci.org/test/plan/id/60f02af97e0be61d708a93a8

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.275-1=
28-g1ae5be41556b/arm/multi_v7_defconfig/gcc-8/lab-baylibre/baseline-qemu_ar=
m-virt-gicv3.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.275-1=
28-g1ae5be41556b/arm/multi_v7_defconfig/gcc-8/lab-baylibre/baseline-qemu_ar=
m-virt-gicv3.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60f02af97e0be61d708a9=
3a9
        failing since 243 days (last pass: v4.4.243-18-gfc7e8c68369a, first=
 fail: v4.4.243-19-g71b6c961c7fe) =

 =



platform            | arch | lab             | compiler | defconfig        =
   | regressions
--------------------+------+-----------------+----------+------------------=
---+------------
qemu_arm-virt-gicv3 | arm  | lab-broonie     | gcc-8    | multi_v7_defconfi=
g  | 1          =


  Details:     https://kernelci.org/test/plan/id/60f02bd28b1b21d5f28a93ae

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.275-1=
28-g1ae5be41556b/arm/multi_v7_defconfig/gcc-8/lab-broonie/baseline-qemu_arm=
-virt-gicv3.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.275-1=
28-g1ae5be41556b/arm/multi_v7_defconfig/gcc-8/lab-broonie/baseline-qemu_arm=
-virt-gicv3.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60f02bd28b1b21d5f28a9=
3af
        failing since 243 days (last pass: v4.4.243-18-gfc7e8c68369a, first=
 fail: v4.4.243-19-g71b6c961c7fe) =

 =



platform            | arch | lab             | compiler | defconfig        =
   | regressions
--------------------+------+-----------------+----------+------------------=
---+------------
qemu_arm-virt-gicv3 | arm  | lab-cip         | gcc-8    | multi_v7_defconfi=
g  | 1          =


  Details:     https://kernelci.org/test/plan/id/60f02b03d70623a72b8a939b

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.275-1=
28-g1ae5be41556b/arm/multi_v7_defconfig/gcc-8/lab-cip/baseline-qemu_arm-vir=
t-gicv3.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.275-1=
28-g1ae5be41556b/arm/multi_v7_defconfig/gcc-8/lab-cip/baseline-qemu_arm-vir=
t-gicv3.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60f02b03d70623a72b8a9=
39c
        failing since 243 days (last pass: v4.4.243-18-gfc7e8c68369a, first=
 fail: v4.4.243-19-g71b6c961c7fe) =

 =



platform            | arch | lab             | compiler | defconfig        =
   | regressions
--------------------+------+-----------------+----------+------------------=
---+------------
qemu_arm-virt-gicv3 | arm  | lab-collabora   | gcc-8    | multi_v7_defconfi=
g  | 1          =


  Details:     https://kernelci.org/test/plan/id/60f02c3c00ceff6e3c8a93a0

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.275-1=
28-g1ae5be41556b/arm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-qemu_a=
rm-virt-gicv3.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.275-1=
28-g1ae5be41556b/arm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-qemu_a=
rm-virt-gicv3.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60f02c3c00ceff6e3c8a9=
3a1
        failing since 243 days (last pass: v4.4.243-18-gfc7e8c68369a, first=
 fail: v4.4.243-19-g71b6c961c7fe) =

 =



platform            | arch | lab             | compiler | defconfig        =
   | regressions
--------------------+------+-----------------+----------+------------------=
---+------------
qemu_arm-virt-gicv3 | arm  | lab-linaro-lkft | gcc-8    | multi_v7_defconfi=
g  | 1          =


  Details:     https://kernelci.org/test/plan/id/60f02af1c06193736a8a93c3

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.275-1=
28-g1ae5be41556b/arm/multi_v7_defconfig/gcc-8/lab-linaro-lkft/baseline-qemu=
_arm-virt-gicv3.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.275-1=
28-g1ae5be41556b/arm/multi_v7_defconfig/gcc-8/lab-linaro-lkft/baseline-qemu=
_arm-virt-gicv3.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60f02af1c06193736a8a9=
3c4
        failing since 243 days (last pass: v4.4.243-18-gfc7e8c68369a, first=
 fail: v4.4.243-19-g71b6c961c7fe) =

 =20
