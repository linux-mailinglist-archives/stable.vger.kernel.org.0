Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 09FB82ECA4F
	for <lists+stable@lfdr.de>; Thu,  7 Jan 2021 07:05:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725763AbhAGGE5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 7 Jan 2021 01:04:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33946 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725306AbhAGGE4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 7 Jan 2021 01:04:56 -0500
Received: from mail-pj1-x102b.google.com (mail-pj1-x102b.google.com [IPv6:2607:f8b0:4864:20::102b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 90A54C0612F4
        for <stable@vger.kernel.org>; Wed,  6 Jan 2021 22:04:16 -0800 (PST)
Received: by mail-pj1-x102b.google.com with SMTP id v1so874517pjr.2
        for <stable@vger.kernel.org>; Wed, 06 Jan 2021 22:04:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=zt5ZNqjNN3P9OJ0YWBPUmde07KwIF/SJUKb2/GWJXdg=;
        b=tp4M2I3iRuVco61Z/s99k+EjM1+lghFPkMEuVRhdMP07wriGKGh+2tFjSnXpavJyjv
         Pci2einTf0VKQPTu/7zl834N7OO8U01ShcOaWe1KRRFa0Y2rrYSgQx/NPBGgfJMTRgOg
         ni6Y42uFJA4w08KwK4uhnt7+Y+lLRdg1xxxfn3uq5ckV5ZWfIBDcnE2wtzV1ZXR/QYRO
         RlMhRBnTsQU9rZ28DBChr2IDzQSgW9zRB64TwkdrGlJZt8Eq9Mz7ozusgnY2xG1UOrzL
         3WpDp2/UrMa3KHMz/T3S2wbHI/6qbgrwFrOsxITaldx8IE0KaIRZhjR5vbTz8xhPN+oT
         1tPQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=zt5ZNqjNN3P9OJ0YWBPUmde07KwIF/SJUKb2/GWJXdg=;
        b=C+nDWzsyj9SRSOhwdbugFDR+yV5bI/W/hheygQ3rSgT46DcLmin6H52H87XpRAjBJ2
         dDo9dEIprqFBL7+GxZL4ZPE+auSaxhE9OWuelaxG3LD+4piODDn79b85DUMbeEYfMfF5
         +ydQRcCnsImD8uB7b+AiQYflnaU/AYO83cDQGjEzqIF7U0CxuvbIJBIPKQCJRp0Pfq5u
         kOubrtDGIn3Fj2PfY2eH5bKtRMAArnvEyfzMxINqbhqu5QHjmfpM6rexWus4HtCOdvwo
         YR0FPENcSvKIC0RBVHQdHuKmhYIy40mU6rYf1eRL7L/l0OFS+WTBLdT09e+3rHEecv3W
         uIyA==
X-Gm-Message-State: AOAM533O90ledhSJlRRBQPrKyEOCunzRRVMkkZzQd4jyGm41UOxIIpFx
        hMsmmfBBCupuZxsp3uKLrJstq/ntdConeA==
X-Google-Smtp-Source: ABdhPJxzq077oYbY+YqSQBvuGmaWfKqTAZGCNGl0eFZNVb3waTRsPIXGV3tM5ZriTdM6iH3gzXYsmw==
X-Received: by 2002:a17:902:b7c3:b029:da:74c3:427 with SMTP id v3-20020a170902b7c3b02900da74c30427mr7990308plz.38.1609999455629;
        Wed, 06 Jan 2021 22:04:15 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id p22sm4902167pgk.21.2021.01.06.22.04.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 06 Jan 2021 22:04:14 -0800 (PST)
Message-ID: <5ff6a45e.1c69fb81.514f3.c93f@mx.google.com>
Date:   Wed, 06 Jan 2021 22:04:14 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: linux-4.14.y
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v4.14.213
X-Kernelci-Report-Type: test
Subject: stable-rc/linux-4.14.y baseline: 154 runs, 9 regressions (v4.14.213)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.14.y baseline: 154 runs, 9 regressions (v4.14.213)

Regressions Summary
-------------------

platform                   | arch   | lab             | compiler | defconfi=
g           | regressions
---------------------------+--------+-----------------+----------+---------=
------------+------------
fsl-ls2088a-rdb            | arm64  | lab-nxp         | gcc-8    | defconfi=
g           | 1          =

meson-gxl-s905x-khadas-vim | arm64  | lab-baylibre    | gcc-8    | defconfi=
g           | 1          =

panda                      | arm    | lab-collabora   | gcc-8    | omap2plu=
s_defconfig | 1          =

qemu_arm-versatilepb       | arm    | lab-baylibre    | gcc-8    | versatil=
e_defconfig | 1          =

qemu_arm-versatilepb       | arm    | lab-broonie     | gcc-8    | versatil=
e_defconfig | 1          =

qemu_arm-versatilepb       | arm    | lab-cip         | gcc-8    | versatil=
e_defconfig | 1          =

qemu_arm-versatilepb       | arm    | lab-collabora   | gcc-8    | versatil=
e_defconfig | 1          =

qemu_arm-versatilepb       | arm    | lab-linaro-lkft | gcc-8    | versatil=
e_defconfig | 1          =

qemu_x86_64-uefi           | x86_64 | lab-baylibre    | gcc-8    | x86_64_d=
efconfig    | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-4.14.y/ker=
nel/v4.14.213/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-4.14.y
  Describe: v4.14.213
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      1752938529c614a8ed4432ecce6ebc95d3b87207 =



Test Regressions
---------------- =



platform                   | arch   | lab             | compiler | defconfi=
g           | regressions
---------------------------+--------+-----------------+----------+---------=
------------+------------
fsl-ls2088a-rdb            | arm64  | lab-nxp         | gcc-8    | defconfi=
g           | 1          =


  Details:     https://kernelci.org/test/plan/id/5ff671d5897387d704c94ccc

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
13/arm64/defconfig/gcc-8/lab-nxp/baseline-fsl-ls2088a-rdb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
13/arm64/defconfig/gcc-8/lab-nxp/baseline-fsl-ls2088a-rdb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5ff671d5897387d704c94=
ccd
        new failure (last pass: v4.14.213-26-g6be3307e10cb4) =

 =



platform                   | arch   | lab             | compiler | defconfi=
g           | regressions
---------------------------+--------+-----------------+----------+---------=
------------+------------
meson-gxl-s905x-khadas-vim | arm64  | lab-baylibre    | gcc-8    | defconfi=
g           | 1          =


  Details:     https://kernelci.org/test/plan/id/5ff66f9e8680ec09dcc94d6e

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
13/arm64/defconfig/gcc-8/lab-baylibre/baseline-meson-gxl-s905x-khadas-vim.t=
xt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
13/arm64/defconfig/gcc-8/lab-baylibre/baseline-meson-gxl-s905x-khadas-vim.h=
tml
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5ff66f9e8680ec09dcc94=
d6f
        new failure (last pass: v4.14.213-26-g6be3307e10cb4) =

 =



platform                   | arch   | lab             | compiler | defconfi=
g           | regressions
---------------------------+--------+-----------------+----------+---------=
------------+------------
panda                      | arm    | lab-collabora   | gcc-8    | omap2plu=
s_defconfig | 1          =


  Details:     https://kernelci.org/test/plan/id/5ff66ed4bc72e516efc94d00

  Results:     3 PASS, 1 FAIL, 1 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
13/arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-panda.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
13/arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-panda.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/5ff66ed4bc72e51=
6efc94d05
        failing since 35 days (last pass: v4.14.209-51-g07930d77d7ba, first=
 fail: v4.14.210)
        2 lines

    2021-01-07 02:15:43.136000+00:00  kern  :emerg : BUG: spinlock bad magi=
c on CPU#0, udevd/104
    2021-01-07 02:15:43.145000+00:00  kern  :emerg :  lock: emif_lock+0x0/0=
xffffed34 [emif], .magic: dead4ead, .owner: <none>/-1, .owner_cpu: -1
    2021-01-07 02:15:43.165000+00:00  [   20.443786] <LAVA_SIGNAL_TESTCASE =
TEST_CASE_ID=3Demerg RESULT=3Dfail UNITS=3Dlines MEASUREMENT=3D2>
    2021-01-07 02:15:43.165000+00:00  + set +x   =

 =



platform                   | arch   | lab             | compiler | defconfi=
g           | regressions
---------------------------+--------+-----------------+----------+---------=
------------+------------
qemu_arm-versatilepb       | arm    | lab-baylibre    | gcc-8    | versatil=
e_defconfig | 1          =


  Details:     https://kernelci.org/test/plan/id/5ff66c6f23d18756dec94cd1

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
13/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_arm-versatilepb=
.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
13/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_arm-versatilepb=
.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5ff66c6f23d18756dec94=
cd2
        failing since 53 days (last pass: v4.14.206-21-gf1262f26e4d0, first=
 fail: v4.14.206-23-g520c3568920c8) =

 =



platform                   | arch   | lab             | compiler | defconfi=
g           | regressions
---------------------------+--------+-----------------+----------+---------=
------------+------------
qemu_arm-versatilepb       | arm    | lab-broonie     | gcc-8    | versatil=
e_defconfig | 1          =


  Details:     https://kernelci.org/test/plan/id/5ff66c3460574384cdc94cce

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
13/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_arm-versatilepb.=
txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
13/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_arm-versatilepb.=
html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5ff66c3460574384cdc94=
ccf
        failing since 53 days (last pass: v4.14.206-21-gf1262f26e4d0, first=
 fail: v4.14.206-23-g520c3568920c8) =

 =



platform                   | arch   | lab             | compiler | defconfi=
g           | regressions
---------------------------+--------+-----------------+----------+---------=
------------+------------
qemu_arm-versatilepb       | arm    | lab-cip         | gcc-8    | versatil=
e_defconfig | 1          =


  Details:     https://kernelci.org/test/plan/id/5ff66c306926f14daac94cd8

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
13/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
13/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5ff66c306926f14daac94=
cd9
        failing since 53 days (last pass: v4.14.206-21-gf1262f26e4d0, first=
 fail: v4.14.206-23-g520c3568920c8) =

 =



platform                   | arch   | lab             | compiler | defconfi=
g           | regressions
---------------------------+--------+-----------------+----------+---------=
------------+------------
qemu_arm-versatilepb       | arm    | lab-collabora   | gcc-8    | versatil=
e_defconfig | 1          =


  Details:     https://kernelci.org/test/plan/id/5ff66beab5aa6a5a31c94cd6

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
13/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu_arm-versatilep=
b.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
13/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu_arm-versatilep=
b.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5ff66beab5aa6a5a31c94=
cd7
        failing since 53 days (last pass: v4.14.206-21-gf1262f26e4d0, first=
 fail: v4.14.206-23-g520c3568920c8) =

 =



platform                   | arch   | lab             | compiler | defconfi=
g           | regressions
---------------------------+--------+-----------------+----------+---------=
------------+------------
qemu_arm-versatilepb       | arm    | lab-linaro-lkft | gcc-8    | versatil=
e_defconfig | 1          =


  Details:     https://kernelci.org/test/plan/id/5ff66bf4a32b69d1edc94cbe

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
13/arm/versatile_defconfig/gcc-8/lab-linaro-lkft/baseline-qemu_arm-versatil=
epb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
13/arm/versatile_defconfig/gcc-8/lab-linaro-lkft/baseline-qemu_arm-versatil=
epb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5ff66bf4a32b69d1edc94=
cbf
        failing since 53 days (last pass: v4.14.206-21-gf1262f26e4d0, first=
 fail: v4.14.206-23-g520c3568920c8) =

 =



platform                   | arch   | lab             | compiler | defconfi=
g           | regressions
---------------------------+--------+-----------------+----------+---------=
------------+------------
qemu_x86_64-uefi           | x86_64 | lab-baylibre    | gcc-8    | x86_64_d=
efconfig    | 1          =


  Details:     https://kernelci.org/test/plan/id/5ff66d2f64b61963ccc94cba

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig
  Compiler:    gcc-8 (gcc (Debian 8.3.0-6) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
13/x86_64/x86_64_defconfig/gcc-8/lab-baylibre/baseline-qemu_x86_64-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
13/x86_64/x86_64_defconfig/gcc-8/lab-baylibre/baseline-qemu_x86_64-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/x86/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5ff66d2f64b61963ccc94=
cbb
        new failure (last pass: v4.14.213-26-g6be3307e10cb4) =

 =20
