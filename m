Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 648F33BBE66
	for <lists+stable@lfdr.de>; Mon,  5 Jul 2021 16:49:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231458AbhGEOwO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 5 Jul 2021 10:52:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57374 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230504AbhGEOwO (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 5 Jul 2021 10:52:14 -0400
Received: from mail-pf1-x429.google.com (mail-pf1-x429.google.com [IPv6:2607:f8b0:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BE879C061574
        for <stable@vger.kernel.org>; Mon,  5 Jul 2021 07:49:36 -0700 (PDT)
Received: by mail-pf1-x429.google.com with SMTP id f20so8958194pfa.1
        for <stable@vger.kernel.org>; Mon, 05 Jul 2021 07:49:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=ox1CT3jZI1VZBy72w6oP57nKijh30TWCfHO6uIsc6Iw=;
        b=NZAGZfQSFWvvJBaz2wPijAOwHOobcn/IJ52WPulTyZdg9LysKHnNCfamMgdnL2LMnC
         O/TN/onpwZsCIHS5RlBac9Jm+eGu8fuITGF/eafv2pKOKr+mv8OYwakojaY9HT0dh7yo
         FABLhJOOSgCbrbwiaiQJr54bF3NrYNTOMTkgXDpbYZ0bK1ZhBd56n2RF8qoZyqePdFtk
         Me3t4M3xXl2vRYP1IvCVykLIZWmbq9jxEOp/O2Pd+XkmfjrcsunqoHF8VM30JZ6or8th
         lFuibDBUtQoi8G4AeNve/l8O9/dlq+aUyX5smE0VYqmOVI7mxDHPhBEoxl6ufXcUeRb9
         Db+w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=ox1CT3jZI1VZBy72w6oP57nKijh30TWCfHO6uIsc6Iw=;
        b=aMFxrgAwYhaRzUkuribQ3egItybnujI4ikNUqQ/eroJ+6n72XKdbTAk5bV5q8rnAsT
         CiGzs7fcz6xpNI4P0PhJ31JhLOxgy6zgE29WkQUpMeSnYS6sgsOd1tnG2vCzW88Y9CAQ
         BQ8wmmq4blXX2BPMO16Ud8Fl4IyeeDYaxsr51IxGQg36GFj8qaKccn3LGmBV8dQ3UOZz
         2EBgeNaPFOb193wwnTovPYmZ6MgBX1mlyd7JbE/7DIfYoUGXmNkBZ/GYN227tsEDcXMS
         hHHOzfXljUt24pGKebj4iR8cmXdfNkHyTgbmY4ehvyMFjfZsKdUF7sHPOSaptMBYAXmG
         x08Q==
X-Gm-Message-State: AOAM531ULUImg24qOZhYBa9HrBPXdGQywvDxngmNtR4Ua3RxyLBUF7hv
        Ncp0acDTJCBWd4/CN3A+lEUZQSbLRvZ0WUzK
X-Google-Smtp-Source: ABdhPJzukDnECqpVeGrbr6wb0xCJcgxaE7xG2tE9o+b75aPtS2P5+wRobCuQuqPv9swu4CQOPOihYg==
X-Received: by 2002:a62:7e91:0:b029:315:155c:d555 with SMTP id z139-20020a627e910000b0290315155cd555mr15322899pfc.27.1625496576160;
        Mon, 05 Jul 2021 07:49:36 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id t2sm12968736pfg.73.2021.07.05.07.49.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 05 Jul 2021 07:49:35 -0700 (PDT)
Message-ID: <60e31bff.1c69fb81.e530a.61bf@mx.google.com>
Date:   Mon, 05 Jul 2021 07:49:35 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v5.4.129-6-g420a8ce29e61
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-5.4.y
Subject: stable-rc/linux-5.4.y baseline: 173 runs,
 4 regressions (v5.4.129-6-g420a8ce29e61)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-5.4.y baseline: 173 runs, 4 regressions (v5.4.129-6-g420a8c=
e29e61)

Regressions Summary
-------------------

platform             | arch  | lab           | compiler | defconfig        =
  | regressions
---------------------+-------+---------------+----------+------------------=
--+------------
hifive-unleashed-a00 | riscv | lab-baylibre  | gcc-8    | defconfig        =
  | 1          =

rk3288-veyron-jaq    | arm   | lab-collabora | gcc-8    | multi_v7_defconfi=
g | 3          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-5.4.y/kern=
el/v5.4.129-6-g420a8ce29e61/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-5.4.y
  Describe: v5.4.129-6-g420a8ce29e61
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      420a8ce29e610f3d9be6449dff1e2bb9a9c14ee5 =



Test Regressions
---------------- =



platform             | arch  | lab           | compiler | defconfig        =
  | regressions
---------------------+-------+---------------+----------+------------------=
--+------------
hifive-unleashed-a00 | riscv | lab-baylibre  | gcc-8    | defconfig        =
  | 1          =


  Details:     https://kernelci.org/test/plan/id/60e2e69e95d9678f24117986

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (riscv64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.129=
-6-g420a8ce29e61/riscv/defconfig/gcc-8/lab-baylibre/baseline-hifive-unleash=
ed-a00.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.129=
-6-g420a8ce29e61/riscv/defconfig/gcc-8/lab-baylibre/baseline-hifive-unleash=
ed-a00.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/riscv/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60e2e69e95d9678f24117=
987
        failing since 227 days (last pass: v5.4.77-152-ga3746663c3479, firs=
t fail: v5.4.78) =

 =



platform             | arch  | lab           | compiler | defconfig        =
  | regressions
---------------------+-------+---------------+----------+------------------=
--+------------
rk3288-veyron-jaq    | arm   | lab-collabora | gcc-8    | multi_v7_defconfi=
g | 3          =


  Details:     https://kernelci.org/test/plan/id/60e3077a6d5d73e14011796c

  Results:     67 PASS, 3 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.129=
-6-g420a8ce29e61/arm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-rk3288=
-veyron-jaq.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.129=
-6-g420a8ce29e61/arm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-rk3288=
-veyron-jaq.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.bootrr.rockchip-iodomain-grf-probed: https://kernelci.org/test=
/case/id/60e3077a6d5d73e140117984
        failing since 20 days (last pass: v5.4.125, first fail: v5.4.125-85=
-g4a2dfe908c1e)

    2021-07-05T13:21:49.239841  /lava-4141464/1/../bin/lava-test-case<8>[  =
 16.453531] <LAVA_SIGNAL_TESTCASE TEST_CASE_ID=3Drockchip-iodomain-grf-prob=
ed RESULT=3Dfail>
    2021-07-05T13:21:49.240358  =

    2021-07-05T13:21:49.240733  /lava-4141464/1/../bin/lava-test-case   =


  * baseline.bootrr.dwmmc_rockchip-sdio0-probed: https://kernelci.org/test/=
case/id/60e3077a6d5d73e14011799c
        failing since 20 days (last pass: v5.4.125, first fail: v5.4.125-85=
-g4a2dfe908c1e)

    2021-07-05T13:21:47.798611  /lava-4141464/1/../bin/lava-test-case
    2021-07-05T13:21:47.815709  <8>[   15.029330] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Ddwmmc_rockchip-sdio0-probed RESULT=3Dfail>
    2021-07-05T13:21:47.815992  /lava-4141464/1/../bin/lava-test-case   =


  * baseline.bootrr.dwmmc_rockchip-sdmmc-probed: https://kernelci.org/test/=
case/id/60e3077a6d5d73e14011799d
        failing since 20 days (last pass: v5.4.125, first fail: v5.4.125-85=
-g4a2dfe908c1e)

    2021-07-05T13:21:46.785407  /lava-4141464/1/../bin/lava-test-case<8>[  =
 14.010044] <LAVA_SIGNAL_TESTCASE TEST_CASE_ID=3Ddwmmc_rockchip-sdmmc-probe=
d RESULT=3Dfail>
    2021-07-05T13:21:46.785741     =

 =20
