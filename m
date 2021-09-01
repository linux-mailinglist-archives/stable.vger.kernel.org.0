Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3195B3FE612
	for <lists+stable@lfdr.de>; Thu,  2 Sep 2021 02:33:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344915AbhIAXZ5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 1 Sep 2021 19:25:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41570 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344846AbhIAXZ5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 1 Sep 2021 19:25:57 -0400
Received: from mail-pg1-x535.google.com (mail-pg1-x535.google.com [IPv6:2607:f8b0:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B536FC061575
        for <stable@vger.kernel.org>; Wed,  1 Sep 2021 16:24:59 -0700 (PDT)
Received: by mail-pg1-x535.google.com with SMTP id n18so1068581pgm.12
        for <stable@vger.kernel.org>; Wed, 01 Sep 2021 16:24:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=bKkUtPU+eJnlwR1gVVWKW+xrGJbuB5ge3fAoy66R9K4=;
        b=qVyju7h16yVBx/DsihvIiXa8JWL7WuLJYsveH58OnoqfiBtTF8lBLClND6pZiIrMd1
         qHFrLCirqfZbVn4yXB6J4I1qhwrrP5IW0vY1T6tMHK3FOXmvmLWZTkWa9YJ/8uixVJhl
         G96DztOap39oXL4krT0qRxPyzD4Lkw/RLd9zPmRIgILStSLMHHx3dpH7zGtQH/timvHw
         Y7rFRP1KRQAG14UeFTncO0PN63gkchAFA6skqeGf+z3J3wX12tMJaYIv9bbNA1FUeiee
         NnRdJ2xQ71nrJcQrwrwsat/957IOaDvp6qCTqGSzM/CK6fCTrFrIzuvk4+PHcxlG9fbr
         5WyQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=bKkUtPU+eJnlwR1gVVWKW+xrGJbuB5ge3fAoy66R9K4=;
        b=A1JYmQ8tBONE3YxYZNhVeMmiPCbLnoAXMfLJIPNX9RUvyPN0fojvQRLdbde3f/dAo+
         5Z/+rcvxqSEQYUzKLpAmsgu5UidRV9jr/QAZ7fhfwQIJCo+aSX016Vw9BntE8QPZFnJS
         kaqVQB3AYFTIsfhqrv94e0GJZBcltTmhP/Gl4O656KAGwbjgRC4jtCxC7Omb1I4kM/ig
         2KnNj+Gs3evEQanl3H3iJl4tuAGCabFOO2dh6JNdz7qVNNlSP8KIhGqaCNH9gOj6Q4uG
         jlILqbAGP6p6LAyaIXDjc5av+mLrMp4Mgh968fAA5gEqiCS70i29pbcFW+Q2NQI2ZoGT
         ghCg==
X-Gm-Message-State: AOAM533IEujK9InDXN7FEA6HbsoZhwCzPyFMlnEM0LVUNlVDcJclNE6G
        kWefJYgsjsUezpqD3yETlu4u/+BJKXYZSp+eJ6E=
X-Google-Smtp-Source: ABdhPJwz+gMIAAai8zWMf1G5Y/FGKIhTorOzaXjmZ8w1reposeQU3SuvbQve/22aFyoYPagp+Z9N1w==
X-Received: by 2002:a63:3482:: with SMTP id b124mr188401pga.22.1630538698855;
        Wed, 01 Sep 2021 16:24:58 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id b17sm16499pgl.61.2021.09.01.16.24.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 01 Sep 2021 16:24:58 -0700 (PDT)
Message-ID: <61300bca.1c69fb81.8ba0.012f@mx.google.com>
Date:   Wed, 01 Sep 2021 16:24:58 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v4.19.205-33-gfc9ff1c6b4ff
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/4.19
Subject: stable-rc/queue/4.19 baseline: 170 runs,
 7 regressions (v4.19.205-33-gfc9ff1c6b4ff)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.19 baseline: 170 runs, 7 regressions (v4.19.205-33-gfc9ff=
1c6b4ff)

Regressions Summary
-------------------

platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-baylibre  | gcc-8    | versatile_defconfi=
g | 1          =

qemu_arm-versatilepb | arm  | lab-broonie   | gcc-8    | versatile_defconfi=
g | 1          =

qemu_arm-versatilepb | arm  | lab-cip       | gcc-8    | versatile_defconfi=
g | 1          =

qemu_arm-versatilepb | arm  | lab-collabora | gcc-8    | versatile_defconfi=
g | 1          =

rk3288-veyron-jaq    | arm  | lab-collabora | gcc-8    | multi_v7_defconfig=
  | 3          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.19/ker=
nel/v4.19.205-33-gfc9ff1c6b4ff/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.19
  Describe: v4.19.205-33-gfc9ff1c6b4ff
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      fc9ff1c6b4fff0d0e5435c1b60aae8c4e5957828 =



Test Regressions
---------------- =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-baylibre  | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/612fd829bec427ff9bd59669

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.205=
-33-gfc9ff1c6b4ff/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_=
arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.205=
-33-gfc9ff1c6b4ff/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_=
arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/612fd829bec427ff9bd59=
66a
        failing since 291 days (last pass: v4.19.157-26-gd59f3161b3a0, firs=
t fail: v4.19.157-27-g5543cc2c41d55) =

 =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-broonie   | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/612fe76023aa67f1c4d59693

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.205=
-33-gfc9ff1c6b4ff/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_a=
rm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.205=
-33-gfc9ff1c6b4ff/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_a=
rm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/612fe76023aa67f1c4d59=
694
        failing since 291 days (last pass: v4.19.157-26-gd59f3161b3a0, firs=
t fail: v4.19.157-27-g5543cc2c41d55) =

 =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-cip       | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/612fd562ec14d1041bd5969e

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.205=
-33-gfc9ff1c6b4ff/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-v=
ersatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.205=
-33-gfc9ff1c6b4ff/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-v=
ersatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/612fd562ec14d1041bd59=
69f
        failing since 291 days (last pass: v4.19.157-26-gd59f3161b3a0, firs=
t fail: v4.19.157-27-g5543cc2c41d55) =

 =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-collabora | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/612fd53d3af2307cd0d5968c

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.205=
-33-gfc9ff1c6b4ff/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu=
_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.205=
-33-gfc9ff1c6b4ff/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu=
_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/612fd53d3af2307cd0d59=
68d
        failing since 291 days (last pass: v4.19.157-26-gd59f3161b3a0, firs=
t fail: v4.19.157-27-g5543cc2c41d55) =

 =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
rk3288-veyron-jaq    | arm  | lab-collabora | gcc-8    | multi_v7_defconfig=
  | 3          =


  Details:     https://kernelci.org/test/plan/id/61300451cf62fc02cfd59669

  Results:     64 PASS, 6 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.205=
-33-gfc9ff1c6b4ff/arm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-rk328=
8-veyron-jaq.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.205=
-33-gfc9ff1c6b4ff/arm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-rk328=
8-veyron-jaq.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.bootrr.rockchip-iodomain-grf-probed: https://kernelci.org/test=
/case/id/61300451cf62fc02cfd5967d
        failing since 78 days (last pass: v4.19.194-28-g6098ecdead2c, first=
 fail: v4.19.194-67-g1b5dea188d94)

    2021-09-01T22:52:16.369361  /lava-4431124/1/../bin/lava-test-case
    2021-09-01T22:52:16.385990  <8>[   18.614446] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Drockchip-iodomain-grf-probed RESULT=3Dfail>   =


  * baseline.bootrr.dwmmc_rockchip-sdio0-probed: https://kernelci.org/test/=
case/id/61300451cf62fc02cfd59696
        failing since 78 days (last pass: v4.19.194-28-g6098ecdead2c, first=
 fail: v4.19.194-67-g1b5dea188d94)

    2021-09-01T22:52:13.945232  /lava-4431124/1/../bin/lava-test-case<8>[  =
 16.172358] <LAVA_SIGNAL_TESTCASE TEST_CASE_ID=3Ddwmmc_rockchip-sdio0-probe=
d RESULT=3Dfail>
    2021-09-01T22:52:13.945567  =

    2021-09-01T22:52:13.945762  /lava-4431124/1/../bin/lava-test-case   =


  * baseline.bootrr.dwmmc_rockchip-sdmmc-probed: https://kernelci.org/test/=
case/id/61300451cf62fc02cfd59697
        failing since 78 days (last pass: v4.19.194-28-g6098ecdead2c, first=
 fail: v4.19.194-67-g1b5dea188d94)

    2021-09-01T22:52:12.908368  /lava-4431124/1/../bin/lava-test-case
    2021-09-01T22:52:12.913761  <8>[   15.152814] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Ddwmmc_rockchip-sdmmc-probed RESULT=3Dfail>   =

 =20
