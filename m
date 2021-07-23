Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 79F4B3D361F
	for <lists+stable@lfdr.de>; Fri, 23 Jul 2021 10:06:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234318AbhGWHZg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 23 Jul 2021 03:25:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59556 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234196AbhGWHZf (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 23 Jul 2021 03:25:35 -0400
Received: from mail-pl1-x62a.google.com (mail-pl1-x62a.google.com [IPv6:2607:f8b0:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8BB4CC061575
        for <stable@vger.kernel.org>; Fri, 23 Jul 2021 01:06:08 -0700 (PDT)
Received: by mail-pl1-x62a.google.com with SMTP id n10so2386231plf.4
        for <stable@vger.kernel.org>; Fri, 23 Jul 2021 01:06:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=FsYNTkn9LcnV9Rmew+HSFuBhuWQMayIT+JTqF515hyQ=;
        b=lbbKch/zQskEl+vh7BQlRYBXxK0VH+Ahs9BNcjDIlEpp8k88bR9i+phkHBA1g2pWGF
         uQoPSMBH+G9KKRDjwp/5elwEDEIXguUGer5ncGica5jui5FoAOoPtgjaxe6OlGIPL2zj
         F6Oe3ujxGlnlbc+eOeWQJ1/qYl61wQ4DeEyPKuZAq1jwac3F2cqSfsJ+WOAH2agDc6w6
         lvXlkMlpG2dl3Mcj4C0Bh9h93d6ed0bKImJYL7FsL/aN4s1EjJymZdAx+faE1/4cv1yD
         JWrM3ul3pbjmbHPnD4RmRORNN/g2ofnUgEIy0gGKnHN3xGqNR7UwXZp2ag0dzAL8u/Tf
         +qgg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=FsYNTkn9LcnV9Rmew+HSFuBhuWQMayIT+JTqF515hyQ=;
        b=WFWJV3HqYGWUYExQfqI0FI5qem3D4dUsAilrAL1XfRoHcPvguoGlQrW3OJj5rtR//o
         Lz9toakowfftVA6YFcFb2/v+Eq9QNkt6JckNoj2fatsfbrn+9uNq2/Gbvk056IlQIlPz
         J1JJwfqXjY3ePYUAGQQvOVpenrTxJ9Oy2QrtVfxNsNsnp2qs6uxwBQvW/gjcRHhpMyha
         JDGIKby6NJUk/7JGW61PKymbBufIwaw4u/YQFLOiTsoNbiedvML61OOFeFv14p9EZK2a
         gfBDO0YgAGoqAJbutoRhcvsXXAyqWtBI5FBNQWh5w6S4XQb/g+vThVSc7IZ8i3ZRHj1+
         TBZQ==
X-Gm-Message-State: AOAM533RQihH8zkF9/NB0DG/GkO8GRiV3SnKEJfkfstRj8V6SP7jm0Ev
        /RVnYM7HYsKAe2xcFAqTQQDYbiFK0f7G4jIp
X-Google-Smtp-Source: ABdhPJzp255HyQx20+BrChV/IJbSjHYajKQhbejhZfD2UZKI7GIWS+iJuL+0XchCFD8F27CbMpDyAA==
X-Received: by 2002:a17:90b:380c:: with SMTP id mq12mr12600423pjb.76.1627027567858;
        Fri, 23 Jul 2021 01:06:07 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id m34sm37514569pgb.85.2021.07.23.01.06.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 23 Jul 2021 01:06:07 -0700 (PDT)
Message-ID: <60fa786f.1c69fb81.de066.1811@mx.google.com>
Date:   Fri, 23 Jul 2021 01:06:07 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: linux-4.19.y
X-Kernelci-Kernel: v4.19.197-473-gfa4e8f7690799
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
Subject: stable-rc/linux-4.19.y baseline: 141 runs,
 7 regressions (v4.19.197-473-gfa4e8f7690799)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.19.y baseline: 141 runs, 7 regressions (v4.19.197-473-gfa=
4e8f7690799)

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

qemu_arm-versatilepb | arm  | lab-cip       | gcc-8    | versatile_defconfi=
g | 1          =

qemu_arm-versatilepb | arm  | lab-collabora | gcc-8    | versatile_defconfi=
g | 1          =

rk3288-veyron-jaq    | arm  | lab-collabora | gcc-8    | multi_v7_defconfig=
  | 3          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-4.19.y/ker=
nel/v4.19.197-473-gfa4e8f7690799/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-4.19.y
  Describe: v4.19.197-473-gfa4e8f7690799
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      fa4e8f76907993c49897b1d7d2b3a5d0e5b369d7 =



Test Regressions
---------------- =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-baylibre  | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/60fa41fa2823e34f0a85c2ad

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.1=
97-473-gfa4e8f7690799/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-q=
emu_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.1=
97-473-gfa4e8f7690799/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-q=
emu_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60fa41fa2823e34f0a85c=
2ae
        failing since 246 days (last pass: v4.19.157-26-ga8e7fec1fea1, firs=
t fail: v4.19.157-102-g1d674327c1b7) =

 =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-broonie   | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/60fa456a467b5cee7385c286

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.1=
97-473-gfa4e8f7690799/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qe=
mu_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.1=
97-473-gfa4e8f7690799/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qe=
mu_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60fa456a467b5cee7385c=
287
        failing since 246 days (last pass: v4.19.157-26-ga8e7fec1fea1, firs=
t fail: v4.19.157-102-g1d674327c1b7) =

 =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-cip       | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/60fa41f42823e34f0a85c256

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.1=
97-473-gfa4e8f7690799/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_a=
rm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.1=
97-473-gfa4e8f7690799/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_a=
rm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60fa41f42823e34f0a85c=
257
        failing since 246 days (last pass: v4.19.157-26-ga8e7fec1fea1, firs=
t fail: v4.19.157-102-g1d674327c1b7) =

 =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-collabora | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/60fa57f189970c31e285c257

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.1=
97-473-gfa4e8f7690799/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-=
qemu_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.1=
97-473-gfa4e8f7690799/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-=
qemu_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60fa57f189970c31e285c=
258
        failing since 246 days (last pass: v4.19.157-26-ga8e7fec1fea1, firs=
t fail: v4.19.157-102-g1d674327c1b7) =

 =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
rk3288-veyron-jaq    | arm  | lab-collabora | gcc-8    | multi_v7_defconfig=
  | 3          =


  Details:     https://kernelci.org/test/plan/id/60fa628333eb83923c85c279

  Results:     64 PASS, 6 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.1=
97-473-gfa4e8f7690799/arm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-r=
k3288-veyron-jaq.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.1=
97-473-gfa4e8f7690799/arm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-r=
k3288-veyron-jaq.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.bootrr.rockchip-iodomain-grf-probed: https://kernelci.org/test=
/case/id/60fa628333eb83923c85c28d
        failing since 38 days (last pass: v4.19.194, first fail: v4.19.194-=
68-g3c1f7bd17074)

    2021-07-23T06:32:23.538022  /lava-4233763/1/../bin/lava-test-case
    2021-07-23T06:32:23.555878  <8>[   17.917480] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Drockchip-iodomain-grf-probed RESULT=3Dfail>
    2021-07-23T06:32:23.556212  /lava-4233763/1/../bin/lava-test-case   =


  * baseline.bootrr.dwmmc_rockchip-sdio0-probed: https://kernelci.org/test/=
case/id/60fa628333eb83923c85c2a6
        failing since 38 days (last pass: v4.19.194, first fail: v4.19.194-=
68-g3c1f7bd17074)

    2021-07-23T06:32:21.097427  /lava-4233763/1/../bin/lava-test-case
    2021-07-23T06:32:21.114296  <8>[   15.475897] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Ddwmmc_rockchip-sdio0-probed RESULT=3Dfail>
    2021-07-23T06:32:21.114566  /lava-4233763/1/../bin/lava-test-case   =


  * baseline.bootrr.dwmmc_rockchip-sdmmc-probed: https://kernelci.org/test/=
case/id/60fa628333eb83923c85c2a7
        failing since 38 days (last pass: v4.19.194, first fail: v4.19.194-=
68-g3c1f7bd17074)

    2021-07-23T06:32:20.077704  /lava-4233763/1/../bin/lava-test-case
    2021-07-23T06:32:20.083310  <8>[   14.456483] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Ddwmmc_rockchip-sdmmc-probed RESULT=3Dfail>   =

 =20
