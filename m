Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E10BB3B958C
	for <lists+stable@lfdr.de>; Thu,  1 Jul 2021 19:34:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230063AbhGARgq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 1 Jul 2021 13:36:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46690 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229978AbhGARgq (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 1 Jul 2021 13:36:46 -0400
Received: from mail-pg1-x535.google.com (mail-pg1-x535.google.com [IPv6:2607:f8b0:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9A566C061762
        for <stable@vger.kernel.org>; Thu,  1 Jul 2021 10:34:14 -0700 (PDT)
Received: by mail-pg1-x535.google.com with SMTP id o18so6135449pgu.10
        for <stable@vger.kernel.org>; Thu, 01 Jul 2021 10:34:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=Bg6CiyKD2EvclYjiq99IOvkswf840+gEWMvXf0yyVIo=;
        b=LnaMHpG6rKcJtkqfhAwf79iF5mB8c20ZBn8445yqpNPrptj8o6qZSQLSnDx89ZVZd3
         v75mDx09KVOySz+8Tg/WqCg5sDful5QVe9dl1Kh4ZLq8Hub6ki2SEFUAHMNsiWEbqPze
         z/46OPOFl8wW9CD7OatFILWU5r56Vis7LzaEn7RwUAAmp9QnrNdYaJug+UN3ggKp3sA/
         9a9RJgxvTANrvLvcTHcVxdxnxoRaIJjZfqRgQi29ZEF8UJjfVo8r8MiS3dK93O+JKb5U
         YHMBptr97IJBF1E7Yfm24UlQAm3XQsqzSKtAKnl1SxDD4PPt6LbHyaCsGXmHn7RO/146
         +FMA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=Bg6CiyKD2EvclYjiq99IOvkswf840+gEWMvXf0yyVIo=;
        b=U4ktTTP2dydDP2x29HIx/RWfX9ne3T77BmmVzugSAQtuNMLtMNHHOiMpYFUpOrYohP
         BvVDU/vuW4tXBD/8pY9OmLaOrnKK2wwxc4OnwbMWfxkjDU9Ihjj00G4u8GDN4YQKk+lr
         ig3xZBg8qZDSPfNWloC4aJtJyl7Evf7kKPXGQp4uVv7YCJl4gGJgQwvVPS7zClyvBEYh
         9RePX1OZaXCYJJ/4aPEEH/whU2zwIrQkHqcptspKg5bcid/tEuMytyG0yCvP8NGfslFp
         wl62bvLtSd7V7Qjk+NdVO7XpzgdjM+IL8mqrzvCaCPInfqSC+taIF1tkbhlU6YwFv0Hq
         cg6Q==
X-Gm-Message-State: AOAM530aCn1uzLc7tTL04xLa7UC2gE7tgQymOGWbs2qJML2SNhn/m6cZ
        wYk6sh5vdlidqP3Ahf+aIl+2waUDNKZwLedJ
X-Google-Smtp-Source: ABdhPJzTaCdGedhXrOyaCfja8vWAAGWwZ59vcwoeNQq3zhCJIqPyQsPFHUxGSFFiXGs6idrT1Ld4Ig==
X-Received: by 2002:a63:ed0d:: with SMTP id d13mr710452pgi.258.1625160853748;
        Thu, 01 Jul 2021 10:34:13 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id lm21sm10791708pjb.8.2021.07.01.10.34.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 01 Jul 2021 10:34:13 -0700 (PDT)
Message-ID: <60ddfc95.1c69fb81.e4519.166a@mx.google.com>
Date:   Thu, 01 Jul 2021 10:34:13 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v4.14.238-19-g0e641025550d
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/4.14
Subject: stable-rc/queue/4.14 baseline: 149 runs,
 5 regressions (v4.14.238-19-g0e641025550d)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.14 baseline: 149 runs, 5 regressions (v4.14.238-19-g0e641=
025550d)

Regressions Summary
-------------------

platform          | arch  | lab           | compiler | defconfig          |=
 regressions
------------------+-------+---------------+----------+--------------------+=
------------
fsl-ls2088a-rdb   | arm64 | lab-nxp       | gcc-8    | defconfig          |=
 1          =

meson-gxm-q200    | arm64 | lab-baylibre  | gcc-8    | defconfig          |=
 1          =

rk3288-veyron-jaq | arm   | lab-collabora | gcc-8    | multi_v7_defconfig |=
 3          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.14/ker=
nel/v4.14.238-19-g0e641025550d/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.14
  Describe: v4.14.238-19-g0e641025550d
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      0e641025550db1e69497c60d0ec4ebd6e02c676c =



Test Regressions
---------------- =



platform          | arch  | lab           | compiler | defconfig          |=
 regressions
------------------+-------+---------------+----------+--------------------+=
------------
fsl-ls2088a-rdb   | arm64 | lab-nxp       | gcc-8    | defconfig          |=
 1          =


  Details:     https://kernelci.org/test/plan/id/60ddc929570a0f715423bbe8

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.238=
-19-g0e641025550d/arm64/defconfig/gcc-8/lab-nxp/baseline-fsl-ls2088a-rdb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.238=
-19-g0e641025550d/arm64/defconfig/gcc-8/lab-nxp/baseline-fsl-ls2088a-rdb.ht=
ml
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60ddc929570a0f715423b=
be9
        new failure (last pass: v4.14.237-87-g40c926756603e) =

 =



platform          | arch  | lab           | compiler | defconfig          |=
 regressions
------------------+-------+---------------+----------+--------------------+=
------------
meson-gxm-q200    | arm64 | lab-baylibre  | gcc-8    | defconfig          |=
 1          =


  Details:     https://kernelci.org/test/plan/id/60ddd0c175afddf82323bbc1

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.238=
-19-g0e641025550d/arm64/defconfig/gcc-8/lab-baylibre/baseline-meson-gxm-q20=
0.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.238=
-19-g0e641025550d/arm64/defconfig/gcc-8/lab-baylibre/baseline-meson-gxm-q20=
0.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60ddd0c175afddf82323b=
bc2
        failing since 122 days (last pass: v4.14.222-11-g13b8482a0f700, fir=
st fail: v4.14.222-120-gdc8887cba23e) =

 =



platform          | arch  | lab           | compiler | defconfig          |=
 regressions
------------------+-------+---------------+----------+--------------------+=
------------
rk3288-veyron-jaq | arm   | lab-collabora | gcc-8    | multi_v7_defconfig |=
 3          =


  Details:     https://kernelci.org/test/plan/id/60dddd56f887de32ad23bc02

  Results:     63 PASS, 6 FAIL, 1 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.238=
-19-g0e641025550d/arm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-rk328=
8-veyron-jaq.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.238=
-19-g0e641025550d/arm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-rk328=
8-veyron-jaq.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.bootrr.rockchip-iodomain-grf-probed: https://kernelci.org/test=
/case/id/60dddd56f887de32ad23bc16
        failing since 16 days (last pass: v4.14.236-20-gdb14655bb4bf, first=
 fail: v4.14.236-49-gfd4c319f2583)

    2021-07-01T15:20:34.301130  /lava-4123570/1/../bin/lava-test-case
    2021-07-01T15:20:34.317192  [   16.959520] <LAVA_SIGNAL_TESTCASE TEST_C=
ASE_ID=3Drockchip-iodomain-grf-probed RESULT=3Dfail>
    2021-07-01T15:20:34.317592  /lava-4123570/1/../bin/lava-test-case   =


  * baseline.bootrr.dwmmc_rockchip-sdio0-probed: https://kernelci.org/test/=
case/id/60dddd56f887de32ad23bc2f
        failing since 16 days (last pass: v4.14.236-20-gdb14655bb4bf, first=
 fail: v4.14.236-49-gfd4c319f2583)

    2021-07-01T15:20:31.870232  /lava-4123570/1/../bin/lava-test-case
    2021-07-01T15:20:31.870831  [   14.527282] <LAVA_SIGNAL_TESTCASE TEST_C=
ASE_ID=3Ddwmmc_rockchip-sdio0-probed RESULT=3Dfail>   =


  * baseline.bootrr.dwmmc_rockchip-sdmmc-probed: https://kernelci.org/test/=
case/id/60dddd56f887de32ad23bc30
        failing since 16 days (last pass: v4.14.236-20-gdb14655bb4bf, first=
 fail: v4.14.236-49-gfd4c319f2583)

    2021-07-01T15:20:30.849718  /lava-4123570/1/../bin/lava-test-case
    2021-07-01T15:20:30.855355  [   13.508364] <LAVA_SIGNAL_TESTCASE TEST_C=
ASE_ID=3Ddwmmc_rockchip-sdmmc-probed RESULT=3Dfail>   =

 =20
