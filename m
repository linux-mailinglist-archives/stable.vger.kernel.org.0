Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 94F093E8918
	for <lists+stable@lfdr.de>; Wed, 11 Aug 2021 06:08:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229530AbhHKEI4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 11 Aug 2021 00:08:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54236 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233499AbhHKEIz (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 11 Aug 2021 00:08:55 -0400
Received: from mail-pl1-x62a.google.com (mail-pl1-x62a.google.com [IPv6:2607:f8b0:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A647EC0613D3
        for <stable@vger.kernel.org>; Tue, 10 Aug 2021 21:08:32 -0700 (PDT)
Received: by mail-pl1-x62a.google.com with SMTP id b7so978809plh.7
        for <stable@vger.kernel.org>; Tue, 10 Aug 2021 21:08:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=Q+J798lBBRmuHYKAIFnrL3oDioL3JmuviLl0PdZowuM=;
        b=L2FlKoVOc9hXASWnReqnn7UJiHP3I/avh3/H90ffKWeZyyXonnfZI/l9wD1+EX4id2
         GJNB2dgH0ZMcJzEIu7QOXnEp/MHOAqahmHbH+LIkDtb7s3ICfLow0wfnnZVqt2UqUX5F
         Aw4IQ0RiLE/h6PSj0ihfTL+y45UedoIEgAZhrnPoaZXsFieBpUh3wqJYsLrWMIEAn1xH
         U1nS+qtReEUJ7mo+OFPVD1Y9+EN6q10BcXlO93ADUxCWpZ/FTJRVy6OeoZ4fLX1LOGdA
         5AMpBqjb/1LvdHqr4QfmNjLYj+u+aTVH5dIbRRHMeTv1zgr+KWLw9/5ghkz2rhjFr4LN
         y+gw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=Q+J798lBBRmuHYKAIFnrL3oDioL3JmuviLl0PdZowuM=;
        b=OAc4ZtmZ7nkkhHMjSsaddKGrN7/5LwtwDCMeixP3PcIKzktBcrYy7nvZ7hQihRBuNx
         ySBwjzRGGAq2Ke+KVER9uPoxtVU0cva5zzP7FbJNv5rbyAbvRJCckhV4wCEmuymVFXQi
         3Dl/+vEAt2nqyxHfQytmN0+CdaRa2eW5a5UnsVy8dZYo9VT2UYlGinP7N2H267iLOqjy
         jRB9sgmwaOBmZKq4TURsRCfr84W46jwZXkPY0eLVlIrs4NxjEe6aEPnv27k9IVqQGSy8
         +3GbbIA8Tx721UL1N6/ma1/G4A1cLo7kTxu2uzyDAk6G6+EQJMj9c5fpEesIZdNt7/XJ
         HkxA==
X-Gm-Message-State: AOAM5318ypJ4dtQBOYSUN8JVIFidOXaYFpF2ZgTk6gayw/6SP+dHlOqq
        kcTGKy7um3qS0F8HygCbfgyyLNIfZTmj4swg
X-Google-Smtp-Source: ABdhPJx3N891G/v8A6fupZnMKsDR1gNaw0AkFablIy9O4UvjUzw+3MU5l7iZkET1YPz7RJHWpPMRYg==
X-Received: by 2002:a17:90a:2c05:: with SMTP id m5mr35872063pjd.32.1628654911987;
        Tue, 10 Aug 2021 21:08:31 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id o22sm25008343pfu.87.2021.08.10.21.08.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 10 Aug 2021 21:08:31 -0700 (PDT)
Message-ID: <61134d3f.1c69fb81.b764.a8ce@mx.google.com>
Date:   Tue, 10 Aug 2021 21:08:31 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: linux-4.14.y
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v4.14.243-39-g7d5ea050a415
X-Kernelci-Report-Type: test
Subject: stable-rc/linux-4.14.y baseline: 83 runs,
 6 regressions (v4.14.243-39-g7d5ea050a415)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.14.y baseline: 83 runs, 6 regressions (v4.14.243-39-g7d5e=
a050a415)

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

qemu_arm-versatilepb | arm  | lab-collabora | gcc-8    | versatile_defconfi=
g | 1          =

rk3288-veyron-jaq    | arm  | lab-collabora | gcc-8    | multi_v7_defconfig=
  | 3          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-4.14.y/ker=
nel/v4.14.243-39-g7d5ea050a415/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-4.14.y
  Describe: v4.14.243-39-g7d5ea050a415
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      7d5ea050a415653564ff6cf2774763d1361f3af4 =



Test Regressions
---------------- =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-baylibre  | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/61131392d69da2791cb13685

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
43-39-g7d5ea050a415/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qem=
u_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
43-39-g7d5ea050a415/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qem=
u_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61131392d69da2791cb13=
686
        failing since 269 days (last pass: v4.14.206-21-gf1262f26e4d0, firs=
t fail: v4.14.206-23-g520c3568920c8) =

 =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-broonie   | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/61131390f1327007e9b1366b

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
43-39-g7d5ea050a415/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu=
_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
43-39-g7d5ea050a415/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu=
_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61131390f1327007e9b13=
66c
        failing since 269 days (last pass: v4.14.206-21-gf1262f26e4d0, firs=
t fail: v4.14.206-23-g520c3568920c8) =

 =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-collabora | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/6113133c5e9533c5c5b13661

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
43-39-g7d5ea050a415/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qe=
mu_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
43-39-g7d5ea050a415/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qe=
mu_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6113133c5e9533c5c5b13=
662
        failing since 269 days (last pass: v4.14.206-21-gf1262f26e4d0, firs=
t fail: v4.14.206-23-g520c3568920c8) =

 =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
rk3288-veyron-jaq    | arm  | lab-collabora | gcc-8    | multi_v7_defconfig=
  | 3          =


  Details:     https://kernelci.org/test/plan/id/61131a16497216e3d4b13682

  Results:     63 PASS, 6 FAIL, 1 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
43-39-g7d5ea050a415/arm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-rk3=
288-veyron-jaq.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
43-39-g7d5ea050a415/arm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-rk3=
288-veyron-jaq.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.bootrr.rockchip-iodomain-grf-probed: https://kernelci.org/test=
/case/id/61131a16497216e3d4b1369a
        failing since 57 days (last pass: v4.14.236, first fail: v4.14.236-=
50-g2e03cf25d5d0)

    2021-08-11T00:29:57.037643  /lava-4345207/1/../bin/lava-test-case
    2021-08-11T00:29:57.053945  [   16.897235] <LAVA_SIGNAL_TESTCASE TEST_C=
ASE_ID=3Drockchip-iodomain-grf-probed RESULT=3Dfail>
    2021-08-11T00:29:57.054238  /lava-4345207/1/../bin/lava-test-case   =


  * baseline.bootrr.dwmmc_rockchip-sdio0-probed: https://kernelci.org/test/=
case/id/61131a16497216e3d4b136b3
        failing since 57 days (last pass: v4.14.236, first fail: v4.14.236-=
50-g2e03cf25d5d0)

    2021-08-11T00:29:53.590575  /lava-4345207/1/../bin/lava-test-case[   13=
.446223] <LAVA_SIGNAL_TESTCASE TEST_CASE_ID=3Ddwmmc_rockchip-sdmmc-probed R=
ESULT=3Dfail>
    2021-08-11T00:29:53.591017  =

    2021-08-11T00:29:54.604699  /lava-4345207/1/../bin/lava-test-case
    2021-08-11T00:29:54.623253  [   14.464966] <LAVA_SIGNAL_TESTCASE TEST_C=
ASE_ID=3Ddwmmc_rockchip-sdio0-probed RESULT=3Dfail>
    2021-08-11T00:29:54.623742  /lava-4345207/1/../bin/lava-test-case   =


  * baseline.bootrr.dwmmc_rockchip-sdmmc-probed: https://kernelci.org/test/=
case/id/61131a16497216e3d4b136b4
        failing since 57 days (last pass: v4.14.236, first fail: v4.14.236-=
50-g2e03cf25d5d0) =

 =20
