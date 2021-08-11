Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 37BEC3E88C7
	for <lists+stable@lfdr.de>; Wed, 11 Aug 2021 05:22:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232994AbhHKDWf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Aug 2021 23:22:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43962 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232498AbhHKDWf (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 10 Aug 2021 23:22:35 -0400
Received: from mail-pl1-x633.google.com (mail-pl1-x633.google.com [IPv6:2607:f8b0:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6ED6EC061765
        for <stable@vger.kernel.org>; Tue, 10 Aug 2021 20:22:12 -0700 (PDT)
Received: by mail-pl1-x633.google.com with SMTP id q2so823227plr.11
        for <stable@vger.kernel.org>; Tue, 10 Aug 2021 20:22:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=JqRYOwUc0W+J3hzz119FhGUr0+BPy6C59OvBfJ6LSFQ=;
        b=1T1BRjtzjuHYO0Ikho5bKjMEuc7Zm5jwGP0MTQWBOGZvCtC5x/DjNUIqSMneORjahw
         nqvx8p0PulpcBLaj89aGe7RrnB6L6XbqRoJ+bFnBlmhfz6XgUMx8XN4auo6zREXaPbrt
         2Brn1ozayRHb+f5R/SI3a1e5qKLdX2UPrBkdeqxh24F6dtVA2EEZnArH6hL6fjH7czqy
         ICjApqWzcrZDbtILfyCFqcFGimAn+++QEYtFDjqq9mv3MVg8A0NKBt8bKl7J232UJsyK
         xFB9pw6GZNPjV4nC4WyPC2q56dcYTzWQkccxemj9Jj0c7FiWd4ji98nPQtJfxLeenhJh
         QJNg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=JqRYOwUc0W+J3hzz119FhGUr0+BPy6C59OvBfJ6LSFQ=;
        b=EBO4xm6Zufs/LnzOZ/gYzQl2pwW/ZzVdK6/gFZDbJEtibBOaOp9ktyxtPptFgOfSNk
         n1LEiE5aFLCuqLskkSQSinSOIiCqK9zuTSmoPMnsnE+wdmPGaDWdFiL1dYhypeFYkK8F
         qpnx8yMOgDDPvoYR9mxg3v5QxZKJq/gaxSxjDhQWrl2qWrHKjUsThoio9X45RxFehEpu
         PM8Itp/GHPUa+K7l2R1TItp/i8/Zh9QreHzNUtEaz8OagrgGRw1m0V6AqN0VoMje1ClN
         b4EYeyifMoz1KxcCRu1lpleZMFQlt7qLEybgtiuRRmkh70dSWx7tuy/wFliLydRSW4iG
         XVOQ==
X-Gm-Message-State: AOAM533FDhCWY7oFPUm0/E5yZnc9aYKVTVU0R2AhLTh72ty9e8h39k+h
        QPHuYWN8lB5wGmyAg/RWHqv7cyWwPWyPIVs2
X-Google-Smtp-Source: ABdhPJwQXSsT6dN79J2vGHnpqnDPgNc59XYzT417iJ9Dwxec3NwqWCgMvX2iC8VnstUWOVuAHtWVJA==
X-Received: by 2002:a17:90a:9411:: with SMTP id r17mr34423087pjo.49.1628652131747;
        Tue, 10 Aug 2021 20:22:11 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id b17sm29025191pgl.61.2021.08.10.20.22.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 10 Aug 2021 20:22:11 -0700 (PDT)
Message-ID: <61134263.1c69fb81.62331.6b94@mx.google.com>
Date:   Tue, 10 Aug 2021 20:22:11 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: linux-5.4.y
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v5.4.139-86-gff7bc8590c20
X-Kernelci-Report-Type: test
Subject: stable-rc/linux-5.4.y baseline: 149 runs,
 7 regressions (v5.4.139-86-gff7bc8590c20)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-5.4.y baseline: 149 runs, 7 regressions (v5.4.139-86-gff7bc=
8590c20)

Regressions Summary
-------------------

platform             | arch  | lab           | compiler | defconfig        =
   | regressions
---------------------+-------+---------------+----------+------------------=
---+------------
hifive-unleashed-a00 | riscv | lab-baylibre  | gcc-8    | defconfig        =
   | 1          =

qemu_arm-versatilepb | arm   | lab-baylibre  | gcc-8    | versatile_defconf=
ig | 1          =

qemu_arm-versatilepb | arm   | lab-broonie   | gcc-8    | versatile_defconf=
ig | 1          =

qemu_arm-versatilepb | arm   | lab-collabora | gcc-8    | versatile_defconf=
ig | 1          =

rk3288-veyron-jaq    | arm   | lab-collabora | gcc-8    | multi_v7_defconfi=
g  | 3          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-5.4.y/kern=
el/v5.4.139-86-gff7bc8590c20/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-5.4.y
  Describe: v5.4.139-86-gff7bc8590c20
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      ff7bc8590c20350dd180f3e751354836564c7342 =



Test Regressions
---------------- =



platform             | arch  | lab           | compiler | defconfig        =
   | regressions
---------------------+-------+---------------+----------+------------------=
---+------------
hifive-unleashed-a00 | riscv | lab-baylibre  | gcc-8    | defconfig        =
   | 1          =


  Details:     https://kernelci.org/test/plan/id/611308cab2e0ee9bbeb1367a

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (riscv64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.139=
-86-gff7bc8590c20/riscv/defconfig/gcc-8/lab-baylibre/baseline-hifive-unleas=
hed-a00.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.139=
-86-gff7bc8590c20/riscv/defconfig/gcc-8/lab-baylibre/baseline-hifive-unleas=
hed-a00.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/riscv/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/611308cab2e0ee9bbeb13=
67b
        failing since 263 days (last pass: v5.4.77-152-ga3746663c3479, firs=
t fail: v5.4.78) =

 =



platform             | arch  | lab           | compiler | defconfig        =
   | regressions
---------------------+-------+---------------+----------+------------------=
---+------------
qemu_arm-versatilepb | arm   | lab-baylibre  | gcc-8    | versatile_defconf=
ig | 1          =


  Details:     https://kernelci.org/test/plan/id/61130a4459ae70c841b1368b

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.139=
-86-gff7bc8590c20/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_=
arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.139=
-86-gff7bc8590c20/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_=
arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61130a4459ae70c841b13=
68c
        failing since 269 days (last pass: v5.4.77-44-g28fe0e171c204, first=
 fail: v5.4.77-46-ga3e34830d912) =

 =



platform             | arch  | lab           | compiler | defconfig        =
   | regressions
---------------------+-------+---------------+----------+------------------=
---+------------
qemu_arm-versatilepb | arm   | lab-broonie   | gcc-8    | versatile_defconf=
ig | 1          =


  Details:     https://kernelci.org/test/plan/id/61130fe3a4047d6613b1367c

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.139=
-86-gff7bc8590c20/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_a=
rm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.139=
-86-gff7bc8590c20/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_a=
rm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61130fe3a4047d6613b13=
67d
        failing since 269 days (last pass: v5.4.77-44-g28fe0e171c204, first=
 fail: v5.4.77-46-ga3e34830d912) =

 =



platform             | arch  | lab           | compiler | defconfig        =
   | regressions
---------------------+-------+---------------+----------+------------------=
---+------------
qemu_arm-versatilepb | arm   | lab-collabora | gcc-8    | versatile_defconf=
ig | 1          =


  Details:     https://kernelci.org/test/plan/id/61130a3826d483a406b1366d

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.139=
-86-gff7bc8590c20/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu=
_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.139=
-86-gff7bc8590c20/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu=
_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61130a3826d483a406b13=
66e
        failing since 269 days (last pass: v5.4.77-44-g28fe0e171c204, first=
 fail: v5.4.77-46-ga3e34830d912) =

 =



platform             | arch  | lab           | compiler | defconfig        =
   | regressions
---------------------+-------+---------------+----------+------------------=
---+------------
rk3288-veyron-jaq    | arm   | lab-collabora | gcc-8    | multi_v7_defconfi=
g  | 3          =


  Details:     https://kernelci.org/test/plan/id/61130f4868fe5d7ae2b136a0

  Results:     67 PASS, 3 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.139=
-86-gff7bc8590c20/arm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-rk328=
8-veyron-jaq.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.139=
-86-gff7bc8590c20/arm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-rk328=
8-veyron-jaq.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.bootrr.dwmmc_rockchip-sdio0-probed: https://kernelci.org/test/=
case/id/61130f4868fe5d7ae2b136cd
        failing since 56 days (last pass: v5.4.125, first fail: v5.4.125-85=
-g4a2dfe908c1e)

    2021-08-10T23:43:57.687249  /lava-4345145/1/../bin/lava-test-case
    2021-08-10T23:43:57.705010  <8>[   14.287731] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Ddwmmc_rockchip-sdio0-probed RESULT=3Dfail>
    2021-08-10T23:43:57.705426  /lava-4345145/1/../bin/lava-test-case   =


  * baseline.bootrr.dwmmc_rockchip-sdmmc-probed: https://kernelci.org/test/=
case/id/61130f4868fe5d7ae2b136ce
        failing since 56 days (last pass: v5.4.125, first fail: v5.4.125-85=
-g4a2dfe908c1e)

    2021-08-10T23:43:56.668144  /lava-4345145/1/../bin/lava-test-case
    2021-08-10T23:43:56.673303  <8>[   13.268069] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Ddwmmc_rockchip-sdmmc-probed RESULT=3Dfail>   =


  * baseline.bootrr.rockchip-iodomain-grf-probed: https://kernelci.org/test=
/case/id/61130f4868fe5d7ae2b136e7
        failing since 56 days (last pass: v5.4.125, first fail: v5.4.125-85=
-g4a2dfe908c1e)

    2021-08-10T23:43:59.112428  /lava-4345145/1/../bin/lava-test-case
    2021-08-10T23:43:59.128826  <8>[   15.712432] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Drockchip-iodomain-grf-probed RESULT=3Dfail>
    2021-08-10T23:43:59.129310  /lava-4345145/1/../bin/lava-test-case   =

 =20
