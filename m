Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CCEAB3C87DE
	for <lists+stable@lfdr.de>; Wed, 14 Jul 2021 17:41:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232360AbhGNPoq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 14 Jul 2021 11:44:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49818 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232354AbhGNPop (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 14 Jul 2021 11:44:45 -0400
Received: from mail-pj1-x102a.google.com (mail-pj1-x102a.google.com [IPv6:2607:f8b0:4864:20::102a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AC6A6C06175F
        for <stable@vger.kernel.org>; Wed, 14 Jul 2021 08:41:53 -0700 (PDT)
Received: by mail-pj1-x102a.google.com with SMTP id x21-20020a17090aa395b029016e25313bfcso1981061pjp.2
        for <stable@vger.kernel.org>; Wed, 14 Jul 2021 08:41:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=O16H+fx28hH4Q2IycM82v3SdcOROaUmFLMslHYRnU2E=;
        b=w6LWGH8Y0PGCvqNO7OtwH7A9bsaFZ2HYNMvzVNDvxfYEWqqXig3xsc5Tr85nUXf3qS
         +e2GbtlF1bNQiP8wsuWWgfJ91zc+cNBV4WvXEN4I0Iuc5yIujv5OSb+63ZhTEnXKls+5
         6rkydsfN09Z8dNSJ8gEPYAMfyoOsTk6XhfyKYrb1Z+8KzienwfQ0z2GGXy/8bWzOBQdX
         6YfAqWDh3e+ND4dwJPuZ4HCqseEq/dy+Zjvx/N3RWaNs7QnB2eEst91QSX8jUXD5af2A
         iKz+PH1ae8+vLy2keirDMw4AzP3+qAh25ZU++wyCeUxZ/QvPii0DYGHwCYn3u4Httq0/
         Ea3w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=O16H+fx28hH4Q2IycM82v3SdcOROaUmFLMslHYRnU2E=;
        b=ACFji3fSlpceKyhVhImp1mfdNkoT3zJ6VP1UJJw8NTUNvbHVz3T1+0xZDmarpXuD6+
         57FDLTvlYx+r8XPEg8vOsmThT/I6geQnW0I296VVuhbe6ZPrO6VE0i0eEqyArLZfMwR2
         YeupNjYN3RVPjL7MPIUBIAV1WiX+LS54BSagewfLSft7vD4R+CS/lmjoUOWZ3EXZthGZ
         x1aysuzFOXrxRzP0g/LlYO8SSmNU/tn7IHfBeDDWQffRdjcBullfqyi8zCf3Qa40WUK0
         3iuoCx+6Zqx/Q8SzX5I2dXs3lin/WRwXIli7WFAlYq3O3YXoZfsnnjDLkfQoz6BLG22k
         Y0gA==
X-Gm-Message-State: AOAM531P+e27tPPFfSuzr00Ey8t+YajKUuk8BO8jUglHG/tk3xDIYRrE
        QbRI2PkFnvBpSjXCa76HAukzzQT0SEuD9P5r
X-Google-Smtp-Source: ABdhPJzTsTXqMnZDtaXNsnDP/ZDtc5k8/pZQKWmxbQUNuss7H+icTjKrDLq831FL0mWJgAK7DrTpGw==
X-Received: by 2002:a17:90b:1041:: with SMTP id gq1mr4257206pjb.222.1626277312804;
        Wed, 14 Jul 2021 08:41:52 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id a13sm3481262pfl.92.2021.07.14.08.41.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 14 Jul 2021 08:41:52 -0700 (PDT)
Message-ID: <60ef05c0.1c69fb81.5a4de.9a49@mx.google.com>
Date:   Wed, 14 Jul 2021 08:41:52 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-5.4.y
X-Kernelci-Kernel: v5.4.131-350-g22b22e7110f5
Subject: stable-rc/linux-5.4.y baseline: 195 runs,
 10 regressions (v5.4.131-350-g22b22e7110f5)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-5.4.y baseline: 195 runs, 10 regressions (v5.4.131-350-g22b=
22e7110f5)

Regressions Summary
-------------------

platform             | arch  | lab             | compiler | defconfig      =
     | regressions
---------------------+-------+-----------------+----------+----------------=
-----+------------
hifive-unleashed-a00 | riscv | lab-baylibre    | gcc-8    | defconfig      =
     | 1          =

meson-gxbb-p200      | arm64 | lab-baylibre    | gcc-8    | defconfig      =
     | 1          =

qemu_arm-versatilepb | arm   | lab-baylibre    | gcc-8    | versatile_defco=
nfig | 1          =

qemu_arm-versatilepb | arm   | lab-broonie     | gcc-8    | versatile_defco=
nfig | 1          =

qemu_arm-versatilepb | arm   | lab-cip         | gcc-8    | versatile_defco=
nfig | 1          =

qemu_arm-versatilepb | arm   | lab-collabora   | gcc-8    | versatile_defco=
nfig | 1          =

qemu_arm-versatilepb | arm   | lab-linaro-lkft | gcc-8    | versatile_defco=
nfig | 1          =

rk3288-veyron-jaq    | arm   | lab-collabora   | gcc-8    | multi_v7_defcon=
fig  | 3          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-5.4.y/kern=
el/v5.4.131-350-g22b22e7110f5/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-5.4.y
  Describe: v5.4.131-350-g22b22e7110f5
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      22b22e7110f52e9b2458fcb1a31aafea2590025f =



Test Regressions
---------------- =



platform             | arch  | lab             | compiler | defconfig      =
     | regressions
---------------------+-------+-----------------+----------+----------------=
-----+------------
hifive-unleashed-a00 | riscv | lab-baylibre    | gcc-8    | defconfig      =
     | 1          =


  Details:     https://kernelci.org/test/plan/id/60eed0dc3ca557c04e8a93c9

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (riscv64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.131=
-350-g22b22e7110f5/riscv/defconfig/gcc-8/lab-baylibre/baseline-hifive-unlea=
shed-a00.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.131=
-350-g22b22e7110f5/riscv/defconfig/gcc-8/lab-baylibre/baseline-hifive-unlea=
shed-a00.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/riscv/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60eed0dc3ca557c04e8a9=
3ca
        failing since 236 days (last pass: v5.4.77-152-ga3746663c3479, firs=
t fail: v5.4.78) =

 =



platform             | arch  | lab             | compiler | defconfig      =
     | regressions
---------------------+-------+-----------------+----------+----------------=
-----+------------
meson-gxbb-p200      | arm64 | lab-baylibre    | gcc-8    | defconfig      =
     | 1          =


  Details:     https://kernelci.org/test/plan/id/60eed7a9a2fdc8254e8a93b9

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.131=
-350-g22b22e7110f5/arm64/defconfig/gcc-8/lab-baylibre/baseline-meson-gxbb-p=
200.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.131=
-350-g22b22e7110f5/arm64/defconfig/gcc-8/lab-baylibre/baseline-meson-gxbb-p=
200.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60eed7a9a2fdc8254e8a9=
3ba
        new failure (last pass: v5.4.131-349-ge00f43b5589ca) =

 =



platform             | arch  | lab             | compiler | defconfig      =
     | regressions
---------------------+-------+-----------------+----------+----------------=
-----+------------
qemu_arm-versatilepb | arm   | lab-baylibre    | gcc-8    | versatile_defco=
nfig | 1          =


  Details:     https://kernelci.org/test/plan/id/60eed1ef7850ebba5d8a93c4

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.131=
-350-g22b22e7110f5/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu=
_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.131=
-350-g22b22e7110f5/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu=
_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60eed1ef7850ebba5d8a9=
3c5
        failing since 241 days (last pass: v5.4.77-44-g28fe0e171c204, first=
 fail: v5.4.77-46-ga3e34830d912) =

 =



platform             | arch  | lab             | compiler | defconfig      =
     | regressions
---------------------+-------+-----------------+----------+----------------=
-----+------------
qemu_arm-versatilepb | arm   | lab-broonie     | gcc-8    | versatile_defco=
nfig | 1          =


  Details:     https://kernelci.org/test/plan/id/60eed48d1a070434e88a93a5

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.131=
-350-g22b22e7110f5/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_=
arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.131=
-350-g22b22e7110f5/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_=
arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60eed48d1a070434e88a9=
3a6
        failing since 241 days (last pass: v5.4.77-44-g28fe0e171c204, first=
 fail: v5.4.77-46-ga3e34830d912) =

 =



platform             | arch  | lab             | compiler | defconfig      =
     | regressions
---------------------+-------+-----------------+----------+----------------=
-----+------------
qemu_arm-versatilepb | arm   | lab-cip         | gcc-8    | versatile_defco=
nfig | 1          =


  Details:     https://kernelci.org/test/plan/id/60eed209ec12f2493d8a93de

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.131=
-350-g22b22e7110f5/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-=
versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.131=
-350-g22b22e7110f5/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-=
versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60eed209ec12f2493d8a9=
3df
        failing since 241 days (last pass: v5.4.77-44-g28fe0e171c204, first=
 fail: v5.4.77-46-ga3e34830d912) =

 =



platform             | arch  | lab             | compiler | defconfig      =
     | regressions
---------------------+-------+-----------------+----------+----------------=
-----+------------
qemu_arm-versatilepb | arm   | lab-collabora   | gcc-8    | versatile_defco=
nfig | 1          =


  Details:     https://kernelci.org/test/plan/id/60eed19bb133aa55b58a93ad

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.131=
-350-g22b22e7110f5/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qem=
u_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.131=
-350-g22b22e7110f5/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qem=
u_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60eed19bb133aa55b58a9=
3ae
        failing since 241 days (last pass: v5.4.77-44-g28fe0e171c204, first=
 fail: v5.4.77-46-ga3e34830d912) =

 =



platform             | arch  | lab             | compiler | defconfig      =
     | regressions
---------------------+-------+-----------------+----------+----------------=
-----+------------
qemu_arm-versatilepb | arm   | lab-linaro-lkft | gcc-8    | versatile_defco=
nfig | 1          =


  Details:     https://kernelci.org/test/plan/id/60eed19838ee3754e88a93a3

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.131=
-350-g22b22e7110f5/arm/versatile_defconfig/gcc-8/lab-linaro-lkft/baseline-q=
emu_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.131=
-350-g22b22e7110f5/arm/versatile_defconfig/gcc-8/lab-linaro-lkft/baseline-q=
emu_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60eed19838ee3754e88a9=
3a4
        failing since 241 days (last pass: v5.4.77-44-g28fe0e171c204, first=
 fail: v5.4.77-46-ga3e34830d912) =

 =



platform             | arch  | lab             | compiler | defconfig      =
     | regressions
---------------------+-------+-----------------+----------+----------------=
-----+------------
rk3288-veyron-jaq    | arm   | lab-collabora   | gcc-8    | multi_v7_defcon=
fig  | 3          =


  Details:     https://kernelci.org/test/plan/id/60eedf40194d7d8cb38a939f

  Results:     67 PASS, 3 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.131=
-350-g22b22e7110f5/arm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-rk32=
88-veyron-jaq.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.131=
-350-g22b22e7110f5/arm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-rk32=
88-veyron-jaq.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.bootrr.rockchip-iodomain-grf-probed: https://kernelci.org/test=
/case/id/60eedf40194d7d8cb38a93b7
        failing since 29 days (last pass: v5.4.125, first fail: v5.4.125-85=
-g4a2dfe908c1e)

    2021-07-14T12:57:20.690309  /lava-4196037/1/../bin/lava-test-case<8>[  =
 14.599699] <LAVA_SIGNAL_TESTCASE TEST_CASE_ID=3Drockchip-iodomain-grf-prob=
ed RESULT=3Dfail>
    2021-07-14T12:57:20.690898  =

    2021-07-14T12:57:20.691306  /lava-4196037/1/../bin/lava-test-case   =


  * baseline.bootrr.dwmmc_rockchip-sdio0-probed: https://kernelci.org/test/=
case/id/60eedf40194d7d8cb38a93cf
        failing since 29 days (last pass: v5.4.125, first fail: v5.4.125-85=
-g4a2dfe908c1e)

    2021-07-14T12:57:19.249201  /lava-4196037/1/../bin/lava-test-case
    2021-07-14T12:57:19.266467  <8>[   13.175002] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Ddwmmc_rockchip-sdio0-probed RESULT=3Dfail>
    2021-07-14T12:57:19.266919  /lava-4196037/1/../bin/lava-test-case   =


  * baseline.bootrr.dwmmc_rockchip-sdmmc-probed: https://kernelci.org/test/=
case/id/60eedf40194d7d8cb38a93d0
        failing since 29 days (last pass: v5.4.125, first fail: v5.4.125-85=
-g4a2dfe908c1e)

    2021-07-14T12:57:18.229227  /lava-4196037/1/../bin/lava-test-case
    2021-07-14T12:57:18.234774  <8>[   12.155301] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Ddwmmc_rockchip-sdmmc-probed RESULT=3Dfail>   =

 =20
