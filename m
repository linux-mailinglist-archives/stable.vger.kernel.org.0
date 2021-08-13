Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 989773EAE16
	for <lists+stable@lfdr.de>; Fri, 13 Aug 2021 03:16:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238098AbhHMBRV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 12 Aug 2021 21:17:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54956 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233641AbhHMBRU (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 12 Aug 2021 21:17:20 -0400
Received: from mail-pj1-x102a.google.com (mail-pj1-x102a.google.com [IPv6:2607:f8b0:4864:20::102a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DBACDC061756
        for <stable@vger.kernel.org>; Thu, 12 Aug 2021 18:16:54 -0700 (PDT)
Received: by mail-pj1-x102a.google.com with SMTP id fa24-20020a17090af0d8b0290178bfa69d97so13678882pjb.0
        for <stable@vger.kernel.org>; Thu, 12 Aug 2021 18:16:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=K5EgGIEmfBvb8HztPE11E7o3NYrfYnktSYNS0btXgoY=;
        b=Rt++1RDGMqRsHHlQIaLG/3szi2yBhH7N/yl1Sj61NFKZmd3c/CzByGSOYAWAh5ij2d
         qBgC+dYUOU4twrCKeQHV5R6ECqrZ+6Yl4BIuxqD9vB+Qn7VAhv8gTc6/piSG5xkZ3SW0
         oi7wh46LGKkQYPkgd7S20Vi+DBDRmOXPaQFPCX8/Va5JCfH0AqA7l/r0JMZyrqUj3rvu
         GcSb77GfQ12uJGWdwm0YEGrzHWa6NMyH6FVSs24+C0r9YERMCNSkjiMD0TQgIIUSZVOO
         DABt+jNmh2wGQIlOCIxf4aNeJBqoBvUDW4uz8eWzlCDESJ6TMtCKMWLQrgKTXOpsfNFq
         j2wQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=K5EgGIEmfBvb8HztPE11E7o3NYrfYnktSYNS0btXgoY=;
        b=LivAL7Zny7C1Cy0ZK/CphKT4yWj8hucc3yRK8vfjASFz6UURtrUe+P9Vnki1tar8zS
         gnNXOdBqgS2ydkSCgXPwrr3fgqbT1HEufUuOdIsi66l1NFCn3m3ziDA6OaJ9PnAow1ZP
         9EUBrN1L/4CbwyeKJDj3XlvbAwujSjMeEqFg4zTVvHN/yXHilVSCueC0TV8wAeYkO7uE
         9SzarMN57dm0E4oa5SbZISmXwYttcdmpkqLHp4zj8lN+gN9wzPSUtlR55CUGuRsKW+0X
         6nGv5l6fXFwlwMbBerS2Mow0yVn3gdLgyL3y4lCUHDscFI4eaOWWJvsTAuEjpIoO1sbd
         4H/Q==
X-Gm-Message-State: AOAM530t+PAghPm0Pp6//+j279lK0vGnH6yvOMPdzOvaf1q41dEHcefv
        z1JSS2N4npPMvBCKTJOx76pJ8k6arTYpnUSo
X-Google-Smtp-Source: ABdhPJwHvueWhAUG7zzduKeOYzh3pbiO4rfHcHeoVNf7GBZY//9jljUtEwTkYA2fanJtF+q8bUM60g==
X-Received: by 2002:a17:90a:1387:: with SMTP id i7mr7012715pja.169.1628817414170;
        Thu, 12 Aug 2021 18:16:54 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id m28sm94554pgl.9.2021.08.12.18.16.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 12 Aug 2021 18:16:53 -0700 (PDT)
Message-ID: <6115c805.1c69fb81.23323.0723@mx.google.com>
Date:   Thu, 12 Aug 2021 18:16:53 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: queue/4.19
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v4.19.202-56-gb3d9f9f4f698
X-Kernelci-Report-Type: test
Subject: stable-rc/queue/4.19 baseline: 161 runs,
 7 regressions (v4.19.202-56-gb3d9f9f4f698)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.19 baseline: 161 runs, 7 regressions (v4.19.202-56-gb3d9f=
9f4f698)

Regressions Summary
-------------------

platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-baylibre    | gcc-8    | versatile_defcon=
fig | 1          =

qemu_arm-versatilepb | arm  | lab-broonie     | gcc-8    | versatile_defcon=
fig | 1          =

qemu_arm-versatilepb | arm  | lab-collabora   | gcc-8    | versatile_defcon=
fig | 1          =

qemu_arm-versatilepb | arm  | lab-linaro-lkft | gcc-8    | versatile_defcon=
fig | 1          =

rk3288-veyron-jaq    | arm  | lab-collabora   | gcc-8    | multi_v7_defconf=
ig  | 3          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.19/ker=
nel/v4.19.202-56-gb3d9f9f4f698/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.19
  Describe: v4.19.202-56-gb3d9f9f4f698
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      b3d9f9f4f698a26c54d4351139d01527376c64f9 =



Test Regressions
---------------- =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-baylibre    | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/61159430e336fd1731b13669

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.202=
-56-gb3d9f9f4f698/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_=
arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.202=
-56-gb3d9f9f4f698/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_=
arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61159430e336fd1731b13=
66a
        failing since 272 days (last pass: v4.19.157-26-gd59f3161b3a0, firs=
t fail: v4.19.157-27-g5543cc2c41d55) =

 =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-broonie     | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/61159420bc003ca154b1366f

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.202=
-56-gb3d9f9f4f698/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_a=
rm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.202=
-56-gb3d9f9f4f698/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_a=
rm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61159420bc003ca154b13=
670
        failing since 272 days (last pass: v4.19.157-26-gd59f3161b3a0, firs=
t fail: v4.19.157-27-g5543cc2c41d55) =

 =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-collabora   | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/611593dabf56372240b13691

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.202=
-56-gb3d9f9f4f698/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu=
_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.202=
-56-gb3d9f9f4f698/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu=
_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/611593dabf56372240b13=
692
        failing since 272 days (last pass: v4.19.157-26-gd59f3161b3a0, firs=
t fail: v4.19.157-27-g5543cc2c41d55) =

 =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-linaro-lkft | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/611593e075ae974018b13665

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.202=
-56-gb3d9f9f4f698/arm/versatile_defconfig/gcc-8/lab-linaro-lkft/baseline-qe=
mu_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.202=
-56-gb3d9f9f4f698/arm/versatile_defconfig/gcc-8/lab-linaro-lkft/baseline-qe=
mu_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/611593e075ae974018b13=
666
        failing since 272 days (last pass: v4.19.157-26-gd59f3161b3a0, firs=
t fail: v4.19.157-27-g5543cc2c41d55) =

 =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
rk3288-veyron-jaq    | arm  | lab-collabora   | gcc-8    | multi_v7_defconf=
ig  | 3          =


  Details:     https://kernelci.org/test/plan/id/61159707ce0ab9ed3fb1367c

  Results:     64 PASS, 6 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.202=
-56-gb3d9f9f4f698/arm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-rk328=
8-veyron-jaq.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.202=
-56-gb3d9f9f4f698/arm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-rk328=
8-veyron-jaq.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.bootrr.dwmmc_rockchip-sdmmc-probed: https://kernelci.org/test/=
case/id/61159708ce0ab9ed3fb13692
        failing since 58 days (last pass: v4.19.194-28-g6098ecdead2c, first=
 fail: v4.19.194-67-g1b5dea188d94)

    2021-08-12T21:47:30.903428  /lava-4355230/1/../bin/lava-test-case
    2021-08-12T21:47:30.908614  <8>[   14.438203] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Ddwmmc_rockchip-sdmmc-probed RESULT=3Dfail>   =


  * baseline.bootrr.rockchip-iodomain-grf-probed: https://kernelci.org/test=
/case/id/61159708ce0ab9ed3fb13695
        failing since 58 days (last pass: v4.19.194-28-g6098ecdead2c, first=
 fail: v4.19.194-67-g1b5dea188d94)

    2021-08-12T21:47:34.379471  /lava-4355230/1/../bin/lava-test-case<8>[  =
 17.898046] <LAVA_SIGNAL_TESTCASE TEST_CASE_ID=3Drockchip-iodomain-grf-prob=
ed RESULT=3Dfail>
    2021-08-12T21:47:34.379780  =

    2021-08-12T21:47:34.379972  /lava-4355230/1/../bin/lava-test-case   =


  * baseline.bootrr.dwmmc_rockchip-sdio0-probed: https://kernelci.org/test/=
case/id/61159708ce0ab9ed3fb136ae
        failing since 58 days (last pass: v4.19.194-28-g6098ecdead2c, first=
 fail: v4.19.194-67-g1b5dea188d94)

    2021-08-12T21:47:31.922496  /lava-4355230/1/../bin/lava-test-case
    2021-08-12T21:47:31.927532  <8>[   15.457472] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Ddwmmc_rockchip-sdio0-probed RESULT=3Dfail>   =

 =20
