Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CEBFC41E2CB
	for <lists+stable@lfdr.de>; Thu, 30 Sep 2021 22:45:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244886AbhI3UrU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 30 Sep 2021 16:47:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38922 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236008AbhI3UrT (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 30 Sep 2021 16:47:19 -0400
Received: from mail-pg1-x52d.google.com (mail-pg1-x52d.google.com [IPv6:2607:f8b0:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C0FBDC06176A
        for <stable@vger.kernel.org>; Thu, 30 Sep 2021 13:45:36 -0700 (PDT)
Received: by mail-pg1-x52d.google.com with SMTP id g184so7448922pgc.6
        for <stable@vger.kernel.org>; Thu, 30 Sep 2021 13:45:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=mmYZl2N+WeDu0XrbXaqkYEuvrLEDDHIFyZYlXY9C/pQ=;
        b=wpO+caHzUXJSnodpDUtk1omL9Oumt1ysrLmj//tJmI3YS6dwkd4YowIHrZ+5UemZRq
         a8t6Rc1XVDGhV+WaPbI9otvnjKDVUm+6YazQCjl1nGrs7MxwiGfoFXetaO2wlIgrs8cZ
         daRWg/cJHG/Q6LSlfxrU/DdDpwQuP62SRyfJsq/jORcTcDv7l72dhMXjCP6UDAktNkmL
         1wY1S8St6CACRt20LrVE5Acft4aaU/GcUfan6ML87Gpl9YtTgt1jcSvbcXpHwi0AAgqR
         qfQOcrBJ8xzV5SYr0hiPVpRQEi+1q8Z2BuHWJ8AvpPdM4W1KljFLYzGPh+KcTTNHCajq
         HQpA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=mmYZl2N+WeDu0XrbXaqkYEuvrLEDDHIFyZYlXY9C/pQ=;
        b=JAZhAbsn9pbOtYikqo3q7iMoKpPsa1Qr82pJitIH3SJ93aUtqe68VfVtMLrab9vrqd
         o0DllEP/Uw0yvvZFilPjzb2GHwFXNqMTIC9WIW3kHo1xq5h69RNjgZ0/sJ8+G8vrlu8K
         g8KDV7AbRa/l1h4YD0VI/Gnd5UoaeTLZX+B2X6usggSEb9hrESX23ECe0c+1mQhq6z3u
         BzdRUVVkrEGRqABOtohAj+6EVdb80vFfh2oL7F1qWqKF2Ooo75GF8DZoArI4+GD1CVvn
         U+12HYszGWzEUJJmfEf8ncyDLzR1WsZWzC/M6zzi2Wcht2Uhg5WVBY42LPUqJ9M1Utqu
         oHxw==
X-Gm-Message-State: AOAM532X20tF+NsOjEJrPnlzNkZjW5y370AR2am4jFka5eN82g42HnZO
        61o29fOP2xtAcSlQFUaNZTM2/vyjdkfIFpvx
X-Google-Smtp-Source: ABdhPJyDjJK9612Rk8qRCqOkaEvNuk/Df80EGHSTvWJF6M13oE9WqxYLPv1INvRAN/sR++eRM17Lhw==
X-Received: by 2002:a63:8f4a:: with SMTP id r10mr6586995pgn.337.1633034735647;
        Thu, 30 Sep 2021 13:45:35 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id h21sm3763127pfc.118.2021.09.30.13.45.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 30 Sep 2021 13:45:35 -0700 (PDT)
Message-ID: <615621ef.1c69fb81.af08b.b76a@mx.google.com>
Date:   Thu, 30 Sep 2021 13:45:35 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.19.208-55-g875c7e1e11e4
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/4.19
Subject: stable-rc/queue/4.19 baseline: 122 runs,
 8 regressions (v4.19.208-55-g875c7e1e11e4)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.19 baseline: 122 runs, 8 regressions (v4.19.208-55-g875c7=
e1e11e4)

Regressions Summary
-------------------

platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
panda                | arm  | lab-collabora | gcc-8    | omap2plus_defconfi=
g | 1          =

qemu_arm-versatilepb | arm  | lab-baylibre  | gcc-8    | versatile_defconfi=
g | 1          =

qemu_arm-versatilepb | arm  | lab-broonie   | gcc-8    | versatile_defconfi=
g | 1          =

qemu_arm-versatilepb | arm  | lab-cip       | gcc-8    | versatile_defconfi=
g | 1          =

qemu_arm-versatilepb | arm  | lab-collabora | gcc-8    | versatile_defconfi=
g | 1          =

rk3288-veyron-jaq    | arm  | lab-collabora | gcc-8    | multi_v7_defconfig=
  | 3          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.19/ker=
nel/v4.19.208-55-g875c7e1e11e4/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.19
  Describe: v4.19.208-55-g875c7e1e11e4
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      875c7e1e11e4668fb29ba28337937c6af79d9fe6 =



Test Regressions
---------------- =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
panda                | arm  | lab-collabora | gcc-8    | omap2plus_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/6155e9c2a90e9aca7399a2e2

  Results:     5 PASS, 1 FAIL, 0 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.208=
-55-g875c7e1e11e4/arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-pand=
a.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.208=
-55-g875c7e1e11e4/arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-pand=
a.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/6155e9c2a90e9ac=
a7399a2ea
        new failure (last pass: v4.19.208-55-g9e4075ab91c6)
        2 lines

    2021-09-30T16:45:39.291895  <8>[   22.991333] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Dalert RESULT=3Dpass UNITS=3Dlines MEASUREMENT=3D0>
    2021-09-30T16:45:39.341313  kern  :emerg : BUG: spinlock bad magic on C=
PU#0, udevd/105
    2021-09-30T16:45:39.349458  kern  :emerg :  lock: emif_lock+0x0/0xffffe=
d34 [emif], .magic: 00000000, .owner: <none>/-1, .owner_cpu: 0   =

 =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-baylibre  | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/6155e7b40454b2283099a2da

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.208=
-55-g875c7e1e11e4/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_=
arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.208=
-55-g875c7e1e11e4/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_=
arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6155e7b40454b2283099a=
2db
        failing since 320 days (last pass: v4.19.157-26-gd59f3161b3a0, firs=
t fail: v4.19.157-27-g5543cc2c41d55) =

 =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-broonie   | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/6155e8e0f9baa17be699a2e9

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.208=
-55-g875c7e1e11e4/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_a=
rm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.208=
-55-g875c7e1e11e4/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_a=
rm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6155e8e0f9baa17be699a=
2ea
        failing since 320 days (last pass: v4.19.157-26-gd59f3161b3a0, firs=
t fail: v4.19.157-27-g5543cc2c41d55) =

 =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-cip       | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/6155e86cd16e9e6dfb99a30e

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.208=
-55-g875c7e1e11e4/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-v=
ersatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.208=
-55-g875c7e1e11e4/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-v=
ersatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6155e86cd16e9e6dfb99a=
30f
        failing since 320 days (last pass: v4.19.157-26-gd59f3161b3a0, firs=
t fail: v4.19.157-27-g5543cc2c41d55) =

 =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-collabora | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/61560c475c38840e8c99a3d4

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.208=
-55-g875c7e1e11e4/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu=
_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.208=
-55-g875c7e1e11e4/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu=
_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61560c475c38840e8c99a=
3d5
        failing since 320 days (last pass: v4.19.157-26-gd59f3161b3a0, firs=
t fail: v4.19.157-27-g5543cc2c41d55) =

 =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
rk3288-veyron-jaq    | arm  | lab-collabora | gcc-8    | multi_v7_defconfig=
  | 3          =


  Details:     https://kernelci.org/test/plan/id/6155f3b4bd944c5d7099a2dc

  Results:     64 PASS, 6 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.208=
-55-g875c7e1e11e4/arm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-rk328=
8-veyron-jaq.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.208=
-55-g875c7e1e11e4/arm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-rk328=
8-veyron-jaq.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.bootrr.rockchip-iodomain-grf-probed: https://kernelci.org/test=
/case/id/6155f3b4bd944c5d7099a2f0
        failing since 107 days (last pass: v4.19.194-28-g6098ecdead2c, firs=
t fail: v4.19.194-67-g1b5dea188d94)

    2021-09-30T17:28:10.258507  /lava-4613105/1/../bin/lava-test-case
    2021-09-30T17:28:10.275353  <8>[   17.758625] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Drockchip-iodomain-grf-probed RESULT=3Dfail>   =


  * baseline.bootrr.dwmmc_rockchip-sdio0-probed: https://kernelci.org/test/=
case/id/6155f3b4bd944c5d7099a309
        failing since 107 days (last pass: v4.19.194-28-g6098ecdead2c, firs=
t fail: v4.19.194-67-g1b5dea188d94)

    2021-09-30T17:28:07.816565  /lava-4613105/1/../bin/lava-test-case
    2021-09-30T17:28:07.834009  <8>[   15.316610] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Ddwmmc_rockchip-sdio0-probed RESULT=3Dfail>
    2021-09-30T17:28:07.834507  /lava-4613105/1/../bin/lava-test-case   =


  * baseline.bootrr.dwmmc_rockchip-sdmmc-probed: https://kernelci.org/test/=
case/id/6155f3b4bd944c5d7099a30a
        failing since 107 days (last pass: v4.19.194-28-g6098ecdead2c, firs=
t fail: v4.19.194-67-g1b5dea188d94)

    2021-09-30T17:28:06.797555  /lava-4613105/1/../bin/lava-test-case
    2021-09-30T17:28:06.803427  <8>[   14.297121] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Ddwmmc_rockchip-sdmmc-probed RESULT=3Dfail>   =

 =20
