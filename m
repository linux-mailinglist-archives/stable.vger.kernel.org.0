Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 42770418D2A
	for <lists+stable@lfdr.de>; Mon, 27 Sep 2021 01:52:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229976AbhIZXxs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 26 Sep 2021 19:53:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58468 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229468AbhIZXxs (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 26 Sep 2021 19:53:48 -0400
Received: from mail-pf1-x42a.google.com (mail-pf1-x42a.google.com [IPv6:2607:f8b0:4864:20::42a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A29F9C061570
        for <stable@vger.kernel.org>; Sun, 26 Sep 2021 16:52:11 -0700 (PDT)
Received: by mail-pf1-x42a.google.com with SMTP id c1so14109460pfp.10
        for <stable@vger.kernel.org>; Sun, 26 Sep 2021 16:52:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=/GCFKk2h6kkYqs3NDFLdG4Zo+mwLcSeIVxHwm7Oejhw=;
        b=WxYY5knIiCn96qgFDg8HMkT4mJQWYGTRmrxyh08xcdZjzd+YiLVYPe0QqcjtDSXLpW
         Kt0EeeVZNz+p1lQ8Tf1DwPzMuIMZJkcE2imbo7kazjxMFNB5qC5C8wvsn4kz+c47TCr/
         1FIzH9I/ukOAM4WzAp6Wg87gTwne0rqBnTKUpAj4NdM+cYe3Z8ChTAr5cSP+eY80RUbS
         IdEQ/eiOZNRFs+3RvDCaUa6hQxrmk8i7znmaSCGxc6ztx1dPU6yGEVrdMt9DSAf7w5yH
         2ftuZMUINfgkIa8go3/9kefP8zY3HS4ZmffdcWmoGvk/Etk62arS1ts3mYpxxJDqLLMa
         YDlw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=/GCFKk2h6kkYqs3NDFLdG4Zo+mwLcSeIVxHwm7Oejhw=;
        b=nBXwCSIAdvUFJxzcOnWY+GT8TrshZOjpkOB2KCsC8dHcg+McsEjspQ0QXqwyA4vJWx
         Cgs4HfXMB2H6pMRZncwmnVmWWuPqXHwe3ujaH//HRybqW5LcFa9i3T9DtbIm4zho8nT3
         +s0gI1LPbWCD8oJO+8pu5ggX1uIonRFPKUullHSNwcwFQns4oZWNmxux8uySj6V3kDcd
         80Wctf6oGSFRW6mC4kvBKdpuza06mQcrHxZPSabf2Qie7EiNV0HqjbHu9yZL1+CcISRN
         KgB1P40S9p78cxPs73UVObePtxY9kq1nyXEYeFctEs0H+UtX38Rnl/BRKa+9Jl2s+MeV
         4+yA==
X-Gm-Message-State: AOAM533jTYKqCv3iGZ6A3qPR5whzZ0CbT24Zx2xHwpSm+jeiYeSRpv9H
        XedCVBVWWJiL3/mis62IDtf4Hqb+xAohYQYi
X-Google-Smtp-Source: ABdhPJyyVfKmFPMH2rBqXs1wa6FKTJV4bjLMTUEslrJpjCx2SxJbg5g952rVVFpwfYZAq1pPOz3HdA==
X-Received: by 2002:a63:3e8b:: with SMTP id l133mr13866193pga.451.1632700330850;
        Sun, 26 Sep 2021 16:52:10 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id s38sm14604608pfw.209.2021.09.26.16.52.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 26 Sep 2021 16:52:10 -0700 (PDT)
Message-ID: <615107aa.1c69fb81.44263.0eb2@mx.google.com>
Date:   Sun, 26 Sep 2021 16:52:10 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.19.207-52-g30a9665beec7
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/4.19
Subject: stable-rc/queue/4.19 baseline: 79 runs,
 7 regressions (v4.19.207-52-g30a9665beec7)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.19 baseline: 79 runs, 7 regressions (v4.19.207-52-g30a966=
5beec7)

Regressions Summary
-------------------

platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-broonie     | gcc-8    | versatile_defcon=
fig | 1          =

qemu_arm-versatilepb | arm  | lab-cip         | gcc-8    | versatile_defcon=
fig | 1          =

qemu_arm-versatilepb | arm  | lab-collabora   | gcc-8    | versatile_defcon=
fig | 1          =

qemu_arm-versatilepb | arm  | lab-linaro-lkft | gcc-8    | versatile_defcon=
fig | 1          =

rk3288-veyron-jaq    | arm  | lab-collabora   | gcc-8    | multi_v7_defconf=
ig  | 3          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.19/ker=
nel/v4.19.207-52-g30a9665beec7/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.19
  Describe: v4.19.207-52-g30a9665beec7
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      30a9665beec74cf95175a73a0e00a3d5ba4cd60b =



Test Regressions
---------------- =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-broonie     | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/6150c97b633b0f4a2299a302

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.207=
-52-g30a9665beec7/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_a=
rm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.207=
-52-g30a9665beec7/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_a=
rm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6150c97b633b0f4a2299a=
303
        failing since 316 days (last pass: v4.19.157-26-gd59f3161b3a0, firs=
t fail: v4.19.157-27-g5543cc2c41d55) =

 =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-cip         | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/6150c925afedae05fc99a31e

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.207=
-52-g30a9665beec7/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-v=
ersatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.207=
-52-g30a9665beec7/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-v=
ersatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6150c925afedae05fc99a=
31f
        failing since 316 days (last pass: v4.19.157-26-gd59f3161b3a0, firs=
t fail: v4.19.157-27-g5543cc2c41d55) =

 =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-collabora   | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/6150c98900bbd3824899a2eb

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.207=
-52-g30a9665beec7/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu=
_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.207=
-52-g30a9665beec7/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu=
_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6150c98900bbd3824899a=
2ec
        failing since 316 days (last pass: v4.19.157-26-gd59f3161b3a0, firs=
t fail: v4.19.157-27-g5543cc2c41d55) =

 =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-linaro-lkft | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/6150e17cb4670647dd99a2f6

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.207=
-52-g30a9665beec7/arm/versatile_defconfig/gcc-8/lab-linaro-lkft/baseline-qe=
mu_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.207=
-52-g30a9665beec7/arm/versatile_defconfig/gcc-8/lab-linaro-lkft/baseline-qe=
mu_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6150e17cb4670647dd99a=
2f7
        failing since 316 days (last pass: v4.19.157-26-gd59f3161b3a0, firs=
t fail: v4.19.157-27-g5543cc2c41d55) =

 =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
rk3288-veyron-jaq    | arm  | lab-collabora   | gcc-8    | multi_v7_defconf=
ig  | 3          =


  Details:     https://kernelci.org/test/plan/id/6150cc55c369e417c599a2da

  Results:     64 PASS, 6 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.207=
-52-g30a9665beec7/arm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-rk328=
8-veyron-jaq.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.207=
-52-g30a9665beec7/arm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-rk328=
8-veyron-jaq.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.bootrr.rockchip-iodomain-grf-probed: https://kernelci.org/test=
/case/id/6150cc55c369e417c599a2ee
        failing since 103 days (last pass: v4.19.194-28-g6098ecdead2c, firs=
t fail: v4.19.194-67-g1b5dea188d94)

    2021-09-26T19:38:40.534496  /lava-4586250/1/../bin/lava-test-case
    2021-09-26T19:38:40.550781  <8>[   18.373252] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Drockchip-iodomain-grf-probed RESULT=3Dfail>
    2021-09-26T19:38:40.551035  /lava-4586250/1/../bin/lava-test-case   =


  * baseline.bootrr.dwmmc_rockchip-sdio0-probed: https://kernelci.org/test/=
case/id/6150cc55c369e417c599a305
        failing since 103 days (last pass: v4.19.194-28-g6098ecdead2c, firs=
t fail: v4.19.194-67-g1b5dea188d94)

    2021-09-26T19:38:38.093058  /lava-4586250/1/../bin/lava-test-case
    2021-09-26T19:38:38.110144  <8>[   15.931730] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Ddwmmc_rockchip-sdio0-probed RESULT=3Dfail>
    2021-09-26T19:38:38.110398  /lava-4586250/1/../bin/lava-test-case   =


  * baseline.bootrr.dwmmc_rockchip-sdmmc-probed: https://kernelci.org/test/=
case/id/6150cc55c369e417c599a306
        failing since 103 days (last pass: v4.19.194-28-g6098ecdead2c, firs=
t fail: v4.19.194-67-g1b5dea188d94)

    2021-09-26T19:38:37.072720  /lava-4586250/1/../bin/lava-test-case
    2021-09-26T19:38:37.078770  <8>[   14.912320] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Ddwmmc_rockchip-sdmmc-probed RESULT=3Dfail>   =

 =20
