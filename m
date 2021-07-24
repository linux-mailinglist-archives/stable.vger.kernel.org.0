Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B8E1E3D44F7
	for <lists+stable@lfdr.de>; Sat, 24 Jul 2021 06:46:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229586AbhGXEFs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 24 Jul 2021 00:05:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57836 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229550AbhGXEFs (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 24 Jul 2021 00:05:48 -0400
Received: from mail-pj1-x1031.google.com (mail-pj1-x1031.google.com [IPv6:2607:f8b0:4864:20::1031])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A6939C061575
        for <stable@vger.kernel.org>; Fri, 23 Jul 2021 21:46:19 -0700 (PDT)
Received: by mail-pj1-x1031.google.com with SMTP id j1so5039065pjv.3
        for <stable@vger.kernel.org>; Fri, 23 Jul 2021 21:46:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=FSX5eHKnjaF0rT/0cGp5kdQPs1st7di/LNu7W3WnPts=;
        b=JfdTAVFgGpNf+4Csd2dr39HK2P95vWCEGkr3jdQIrlyFY7/FKsU2+WgNCTF9xnv6gQ
         QvsliCxIJl8Dr8AR7ONx0xcJSCjjqbfAczj+nYPXIXa0iON/O8GnnFdhmNLjVsN2csYC
         e0uVjAcfro2VnYPC+wjAwc24KH6vio/uqwvuWSNEQfb62Z1WfRvp4HLUnPvFJNWaW8i6
         N7V7FQHDJ6KdHbI8JgqIh7Qv0Hvf7v9wK62sVb9kOH7i3Q8tsXvo7cJPSnw0+vv2kHUE
         3vz0P/4fAm7WvAUet9nU8vura7xavD6axU6Ho1MI/cz5J6w8y+WDdd4c/3IPQkTL23Fi
         WNTA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=FSX5eHKnjaF0rT/0cGp5kdQPs1st7di/LNu7W3WnPts=;
        b=IoLS0elmi0ZC3P0Z41M6ARZjUlDXLQQXzSG2wmiyL81AOIDlzNjW6Z1L8nXUoZiBB6
         rVrsJeLxbEp7R1VuKl3bxVfL+bx68UVipjbRkpmXgK/bC0MV4fwam/c2EeKo9wKmp86/
         ULxxnX4u4iScmvzQkA8y99JTn2x8cP64NGQgJX37pmdcCiWiuzjX9ly6jaF9e+Bk3XjI
         bIJ9BdHuiU+PO5eK+crw8FJYVQtJ9EDQdEE2rSwGFbhxSoMILTMCBMlYW8PCAMhvwtxS
         KsU86wG+0YpkH/7PRwEQEgKRZuBoj6pUtzDiKTHkYROwSiIAizw0JBtombmJ19mYlXg7
         xbOA==
X-Gm-Message-State: AOAM532mgHzgkQsmLkIeo0z93s7nBVWN7XF2i1GkuFckd9/kgtWW5QQP
        ppSw9omwQ7XSrBngxsjCzLkMovUi13cxn5am
X-Google-Smtp-Source: ABdhPJyb9WVP4bGIBc67qNctqnzCkcoi2+JMAjE6nienltgDV4ziN8Y/4fADNv4M4PIkzif012Pevg==
X-Received: by 2002:a17:902:6509:b029:12b:5175:43b8 with SMTP id b9-20020a1709026509b029012b517543b8mr6532008plk.60.1627101978878;
        Fri, 23 Jul 2021 21:46:18 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id h24sm36585526pfn.180.2021.07.23.21.46.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 23 Jul 2021 21:46:18 -0700 (PDT)
Message-ID: <60fb9b1a.1c69fb81.f2d88.f503@mx.google.com>
Date:   Fri, 23 Jul 2021 21:46:18 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: queue/5.10
X-Kernelci-Kernel: v5.10.51-362-g3c5cb67dccf3
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
Subject: stable-rc/queue/5.10 baseline: 189 runs,
 7 regressions (v5.10.51-362-g3c5cb67dccf3)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.10 baseline: 189 runs, 7 regressions (v5.10.51-362-g3c5cb=
67dccf3)

Regressions Summary
-------------------

platform                | arch  | lab           | compiler | defconfig     =
     | regressions
------------------------+-------+---------------+----------+---------------=
-----+------------
bcm2837-rpi-3-b-32      | arm   | lab-baylibre  | gcc-8    | bcm2835_defcon=
fig  | 1          =

meson-gxm-q200          | arm64 | lab-baylibre  | gcc-8    | defconfig     =
     | 2          =

rk3288-veyron-jaq       | arm   | lab-collabora | gcc-8    | multi_v7_defco=
nfig | 3          =

sun50i-a64-bananapi-m64 | arm64 | lab-clabbe    | gcc-8    | defconfig     =
     | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.10/ker=
nel/v5.10.51-362-g3c5cb67dccf3/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.10
  Describe: v5.10.51-362-g3c5cb67dccf3
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      3c5cb67dccf32b3b2349007ca5b3551bfb9b9864 =



Test Regressions
---------------- =



platform                | arch  | lab           | compiler | defconfig     =
     | regressions
------------------------+-------+---------------+----------+---------------=
-----+------------
bcm2837-rpi-3-b-32      | arm   | lab-baylibre  | gcc-8    | bcm2835_defcon=
fig  | 1          =


  Details:     https://kernelci.org/test/plan/id/60fb61c53c827226ae3a2f22

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: bcm2835_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.51-=
362-g3c5cb67dccf3/arm/bcm2835_defconfig/gcc-8/lab-baylibre/baseline-bcm2837=
-rpi-3-b-32.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.51-=
362-g3c5cb67dccf3/arm/bcm2835_defconfig/gcc-8/lab-baylibre/baseline-bcm2837=
-rpi-3-b-32.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60fb61c53c827226ae3a2=
f23
        failing since 0 day (last pass: v5.10.51-363-gc7603cd6c337, first f=
ail: v5.10.51-363-g9821f32d9c36) =

 =



platform                | arch  | lab           | compiler | defconfig     =
     | regressions
------------------------+-------+---------------+----------+---------------=
-----+------------
meson-gxm-q200          | arm64 | lab-baylibre  | gcc-8    | defconfig     =
     | 2          =


  Details:     https://kernelci.org/test/plan/id/60fb65da91bfc8a0593a2f5d

  Results:     4 PASS, 2 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.51-=
362-g3c5cb67dccf3/arm64/defconfig/gcc-8/lab-baylibre/baseline-meson-gxm-q20=
0.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.51-=
362-g3c5cb67dccf3/arm64/defconfig/gcc-8/lab-baylibre/baseline-meson-gxm-q20=
0.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/arm64/baseline/rootfs.cpio.gz =



  * baseline.dmesg.alert: https://kernelci.org/test/case/id/60fb65da91bfc8a=
0593a2f64
        new failure (last pass: v5.10.51-363-g9821f32d9c36)
        7 lines =


  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/60fb65da91bfc8a=
0593a2f65
        new failure (last pass: v5.10.51-363-g9821f32d9c36)
        2 lines

    2021-07-24T00:58:39.498052  kern  :alert : [000b000000208c80] address b=
etween user and kernel address ranges
    2021-07-24T00:58:39.498360  kern  :emerg : Internal error: Oops: 860000=
04 [#1] PREEMPT SMP
    2021-07-24T00:58:39.498553  kern  :emerg : Code: bad PC value
    2021-07-24T00:58:39.498698  <8>[   16.727069] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Demerg RESULT=3Dfail UNITS=3Dlines MEASUREMENT=3D2>
    2021-07-24T00:58:39.498929  + set +x
    2021-07-24T00:58:39.499146  <8>[   16.731599] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 591709_1.5.2.4.1>   =

 =



platform                | arch  | lab           | compiler | defconfig     =
     | regressions
------------------------+-------+---------------+----------+---------------=
-----+------------
rk3288-veyron-jaq       | arm   | lab-collabora | gcc-8    | multi_v7_defco=
nfig | 3          =


  Details:     https://kernelci.org/test/plan/id/60fb828d37279c33cf3a2f31

  Results:     67 PASS, 3 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.51-=
362-g3c5cb67dccf3/arm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-rk328=
8-veyron-jaq.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.51-=
362-g3c5cb67dccf3/arm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-rk328=
8-veyron-jaq.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.bootrr.rockchip-iodomain-grf-probed: https://kernelci.org/test=
/case/id/60fb828d37279c33cf3a2f45
        failing since 38 days (last pass: v5.10.43-44-g253317604975, first =
fail: v5.10.43-130-g87b5f83f722c)

    2021-07-24T03:01:19.026459  /lava-4240472/1/../bin/lava-test-case
    2021-07-24T03:01:19.043604  <8>[   13.994102] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Drockchip-iodomain-grf-probed RESULT=3Dfail>   =


  * baseline.bootrr.dwmmc_rockchip-sdio0-probed: https://kernelci.org/test/=
case/id/60fb828d37279c33cf3a2f5c
        failing since 38 days (last pass: v5.10.43-44-g253317604975, first =
fail: v5.10.43-130-g87b5f83f722c)

    2021-07-24T03:01:17.603512  /lava-4240472/1/../bin/lava-test-case
    2021-07-24T03:01:17.621063  <8>[   12.571352] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Ddwmmc_rockchip-sdio0-probed RESULT=3Dfail>
    2021-07-24T03:01:17.621289  /lava-4240472/1/../bin/lava-test-case   =


  * baseline.bootrr.dwmmc_rockchip-sdmmc-probed: https://kernelci.org/test/=
case/id/60fb828d37279c33cf3a2f5d
        failing since 38 days (last pass: v5.10.43-44-g253317604975, first =
fail: v5.10.43-130-g87b5f83f722c)

    2021-07-24T03:01:16.585063  /lava-4240472/1/../bin/lava-test-case
    2021-07-24T03:01:16.590481  <8>[   11.552159] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Ddwmmc_rockchip-sdmmc-probed RESULT=3Dfail>   =

 =



platform                | arch  | lab           | compiler | defconfig     =
     | regressions
------------------------+-------+---------------+----------+---------------=
-----+------------
sun50i-a64-bananapi-m64 | arm64 | lab-clabbe    | gcc-8    | defconfig     =
     | 1          =


  Details:     https://kernelci.org/test/plan/id/60fb6678047ed7ab613a2f41

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.51-=
362-g3c5cb67dccf3/arm64/defconfig/gcc-8/lab-clabbe/baseline-sun50i-a64-bana=
napi-m64.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.51-=
362-g3c5cb67dccf3/arm64/defconfig/gcc-8/lab-clabbe/baseline-sun50i-a64-bana=
napi-m64.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60fb6678047ed7ab613a2=
f42
        new failure (last pass: v5.10.51-363-g9821f32d9c36) =

 =20
