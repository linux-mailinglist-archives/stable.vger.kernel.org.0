Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 507F13BF1F3
	for <lists+stable@lfdr.de>; Thu,  8 Jul 2021 00:19:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231192AbhGGWVl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 7 Jul 2021 18:21:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32856 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230508AbhGGWVl (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 7 Jul 2021 18:21:41 -0400
Received: from mail-pj1-x102d.google.com (mail-pj1-x102d.google.com [IPv6:2607:f8b0:4864:20::102d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D9EDCC061574
        for <stable@vger.kernel.org>; Wed,  7 Jul 2021 15:18:59 -0700 (PDT)
Received: by mail-pj1-x102d.google.com with SMTP id d9-20020a17090ae289b0290172f971883bso4040761pjz.1
        for <stable@vger.kernel.org>; Wed, 07 Jul 2021 15:18:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=tQPKYgT5fEDtiA/a2+ADg6/N00Pg5lP++D0+QpU5eDU=;
        b=04zUwKsgj4bSGhmyXLJSaCM+mikKHGeVHJ1djkxnYYwLivXsXiIP7JZS2aMuETj3GF
         aIEAOW2V2Hn4i63MkJeHCKSq/woND6JgTaq6Gw4F3cccqa6NDdS7sr1FZHs7H6AR7HV5
         c0/R33keoJ3kZ4AWOwx7S/ekfzVY8SkjUyEkfj613dLyBBr8Bf/IJC4KIr2g0BzPoXL7
         x7w92c14sxOpkBzhdZv1GzxLc+xi+5qp3tP+dglFwJjEfZGxeqicaEyXF54h5gDTjDhJ
         fyuq04VK2jHoDolpNe+s2v9F/tpkg6pbCU8ooK9y87gSvWg6Bqd6A0ON8x0nmHTPYpxw
         teeg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=tQPKYgT5fEDtiA/a2+ADg6/N00Pg5lP++D0+QpU5eDU=;
        b=JWwUNuaHBUwMmWzRGpjXoEclViMx5O9T4OQCDIQEskzYPkuu4c7R2bmfasNcx7BT8i
         Tlr8YbWeDOGr+Sh+1rAFJ634O5PrlylDb2MQ779Wr2xMCa/3kHSAs79fx2qaHZ1ykL4X
         U6/37HYRz3yb28tBnusZcLTCDsJgk0adUenolL6c2IQJ5LeCVWWYJP5riRLQouGthDrh
         qfogQwAEorPwDPSUtETWFXoy4J36NX+RdcDprvIftpx0h9zOg7Ih+tQNeFAXTroK0BNG
         y+DktQx6ZFuJu4ZoTxl9+DFNsJnNUskNvF38IBDvFNuooYMebS0amuCsoMkzTxrOyfQQ
         B78Q==
X-Gm-Message-State: AOAM530/ouZH10jKszrjEO6Lr9bEhX1tGGJpO/r3CcPY/mhbH4Sqf+u5
        obeaRdGQUgYkO3yL7Gdj5teUXDTbggAJ7Rgx
X-Google-Smtp-Source: ABdhPJyiDtCP/6UoMeyLZrkO4O/LoVarTFmtt5b/6n9WjHsfwRocKD8mBij6v5o4Taw7YqPWnGx2cA==
X-Received: by 2002:a17:90a:7e16:: with SMTP id i22mr1316902pjl.12.1625696339096;
        Wed, 07 Jul 2021 15:18:59 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id h18sm208085pgl.87.2021.07.07.15.18.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 07 Jul 2021 15:18:58 -0700 (PDT)
Message-ID: <60e62852.1c69fb81.d2e95.1352@mx.google.com>
Date:   Wed, 07 Jul 2021 15:18:58 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.19.196-24-g9ef9787c97d6
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/4.19
Subject: stable-rc/queue/4.19 baseline: 188 runs,
 8 regressions (v4.19.196-24-g9ef9787c97d6)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.19 baseline: 188 runs, 8 regressions (v4.19.196-24-g9ef97=
87c97d6)

Regressions Summary
-------------------

platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-baylibre    | gcc-8    | versatile_defcon=
fig | 1          =

qemu_arm-versatilepb | arm  | lab-broonie     | gcc-8    | versatile_defcon=
fig | 1          =

qemu_arm-versatilepb | arm  | lab-cip         | gcc-8    | versatile_defcon=
fig | 1          =

qemu_arm-versatilepb | arm  | lab-collabora   | gcc-8    | versatile_defcon=
fig | 1          =

qemu_arm-versatilepb | arm  | lab-linaro-lkft | gcc-8    | versatile_defcon=
fig | 1          =

rk3288-veyron-jaq    | arm  | lab-collabora   | gcc-8    | multi_v7_defconf=
ig  | 3          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.19/ker=
nel/v4.19.196-24-g9ef9787c97d6/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.19
  Describe: v4.19.196-24-g9ef9787c97d6
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      9ef9787c97d6b582dec1d0fa8be153042bf002b0 =



Test Regressions
---------------- =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-baylibre    | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/60e5ec23c6ac3a983b11797e

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.196=
-24-g9ef9787c97d6/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_=
arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.196=
-24-g9ef9787c97d6/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_=
arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60e5ec23c6ac3a983b117=
97f
        failing since 235 days (last pass: v4.19.157-26-gd59f3161b3a0, firs=
t fail: v4.19.157-27-g5543cc2c41d55) =

 =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-broonie     | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/60e5f461f9c70a6e681179b1

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.196=
-24-g9ef9787c97d6/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_a=
rm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.196=
-24-g9ef9787c97d6/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_a=
rm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60e5f461f9c70a6e68117=
9b2
        failing since 235 days (last pass: v4.19.157-26-gd59f3161b3a0, firs=
t fail: v4.19.157-27-g5543cc2c41d55) =

 =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-cip         | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/60e5ec01966b010e3711798f

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.196=
-24-g9ef9787c97d6/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-v=
ersatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.196=
-24-g9ef9787c97d6/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-v=
ersatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60e5ec01966b010e37117=
990
        failing since 235 days (last pass: v4.19.157-26-gd59f3161b3a0, firs=
t fail: v4.19.157-27-g5543cc2c41d55) =

 =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-collabora   | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/60e5eb99debe81e1dc117998

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.196=
-24-g9ef9787c97d6/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu=
_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.196=
-24-g9ef9787c97d6/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu=
_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60e5eb99debe81e1dc117=
999
        failing since 235 days (last pass: v4.19.157-26-gd59f3161b3a0, firs=
t fail: v4.19.157-27-g5543cc2c41d55) =

 =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-linaro-lkft | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/60e5ebadec6c8b1edf11798f

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.196=
-24-g9ef9787c97d6/arm/versatile_defconfig/gcc-8/lab-linaro-lkft/baseline-qe=
mu_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.196=
-24-g9ef9787c97d6/arm/versatile_defconfig/gcc-8/lab-linaro-lkft/baseline-qe=
mu_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60e5ebadec6c8b1edf117=
990
        failing since 235 days (last pass: v4.19.157-26-gd59f3161b3a0, firs=
t fail: v4.19.157-27-g5543cc2c41d55) =

 =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
rk3288-veyron-jaq    | arm  | lab-collabora   | gcc-8    | multi_v7_defconf=
ig  | 3          =


  Details:     https://kernelci.org/test/plan/id/60e5f1f861bfac10cc117989

  Results:     64 PASS, 6 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.196=
-24-g9ef9787c97d6/arm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-rk328=
8-veyron-jaq.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.196=
-24-g9ef9787c97d6/arm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-rk328=
8-veyron-jaq.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.bootrr.rockchip-iodomain-grf-probed: https://kernelci.org/test=
/case/id/60e5f1f861bfac10cc11799d
        failing since 22 days (last pass: v4.19.194-28-g6098ecdead2c, first=
 fail: v4.19.194-67-g1b5dea188d94)

    2021-07-07T18:26:55.787871  /lava-4153641/1/../bin/lava-test-case
    2021-07-07T18:26:55.804275  <8>[   17.579486] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Drockchip-iodomain-grf-probed RESULT=3Dfail>
    2021-07-07T18:26:55.804760  /lava-4153641/1/../bin/lava-test-case   =


  * baseline.bootrr.dwmmc_rockchip-sdio0-probed: https://kernelci.org/test/=
case/id/60e5f1f861bfac10cc1179b4
        failing since 22 days (last pass: v4.19.194-28-g6098ecdead2c, first=
 fail: v4.19.194-67-g1b5dea188d94)

    2021-07-07T18:26:53.364120  /lava-4153641/1/../bin/lava-test-case<8>[  =
 15.136946] <LAVA_SIGNAL_TESTCASE TEST_CASE_ID=3Ddwmmc_rockchip-sdio0-probe=
d RESULT=3Dfail>
    2021-07-07T18:26:53.364631  =

    2021-07-07T18:26:53.365042  /lava-4153641/1/../bin/lava-test-case   =


  * baseline.bootrr.dwmmc_rockchip-sdmmc-probed: https://kernelci.org/test/=
case/id/60e5f1f861bfac10cc1179b5
        failing since 22 days (last pass: v4.19.194-28-g6098ecdead2c, first=
 fail: v4.19.194-67-g1b5dea188d94)

    2021-07-07T18:26:52.326048  /lava-4153641/1/../bin/lava-test-case
    2021-07-07T18:26:52.331140  <8>[   14.117470] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Ddwmmc_rockchip-sdmmc-probed RESULT=3Dfail>   =

 =20
