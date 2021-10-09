Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8D077427DC2
	for <lists+stable@lfdr.de>; Sat,  9 Oct 2021 23:50:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230139AbhJIVv7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 9 Oct 2021 17:51:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43538 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230116AbhJIVv7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 9 Oct 2021 17:51:59 -0400
Received: from mail-pg1-x530.google.com (mail-pg1-x530.google.com [IPv6:2607:f8b0:4864:20::530])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CB523C061570
        for <stable@vger.kernel.org>; Sat,  9 Oct 2021 14:50:01 -0700 (PDT)
Received: by mail-pg1-x530.google.com with SMTP id 133so6871783pgb.1
        for <stable@vger.kernel.org>; Sat, 09 Oct 2021 14:50:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=TnT/qkA9QAWwglcSt472po6AXVoaVoEl4Zg24pysKfY=;
        b=7VxM0yb85YBmtdUb7P8x83P5XHw1+9t7DuPVZqrGHYctfswtFxScalw6oBWByL3myR
         EQphNkJY30jAiqe/IMH1dVEIApc0sxNrrikqaRHoS7lfmmIgAhYDSRv1GDB13BXw5Y1F
         PKirURMlSyaSIRtKeW3pLK1NUU8fTqyZpYVhQeNHIywkfdy+kiS2tWstCPeZ+1xtfSGY
         h0IXTLsHl1cSHYZZOxLzeaqtmV0VcluZnLlXaV3ffRI40M7Rsw6Gs2wBShNvEz2LK+on
         2w361f+bTjuoAuEeiuMw58mzM4PBIuckrYWMlJObugJQeGaMarqPrhX2dDagTggfhswM
         eBzA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=TnT/qkA9QAWwglcSt472po6AXVoaVoEl4Zg24pysKfY=;
        b=0Ix8rjyeVQwox9jnIJDFzgeJis/M5xPKDmHziSdK7/BWDnNWa5qqzI3MI85Uqrrawy
         Mhn47hTHjSBDHktfxVK+DcDmCmaXttmZa8EBUvmVo64BlieaykG/Ci/wFtXjiI2QaUZK
         x13IHkwW2u+cwGdamfERTcvV7RflhInmY39x/ONBILhDozB7aw5Hso6wIAv01lJroxMO
         V2p475RKgrzZp/0L8zrbY8JS/p2yHQazRlh8mqSdAbQ4uM+7b5/hdzEy3dVHh4G8YeXH
         cg0FThpiSrtXafmXTXdu8MuPEmjmaMkpaiHfzbSK8mrgJt6m6n3tWDupH9T3Fbw4VlTx
         09Vg==
X-Gm-Message-State: AOAM531PsL9dyZtOi3gjBpLNcPvVsl6rhWzxaAti8tzcThTQftdegVvU
        oP/JZb6obyD/VMbMvXZ2aE0hUONkCQ0WSoTS
X-Google-Smtp-Source: ABdhPJwgbg7Bwq9G1DXpGBxwEQx+vvVvJ+GUTIwcifqBK9b6brR0OB4iIO2ES+ojIu9KN7gxo3rbYw==
X-Received: by 2002:a63:2b8c:: with SMTP id r134mr11226837pgr.420.1633816200297;
        Sat, 09 Oct 2021 14:50:00 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id q6sm3482758pgc.1.2021.10.09.14.49.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 09 Oct 2021 14:50:00 -0700 (PDT)
Message-ID: <61620e88.1c69fb81.c14cc.a2c9@mx.google.com>
Date:   Sat, 09 Oct 2021 14:50:00 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.19.210
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable
X-Kernelci-Branch: linux-4.19.y
Subject: stable/linux-4.19.y baseline: 150 runs, 7 regressions (v4.19.210)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable/linux-4.19.y baseline: 150 runs, 7 regressions (v4.19.210)

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


  Details:  https://kernelci.org/test/job/stable/branch/linux-4.19.y/kernel=
