Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5BDE03E8340
	for <lists+stable@lfdr.de>; Tue, 10 Aug 2021 20:50:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230295AbhHJSvH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Aug 2021 14:51:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40566 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229774AbhHJSvH (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 10 Aug 2021 14:51:07 -0400
Received: from mail-pl1-x633.google.com (mail-pl1-x633.google.com [IPv6:2607:f8b0:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B24F9C0613C1
        for <stable@vger.kernel.org>; Tue, 10 Aug 2021 11:50:44 -0700 (PDT)
Received: by mail-pl1-x633.google.com with SMTP id u16so22512663ple.2
        for <stable@vger.kernel.org>; Tue, 10 Aug 2021 11:50:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=zu9fe1SudBhsGlKSY+sHTH2be9nKSWDtHVz8AqiZp4I=;
        b=pPorrYfMj0Uxhl6stV14dl4Bnwe6qN6uBBjc8zsfY4hdGYWxiSTw6S5UWFqrnxOZa4
         3okDsFivSNTtzwgqQwM2WmtLk0/Uisgq0EsU6RuZMu86yVQGtDsPp3rd5v8xi2riqapa
         FMZMzsjQakRsbhZge3ny1rDmDUszzxBnn5SnCTdypGa6dBK/F6MGt/WgSCrrXTm8cP92
         izNAuSzQcH3u4RtZEZifpTgK0Dhg62tHODv4rlYmQaOY9itaUY3RNuw9VI0iJ9r3awoZ
         syuqSYjceoz4wuJzdHMfkj6/Q7Vy7lW687rt/9vAMAMv62O3H+5B/TlvFmYr/MJoJ7j3
         6eBA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=zu9fe1SudBhsGlKSY+sHTH2be9nKSWDtHVz8AqiZp4I=;
        b=NaPMnpDUu+QudYDQQ1bxO5AKOQ46VkcNtJVpVXZ0T+/698lC1py2bjYc8Rq+8SM4Wz
         6kHDPCTy2sLHHKXR+DApwdIQtV8e0NnC/Wpm9ILy8ooHd8+M1FgCosqJKSapRr+c2YzO
         J0qRaN7d7JExreRFssCGyjEcNmhTS7Mtfo0bPbzDXg+92l0wJQb0aye8v7YDMRnBrQdM
         etCY56iPzd+bAmX3NRk2delXN38V06K/54HybLVCv7Xxoyw1EHycgjGFrN39GSVUZzyA
         ZgxWO+NVwlLZOpXVeTC0gsqSU+h1SYmDX+bOa0NX2a/6V/vvJnQSSAkOs2emVFa0tinF
         0TPw==
X-Gm-Message-State: AOAM5324iPxaRhvL03jsxhwUJDaBIbleHVdUbc7lORIjbWKGjL71sDd4
        QRoIrXa6l7jxaqrr/uqRfJYig0CVhbDyeNIW
X-Google-Smtp-Source: ABdhPJx/0cuECVQg1b3Z0aeA5GH4s+6NfAAdvZGKq8Emx81YaGOEIMtXhjNISAXf+192+8R7LzGHbQ==
X-Received: by 2002:a05:6a00:238e:b029:35c:c5e:b82d with SMTP id f14-20020a056a00238eb029035c0c5eb82dmr30552515pfc.33.1628621443699;
        Tue, 10 Aug 2021 11:50:43 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id l126sm28910795pgl.14.2021.08.10.11.50.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 10 Aug 2021 11:50:43 -0700 (PDT)
Message-ID: <6112ca83.1c69fb81.aa818.40f3@mx.google.com>
Date:   Tue, 10 Aug 2021 11:50:43 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: queue/4.19
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v4.19.202-54-g6afcc9fd22c9
X-Kernelci-Report-Type: test
Subject: stable-rc/queue/4.19 baseline: 157 runs,
 7 regressions (v4.19.202-54-g6afcc9fd22c9)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.19 baseline: 157 runs, 7 regressions (v4.19.202-54-g6afcc=
9fd22c9)

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

qemu_arm-versatilepb | arm  | lab-collabora   | gcc-8    | versatile_defcon=
fig | 1          =

qemu_arm-versatilepb | arm  | lab-linaro-lkft | gcc-8    | versatile_defcon=
fig | 1          =

rk3288-veyron-jaq    | arm  | lab-collabora   | gcc-8    | multi_v7_defconf=
ig  | 3          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.19/ker=
nel/v4.19.202-54-g6afcc9fd22c9/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.19
  Describe: v4.19.202-54-g6afcc9fd22c9
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      6afcc9fd22c9ece265fe813d49add48ea76223dd =



Test Regressions
---------------- =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-baylibre    | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/6112915f48440f4cd2b1366e

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.202=
-54-g6afcc9fd22c9/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_=
arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.202=
-54-g6afcc9fd22c9/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_=
arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6112915f48440f4cd2b13=
66f
        failing since 269 days (last pass: v4.19.157-26-gd59f3161b3a0, firs=
t fail: v4.19.157-27-g5543cc2c41d55) =

 =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-broonie     | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/6112931639f5644742b13685

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.202=
-54-g6afcc9fd22c9/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_a=
rm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.202=
-54-g6afcc9fd22c9/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_a=
rm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6112931639f5644742b13=
686
        failing since 269 days (last pass: v4.19.157-26-gd59f3161b3a0, firs=
t fail: v4.19.157-27-g5543cc2c41d55) =

 =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-collabora   | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/6112913e86f1015701b1366f

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.202=
-54-g6afcc9fd22c9/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu=
_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.202=
-54-g6afcc9fd22c9/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu=
_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6112913e86f1015701b13=
670
        failing since 269 days (last pass: v4.19.157-26-gd59f3161b3a0, firs=
t fail: v4.19.157-27-g5543cc2c41d55) =

 =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-linaro-lkft | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/6112a695fdd2ece1acb13691

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.202=
-54-g6afcc9fd22c9/arm/versatile_defconfig/gcc-8/lab-linaro-lkft/baseline-qe=
mu_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.202=
-54-g6afcc9fd22c9/arm/versatile_defconfig/gcc-8/lab-linaro-lkft/baseline-qe=
mu_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6112a695fdd2ece1acb13=
692
        failing since 269 days (last pass: v4.19.157-26-gd59f3161b3a0, firs=
t fail: v4.19.157-27-g5543cc2c41d55) =

 =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
rk3288-veyron-jaq    | arm  | lab-collabora   | gcc-8    | multi_v7_defconf=
ig  | 3          =


  Details:     https://kernelci.org/test/plan/id/611293eef8b4a8f821b13681

  Results:     64 PASS, 6 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.202=
-54-g6afcc9fd22c9/arm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-rk328=
8-veyron-jaq.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.202=
-54-g6afcc9fd22c9/arm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-rk328=
8-veyron-jaq.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.bootrr.rockchip-iodomain-grf-probed: https://kernelci.org/test=
/case/id/611293eef8b4a8f821b13699
        failing since 56 days (last pass: v4.19.194-28-g6098ecdead2c, first=
 fail: v4.19.194-67-g1b5dea188d94)

    2021-08-10T14:57:25.235777  /lava-4342491/1/../bin/lava-test-case
    2021-08-10T14:57:25.252711  <8>[   17.256709] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Drockchip-iodomain-grf-probed RESULT=3Dfail>   =


  * baseline.bootrr.dwmmc_rockchip-sdio0-probed: https://kernelci.org/test/=
case/id/611293eef8b4a8f821b136b2
        failing since 56 days (last pass: v4.19.194-28-g6098ecdead2c, first=
 fail: v4.19.194-67-g1b5dea188d94)

    2021-08-10T14:57:22.795084  /lava-4342491/1/../bin/lava-test-case
    2021-08-10T14:57:22.813210  <8>[   14.815984] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Ddwmmc_rockchip-sdio0-probed RESULT=3Dfail>
    2021-08-10T14:57:22.813694  /lava-4342491/1/../bin/lava-test-case   =


  * baseline.bootrr.dwmmc_rockchip-sdmmc-probed: https://kernelci.org/test/=
case/id/611293eef8b4a8f821b136b3
        failing since 56 days (last pass: v4.19.194-28-g6098ecdead2c, first=
 fail: v4.19.194-67-g1b5dea188d94)

    2021-08-10T14:57:21.775694  /lava-4342491/1/../bin/lava-test-case
    2021-08-10T14:57:21.781923  <8>[   13.796585] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Ddwmmc_rockchip-sdmmc-probed RESULT=3Dfail>   =

 =20
