Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3B36F3B4D33
	for <lists+stable@lfdr.de>; Sat, 26 Jun 2021 08:46:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229573AbhFZGtO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 26 Jun 2021 02:49:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46394 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229518AbhFZGtO (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 26 Jun 2021 02:49:14 -0400
Received: from mail-pf1-x42e.google.com (mail-pf1-x42e.google.com [IPv6:2607:f8b0:4864:20::42e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3AA13C061574
        for <stable@vger.kernel.org>; Fri, 25 Jun 2021 23:46:52 -0700 (PDT)
Received: by mail-pf1-x42e.google.com with SMTP id 21so9287440pfp.3
        for <stable@vger.kernel.org>; Fri, 25 Jun 2021 23:46:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=ZJNIDLY41w63B5NMg65S0+W89UZ+wI4uAueQlXXv+ew=;
        b=snhoKuOGDJkk32R7mSghBtze5joWTFCqE0acVE0VZh9K+d6FN3tzQyH6MbIcmZhh97
         8SQKfujZggKXvE9U+9fdFHH4OsB4or3PAuUiHvnAlRjb9bACxw7uLIkji1ntBrrxxLmF
         dYs2TnZZGbSkk0sofYE2rmQnOnxXrvAtMAGtlcTUuUwtAJVA+yqLXSEWDTuuHFVeczK0
         sI01euFduO+xW82Ctbo5mUoYq3dbFtJSCGuixXPGUaAN8z2qHDZV5tDWcflIaae8XBKX
         02GBs3cHQQe/f3tR+PAnpsVL3czN6NMYlDOpCtkns1ate6OPqAFW81/GvBOnNmehw7zO
         /gEA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=ZJNIDLY41w63B5NMg65S0+W89UZ+wI4uAueQlXXv+ew=;
        b=gd/YC/iF+pHyCpJxx0wd0WVswF/UCfUC0XuSPOyDULHGAvIufFKGGHgGTWX0WoWwya
         bWzs6v1ywSoEh++xnA/Gc8hlgxqzBj2I0cbI1z3as4/ohd8HBYm9Rs20OJxc/AIyJlxs
         cYUD17hxin0p0dWL0UU2yijorx3LBEGJWdPOc4kun75VQhvVT/NKmh/K9HkEdTgi4IUb
         kkHp/4cC5Xtkud5tXS0bYmdXko8fJIp6g9CoHegtU2nbynslMltgqrk/i0vOoRt9t7WI
         OHTHuh+UlJTjQ2JFC+HqAYyVdG+aFs0c9Qvc6YjkORSp1rVj4J5n4wHEjTin9A4HtKvQ
         s68w==
X-Gm-Message-State: AOAM530IoLmxW1V0Gpr6Hdgtc3ntM1HsVaLh4SaLs/0eKlNtJR/l1jbm
        5DL1PxoWX3wmsiveWIhVuXmPYPvjrFR7klp1
X-Google-Smtp-Source: ABdhPJw2pF1E6wJuw+LOHS7apcytMHaysSUtJ+OFDZzfOmNn4uiLmdmH/84gYyRRhebIuqn7XAzO5A==
X-Received: by 2002:aa7:8615:0:b029:303:4428:9dbe with SMTP id p21-20020aa786150000b029030344289dbemr14223486pfn.17.1624690011219;
        Fri, 25 Jun 2021 23:46:51 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id b126sm7711910pfg.176.2021.06.25.23.46.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 25 Jun 2021 23:46:50 -0700 (PDT)
Message-ID: <60d6cd5a.1c69fb81.a22ee.6960@mx.google.com>
Date:   Fri, 25 Jun 2021 23:46:50 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v4.14.237-84-g6a0acfa1dd02
X-Kernelci-Branch: queue/4.14
X-Kernelci-Tree: stable-rc
Subject: stable-rc/queue/4.14 baseline: 149 runs,
 4 regressions (v4.14.237-84-g6a0acfa1dd02)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.14 baseline: 149 runs, 4 regressions (v4.14.237-84-g6a0ac=
fa1dd02)

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
nel/v4.14.237-84-g6a0acfa1dd02/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.14
  Describe: v4.14.237-84-g6a0acfa1dd02
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      6a0acfa1dd021abdb0b2aaa3904cf5142bbde738 =



Test Regressions
---------------- =



platform          | arch  | lab           | compiler | defconfig          |=
 regressions
------------------+-------+---------------+----------+--------------------+=
------------
meson-gxm-q200    | arm64 | lab-baylibre  | gcc-8    | defconfig          |=
 1          =


  Details:     https://kernelci.org/test/plan/id/60d69c8e788300484e41326b

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.237=
-84-g6a0acfa1dd02/arm64/defconfig/gcc-8/lab-baylibre/baseline-meson-gxm-q20=
0.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.237=
-84-g6a0acfa1dd02/arm64/defconfig/gcc-8/lab-baylibre/baseline-meson-gxm-q20=
0.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60d69c8e788300484e413=
26c
        failing since 116 days (last pass: v4.14.222-11-g13b8482a0f700, fir=
st fail: v4.14.222-120-gdc8887cba23e) =

 =



platform          | arch  | lab           | compiler | defconfig          |=
 regressions
------------------+-------+---------------+----------+--------------------+=
------------
rk3288-veyron-jaq | arm   | lab-collabora | gcc-8    | multi_v7_defconfig |=
 3          =


  Details:     https://kernelci.org/test/plan/id/60d6a08bc7b99d1191413283

  Results:     62 PASS, 6 FAIL, 1 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.237=
-84-g6a0acfa1dd02/arm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-rk328=
8-veyron-jaq.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.237=
-84-g6a0acfa1dd02/arm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-rk328=
8-veyron-jaq.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.bootrr.dwmmc_rockchip-sdmmc-probed: https://kernelci.org/test/=
case/id/60d6a08bc7b99d119141329f
        failing since 10 days (last pass: v4.14.236-20-gdb14655bb4bf, first=
 fail: v4.14.236-49-gfd4c319f2583)

    2021-06-26T03:35:24.079142  /lava-4098638/1/../bin/lava-test-case
    2021-06-26T03:35:24.085261  [   12.992965] <LAVA_SIGNAL_TESTCASE TEST_C=
ASE_ID=3Ddwmmc_rockchip-sdmmc-probed RESULT=3Dfail>   =


  * baseline.bootrr.dwmmc_rockchip-sdio0-probed: https://kernelci.org/test/=
case/id/60d6a08bc7b99d11914132a0
        failing since 10 days (last pass: v4.14.236-20-gdb14655bb4bf, first=
 fail: v4.14.236-49-gfd4c319f2583)

    2021-06-26T03:35:25.099278  /lava-4098638/1/../bin/lava-test-case
    2021-06-26T03:35:25.116870  [   14.011878] <LAVA_SIGNAL_TESTCASE TEST_C=
ASE_ID=3Ddwmmc_rockchip-sdio0-probed RESULT=3Dfail>
    2021-06-26T03:35:25.117425  /lava-4098638/1/../bin/lava-test-case   =


  * baseline.bootrr.rockchip-iodomain-grf-probed: https://kernelci.org/test=
/case/id/60d6a08bc7b99d11914132b9
        failing since 10 days (last pass: v4.14.236-20-gdb14655bb4bf, first=
 fail: v4.14.236-49-gfd4c319f2583)

    2021-06-26T03:35:27.530268  /lava-4098638/1/../bin/lava-test-case
    2021-06-26T03:35:27.546687  [   16.443219] <LAVA_SIGNAL_TESTCASE TEST_C=
ASE_ID=3Drockchip-iodomain-grf-probed RESULT=3Dfail>
    2021-06-26T03:35:27.546993  /lava-4098638/1/../bin/lava-test-case   =

 =20