/v4.19.210/plan/baseline/

  Test:     baseline
  Tree:     stable
  Branch:   linux-4.19.y
  Describe: v4.19.210
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able.git
  SHA:      e34184f53363f6bb873c2fe0ce1a08ed7d16e94a =



Test Regressions
---------------- =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-baylibre  | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/6161d45f6448f2ff4899a321

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable/linux-4.19.y/v4.19.210/=
arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.19.y/v4.19.210/=
arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_arm-versatilepb.ht=
ml
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6161d45f6448f2ff4899a=
322
        failing since 324 days (last pass: v4.19.157, first fail: v4.19.158=
) =

 =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-broonie   | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/6161d6ac30023a8cbb99a2f3

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable/linux-4.19.y/v4.19.210/=
arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.19.y/v4.19.210/=
arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6161d6ac30023a8cbb99a=
2f4
        failing since 324 days (last pass: v4.19.157, first fail: v4.19.158=
) =

 =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-cip       | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/6161d47ce3cd5331a199a31a

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable/linux-4.19.y/v4.19.210/=
arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.19.y/v4.19.210/=
arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6161d47ce3cd5331a199a=
31b
        failing since 324 days (last pass: v4.19.157, first fail: v4.19.158=
) =

 =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-collabora | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/6161d418dee90c00f599a2df

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable/linux-4.19.y/v4.19.210/=
arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu_arm-versatilepb.t=
xt
  HTML log:    https://storage.kernelci.org//stable/linux-4.19.y/v4.19.210/=
arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu_arm-versatilepb.h=
tml
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6161d418dee90c00f599a=
2e0
        failing since 324 days (last pass: v4.19.157, first fail: v4.19.158=
) =

 =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
rk3288-veyron-jaq    | arm  | lab-collabora | gcc-8    | multi_v7_defconfig=
  | 3          =


  Details:     https://kernelci.org/test/plan/id/6161f91686010e8ae199a2e4

  Results:     64 PASS, 6 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable/linux-4.19.y/v4.19.210/=
arm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-rk3288-veyron-jaq.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.19.y/v4.19.210/=
arm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-rk3288-veyron-jaq.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.bootrr.rockchip-iodomain-grf-probed: https://kernelci.org/test=
/case/id/6161f91686010e8ae199a2f4
        failing since 115 days (last pass: v4.19.194, first fail: v4.19.195)

    2021-10-09T20:18:08.075141  /lava-4685911/1/../bin/lava-test-case
    2021-10-09T20:18:08.092432  <8>[   18.192461] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Drockchip-iodomain-grf-probed RESULT=3Dfail>
    2021-10-09T20:18:08.092786  /lava-4685911/1/../bin/lava-test-case   =


  * baseline.bootrr.dwmmc_rockchip-sdio0-probed: https://kernelci.org/test/=
case/id/6161f91686010e8ae199a30d
        failing since 115 days (last pass: v4.19.194, first fail: v4.19.195)

    2021-10-09T20:18:05.650479  /lava-4685911/1/../bin/lava-test-case<8>[  =
 15.751083] <LAVA_SIGNAL_TESTCASE TEST_CASE_ID=3Ddwmmc_rockchip-sdio0-probe=
d RESULT=3Dfail>
    2021-10-09T20:18:05.651020  =

    2021-10-09T20:18:05.651451  /lava-4685911/1/../bin/lava-test-case   =


  * baseline.bootrr.dwmmc_rockchip-sdmmc-probed: https://kernelci.org/test/=
case/id/6161f91686010e8ae199a30e
        failing since 115 days (last pass: v4.19.194, first fail: v4.19.195)

    2021-10-09T20:18:04.613513  /lava-4685911/1/../bin/lava-test-case
    2021-10-09T20:18:04.618743  <8>[   14.731715] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Ddwmmc_rockchip-sdmmc-probed RESULT=3Dfail>   =

 =20
