Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8B09841B6D6
	for <lists+stable@lfdr.de>; Tue, 28 Sep 2021 21:02:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242344AbhI1TDj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 Sep 2021 15:03:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59638 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242155AbhI1TDj (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 28 Sep 2021 15:03:39 -0400
Received: from mail-pj1-x102e.google.com (mail-pj1-x102e.google.com [IPv6:2607:f8b0:4864:20::102e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B029CC06161C
        for <stable@vger.kernel.org>; Tue, 28 Sep 2021 12:01:59 -0700 (PDT)
Received: by mail-pj1-x102e.google.com with SMTP id oa12-20020a17090b1bcc00b0019f2d30c08fso31699pjb.0
        for <stable@vger.kernel.org>; Tue, 28 Sep 2021 12:01:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=A9AjDwx7XYIBNXrGt1y9LpAZq+pPu2bc5EiYfcrD/jk=;
        b=caLY52dwRRzkXTE+Z8OxVgD1ELqfQz7PFQDz1wRHnnmCmPimzdQpEoACcuDoktsid7
         IUxCtrYGiB4gMbHzy1y2M60LkEFoYvzN4/apYK2P13FZt6qjZEHij6mXfA7oDebB2SyZ
         fCj7E3fN3GeLG8BMqx+WI5qZEi40HFELLsTkX6o+HWbhbY2u6/yUHhYOIxLGiuqu4hqz
         z4ncLvuCudIuaCw0GJ06ohIBzMOwvZhlfwnqhuFMwCKHnkPtR02RRV5qWPXOYeoDgRds
         4bPK1vW2YHQJL7Ge5+S15GT6Ug7M1zX7kpK9XhphS7y7iWY8r+dfnywuq3VtVivQgX59
         v+8w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=A9AjDwx7XYIBNXrGt1y9LpAZq+pPu2bc5EiYfcrD/jk=;
        b=g2O0xGDjIqD6iK5Hl5B3Kjsf1SUkl2ztAAbgjOpZgvQI0197vPZKDeoMKmqW9HXuqz
         kkR6UKw8sFClfi8hwTrrmmi2YxGo7QQ22R3LXpVcukYH2i2y4gDSy1/XX8qIKmCFgc+v
         khRd46xzk0epReBQdriJNjjKrBBzF+Wv72fne18MnhRE6nUi5JSmijgAV+WrNfvUAZBs
         PZRxCC9D62DCcRB2EvfvIIduDFSBWwXuHALXwTwdf5B3OCkq4AzKcBRL7lMdPO21AQd8
         oIFZs9uFjiuesoi+Jf5EDTdLE+19NrYl6PGyEFiDWSkxhy4a2C+qtsAi6N55P2/Y6uTP
         3uNQ==
X-Gm-Message-State: AOAM5335VD0Zc1ybYsr4Sr9DKhmpGY3gb2Hdy2SLQCbYCRwIC/rUewU3
        LcO0v+tQ+I9TcAHQEbUc9fx/Wfqidwf6zMPz
X-Google-Smtp-Source: ABdhPJzVgqkS4kzbktsx3mZmdIszhKeapVjs3+xr44hb3LZrjJLSV18gRqAmRRSBI++VW/XMIPc4gQ==
X-Received: by 2002:a17:90b:1105:: with SMTP id gi5mr1726484pjb.100.1632855718992;
        Tue, 28 Sep 2021 12:01:58 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id i69sm22087765pgc.7.2021.09.28.12.01.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 28 Sep 2021 12:01:58 -0700 (PDT)
Message-ID: <615366a6.1c69fb81.2dcf.7242@mx.google.com>
Date:   Tue, 28 Sep 2021 12:01:58 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.19.208-55-g9e4075ab91c6
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/4.19
Subject: stable-rc/queue/4.19 baseline: 137 runs,
 7 regressions (v4.19.208-55-g9e4075ab91c6)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.19 baseline: 137 runs, 7 regressions (v4.19.208-55-g9e407=
5ab91c6)

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
nel/v4.19.208-55-g9e4075ab91c6/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.19
  Describe: v4.19.208-55-g9e4075ab91c6
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      9e4075ab91c6c3c7ad7e643442cc5b9233a049de =



Test Regressions
---------------- =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-baylibre  | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/61533f5e2c8b32341399a306

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.208=
-55-g9e4075ab91c6/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_=
arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.208=
-55-g9e4075ab91c6/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_=
arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61533f5e2c8b32341399a=
307
        failing since 318 days (last pass: v4.19.157-26-gd59f3161b3a0, firs=
t fail: v4.19.157-27-g5543cc2c41d55) =

 =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-broonie   | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/61535c453e84b7bd0d99a2de

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.208=
-55-g9e4075ab91c6/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_a=
rm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.208=
-55-g9e4075ab91c6/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_a=
rm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61535c453e84b7bd0d99a=
2df
        failing since 318 days (last pass: v4.19.157-26-gd59f3161b3a0, firs=
t fail: v4.19.157-27-g5543cc2c41d55) =

 =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-cip       | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/61533490584b0fff9499a2da

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.208=
-55-g9e4075ab91c6/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-v=
ersatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.208=
-55-g9e4075ab91c6/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-v=
ersatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61533490584b0fff9499a=
2db
        failing since 318 days (last pass: v4.19.157-26-gd59f3161b3a0, firs=
t fail: v4.19.157-27-g5543cc2c41d55) =

 =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-collabora | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/61533629cce2ceb86c99a2f3

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.208=
-55-g9e4075ab91c6/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu=
_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.208=
-55-g9e4075ab91c6/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu=
_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61533629cce2ceb86c99a=
2f4
        failing since 318 days (last pass: v4.19.157-26-gd59f3161b3a0, firs=
t fail: v4.19.157-27-g5543cc2c41d55) =

 =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
rk3288-veyron-jaq    | arm  | lab-collabora | gcc-8    | multi_v7_defconfig=
  | 3          =


  Details:     https://kernelci.org/test/plan/id/61535b95c4cbeb4bbc99a2ff

  Results:     64 PASS, 6 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.208=
-55-g9e4075ab91c6/arm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-rk328=
8-veyron-jaq.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.208=
-55-g9e4075ab91c6/arm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-rk328=
8-veyron-jaq.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.bootrr.rockchip-iodomain-grf-probed: https://kernelci.org/test=
/case/id/61535b95c4cbeb4bbc99a313
        failing since 105 days (last pass: v4.19.194-28-g6098ecdead2c, firs=
t fail: v4.19.194-67-g1b5dea188d94)

    2021-09-28T18:14:39.423477  /lava-4595030/1/../bin/lava-test-case
    2021-09-28T18:14:39.440303  <8>[   17.705227] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Drockchip-iodomain-grf-probed RESULT=3Dfail>   =


  * baseline.bootrr.dwmmc_rockchip-sdio0-probed: https://kernelci.org/test/=
case/id/61535b95c4cbeb4bbc99a32c
        failing since 105 days (last pass: v4.19.194-28-g6098ecdead2c, firs=
t fail: v4.19.194-67-g1b5dea188d94)

    2021-09-28T18:14:36.999685  /lava-4595030/1/../bin/lava-test-case<8>[  =
 15.264293] <LAVA_SIGNAL_TESTCASE TEST_CASE_ID=3Ddwmmc_rockchip-sdio0-probe=
d RESULT=3Dfail>
    2021-09-28T18:14:37.000126  =

    2021-09-28T18:14:37.001525  /lava-4595030/1/../bin/lava-test-case   =


  * baseline.bootrr.dwmmc_rockchip-sdmmc-probed: https://kernelci.org/test/=
case/id/61535b95c4cbeb4bbc99a32d
        failing since 105 days (last pass: v4.19.194-28-g6098ecdead2c, firs=
t fail: v4.19.194-67-g1b5dea188d94)

    2021-09-28T18:14:35.963059  /lava-4595030/1/../bin/lava-test-case
    2021-09-28T18:14:35.969075  <8>[   14.244719] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Ddwmmc_rockchip-sdmmc-probed RESULT=3Dfail>   =

 =20
