Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 630EB3DDE30
	for <lists+stable@lfdr.de>; Mon,  2 Aug 2021 19:04:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229593AbhHBREn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 2 Aug 2021 13:04:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60178 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229500AbhHBREn (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 2 Aug 2021 13:04:43 -0400
Received: from mail-pl1-x633.google.com (mail-pl1-x633.google.com [IPv6:2607:f8b0:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 05654C06175F
        for <stable@vger.kernel.org>; Mon,  2 Aug 2021 10:04:34 -0700 (PDT)
Received: by mail-pl1-x633.google.com with SMTP id c16so20352198plh.7
        for <stable@vger.kernel.org>; Mon, 02 Aug 2021 10:04:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=isN8VC4STEvxl2kEJGQUcoa2kyoNIZ0yLKtWSWlm7lY=;
        b=jQ6e6EQLtv/sXX7NnlF984NimhD5s2EJ2Vux4OJ3UQ9IXl/pNYga2xV5UaCCW3iNft
         V62jMfuBxzC+zjVQzzRsbYNzP7VgDk4XqfIqsTOUwM/DVxEcdaBC5L9TbpJ1Mw878h4a
         +gwzFgugM/dXQCjjhd5Rsnx4M1jhfZ0Ms7Vm+dkDUjnBXqaC7kp9pci+sNGRs8goVjB8
         ahDi6VVxmB66fz6os1a4KjtVtvfukSihBbaj2SZOekYknlb9vGFr92Zpcyck+9TpaE39
         0UsxwX7PrYvEPWAD56w43PFoF5uLAON6e5+O/lHGJMix0D4o/s7mbPTQSP0XaoV/dVHm
         Mxdw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=isN8VC4STEvxl2kEJGQUcoa2kyoNIZ0yLKtWSWlm7lY=;
        b=Vvs4dkbuxrudviY7f9js7DJJAFZbTAnWYLHrHOl098oHHD+IILKyadGmx8/+67BaEP
         /0U1+TBaRaD4nVRlY8d0P8cCvnIZJlpmHipL4ch3/MdVJ4amR14LN9FgyJEhEPltilZz
         JqydnF9/a+3w/nYXSqpRAQJ20Zqco2Re0B/OyCEnPc6LouGhBBxZWJCM4YEhbP8aZHXr
         VFlBFLVdXVNRZg76q44LHOQjrYuPoKn/nLMkV5sLWVN71OITC9mAt1N63alxdHpJ7j/6
         rq0mTI90c55h1+19HTkcN+XCoDT/vgpeduIkq/UtlrYVZsN9d7p8lZUcOB+KO+ENkFjf
         fQ0Q==
X-Gm-Message-State: AOAM531lQz3nQFEEjt3617EkZBxLjF7VZjUBGcMGBVsSJRmLBt1T+nMK
        Gu+N9C5zJzbNCyq1eF8t+vXhJjGF8EFyGS2u
X-Google-Smtp-Source: ABdhPJwUUEhPJF5SriNECUkyq9DHGkfqpPGU/Y25L69B9RBmbQChb7G+i1dYHhSOJDbFjXMXI6PKiw==
X-Received: by 2002:a05:6a00:23cf:b029:2d5:302e:dc77 with SMTP id g15-20020a056a0023cfb02902d5302edc77mr18347336pfc.63.1627923873235;
        Mon, 02 Aug 2021 10:04:33 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id d9sm13977701pgm.89.2021.08.02.10.04.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 02 Aug 2021 10:04:32 -0700 (PDT)
Message-ID: <610825a0.1c69fb81.e22cf.7327@mx.google.com>
Date:   Mon, 02 Aug 2021 10:04:32 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: queue/4.19
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v4.19.200-30-gb520bff71c50
X-Kernelci-Report-Type: test
Subject: stable-rc/queue/4.19 baseline: 124 runs,
 8 regressions (v4.19.200-30-gb520bff71c50)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.19 baseline: 124 runs, 8 regressions (v4.19.200-30-gb520b=
ff71c50)

Regressions Summary
-------------------

platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
odroid-xu3           | arm  | lab-collabora | gcc-8    | exynos_defconfig  =
  | 1          =

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
nel/v4.19.200-30-gb520bff71c50/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.19
  Describe: v4.19.200-30-gb520bff71c50
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      b520bff71c5089f60bf2bbc6465d6d73dc48d004 =



Test Regressions
---------------- =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
odroid-xu3           | arm  | lab-collabora | gcc-8    | exynos_defconfig  =
  | 1          =


  Details:     https://kernelci.org/test/plan/id/61080114fde29effc4b13665

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: exynos_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.200=
-30-gb520bff71c50/arm/exynos_defconfig/gcc-8/lab-collabora/baseline-odroid-=
xu3.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.200=
-30-gb520bff71c50/arm/exynos_defconfig/gcc-8/lab-collabora/baseline-odroid-=
xu3.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61080114fde29effc4b13=
666
        new failure (last pass: v4.19.200-27-g95a3cef6d1b1) =

 =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-baylibre  | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/6107e9d5cd1374760ab1366a

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.200=
-30-gb520bff71c50/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_=
arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.200=
-30-gb520bff71c50/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_=
arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6107e9d5cd1374760ab13=
66b
        failing since 261 days (last pass: v4.19.157-26-gd59f3161b3a0, firs=
t fail: v4.19.157-27-g5543cc2c41d55) =

 =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-broonie   | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/6107eb8694311f8c87b1368f

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.200=
-30-gb520bff71c50/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_a=
rm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.200=
-30-gb520bff71c50/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_a=
rm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6107eb8694311f8c87b13=
690
        failing since 261 days (last pass: v4.19.157-26-gd59f3161b3a0, firs=
t fail: v4.19.157-27-g5543cc2c41d55) =

 =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-cip       | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/6107e9d91b3db97aacb13671

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.200=
-30-gb520bff71c50/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-v=
ersatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.200=
-30-gb520bff71c50/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-v=
ersatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6107e9d91b3db97aacb13=
672
        failing since 261 days (last pass: v4.19.157-26-gd59f3161b3a0, firs=
t fail: v4.19.157-27-g5543cc2c41d55) =

 =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-collabora | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/6107ea508a36839fc1b13698

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.200=
-30-gb520bff71c50/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu=
_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.200=
-30-gb520bff71c50/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu=
_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6107ea508a36839fc1b13=
699
        failing since 261 days (last pass: v4.19.157-26-gd59f3161b3a0, firs=
t fail: v4.19.157-27-g5543cc2c41d55) =

 =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
rk3288-veyron-jaq    | arm  | lab-collabora | gcc-8    | multi_v7_defconfig=
  | 3          =


  Details:     https://kernelci.org/test/plan/id/6107f542046a2332f9b13692

  Results:     64 PASS, 6 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.200=
-30-gb520bff71c50/arm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-rk328=
8-veyron-jaq.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.200=
-30-gb520bff71c50/arm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-rk328=
8-veyron-jaq.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.bootrr.rockchip-iodomain-grf-probed: https://kernelci.org/test=
/case/id/6107f542046a2332f9b136aa
        failing since 48 days (last pass: v4.19.194-28-g6098ecdead2c, first=
 fail: v4.19.194-67-g1b5dea188d94)

    2021-08-02T13:37:55.258716  /lava-4306345/1/../bin/lava-test-case
    2021-08-02T13:37:55.276772  <8>[   18.397353] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Drockchip-iodomain-grf-probed RESULT=3Dfail>   =


  * baseline.bootrr.dwmmc_rockchip-sdio0-probed: https://kernelci.org/test/=
case/id/6107f542046a2332f9b136c3
        failing since 48 days (last pass: v4.19.194-28-g6098ecdead2c, first=
 fail: v4.19.194-67-g1b5dea188d94)

    2021-08-02T13:37:52.815587  /lava-4306345/1/../bin/lava-test-case
    2021-08-02T13:37:52.832869  <8>[   15.954064] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Ddwmmc_rockchip-sdio0-probed RESULT=3Dfail>
    2021-08-02T13:37:52.833115  /lava-4306345/1/../bin/lava-test-case   =


  * baseline.bootrr.dwmmc_rockchip-sdmmc-probed: https://kernelci.org/test/=
case/id/6107f542046a2332f9b136c4
        failing since 48 days (last pass: v4.19.194-28-g6098ecdead2c, first=
 fail: v4.19.194-67-g1b5dea188d94)

    2021-08-02T13:37:51.801905  /lava-4306345/1/../bin/lava-test-case<8>[  =
 14.934584] <LAVA_SIGNAL_TESTCASE TEST_CASE_ID=3Ddwmmc_rockchip-sdmmc-probe=
d RESULT=3Dfail>
    2021-08-02T13:37:51.802449     =

 =20
