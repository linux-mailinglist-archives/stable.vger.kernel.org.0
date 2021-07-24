Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 541813D44F1
	for <lists+stable@lfdr.de>; Sat, 24 Jul 2021 06:29:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233852AbhGXDst (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 23 Jul 2021 23:48:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53958 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233812AbhGXDst (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 23 Jul 2021 23:48:49 -0400
Received: from mail-pl1-x62c.google.com (mail-pl1-x62c.google.com [IPv6:2607:f8b0:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8F4B3C061575
        for <stable@vger.kernel.org>; Fri, 23 Jul 2021 21:29:21 -0700 (PDT)
Received: by mail-pl1-x62c.google.com with SMTP id i1so5380781plr.9
        for <stable@vger.kernel.org>; Fri, 23 Jul 2021 21:29:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=v/nDsxfKuPzuYjx7HBgsS1m3YGkzUbl9YsA5lUfD5tU=;
        b=Dzr4sBUQcwv7vh/hN2l62oTMOFJ6MqM8uy9dti1xZNXWfiB/xTIs8kO6ZxE1TbnOpy
         12/HIjkYXiH4uAgeOgoE9MW4qgEq1YExGxDhA6/oPPeUz/+D94ZzOGJHpo/d0QzBB6FE
         IRyKlJoUgOismVHVZLj1J1AVwTkUG9IWFGoSKtbfp9iW/Yg2YzGO7U1TS+DWubkARaiR
         i0Ngg2/ho0aRjW2k7ynX3/6TJMZoVvR0fKjvErrhNve8vdhOQf7CXQSOBTPPb+M1MDIV
         uB/J5zyLo3/jVuhpkbRu+QOQPSOeV/DMNDSlTV2oHTpmA3Yx0/6t6ghTVN52n8jDfYix
         hk0A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=v/nDsxfKuPzuYjx7HBgsS1m3YGkzUbl9YsA5lUfD5tU=;
        b=Vw2xgk+h3i9jd95AsV9Yp48bJqt6+vxT1ro55t/ZfguRNK99qEsbwhw1YoYzgC0rOB
         2rRqwl/jYBCas+5zP6MKpd3w9xswEMQPMvwMvfjcj9a/rrEu2MJKGMh54pVUKE3soV88
         i6oZxzEwE/MANFOb59eHOVbF7mR0vRxjWOi/eFMJbolQ/exZ+ZRCvq+l82dq4zTbR3uf
         PgGJCG+77dAI+e056HB+x8mO/dqt84+qRapnnjSOCQUD2iDm9QObY+PiXkY2sWy5QLAN
         v2qOErTyKTW/hO6qc75wYGXCilRWihSmF0JTULRPji/wn9fXOx/YfxJjBcTNJFOWXQqf
         72Mw==
X-Gm-Message-State: AOAM531f1LUbIK3RiE6nkUFcKD2ItwRGm/f/vYXM8fRTVdSnO7BzzsOv
        UWI6VCL4RAbUYRVCJJyv5ihKzbg2WnsSHsZe
X-Google-Smtp-Source: ABdhPJwIWGay9T0AEODUDSmJfdKA4Gb/RsZEyZQISfwIKxXGjIA2m2BsiWtMk5xL+aQnNuu5Ii6Bqw==
X-Received: by 2002:a63:5a5b:: with SMTP id k27mr7940307pgm.74.1627100960857;
        Fri, 23 Jul 2021 21:29:20 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id b20sm34987895pfl.9.2021.07.23.21.29.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 23 Jul 2021 21:29:20 -0700 (PDT)
Message-ID: <60fb9720.1c69fb81.9beaf.b99b@mx.google.com>
Date:   Fri, 23 Jul 2021 21:29:20 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: queue/4.19
X-Kernelci-Kernel: v4.19.197-473-g00de6b0175fa
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
Subject: stable-rc/queue/4.19 baseline: 136 runs,
 7 regressions (v4.19.197-473-g00de6b0175fa)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.19 baseline: 136 runs, 7 regressions (v4.19.197-473-g00de=
6b0175fa)

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

qemu_arm-versatilepb | arm  | lab-linaro-lkft | gcc-8    | versatile_defcon=
fig | 1          =

rk3288-veyron-jaq    | arm  | lab-collabora   | gcc-8    | multi_v7_defconf=
ig  | 3          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.19/ker=
nel/v4.19.197-473-g00de6b0175fa/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.19
  Describe: v4.19.197-473-g00de6b0175fa
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      00de6b0175fa8a349de5dbd60d69eda9c81effe3 =



Test Regressions
---------------- =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-baylibre    | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/60fb5c492798278a973a2f2d

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.197=
-473-g00de6b0175fa/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu=
_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.197=
-473-g00de6b0175fa/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu=
_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60fb5c492798278a973a2=
f2e
        failing since 252 days (last pass: v4.19.157-26-gd59f3161b3a0, firs=
t fail: v4.19.157-27-g5543cc2c41d55) =

 =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-broonie     | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/60fb5cb968ff1bd5793a2f55

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.197=
-473-g00de6b0175fa/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_=
arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.197=
-473-g00de6b0175fa/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_=
arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60fb5cb968ff1bd5793a2=
f56
        failing since 252 days (last pass: v4.19.157-26-gd59f3161b3a0, firs=
t fail: v4.19.157-27-g5543cc2c41d55) =

 =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-cip         | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/60fb5c3c2798278a973a2f22

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.197=
-473-g00de6b0175fa/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-=
versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.197=
-473-g00de6b0175fa/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-=
versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60fb5c3c2798278a973a2=
f23
        failing since 252 days (last pass: v4.19.157-26-gd59f3161b3a0, firs=
t fail: v4.19.157-27-g5543cc2c41d55) =

 =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-linaro-lkft | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/60fb747cca27d29f263a2f59

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.197=
-473-g00de6b0175fa/arm/versatile_defconfig/gcc-8/lab-linaro-lkft/baseline-q=
emu_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.197=
-473-g00de6b0175fa/arm/versatile_defconfig/gcc-8/lab-linaro-lkft/baseline-q=
emu_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60fb747cca27d29f263a2=
f5a
        failing since 252 days (last pass: v4.19.157-26-gd59f3161b3a0, firs=
t fail: v4.19.157-27-g5543cc2c41d55) =

 =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
rk3288-veyron-jaq    | arm  | lab-collabora   | gcc-8    | multi_v7_defconf=
ig  | 3          =


  Details:     https://kernelci.org/test/plan/id/60fb7dab435c122f3b3a2f69

  Results:     64 PASS, 6 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.197=
-473-g00de6b0175fa/arm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-rk32=
88-veyron-jaq.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.197=
-473-g00de6b0175fa/arm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-rk32=
88-veyron-jaq.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.bootrr.rockchip-iodomain-grf-probed: https://kernelci.org/test=
/case/id/60fb7dab435c122f3b3a2f7d
        failing since 39 days (last pass: v4.19.194-28-g6098ecdead2c, first=
 fail: v4.19.194-67-g1b5dea188d94)

    2021-07-24T02:40:28.290537  /lava-4240222/1/../bin/lava-test-case<8>[  =
 17.215635] <LAVA_SIGNAL_TESTCASE TEST_CASE_ID=3Drockchip-iodomain-grf-prob=
ed RESULT=3Dfail>
    2021-07-24T02:40:28.290865     =


  * baseline.bootrr.dwmmc_rockchip-sdio0-probed: https://kernelci.org/test/=
case/id/60fb7dab435c122f3b3a2f96
        failing since 39 days (last pass: v4.19.194-28-g6098ecdead2c, first=
 fail: v4.19.194-67-g1b5dea188d94)

    2021-07-24T02:40:25.841096  /lava-4240222/1/../bin/lava-test-case
    2021-07-24T02:40:25.858351  <8>[   14.773976] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Ddwmmc_rockchip-sdio0-probed RESULT=3Dfail>
    2021-07-24T02:40:25.858685  /lava-4240222/1/../bin/lava-test-case   =


  * baseline.bootrr.dwmmc_rockchip-sdmmc-probed: https://kernelci.org/test/=
case/id/60fb7dab435c122f3b3a2f97
        failing since 39 days (last pass: v4.19.194-28-g6098ecdead2c, first=
 fail: v4.19.194-67-g1b5dea188d94)

    2021-07-24T02:40:24.820988  /lava-4240222/1/../bin/lava-test-case
    2021-07-24T02:40:24.827076  <8>[   13.754555] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Ddwmmc_rockchip-sdmmc-probed RESULT=3Dfail>   =

 =20
