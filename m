Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8A6B33CA292
	for <lists+stable@lfdr.de>; Thu, 15 Jul 2021 18:41:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232954AbhGOQoY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 15 Jul 2021 12:44:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55090 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232953AbhGOQoV (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 15 Jul 2021 12:44:21 -0400
Received: from mail-pj1-x102c.google.com (mail-pj1-x102c.google.com [IPv6:2607:f8b0:4864:20::102c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5C1FFC061762
        for <stable@vger.kernel.org>; Thu, 15 Jul 2021 09:41:28 -0700 (PDT)
Received: by mail-pj1-x102c.google.com with SMTP id g24so4496353pji.4
        for <stable@vger.kernel.org>; Thu, 15 Jul 2021 09:41:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=fthmjAQ3qNknjjUAbxlBIqQYx2nk8zF2dNW/rD+Mv+g=;
        b=XkyhG+VvoZgGDxlmqS9hKVBqWpShteW+zFyjy4ARpdQ4KsM37MBseqZTlzWnSZ97V3
         j/0M6+VmVOgcXR4c+M83OIOg+1XXcYMyB+lZvvjwOaoFj12aRz+EaeHbNGjFsHQojHxA
         8ogD1uD8gwA/aFz1ScjskCCrJPSgNoSyJ2ntkn3REdM9dtxeZ2DqMwHVz/BwVT8kppSe
         WJUJ5/TXpB/Tm+bKltCu0H6MzQu31/NHUiIMKDPgSSK2MhvlzLJpAaFhmCsV/uVE/tkV
         0SiAMGVJvULfx3wnevmZm2YY9wztbzRv03UVFLI88PPsAMOLr2t2XHZnyba70uv+89z5
         frng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=fthmjAQ3qNknjjUAbxlBIqQYx2nk8zF2dNW/rD+Mv+g=;
        b=f1fNRrAl5Xdynl29uZ+1zSV5k4P6BaVaLbtaUegm3isKiUaGoFQY0KTqDxsDbxxiJ8
         BTVEtNtrXwiupmWEx+uNvBDgf5CPAe8rEw7aw3JlcsghhXt01aIM7p3ir+AICngfXpp9
         S0JzGcedl3xHi/LwhcjYrLpCToc8HOyRRrGMIVjFqfSgqqOu6kmZxBXuaOtHLxHcwbb6
         w/noj18w4glgCgQ2n4T/2CGMEPAlIlLpxmXF+I81JNK5DXRW2V1KmJcsWr5QRcCx+gzy
         Bl8h/xK1hLWtwxZ8djHpk9VSgoJ6XIqP/LT+6o3EERF9U9ULqrPMzjzK4A9Gxq1089VK
         9+HQ==
X-Gm-Message-State: AOAM533SbK3GzOj/yu6a6dccVrH6plJyaM/LwOxy5lDGwNuDoYxIjSK6
        FEg1DoOCim7PnSW/GSnRpvdq3l+6EIHDpFVi
X-Google-Smtp-Source: ABdhPJx0YTTbAHFNYPnM+dTtuTPMOZK/jJd6iEKGbzkbSkNlbjnRIHX+QsB8aizYDdwrbrJDv4E/5Q==
X-Received: by 2002:a17:90a:5903:: with SMTP id k3mr11232632pji.104.1626367287652;
        Thu, 15 Jul 2021 09:41:27 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id h9sm8200857pgi.43.2021.07.15.09.41.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 15 Jul 2021 09:41:27 -0700 (PDT)
Message-ID: <60f06537.1c69fb81.8a895.84aa@mx.google.com>
Date:   Thu, 15 Jul 2021 09:41:27 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/4.14
X-Kernelci-Kernel: v4.14.239-207-g54be24367578
Subject: stable-rc/queue/4.14 baseline: 180 runs,
 5 regressions (v4.14.239-207-g54be24367578)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.14 baseline: 180 runs, 5 regressions (v4.14.239-207-g54be=
24367578)

Regressions Summary
-------------------

platform          | arch  | lab           | compiler | defconfig           =
| regressions
------------------+-------+---------------+----------+---------------------=
+------------
meson-gxm-q200    | arm64 | lab-baylibre  | gcc-8    | defconfig           =
| 1          =

panda             | arm   | lab-baylibre  | gcc-8    | omap2plus_defconfig =
| 1          =

rk3288-veyron-jaq | arm   | lab-collabora | gcc-8    | multi_v7_defconfig  =
| 3          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.14/ker=
nel/v4.14.239-207-g54be24367578/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.14
  Describe: v4.14.239-207-g54be24367578
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      54be24367578d5ac66b9044b8c0bfead2c8b2669 =



Test Regressions
---------------- =



platform          | arch  | lab           | compiler | defconfig           =
| regressions
------------------+-------+---------------+----------+---------------------=
+------------
meson-gxm-q200    | arm64 | lab-baylibre  | gcc-8    | defconfig           =
| 1          =


  Details:     https://kernelci.org/test/plan/id/60f033e02cb45598a08a93a2

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.239=
-207-g54be24367578/arm64/defconfig/gcc-8/lab-baylibre/baseline-meson-gxm-q2=
00.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.239=
-207-g54be24367578/arm64/defconfig/gcc-8/lab-baylibre/baseline-meson-gxm-q2=
00.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60f033e02cb45598a08a9=
3a3
        failing since 136 days (last pass: v4.14.222-11-g13b8482a0f700, fir=
st fail: v4.14.222-120-gdc8887cba23e) =

 =



platform          | arch  | lab           | compiler | defconfig           =
| regressions
------------------+-------+---------------+----------+---------------------=
+------------
panda             | arm   | lab-baylibre  | gcc-8    | omap2plus_defconfig =
| 1          =


  Details:     https://kernelci.org/test/plan/id/60f033fe9001c59fe78a93a7

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.239=
-207-g54be24367578/arm/omap2plus_defconfig/gcc-8/lab-baylibre/baseline-pand=
a.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.239=
-207-g54be24367578/arm/omap2plus_defconfig/gcc-8/lab-baylibre/baseline-pand=
a.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60f033fe9001c59fe78a9=
3a8
        new failure (last pass: v4.14.239-159-g430a97fa23346) =

 =



platform          | arch  | lab           | compiler | defconfig           =
| regressions
------------------+-------+---------------+----------+---------------------=
+------------
rk3288-veyron-jaq | arm   | lab-collabora | gcc-8    | multi_v7_defconfig  =
| 3          =


  Details:     https://kernelci.org/test/plan/id/60f037da2dbbdb36498a939b

  Results:     63 PASS, 6 FAIL, 1 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.239=
-207-g54be24367578/arm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-rk32=
88-veyron-jaq.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.239=
-207-g54be24367578/arm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-rk32=
88-veyron-jaq.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.bootrr.rockchip-iodomain-grf-probed: https://kernelci.org/test=
/case/id/60f037da2dbbdb36498a93b3
        failing since 30 days (last pass: v4.14.236-20-gdb14655bb4bf, first=
 fail: v4.14.236-49-gfd4c319f2583)

    2021-07-15T13:27:38.413303  /lava-4203570/1/../bin/lava-test-case
    2021-07-15T13:27:38.429182  [   16.636460] <LAVA_SIGNAL_TESTCASE TEST_C=
ASE_ID=3Drockchip-iodomain-grf-probed RESULT=3Dfail>   =


  * baseline.bootrr.dwmmc_rockchip-sdio0-probed: https://kernelci.org/test/=
case/id/60f037da2dbbdb36498a93cc
        failing since 30 days (last pass: v4.14.236-20-gdb14655bb4bf, first=
 fail: v4.14.236-49-gfd4c319f2583)

    2021-07-15T13:27:34.968255  /lava-4203570/1/../bin/lava-test-case[   13=
.186143] <LAVA_SIGNAL_TESTCASE TEST_CASE_ID=3Ddwmmc_rockchip-sdmmc-probed R=
ESULT=3Dfail>
    2021-07-15T13:27:34.968481  =

    2021-07-15T13:27:35.981574  /lava-4203570/1/../bin/lava-test-case
    2021-07-15T13:27:35.998860  [   14.204791] <LAVA_SIGNAL_TESTCASE TEST_C=
ASE_ID=3Ddwmmc_rockchip-sdio0-probed RESULT=3Dfail>
    2021-07-15T13:27:35.999192  /lava-4203570/1/../bin/lava-test-case   =


  * baseline.bootrr.dwmmc_rockchip-sdmmc-probed: https://kernelci.org/test/=
case/id/60f037da2dbbdb36498a93cd
        failing since 30 days (last pass: v4.14.236-20-gdb14655bb4bf, first=
 fail: v4.14.236-49-gfd4c319f2583) =

 =20
