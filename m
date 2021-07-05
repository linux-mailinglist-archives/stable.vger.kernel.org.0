Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3562F3BC22D
	for <lists+stable@lfdr.de>; Mon,  5 Jul 2021 19:17:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229713AbhGERUd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 5 Jul 2021 13:20:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34070 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229686AbhGERUc (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 5 Jul 2021 13:20:32 -0400
Received: from mail-pf1-x431.google.com (mail-pf1-x431.google.com [IPv6:2607:f8b0:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C6CC9C061574
        for <stable@vger.kernel.org>; Mon,  5 Jul 2021 10:17:55 -0700 (PDT)
Received: by mail-pf1-x431.google.com with SMTP id b12so16064212pfv.6
        for <stable@vger.kernel.org>; Mon, 05 Jul 2021 10:17:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=6icTBnC/qy1kML/pAV3y/cY0741X5meCHNPaXW2cVJg=;
        b=qh7lHUzTaSsvMV2k9915XCW8QWBvd652THK6KfrDEq0O0blK4x6aXx6pEqldrZyiwT
         awA5YlKALanBRt0TiwesqZIdABlwl4aBBLG3CnuHEjeGf7WVK5LPk/KsvmwvlmkvWCbz
         h9F/xyYsxdlrrHHpwSwipJAM8jKoY0W0U5kZaX+tQR9DTWKD7aO4I7m5n5tG+2SVDfCz
         NzNELwfoliDnA2XD10zEH9aKXfGmajZu7b4+X4U2OZ6kelF/Z9aSH34uXUX/4gHLkefb
         D2IAkEpITy4jnv7j0JyaSIM8YZK4SdVOXcuqBNAWdWqo610csUNjkorCUMA3/hW6W6yX
         xk3w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=6icTBnC/qy1kML/pAV3y/cY0741X5meCHNPaXW2cVJg=;
        b=Hci9zlbDwrzoMBlNuByjZCou9JeFpfcO6EB4JCHlHcMAJjTrU7PqWoXx7byvd/iPyC
         RyZVkZxnCJJRhGloOYcboY7JG1qbaiJTep9r6DLqRJu5B8AljK10WmB4C0aun4Mxenuq
         n0y2ICpCQTb/vZHz3nCcYP5l96Ht5lEqm/HoB++hjy+rPjncndetN6zuWUw9EP/V/mEn
         XEYM0bzWSk3dso2KmThbKaYXO5cRg60rIn/oOwsRaWEt0Cks5EQakZUUtQbbmzYIxX6Z
         2l73IDpVb74hAJBABbAQhj4kmXZ3MS8L4mPiN+2ij0BM8+ONo+O782Ov+3mNrIDnL1kD
         z5Gg==
X-Gm-Message-State: AOAM5300oSdqVmkGNY9LsvT5mWb2O9CLN/bbD52Dw/PsPJlHnhQstiS6
        01kSYwPf8/xbOUVQ9Z1r+DjdI5jTZ7t2fqpU
X-Google-Smtp-Source: ABdhPJysUcOB+DmJvnT6gEEI6ZLSM2asOpA3kpnSOL/tvl2DqJ4TNh48TQ5ne0csKfDZH69hFNuuew==
X-Received: by 2002:a05:6a00:1508:b029:30a:2b2:b2ea with SMTP id q8-20020a056a001508b029030a02b2b2eamr16303774pfu.30.1625505475161;
        Mon, 05 Jul 2021 10:17:55 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id u23sm16164895pgk.38.2021.07.05.10.17.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 05 Jul 2021 10:17:54 -0700 (PDT)
Message-ID: <60e33ec2.1c69fb81.50107.f77a@mx.google.com>
Date:   Mon, 05 Jul 2021 10:17:54 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v5.4.129-6-g730ab99d05cb
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-5.4.y
Subject: stable-rc/linux-5.4.y baseline: 123 runs,
 8 regressions (v5.4.129-6-g730ab99d05cb)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-5.4.y baseline: 123 runs, 8 regressions (v5.4.129-6-g730ab9=
9d05cb)

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

qemu_arm-versatilepb | arm   | lab-cip       | gcc-8    | versatile_defconf=
ig | 1          =

qemu_arm-versatilepb | arm   | lab-collabora | gcc-8    | versatile_defconf=
ig | 1          =

rk3288-veyron-jaq    | arm   | lab-collabora | gcc-8    | multi_v7_defconfi=
g  | 3          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-5.4.y/kern=
el/v5.4.129-6-g730ab99d05cb/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-5.4.y
  Describe: v5.4.129-6-g730ab99d05cb
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      730ab99d05cb6e5857910adb0a22eba8d08ee621 =



Test Regressions
---------------- =



platform             | arch  | lab           | compiler | defconfig        =
   | regressions
---------------------+-------+---------------+----------+------------------=
---+------------
hifive-unleashed-a00 | riscv | lab-baylibre  | gcc-8    | defconfig        =
   | 1          =


  Details:     https://kernelci.org/test/plan/id/60e30760e3462ab5651179b2

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (riscv64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.129=
-6-g730ab99d05cb/riscv/defconfig/gcc-8/lab-baylibre/baseline-hifive-unleash=
ed-a00.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.129=
-6-g730ab99d05cb/riscv/defconfig/gcc-8/lab-baylibre/baseline-hifive-unleash=
ed-a00.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/riscv/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60e30760e3462ab565117=
9b3
        failing since 227 days (last pass: v5.4.77-152-ga3746663c3479, firs=
t fail: v5.4.78) =

 =



platform             | arch  | lab           | compiler | defconfig        =
   | regressions
---------------------+-------+---------------+----------+------------------=
---+------------
qemu_arm-versatilepb | arm   | lab-baylibre  | gcc-8    | versatile_defconf=
ig | 1          =


  Details:     https://kernelci.org/test/plan/id/60e30663a8b32da451117989

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.129=
-6-g730ab99d05cb/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_a=
rm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.129=
-6-g730ab99d05cb/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_a=
rm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60e30663a8b32da451117=
98a
        failing since 232 days (last pass: v5.4.77-44-g28fe0e171c204, first=
 fail: v5.4.77-46-ga3e34830d912) =

 =



platform             | arch  | lab           | compiler | defconfig        =
   | regressions
---------------------+-------+---------------+----------+------------------=
---+------------
qemu_arm-versatilepb | arm   | lab-broonie   | gcc-8    | versatile_defconf=
ig | 1          =


  Details:     https://kernelci.org/test/plan/id/60e30658baf736333611798e

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.129=
-6-g730ab99d05cb/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_ar=
m-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.129=
-6-g730ab99d05cb/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_ar=
m-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60e30658baf7363336117=
98f
        failing since 232 days (last pass: v5.4.77-44-g28fe0e171c204, first=
 fail: v5.4.77-46-ga3e34830d912) =

 =



platform             | arch  | lab           | compiler | defconfig        =
   | regressions
---------------------+-------+---------------+----------+------------------=
---+------------
qemu_arm-versatilepb | arm   | lab-cip       | gcc-8    | versatile_defconf=
ig | 1          =


  Details:     https://kernelci.org/test/plan/id/60e306529c500e730b1179ac

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.129=
-6-g730ab99d05cb/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-ve=
rsatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.129=
-6-g730ab99d05cb/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-ve=
rsatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60e306529c500e730b117=
9ad
        failing since 232 days (last pass: v5.4.77-44-g28fe0e171c204, first=
 fail: v5.4.77-46-ga3e34830d912) =

 =



platform             | arch  | lab           | compiler | defconfig        =
   | regressions
---------------------+-------+---------------+----------+------------------=
---+------------
qemu_arm-versatilepb | arm   | lab-collabora | gcc-8    | versatile_defconf=
ig | 1          =


  Details:     https://kernelci.org/test/plan/id/60e3060f37e56029a411799a

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.129=
-6-g730ab99d05cb/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu_=
arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.129=
-6-g730ab99d05cb/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu_=
arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60e3060f37e56029a4117=
99b
        failing since 232 days (last pass: v5.4.77-44-g28fe0e171c204, first=
 fail: v5.4.77-46-ga3e34830d912) =

 =



platform             | arch  | lab           | compiler | defconfig        =
   | regressions
---------------------+-------+---------------+----------+------------------=
---+------------
rk3288-veyron-jaq    | arm   | lab-collabora | gcc-8    | multi_v7_defconfi=
g  | 3          =


  Details:     https://kernelci.org/test/plan/id/60e3304e08f5a00d36117986

  Results:     67 PASS, 3 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.129=
-6-g730ab99d05cb/arm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-rk3288=
-veyron-jaq.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.129=
-6-g730ab99d05cb/arm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-rk3288=
-veyron-jaq.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.bootrr.rockchip-iodomain-grf-probed: https://kernelci.org/test=
/case/id/60e3304e08f5a00d3611799e
        failing since 20 days (last pass: v5.4.125, first fail: v5.4.125-85=
-g4a2dfe908c1e)

    2021-07-05T16:15:51.303237  /lava-4142588/1/../bin/lava-test-case
    2021-07-05T16:15:51.320361  <8>[   15.104883] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Drockchip-iodomain-grf-probed RESULT=3Dfail>
    2021-07-05T16:15:51.320889  /lava-4142588/1/../bin/lava-test-case   =


  * baseline.bootrr.dwmmc_rockchip-sdio0-probed: https://kernelci.org/test/=
case/id/60e3304e08f5a00d361179b6
        failing since 20 days (last pass: v5.4.125, first fail: v5.4.125-85=
-g4a2dfe908c1e)

    2021-07-05T16:15:49.877940  /lava-4142588/1/../bin/lava-test-case
    2021-07-05T16:15:49.895101  <8>[   13.680146] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Ddwmmc_rockchip-sdio0-probed RESULT=3Dfail>
    2021-07-05T16:15:49.895507  /lava-4142588/1/../bin/lava-test-case   =


  * baseline.bootrr.dwmmc_rockchip-sdmmc-probed: https://kernelci.org/test/=
case/id/60e3304e08f5a00d361179b7
        failing since 20 days (last pass: v5.4.125, first fail: v5.4.125-85=
-g4a2dfe908c1e)

    2021-07-05T16:15:48.857945  /lava-4142588/1/../bin/lava-test-case
    2021-07-05T16:15:48.863191  <8>[   12.660516] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Ddwmmc_rockchip-sdmmc-probed RESULT=3Dfail>   =

 =20
