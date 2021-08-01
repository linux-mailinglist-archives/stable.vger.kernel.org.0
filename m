Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EFEE73DCAD9
	for <lists+stable@lfdr.de>; Sun,  1 Aug 2021 11:06:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231470AbhHAJGu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 1 Aug 2021 05:06:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48708 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231363AbhHAJGu (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 1 Aug 2021 05:06:50 -0400
Received: from mail-pl1-x635.google.com (mail-pl1-x635.google.com [IPv6:2607:f8b0:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0719FC06175F
        for <stable@vger.kernel.org>; Sun,  1 Aug 2021 02:06:43 -0700 (PDT)
Received: by mail-pl1-x635.google.com with SMTP id u2so7973383plg.10
        for <stable@vger.kernel.org>; Sun, 01 Aug 2021 02:06:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=m4J1JCyQidh2c5CwW2TbWYYwI2/P4c6A6Zjbyid3Etg=;
        b=P8ZxtZmGT+vTW+ZndEN5zufaV17+4Uaz0YVWbC/0t+QyMCCqMmyyomtSWaqh1LT28n
         0ykJOdRBjzJIDrBCV9mTYjv3bm8mD9mFMAzfKV6FamIuB4TR3jvGctqhofN2dfYeuSxW
         gNC13cYjeZuFu5x2VTqY0OLPfqr877yzKCXYHPJOs9tC9QI78N1J44tsC+FxN20QgdHj
         Per4f4SpQo7d+Jjo0kZAb/0rblXR3uMnIDyUYUW5PBbY5yw2GZ8lpdXnkwfm41CSEMqv
         /lF/2I9Ej6ep5eyYZb+0A3zAVz0jAQXyA9aVwDSx1c6D6TzHrJglS8lp0/nHxvhzCBZT
         0ddA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=m4J1JCyQidh2c5CwW2TbWYYwI2/P4c6A6Zjbyid3Etg=;
        b=E0jpLLcojUpJIMaDCMTwyp/addppGqEJPkEzJBavYcHOQp37IpT+hqfJXM7B6aAMhi
         vx3SXc1yzzS0szOeosm+gzrElzdKvbECfP2KweQuST4svCpQLeoyv81ueXZgysx3C/Xf
         l2csywaWNBuU0f2qoQXD/AqbRtL3l4qOkYbILMW9ZmKoIya5l1l8zz2kunLb3BW0W6P2
         7RjNAzWjz4z6zs7Hjdar9dGi4A/EKqBqv41DluQjONwf9owVJ/qzyxUVqvSDJ0ErXTLy
         qxGS/YX4bofwOsy3ltHPAHgHauDAHOTuxRlKDpvfYGv+YuTqqDwNqf3H81vAQoG0FeIy
         adLw==
X-Gm-Message-State: AOAM533+PbKbjzvQTcIKeV20fkWXn7i/SAqB6eSlTeHqELbpC4O1ypQD
        ZqWK9jwTLsGJhs1+2HaBMiu9ayOHJo/aMVp1
X-Google-Smtp-Source: ABdhPJwu1KRfSl9f7uzwAEOaT1oi4HC3FZQubiBO0TgQ8nAuYgiDJSidzKaG8f4ComuA3VGn8wIiOg==
X-Received: by 2002:a17:90b:1297:: with SMTP id fw23mr11698514pjb.115.1627808802238;
        Sun, 01 Aug 2021 02:06:42 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id j185sm7855826pfb.86.2021.08.01.02.06.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 01 Aug 2021 02:06:41 -0700 (PDT)
Message-ID: <61066421.1c69fb81.ac4ee.5fa5@mx.google.com>
Date:   Sun, 01 Aug 2021 02:06:41 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: queue/4.19
X-Kernelci-Kernel: v4.19.200-27-g6eaef2a36d83
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
Subject: stable-rc/queue/4.19 baseline: 144 runs,
 7 regressions (v4.19.200-27-g6eaef2a36d83)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.19 baseline: 144 runs, 7 regressions (v4.19.200-27-g6eaef=
2a36d83)

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
nel/v4.19.200-27-g6eaef2a36d83/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.19
  Describe: v4.19.200-27-g6eaef2a36d83
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      6eaef2a36d83f333aef527cb8b0a9b9fd06c4ac2 =



Test Regressions
---------------- =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-baylibre    | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/61062994ff2bc06c9c85f45b

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.200=
-27-g6eaef2a36d83/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_=
arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.200=
-27-g6eaef2a36d83/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_=
arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61062994ff2bc06c9c85f=
45c
        failing since 260 days (last pass: v4.19.157-26-gd59f3161b3a0, firs=
t fail: v4.19.157-27-g5543cc2c41d55) =

 =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-broonie     | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/610629d732c5af9c8f85f46e

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.200=
-27-g6eaef2a36d83/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_a=
rm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.200=
-27-g6eaef2a36d83/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_a=
rm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/610629d732c5af9c8f85f=
46f
        failing since 260 days (last pass: v4.19.157-26-gd59f3161b3a0, firs=
t fail: v4.19.157-27-g5543cc2c41d55) =

 =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-collabora   | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/6106294315230c34a885f466

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.200=
-27-g6eaef2a36d83/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu=
_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.200=
-27-g6eaef2a36d83/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu=
_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6106294315230c34a885f=
467
        failing since 260 days (last pass: v4.19.157-26-gd59f3161b3a0, firs=
t fail: v4.19.157-27-g5543cc2c41d55) =

 =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-linaro-lkft | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/6106294a7dca2d1ccd85f45c

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.200=
-27-g6eaef2a36d83/arm/versatile_defconfig/gcc-8/lab-linaro-lkft/baseline-qe=
mu_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.200=
-27-g6eaef2a36d83/arm/versatile_defconfig/gcc-8/lab-linaro-lkft/baseline-qe=
mu_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6106294a7dca2d1ccd85f=
45d
        failing since 260 days (last pass: v4.19.157-26-gd59f3161b3a0, firs=
t fail: v4.19.157-27-g5543cc2c41d55) =

 =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
rk3288-veyron-jaq    | arm  | lab-collabora   | gcc-8    | multi_v7_defconf=
ig  | 3          =


  Details:     https://kernelci.org/test/plan/id/610658dcccf63a52c585f45a

  Results:     64 PASS, 6 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.200=
-27-g6eaef2a36d83/arm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-rk328=
8-veyron-jaq.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.200=
-27-g6eaef2a36d83/arm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-rk328=
8-veyron-jaq.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.bootrr.rockchip-iodomain-grf-probed: https://kernelci.org/test=
/case/id/610658dcccf63a52c585f46e
        failing since 47 days (last pass: v4.19.194-28-g6098ecdead2c, first=
 fail: v4.19.194-67-g1b5dea188d94)

    2021-08-01T08:18:14.275978  /lava-4298514/1/../bin/lava-test-case
    2021-08-01T08:18:14.292980  <8>[   18.065745] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Drockchip-iodomain-grf-probed RESULT=3Dfail>
    2021-08-01T08:18:14.293474  /lava-4298514/1/../bin/lava-test-case   =


  * baseline.bootrr.dwmmc_rockchip-sdio0-probed: https://kernelci.org/test/=
case/id/610658dcccf63a52c585f487
        failing since 47 days (last pass: v4.19.194-28-g6098ecdead2c, first=
 fail: v4.19.194-67-g1b5dea188d94)

    2021-08-01T08:18:11.833872  /lava-4298514/1/../bin/lava-test-case
    2021-08-01T08:18:11.852043  <8>[   15.623852] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Ddwmmc_rockchip-sdio0-probed RESULT=3Dfail>   =


  * baseline.bootrr.dwmmc_rockchip-sdmmc-probed: https://kernelci.org/test/=
case/id/610658dcccf63a52c585f488
        failing since 47 days (last pass: v4.19.194-28-g6098ecdead2c, first=
 fail: v4.19.194-67-g1b5dea188d94)

    2021-08-01T08:18:10.814757  /lava-4298514/1/../bin/lava-test-case
    2021-08-01T08:18:10.820761  <8>[   14.604487] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Ddwmmc_rockchip-sdmmc-probed RESULT=3Dfail>   =

 =20
