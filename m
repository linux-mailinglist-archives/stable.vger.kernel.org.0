Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1176A3DE4BB
	for <lists+stable@lfdr.de>; Tue,  3 Aug 2021 05:38:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233484AbhHCDix (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 2 Aug 2021 23:38:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42196 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233197AbhHCDix (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 2 Aug 2021 23:38:53 -0400
Received: from mail-pj1-x1032.google.com (mail-pj1-x1032.google.com [IPv6:2607:f8b0:4864:20::1032])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 05D19C06175F
        for <stable@vger.kernel.org>; Mon,  2 Aug 2021 20:38:42 -0700 (PDT)
Received: by mail-pj1-x1032.google.com with SMTP id o44-20020a17090a0a2fb0290176ca3e5a2fso2898602pjo.1
        for <stable@vger.kernel.org>; Mon, 02 Aug 2021 20:38:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=dfuyr2jTJ8BiVKX+3J3U05xAmGtMnmYz7ubyt/+oZrY=;
        b=VjCeMGLCcBo/CAU/KH0DX+hDjUyrMBPsuh5xHxczJK01ECJ1Am7IJEgnn2kYrShLGp
         4XJR2xy9W2sKtT3sDI+rC6VNNE5z2rvvEx4ukwX8m3suIKGaBopRyriEHlCgZM06xyI9
         5RUE/kWY4u3MTTlJkJ4s6vRJOvcs8OPzhJOU/ZpoJqqlBUngrHB4QLEvcu+p+aaMIqug
         j6ndHDPPgfdg/ipUwfxdCk9HoOrplz3ASc4EeA6ct9zQkZG1EynwP/+/+r5APkyaWgxK
         2a+9v7Caz9Du0L7xlC4a2iJ28NbRaYAD2FSIuBoCucqaf3Pzsq828lXKzX1qvqTUuEGS
         Be6g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=dfuyr2jTJ8BiVKX+3J3U05xAmGtMnmYz7ubyt/+oZrY=;
        b=OH0rZkiilcVizXU3SMek8rD0H39GJqejo6CwQ5FEe6ToB9gd6rPkqHfk97uwLWfETQ
         oQhx7Hq3ORUMRVUXbMU4kD8q/ozkw+qMsqudoVTbLfnVH31lz6FVHkeAMQvnS/xrWWXq
         wSCoroTCM8DYVvLsYAFdt9itp2iFsCreI2LN+NBWWaMRZkXulHCRryUNjNGKwdYCBz+o
         uvPg5+C+jbikkd4MjAYE3EzhjArLLwjkm2X9YF30fY3IQeCY8xTBUbtbqe3drKaLBCcb
         r/nOf04q7hk3LvrPcmtr/Ane46JbSmQjUCnjbm8sjcdfy0948bQUUqb82CQWBP8rJq7j
         d9dw==
X-Gm-Message-State: AOAM531AUHqtJChukcspIYDk7iB+vJ9OLgwFkJhVbIfXNouGF5FTzDiK
        2I/cgdHF9oalFmZP6x/+o2Rc6SIU0XQe2Mam
X-Google-Smtp-Source: ABdhPJxUgEXkvVGpIf4rnQqlvRKHrhJKF6RaHUJiMzRpbPXjlduxC2clKt0CDiiAATzeags/oaFweA==
X-Received: by 2002:a65:6a56:: with SMTP id o22mr4082390pgu.446.1627961921346;
        Mon, 02 Aug 2021 20:38:41 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id y8sm13907725pfe.162.2021.08.02.20.38.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 02 Aug 2021 20:38:40 -0700 (PDT)
Message-ID: <6108ba40.1c69fb81.13918.891e@mx.google.com>
Date:   Mon, 02 Aug 2021 20:38:40 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: queue/4.19
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v4.19.200-31-g93b6975cc268
X-Kernelci-Report-Type: test
Subject: stable-rc/queue/4.19 baseline: 142 runs,
 7 regressions (v4.19.200-31-g93b6975cc268)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.19 baseline: 142 runs, 7 regressions (v4.19.200-31-g93b69=
75cc268)

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
nel/v4.19.200-31-g93b6975cc268/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.19
  Describe: v4.19.200-31-g93b6975cc268
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      93b6975cc268029613627c9e55d887a6060c2011 =



Test Regressions
---------------- =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-baylibre  | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/61087e9129f6547948b13686

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.200=
-31-g93b6975cc268/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_=
arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.200=
-31-g93b6975cc268/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_=
arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61087e9129f6547948b13=
687
        failing since 262 days (last pass: v4.19.157-26-gd59f3161b3a0, firs=
t fail: v4.19.157-27-g5543cc2c41d55) =

 =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-broonie   | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/610887867be4201d58b1367b

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.200=
-31-g93b6975cc268/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_a=
rm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.200=
-31-g93b6975cc268/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_a=
rm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/610887867be4201d58b13=
67c
        failing since 262 days (last pass: v4.19.157-26-gd59f3161b3a0, firs=
t fail: v4.19.157-27-g5543cc2c41d55) =

 =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-cip       | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/61087e909364d6fdfab1368a

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.200=
-31-g93b6975cc268/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-v=
ersatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.200=
-31-g93b6975cc268/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-v=
ersatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61087e909364d6fdfab13=
68b
        failing since 262 days (last pass: v4.19.157-26-gd59f3161b3a0, firs=
t fail: v4.19.157-27-g5543cc2c41d55) =

 =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-collabora | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/61088099d4cd7c1490b1368e

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.200=
-31-g93b6975cc268/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu=
_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.200=
-31-g93b6975cc268/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu=
_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61088099d4cd7c1490b13=
68f
        failing since 262 days (last pass: v4.19.157-26-gd59f3161b3a0, firs=
t fail: v4.19.157-27-g5543cc2c41d55) =

 =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
rk3288-veyron-jaq    | arm  | lab-collabora | gcc-8    | multi_v7_defconfig=
  | 3          =


  Details:     https://kernelci.org/test/plan/id/6108aa13eccd2ac729b13670

  Results:     64 PASS, 6 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.200=
-31-g93b6975cc268/arm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-rk328=
8-veyron-jaq.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.200=
-31-g93b6975cc268/arm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-rk328=
8-veyron-jaq.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.bootrr.rockchip-iodomain-grf-probed: https://kernelci.org/test=
/case/id/6108aa13eccd2ac729b13688
        failing since 49 days (last pass: v4.19.194-28-g6098ecdead2c, first=
 fail: v4.19.194-67-g1b5dea188d94)

    2021-08-03T02:29:23.867904  /lava-4312713/1/../bin/lava-test-case
    2021-08-03T02:29:23.884823  <8>[   17.829116] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Drockchip-iodomain-grf-probed RESULT=3Dfail>
    2021-08-03T02:29:23.885192  /lava-4312713/1/../bin/lava-test-case   =


  * baseline.bootrr.dwmmc_rockchip-sdio0-probed: https://kernelci.org/test/=
case/id/6108aa13eccd2ac729b136a0
        failing since 49 days (last pass: v4.19.194-28-g6098ecdead2c, first=
 fail: v4.19.194-67-g1b5dea188d94)

    2021-08-03T02:29:21.427445  /lava-4312713/1/../bin/lava-test-case
    2021-08-03T02:29:21.444741  <8>[   15.388333] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Ddwmmc_rockchip-sdio0-probed RESULT=3Dfail>   =


  * baseline.bootrr.dwmmc_rockchip-sdmmc-probed: https://kernelci.org/test/=
case/id/6108aa13eccd2ac729b136a1
        failing since 49 days (last pass: v4.19.194-28-g6098ecdead2c, first=
 fail: v4.19.194-67-g1b5dea188d94)

    2021-08-03T02:29:20.407667  /lava-4312713/1/../bin/lava-test-case
    2021-08-03T02:29:20.413482  <8>[   14.369040] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Ddwmmc_rockchip-sdmmc-probed RESULT=3Dfail>   =

 =20
