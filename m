Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B9C2C3AA626
	for <lists+stable@lfdr.de>; Wed, 16 Jun 2021 23:30:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233126AbhFPVco (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 16 Jun 2021 17:32:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35066 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232410AbhFPVcn (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 16 Jun 2021 17:32:43 -0400
Received: from mail-pf1-x429.google.com (mail-pf1-x429.google.com [IPv6:2607:f8b0:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D8E13C061574
        for <stable@vger.kernel.org>; Wed, 16 Jun 2021 14:30:36 -0700 (PDT)
Received: by mail-pf1-x429.google.com with SMTP id y15so3272766pfl.4
        for <stable@vger.kernel.org>; Wed, 16 Jun 2021 14:30:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=cLOWU7HjydAFC5mM9vH+TgAKsH0EouBoZuQl0nilPWc=;
        b=aKsJWxQx3OvA0pMqit7324ks4roHI6Y3jpvCitt/csdofAY8zOJG3FjCI++FTF5vkb
         M13ITCgdlaU7kPmKMmJHI5bfzLzeT8eJfI63RPI96dDBIiEtUleFTt4GCgnYxrW2YRfq
         CHA31UfwcgSCZVbWfSfKrtpJnxZmVzo94bHjKB0UHEShvvzMGXBMP8pZ4tmomD8fjAvw
         XM1YCjurGz8bGFj5MBGSa7BsRuFM3g/P46sOE8E2kI7qOk5tYedonGeCThtuL1ID0iDZ
         HIRmGfKjztR/n1A/NgCoz4/+W3T7r57MO80wdn5Krq2rOyQWM0gHoARTJC9+Rp13B1CB
         bkzg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=cLOWU7HjydAFC5mM9vH+TgAKsH0EouBoZuQl0nilPWc=;
        b=EiWKCk07ODbtI5qG1LBfgHk/0oNiRwwiep2GQkCiDjRO/Q/eWE+NnNENffno/9GqkL
         LB0MqkX9EjjLrFs3fdsKtbHmuTMc1FEuL8yoDs89XSMnAY5j/DAKxLUgFswI5ut7FneB
         6Kyae/oOhjHqxalCDlnd/MOLayotIW0b4t79HsQJD2ZMwr2EzkObc+CT9PAeEnq+AkjP
         HJAk6cJCW3DQTcmQ1UMNyVb5FSlL7D3/Kcq0RTtCCek0kTHqyztSqHFNPWgO2YiCS1IN
         c4P/Imo2rVKq2obDfEIlYT2mrSyB8Urj05bV63hVF3GCID8ENU8QEYDTtXzSL0HDNlhX
         vWhw==
X-Gm-Message-State: AOAM532qqjAjy/YOm4N5hA34tUUZSG26DderX+PxpPZWW0aDizPKo4OW
        MZlBfolRlz5DI2C+NpPetVnxBUyO6l7VJigs
X-Google-Smtp-Source: ABdhPJwEj2e+qC0QeGNJR88wSMEh5q/JxCDq/UMXendxqFnKKqfNYrjnCWfyz2E1KUGGatR/d/sP1w==
X-Received: by 2002:a63:5756:: with SMTP id h22mr1566659pgm.377.1623879036185;
        Wed, 16 Jun 2021 14:30:36 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id x3sm3492998pgx.8.2021.06.16.14.30.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 16 Jun 2021 14:30:35 -0700 (PDT)
Message-ID: <60ca6d7b.1c69fb81.233d8.9d6a@mx.google.com>
Date:   Wed, 16 Jun 2021 14:30:35 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v4.19.195-20-gbcfa261141f9
X-Kernelci-Branch: queue/4.19
X-Kernelci-Tree: stable-rc
Subject: stable-rc/queue/4.19 baseline: 93 runs,
 6 regressions (v4.19.195-20-gbcfa261141f9)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.19 baseline: 93 runs, 6 regressions (v4.19.195-20-gbcfa26=
1141f9)

Regressions Summary
-------------------

platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-broonie   | gcc-8    | versatile_defconfi=
g | 1          =

qemu_arm-versatilepb | arm  | lab-cip       | gcc-8    | versatile_defconfi=
g | 1          =

qemu_arm-versatilepb | arm  | lab-collabora | gcc-8    | versatile_defconfi=
g | 1          =

rk3288-veyron-jaq    | arm  | lab-collabora | gcc-8    | multi_v7_defconfig=
  | 3          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.19/ker=
nel/v4.19.195-20-gbcfa261141f9/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.19
  Describe: v4.19.195-20-gbcfa261141f9
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      bcfa261141f92fc6bdcf689a66102e132a993c8d =



Test Regressions
---------------- =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-broonie   | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/60ca4bd9edc3a0f11041327b

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.195=
-20-gbcfa261141f9/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_a=
rm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.195=
-20-gbcfa261141f9/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_a=
rm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60ca4bd9edc3a0f110413=
27c
        failing since 214 days (last pass: v4.19.157-26-gd59f3161b3a0, firs=
t fail: v4.19.157-27-g5543cc2c41d55) =

 =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-cip       | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/60ca33d6691be1157b413291

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.195=
-20-gbcfa261141f9/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-v=
ersatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.195=
-20-gbcfa261141f9/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-v=
ersatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60ca33d6691be1157b413=
292
        failing since 214 days (last pass: v4.19.157-26-gd59f3161b3a0, firs=
t fail: v4.19.157-27-g5543cc2c41d55) =

 =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-collabora | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/60ca48af39b2697503413290

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.195=
-20-gbcfa261141f9/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu=
_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.195=
-20-gbcfa261141f9/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu=
_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60ca48af39b2697503413=
291
        failing since 214 days (last pass: v4.19.157-26-gd59f3161b3a0, firs=
t fail: v4.19.157-27-g5543cc2c41d55) =

 =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
rk3288-veyron-jaq    | arm  | lab-collabora | gcc-8    | multi_v7_defconfig=
  | 3          =


  Details:     https://kernelci.org/test/plan/id/60ca669cde9e995a9c4132a1

  Results:     63 PASS, 6 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.195=
-20-gbcfa261141f9/arm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-rk328=
8-veyron-jaq.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.195=
-20-gbcfa261141f9/arm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-rk328=
8-veyron-jaq.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.bootrr.dwmmc_rockchip-sdmmc-probed: https://kernelci.org/test/=
case/id/60ca669cde9e995a9c4132bd
        failing since 1 day (last pass: v4.19.194-28-g6098ecdead2c, first f=
ail: v4.19.194-67-g1b5dea188d94)

    2021-06-16T21:01:09.058048  /lava-4038102/1/../bin/lava-test-case
    2021-06-16T21:01:09.063848  <8>[   14.670821] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Ddwmmc_rockchip-sdmmc-probed RESULT=3Dfail>   =


  * baseline.bootrr.dwmmc_rockchip-sdio0-probed: https://kernelci.org/test/=
case/id/60ca669cde9e995a9c4132be
        failing since 1 day (last pass: v4.19.194-28-g6098ecdead2c, first f=
ail: v4.19.194-67-g1b5dea188d94)

    2021-06-16T21:01:10.094721  /lava-4038102/1/../bin/lava-test-case<8>[  =
 15.690198] <LAVA_SIGNAL_TESTCASE TEST_CASE_ID=3Ddwmmc_rockchip-sdio0-probe=
d RESULT=3Dfail>
    2021-06-16T21:01:10.095084  =

    2021-06-16T21:01:10.095291  /lava-4038102/1/../bin/lava-test-case   =


  * baseline.bootrr.rockchip-iodomain-grf-probed: https://kernelci.org/test=
/case/id/60ca669cde9e995a9c4132d7
        failing since 1 day (last pass: v4.19.194-28-g6098ecdead2c, first f=
ail: v4.19.194-67-g1b5dea188d94)

    2021-06-16T21:01:12.536063  /lava-4038102/1/../bin/lava-test-case<8>[  =
 18.131469] <LAVA_SIGNAL_TESTCASE TEST_CASE_ID=3Drockchip-iodomain-grf-prob=
ed RESULT=3Dfail>
    2021-06-16T21:01:12.536646  =

    2021-06-16T21:01:12.537061  /lava-4038102/1/../bin/lava-test-case   =

 =20
