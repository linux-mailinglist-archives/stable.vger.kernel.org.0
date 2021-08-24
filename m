Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6E7193F59BC
	for <lists+stable@lfdr.de>; Tue, 24 Aug 2021 10:15:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234936AbhHXIQC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 24 Aug 2021 04:16:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46342 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234872AbhHXIQB (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 24 Aug 2021 04:16:01 -0400
Received: from mail-pg1-x52a.google.com (mail-pg1-x52a.google.com [IPv6:2607:f8b0:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CF89EC061757
        for <stable@vger.kernel.org>; Tue, 24 Aug 2021 01:15:17 -0700 (PDT)
Received: by mail-pg1-x52a.google.com with SMTP id r2so19062805pgl.10
        for <stable@vger.kernel.org>; Tue, 24 Aug 2021 01:15:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=JFLL6xGhjlZzOAyTeXUG30A3ylM6GsSb6S/eudaX3uE=;
        b=IREH64zMRY6S1LvQMJF7SbSd3zdOJCHQw7O/FzpKfF+gNvJ0abMh8WCI9bPDxNGCPT
         WTKP1PRSZR7r2Dn82isCFEGwyBmT4s+GiBcsWXy/QSR3qknY6rmif8wZYhpxXQSSsFyC
         FRgFq+yp5m6MkPccqO3HBbWyFu7JGhSXlVIVEHYsS5XdguNW7zcLzbwdJxJsKDX+kAyd
         AT7mUS6p2vnaa3nnSf+vvjgG9WziXpJhmXynbHk9wTHCWyRIvYbDVUhMsS6z1fiTZ/S/
         DOSZh8weQd4ATICsddnz7Vk3jqvH+fnIg2tJtt9DSDOzjnClFVV2QXfYamkt5F13Rhbt
         B66w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=JFLL6xGhjlZzOAyTeXUG30A3ylM6GsSb6S/eudaX3uE=;
        b=OH/Ay+13wwNykSzIoOtI5M1hUBUM94S5vpSo/w8aN7dEIWGmhVuViXM2sIvjhZOAi8
         Lr8V6biOWGlemuVvmFj+NH61T1tSz2JSaFXaVIVC9vMREqzc0S9hBvDK96Licvv3suGl
         g0TDBtkFyk0Cj8uF7dffg+5genaHl/uL7SuRXDmLO467Ra5AoRtLDo8kMEK3u3ePcZtr
         xL1lmnMusqep9tfR7vDrpqsLsTsB1Zzu0vQH03pVnboqX7fTF+aundTSNGXfPomb8J66
         VWtiXrlNYcA9hGLcvOx3vBb9BQwMlxKcCyfoEWjDW7Ue6X7allvorDDWyBMGI3amVoLZ
         fhmQ==
X-Gm-Message-State: AOAM530Rhllkl5j/D1rTcTHdhVbl7mmE032MtmYmD7Fc2IDwjC+qY3aq
        LZzuWk5wF3T8RLlMYoTLBvBhvQuntBqVCzBE
X-Google-Smtp-Source: ABdhPJx345+i3XEaDEam8U4DllGIn6mcx49aWeA0NLzt+tkGFUCoGP6LWy8qVj7T3nqjdBcMwtHfow==
X-Received: by 2002:a62:1852:0:b0:3e1:43ea:c56b with SMTP id 79-20020a621852000000b003e143eac56bmr38584630pfy.75.1629792917144;
        Tue, 24 Aug 2021 01:15:17 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id u11sm17293082pfk.100.2021.08.24.01.15.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 24 Aug 2021 01:15:16 -0700 (PDT)
Message-ID: <6124aa94.1c69fb81.8739a.367b@mx.google.com>
Date:   Tue, 24 Aug 2021 01:15:16 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: queue/4.19
X-Kernelci-Kernel: v4.19.204-82-g4aa277a7ee16
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
Subject: stable-rc/queue/4.19 baseline: 136 runs,
 7 regressions (v4.19.204-82-g4aa277a7ee16)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.19 baseline: 136 runs, 7 regressions (v4.19.204-82-g4aa27=
7a7ee16)

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

qemu_arm-versatilepb | arm  | lab-cip         | gcc-8    | versatile_defcon=
fig | 1          =

qemu_arm-versatilepb | arm  | lab-linaro-lkft | gcc-8    | versatile_defcon=
fig | 1          =

rk3288-veyron-jaq    | arm  | lab-collabora   | gcc-8    | multi_v7_defconf=
ig  | 3          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.19/ker=
nel/v4.19.204-82-g4aa277a7ee16/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.19
  Describe: v4.19.204-82-g4aa277a7ee16
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      4aa277a7ee16a7ee09a41e758a724734f80a90b3 =



Test Regressions
---------------- =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-baylibre    | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/612477b41a324ff02d8e2c9d

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.204=
-82-g4aa277a7ee16/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_=
arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.204=
-82-g4aa277a7ee16/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_=
arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/612477b41a324ff02d8e2=
c9e
        failing since 283 days (last pass: v4.19.157-26-gd59f3161b3a0, firs=
t fail: v4.19.157-27-g5543cc2c41d55) =

 =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-broonie     | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/612477daa0a17644bd8e2cd3

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.204=
-82-g4aa277a7ee16/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_a=
rm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.204=
-82-g4aa277a7ee16/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_a=
rm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/612477daa0a17644bd8e2=
cd4
        failing since 283 days (last pass: v4.19.157-26-gd59f3161b3a0, firs=
t fail: v4.19.157-27-g5543cc2c41d55) =

 =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-cip         | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/612477a68cebd1c7408e2cdd

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.204=
-82-g4aa277a7ee16/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-v=
ersatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.204=
-82-g4aa277a7ee16/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-v=
ersatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/612477a68cebd1c7408e2=
cde
        failing since 283 days (last pass: v4.19.157-26-gd59f3161b3a0, firs=
t fail: v4.19.157-27-g5543cc2c41d55) =

 =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-linaro-lkft | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/6124777710ff7aaa7e8e2c7e

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.204=
-82-g4aa277a7ee16/arm/versatile_defconfig/gcc-8/lab-linaro-lkft/baseline-qe=
mu_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.204=
-82-g4aa277a7ee16/arm/versatile_defconfig/gcc-8/lab-linaro-lkft/baseline-qe=
mu_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6124777710ff7aaa7e8e2=
c7f
        failing since 283 days (last pass: v4.19.157-26-gd59f3161b3a0, firs=
t fail: v4.19.157-27-g5543cc2c41d55) =

 =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
rk3288-veyron-jaq    | arm  | lab-collabora   | gcc-8    | multi_v7_defconf=
ig  | 3          =


  Details:     https://kernelci.org/test/plan/id/612478c1ab2f0dbc938e2cb5

  Results:     64 PASS, 6 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.204=
-82-g4aa277a7ee16/arm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-rk328=
8-veyron-jaq.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.204=
-82-g4aa277a7ee16/arm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-rk328=
8-veyron-jaq.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.bootrr.rockchip-iodomain-grf-probed: https://kernelci.org/test=
/case/id/612478c1ab2f0dbc938e2cc9
        failing since 70 days (last pass: v4.19.194-28-g6098ecdead2c, first=
 fail: v4.19.194-67-g1b5dea188d94)

    2021-08-24T04:42:33.074570  /lava-4404379/1/../bin/lava-test-case
    2021-08-24T04:42:33.092188  <8>[   17.524610] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Drockchip-iodomain-grf-probed RESULT=3Dfail>
    2021-08-24T04:42:33.092394  /lava-4404379/1/../bin/lava-test-case   =


  * baseline.bootrr.dwmmc_rockchip-sdio0-probed: https://kernelci.org/test/=
case/id/612478c1ab2f0dbc938e2ce2
        failing since 70 days (last pass: v4.19.194-28-g6098ecdead2c, first=
 fail: v4.19.194-67-g1b5dea188d94)

    2021-08-24T04:42:30.633029  /lava-4404379/1/../bin/lava-test-case<8>[  =
 15.081858] <LAVA_SIGNAL_TESTCASE TEST_CASE_ID=3Ddwmmc_rockchip-sdio0-probe=
d RESULT=3Dfail>
    2021-08-24T04:42:30.633389     =


  * baseline.bootrr.dwmmc_rockchip-sdmmc-probed: https://kernelci.org/test/=
case/id/612478c1ab2f0dbc938e2ce3
        failing since 70 days (last pass: v4.19.194-28-g6098ecdead2c, first=
 fail: v4.19.194-67-g1b5dea188d94)

    2021-08-24T04:42:29.612084  /lava-4404379/1/../bin/lava-test-case
    2021-08-24T04:42:29.617412  <8>[   14.062385] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Ddwmmc_rockchip-sdmmc-probed RESULT=3Dfail>   =

 =20
