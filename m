Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 433EA3B390C
	for <lists+stable@lfdr.de>; Fri, 25 Jun 2021 00:04:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232650AbhFXWGh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 24 Jun 2021 18:06:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35096 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232778AbhFXWGd (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 24 Jun 2021 18:06:33 -0400
Received: from mail-pj1-x1034.google.com (mail-pj1-x1034.google.com [IPv6:2607:f8b0:4864:20::1034])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7380CC061574
        for <stable@vger.kernel.org>; Thu, 24 Jun 2021 15:04:13 -0700 (PDT)
Received: by mail-pj1-x1034.google.com with SMTP id bb10-20020a17090b008ab029016eef083425so6750502pjb.5
        for <stable@vger.kernel.org>; Thu, 24 Jun 2021 15:04:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=NPjYw9sIJEB8q4gYEN7aJPN9ywHF5M9kbnLHHkTYZgc=;
        b=q6neU4PllZDxVdkJMx+9BliWOnnZDAKZN4uo5/iApGpk9V50kKhPmY74VelGoEHKcJ
         0BqpI9OfaTkhEKiZRKVCJRUVo3IIXL6Vi6XQFILKu98uHDXrxZvySgxjt6WANKbedmeP
         a4E9mIkG5CGEERLxkbgyc5duPyvKm+nxJoyxdV3EMO89yj4hCTEBjZJxzowP4LFhANyS
         vpKdWWYfb/7aKlcndNFslqpoQaXHNUcz8PFK4h6WODEEpASOhlBf4YxvVgNA0x2OsrqM
         DMocK8yIuyAsYCwAZpxvGHPGTSVllTl53joK+I7XlR10RN7KDSrqkksvXSAZDt9hHF85
         XV7g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=NPjYw9sIJEB8q4gYEN7aJPN9ywHF5M9kbnLHHkTYZgc=;
        b=YUP/jzbeernbs2/4M0mr/7ijfW3TmbWtkiBhJbpRjCCZcHw7fT1lAPXGRVFSZ9DKPm
         mEVQ+x8TNAAXJkb2ZJ5MyKGmqXIWjO3Pml84YDQH5lM84S6q695cQ0C5t0V0qjsicYhp
         77VPrQNc3oyf9eklzok+lxq0bGs/7rxKh3Q3OuUHSv/IuCLLWRyX2VOyNLFCHFQ3rhbe
         TYQhHmlRcblqTFtxP9h17lOzclCbprRBLXN/JbnUmGDEe4GdlSPtiD75VTJ7B+jlInjr
         D4YPcZzX6aEIT6k6D7PfaRhUlGTnKboEmnQ3oRkle9YyEVfd7HlYAJUBJgix9X6fCwYc
         aUeg==
X-Gm-Message-State: AOAM530WmKqebDKoPYkXTIwtLnVjMjF4rFzVq3lQCg1i1XoEgAiwDpiw
        0YSwjOjFbv80eNEAm9xhcDOndYN7clNc970y
X-Google-Smtp-Source: ABdhPJzf4oDG+iRGpml+jprJW67tnMgo+Hmq+SxXckzbRrPKiPCzR3meq9eR0Pm2F9QR0BY/Hwr9/g==
X-Received: by 2002:a17:902:8484:b029:101:7016:fb7b with SMTP id c4-20020a1709028484b02901017016fb7bmr5904908plo.23.1624572252777;
        Thu, 24 Jun 2021 15:04:12 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id g4sm3734780pfu.134.2021.06.24.15.04.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 24 Jun 2021 15:04:12 -0700 (PDT)
Message-ID: <60d5015c.1c69fb81.5f7fc.b30e@mx.google.com>
Date:   Thu, 24 Jun 2021 15:04:12 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v4.14.237-64-g3b75f7a3da8b
X-Kernelci-Branch: queue/4.14
X-Kernelci-Tree: stable-rc
Subject: stable-rc/queue/4.14 baseline: 124 runs,
 4 regressions (v4.14.237-64-g3b75f7a3da8b)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.14 baseline: 124 runs, 4 regressions (v4.14.237-64-g3b75f=
7a3da8b)

Regressions Summary
-------------------

platform          | arch  | lab           | compiler | defconfig          |=
 regressions
------------------+-------+---------------+----------+--------------------+=
------------
meson-gxm-q200    | arm64 | lab-baylibre  | gcc-8    | defconfig          |=
 1          =

rk3288-veyron-jaq | arm   | lab-collabora | gcc-8    | multi_v7_defconfig |=
 3          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.14/ker=
nel/v4.14.237-64-g3b75f7a3da8b/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.14
  Describe: v4.14.237-64-g3b75f7a3da8b
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      3b75f7a3da8bafd92596e9d91a8e854f047e32db =



Test Regressions
---------------- =



platform          | arch  | lab           | compiler | defconfig          |=
 regressions
------------------+-------+---------------+----------+--------------------+=
------------
meson-gxm-q200    | arm64 | lab-baylibre  | gcc-8    | defconfig          |=
 1          =


  Details:     https://kernelci.org/test/plan/id/60d4ebfd73bba67d54413283

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.237=
-64-g3b75f7a3da8b/arm64/defconfig/gcc-8/lab-baylibre/baseline-meson-gxm-q20=
0.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.237=
-64-g3b75f7a3da8b/arm64/defconfig/gcc-8/lab-baylibre/baseline-meson-gxm-q20=
0.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60d4ebfd73bba67d54413=
284
        failing since 115 days (last pass: v4.14.222-11-g13b8482a0f700, fir=
st fail: v4.14.222-120-gdc8887cba23e) =

 =



platform          | arch  | lab           | compiler | defconfig          |=
 regressions
------------------+-------+---------------+----------+--------------------+=
------------
rk3288-veyron-jaq | arm   | lab-collabora | gcc-8    | multi_v7_defconfig |=
 3          =


  Details:     https://kernelci.org/test/plan/id/60d4ff434fedb2d14441326f

  Results:     62 PASS, 6 FAIL, 1 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.237=
-64-g3b75f7a3da8b/arm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-rk328=
8-veyron-jaq.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.237=
-64-g3b75f7a3da8b/arm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-rk328=
8-veyron-jaq.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.bootrr.dwmmc_rockchip-sdmmc-probed: https://kernelci.org/test/=
case/id/60d4ff434fedb2d14441328b
        failing since 9 days (last pass: v4.14.236-20-gdb14655bb4bf, first =
fail: v4.14.236-49-gfd4c319f2583) =


  * baseline.bootrr.dwmmc_rockchip-sdio0-probed: https://kernelci.org/test/=
case/id/60d4ff434fedb2d14441328c
        failing since 9 days (last pass: v4.14.236-20-gdb14655bb4bf, first =
fail: v4.14.236-49-gfd4c319f2583)

    2021-06-24T21:55:07.779891  /lava-4089695/1/../bin/lava-test-case[   13=
.369140] <LAVA_SIGNAL_TESTCASE TEST_CASE_ID=3Ddwmmc_rockchip-sdmmc-probed R=
ESULT=3Dfail>
    2021-06-24T21:55:07.780160  =

    2021-06-24T21:55:08.795697  /lava-4089695/1/../bin/lava-test-case
    2021-06-24T21:55:08.811564  [   14.387608] <LAVA_SIGNAL_TESTCASE TEST_C=
ASE_ID=3Ddwmmc_rockchip-sdio0-probed RESULT=3Dfail>   =


  * baseline.bootrr.rockchip-iodomain-grf-probed: https://kernelci.org/test=
/case/id/60d4ff434fedb2d1444132a5
        failing since 9 days (last pass: v4.14.236-20-gdb14655bb4bf, first =
fail: v4.14.236-49-gfd4c319f2583)

    2021-06-24T21:55:11.224162  /lava-4089695/1/../bin/lava-test-case
    2021-06-24T21:55:11.240395  [   16.818685] <LAVA_SIGNAL_TESTCASE TEST_C=
ASE_ID=3Drockchip-iodomain-grf-probed RESULT=3Dfail>
    2021-06-24T21:55:11.240641  /lava-4089695/1/../bin/lava-test-case   =

 =20
