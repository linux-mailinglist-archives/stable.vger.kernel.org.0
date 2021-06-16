Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 27F123A9EA9
	for <lists+stable@lfdr.de>; Wed, 16 Jun 2021 17:12:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234552AbhFPPOp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 16 Jun 2021 11:14:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35004 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234490AbhFPPOI (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 16 Jun 2021 11:14:08 -0400
Received: from mail-pl1-x62e.google.com (mail-pl1-x62e.google.com [IPv6:2607:f8b0:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E2779C06175F
        for <stable@vger.kernel.org>; Wed, 16 Jun 2021 08:12:00 -0700 (PDT)
Received: by mail-pl1-x62e.google.com with SMTP id x19so1278487pln.2
        for <stable@vger.kernel.org>; Wed, 16 Jun 2021 08:12:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=YnwDBbiPENBUxOLzdWVyPxQjZNy2fVP05WQaUQLAZcY=;
        b=iAku08NcUVGE9mNyteGt1hWAPiwqCSanOFizsejqszYuWz1GiKVaAbjOO3giDjdT0H
         LY9zX2A38DxsLx0H34XAl/WBBn8bX6rqn2JFXC9RlR1ZoUF9Didt1kIEToLf3vaquSiO
         0u5lhkuiEVF4ZEovV/9GE4E7akjLqjEr7eOs45UC5BXtZIZ0XtatUJ0v9Sqbf+z5o70x
         LQwMef65KpzJ5a8Zyj3FffmVi6S/+hBrsAv2HZyIVMssrd+XGx+N516I99pYwcRIjJ1K
         i3hssed2lf0vCsCH9Ba/FZncKkXvh8p+Q90r08T1Y9lfHHWkATBNj0KAR0dRPq/AfjPf
         jRbw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=YnwDBbiPENBUxOLzdWVyPxQjZNy2fVP05WQaUQLAZcY=;
        b=JQONEhQsXsxgOclaI/3e9M3ykq0jjfN4cSkU8u9NhfulxKfTAQEJ92a6gq40z16km2
         /Ow+ok7XLVlQkRnUxwgyhxL7n1iZAYOzljlNGio+kG8ybULxtdqVMK6kSCbWSLP4EQ4/
         ImDUku8CC+PPlTDm7O3Vr2fwVzK71KD6I12NjA4jdKbXzu/mR/74iWtg8rpilMVZK7u5
         QT9PpyAngwTQ7E/ODa1s6cVhJDD00GViyXeLxt9Ty1Saoo1G5MXSkf5xReic09qPq5Mc
         1nLLe3Q469kpXW0zCwBu+Epn2muQu3Cl7DpCmI57oFK0LaR7/p9xX7rkEdLbF67st2M+
         M3FA==
X-Gm-Message-State: AOAM530v90mAbi/RvU9pL+pZ5/kkWBWNCrX6pr9PNMhCnJ3he0yb+Yc4
        NM+93VCkdnXJ45HnFKYcMqLxWTbMY9iz20Tc
X-Google-Smtp-Source: ABdhPJyP+jKqPGT/+Gocp3iz+4eQgLGeUe82B8l7AK2K7czUmXax1vcmr/uaaN7dxbDYg4UQgo9pUg==
X-Received: by 2002:a17:90b:3789:: with SMTP id mz9mr260772pjb.190.1623856320119;
        Wed, 16 Jun 2021 08:12:00 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id x6sm2502118pfd.173.2021.06.16.08.11.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 16 Jun 2021 08:11:59 -0700 (PDT)
Message-ID: <60ca14bf.1c69fb81.234db.6951@mx.google.com>
Date:   Wed, 16 Jun 2021 08:11:59 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v5.4.126
X-Kernelci-Branch: linux-5.4.y
X-Kernelci-Tree: stable
Subject: stable/linux-5.4.y baseline: 150 runs, 9 regressions (v5.4.126)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable/linux-5.4.y baseline: 150 runs, 9 regressions (v5.4.126)

Regressions Summary
-------------------

platform             | arch  | lab           | compiler | defconfig        =
   | regressions
---------------------+-------+---------------+----------+------------------=
---+------------
bcm2837-rpi-3-b      | arm64 | lab-baylibre  | gcc-8    | defconfig        =
   | 1          =

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


  Details:  https://kernelci.org/test/job/stable/branch/linux-5.4.y/kernel/=
v5.4.126/plan/baseline/

  Test:     baseline
  Tree:     stable
  Branch:   linux-5.4.y
  Describe: v5.4.126
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able.git
  SHA:      ffe4d2a0684d4e6aa6ff066b1cd8663a62f2888c =



Test Regressions
---------------- =



platform             | arch  | lab           | compiler | defconfig        =
   | regressions
---------------------+-------+---------------+----------+------------------=
---+------------
bcm2837-rpi-3-b      | arm64 | lab-baylibre  | gcc-8    | defconfig        =
   | 1          =


  Details:     https://kernelci.org/test/plan/id/60c9e305b847077e9b41326d

  Results:     4 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable/linux-5.4.y/v5.4.126/ar=
m64/defconfig/gcc-8/lab-baylibre/baseline-bcm2837-rpi-3-b.txt
  HTML log:    https://storage.kernelci.org//stable/linux-5.4.y/v5.4.126/ar=
m64/defconfig/gcc-8/lab-baylibre/baseline-bcm2837-rpi-3-b.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/arm64/baseline/rootfs.cpio.gz =



  * baseline.dmesg.crit: https://kernelci.org/test/case/id/60c9e305b847077e=
9b413270
        failing since 18 days (last pass: v5.4.121, first fail: v5.4.123)
        1 lines

    2021-06-16T11:39:24.757637  / # [   16.151986] bluetooth hci0: F
    2021-06-16T11:39:24.758264  alling back to sysfs fallback for: brcm/BCM=
43430A1.hcd
    2021-06-16T11:39:24.767759  =

    2021-06-16T11:39:24.870641  / # #
    2021-06-16T11:39:24.879446  #
    2021-06-16T11:39:26.139006  / # export SHELL=3D/bin/sh
    2021-06-16T11:39:26.149480  export SHELL=3D/bin/sh
    2021-06-16T11:39:27.769766  / # . /lava-454489/environment
    2021-06-16T11:39:27.780300  . /lava-454489/environment
    2021-06-16T11:39:30.737115  / # /lava-454489/bin/lava-test-runner /lava=
-454489/0 =

    ... (11 line(s) more)  =

 =



platform             | arch  | lab           | compiler | defconfig        =
   | regressions
---------------------+-------+---------------+----------+------------------=
---+------------
hifive-unleashed-a00 | riscv | lab-baylibre  | gcc-8    | defconfig        =
   | 1          =


  Details:     https://kernelci.org/test/plan/id/60c9e10806aa9820e9413287

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (riscv64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable/linux-5.4.y/v5.4.126/ri=
scv/defconfig/gcc-8/lab-baylibre/baseline-hifive-unleashed-a00.txt
  HTML log:    https://storage.kernelci.org//stable/linux-5.4.y/v5.4.126/ri=
scv/defconfig/gcc-8/lab-baylibre/baseline-hifive-unleashed-a00.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/riscv/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60c9e10806aa9820e9413=
288
        failing since 209 days (last pass: v5.4.77, first fail: v5.4.78) =

 =



platform             | arch  | lab           | compiler | defconfig        =
   | regressions
---------------------+-------+---------------+----------+------------------=
---+------------
qemu_arm-versatilepb | arm   | lab-baylibre  | gcc-8    | versatile_defconf=
ig | 1          =


  Details:     https://kernelci.org/test/plan/id/60c9e0db9373070ad9413296

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable/linux-5.4.y/v5.4.126/ar=
m/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable/linux-5.4.y/v5.4.126/ar=
m/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60c9e0db9373070ad9413=
297
        failing since 209 days (last pass: v5.4.77, first fail: v5.4.78) =

 =



platform             | arch  | lab           | compiler | defconfig        =
   | regressions
---------------------+-------+---------------+----------+------------------=
---+------------
qemu_arm-versatilepb | arm   | lab-broonie   | gcc-8    | versatile_defconf=
ig | 1          =


  Details:     https://kernelci.org/test/plan/id/60c9e1445bdde5e78941327b

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable/linux-5.4.y/v5.4.126/ar=
m/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable/linux-5.4.y/v5.4.126/ar=
m/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60c9e1445bdde5e789413=
27c
        failing since 209 days (last pass: v5.4.77, first fail: v5.4.78) =

 =



platform             | arch  | lab           | compiler | defconfig        =
   | regressions
---------------------+-------+---------------+----------+------------------=
---+------------
qemu_arm-versatilepb | arm   | lab-cip       | gcc-8    | versatile_defconf=
ig | 1          =


  Details:     https://kernelci.org/test/plan/id/60c9e5b8240c9e3fa0413273

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable/linux-5.4.y/v5.4.126/ar=
m/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable/linux-5.4.y/v5.4.126/ar=
m/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60c9e5b8240c9e3fa0413=
274
        failing since 209 days (last pass: v5.4.77, first fail: v5.4.78) =

 =



platform             | arch  | lab           | compiler | defconfig        =
   | regressions
---------------------+-------+---------------+----------+------------------=
---+------------
qemu_arm-versatilepb | arm   | lab-collabora | gcc-8    | versatile_defconf=
ig | 1          =


  Details:     https://kernelci.org/test/plan/id/60c9f23e497da1f9df413276

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable/linux-5.4.y/v5.4.126/ar=
m/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable/linux-5.4.y/v5.4.126/ar=
m/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60c9f23e497da1f9df413=
277
        failing since 209 days (last pass: v5.4.77, first fail: v5.4.78) =

 =



platform             | arch  | lab           | compiler | defconfig        =
   | regressions
---------------------+-------+---------------+----------+------------------=
---+------------
rk3288-veyron-jaq    | arm   | lab-collabora | gcc-8    | multi_v7_defconfi=
g  | 3          =


  Details:     https://kernelci.org/test/plan/id/60ca0f3431aea8629c41327e

  Results:     66 PASS, 3 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable/linux-5.4.y/v5.4.126/ar=
m/multi_v7_defconfig/gcc-8/lab-collabora/baseline-rk3288-veyron-jaq.txt
  HTML log:    https://storage.kernelci.org//stable/linux-5.4.y/v5.4.126/ar=
m/multi_v7_defconfig/gcc-8/lab-collabora/baseline-rk3288-veyron-jaq.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.bootrr.dwmmc_rockchip-sdmmc-probed: https://kernelci.org/test/=
case/id/60ca0f3531aea8629c41329b
        new failure (last pass: v5.4.125)

    2021-06-16T14:48:14.282632  /lava-4036017/1/../bin/lava-test-case
    2021-06-16T14:48:14.288089  <8>[   12.773625] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Ddwmmc_rockchip-sdmmc-probed RESULT=3Dfail>   =


  * baseline.bootrr.dwmmc_rockchip-sdio0-probed: https://kernelci.org/test/=
case/id/60ca0f3531aea8629c41329c
        new failure (last pass: v5.4.125)

    2021-06-16T14:48:15.302719  /lava-4036017/1/../bin/lava-test-case
    2021-06-16T14:48:15.320188  <8>[   13.793361] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Ddwmmc_rockchip-sdio0-probed RESULT=3Dfail>
    2021-06-16T14:48:15.320431  /lava-4036017/1/../bin/lava-test-case   =


  * baseline.bootrr.rockchip-iodomain-grf-probed: https://kernelci.org/test=
/case/id/60ca0f3531aea8629c4132b4
        new failure (last pass: v5.4.125)

    2021-06-16T14:48:16.745761  /lava-4036017/1/../bin/lava-test-case<8>[  =
 15.218440] <LAVA_SIGNAL_TESTCASE TEST_CASE_ID=3Drockchip-iodomain-grf-prob=
ed RESULT=3Dfail>
    2021-06-16T14:48:16.746564  =

    2021-06-16T14:48:16.747152  /lava-4036017/1/../bin/lava-test-case   =

 =20
