Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 275BB406CF5
	for <lists+stable@lfdr.de>; Fri, 10 Sep 2021 15:38:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231963AbhIJNjR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 10 Sep 2021 09:39:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45680 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233483AbhIJNjQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 10 Sep 2021 09:39:16 -0400
Received: from mail-pl1-x634.google.com (mail-pl1-x634.google.com [IPv6:2607:f8b0:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DB413C061574
        for <stable@vger.kernel.org>; Fri, 10 Sep 2021 06:38:05 -0700 (PDT)
Received: by mail-pl1-x634.google.com with SMTP id d17so1148864plr.12
        for <stable@vger.kernel.org>; Fri, 10 Sep 2021 06:38:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=4tt3KazU3yF1rzTlXzFUbStqUW6FjVbkgkUCoTrCYfo=;
        b=hQErySpr/sbgNLW3Utuh88tIpEN9jBccLVvndnnfxhzpk2oL1DStQp4LPBMsP5L9Fh
         JD/fg4+/jV8kmFacRNsPX9Jkz2R0EWY+8V4larTnKxfYIKU+5//7dCqYZ0sf0n/kb+YY
         RQDFVKEbXzP7bDngqJVaP7Mpmoj5GqM+42GRyDOKno+XtO84+w+BLzQxbln2BDn+JKD6
         gY8oq3O6icH4s6INLGREEi8XZmr05S/1vne5aNN0QWS4tADjftnSFsHMMH6X3mgUDL+n
         Ett4GArorfEQtctowyvpthY3RUBE9RJYJxODId+sSyc2jeSMlvnMdpaa8c5gOWeIA1Bo
         fv5A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=4tt3KazU3yF1rzTlXzFUbStqUW6FjVbkgkUCoTrCYfo=;
        b=c6Ah0AjZIzD+rmtFhvoEzhb6g9iBS9r19xG9D2vxSMJ03ITbgScw0B4Dn0aiE1lGdt
         UZ5dgWYNEklOHTqAZhz2i7NOEbjPgZ525Mg0RqOmm6/Pj+6EH11rKxj9ENlxaIuLe8pz
         UWe2v/iGaNVGEaTIjMV4qRASKDVh1wzMJJcFUCduUF9+nTi/EIp7t8ppXAmsOk/+t7/a
         1mtobSv0pcd+wZ+HQg2YeQsn1k6WmjapWmcRlu/lafe6YPTJwf2SquSDSgQvUbKqDdHd
         5QFA/qAZWUMPYtwmFfjNJRZai7jjSdpdA4MKyX5QNhOGlf+5UoTnniK4mYkoB+iUpaZX
         jjxQ==
X-Gm-Message-State: AOAM533u4PnOe06bXimfiZoJRpxlq07I11nTOvwWNCuNdVV4vf3eiAba
        cRs2YriqwjCGgkqpUsIkDX5xaeZEu7Zu5tvJ
X-Google-Smtp-Source: ABdhPJwU61wRsVRYTIQ9aC6Nj6bIXkzc7XB8CdrJFbntV18pShJSS9xIyFCz0+soEjzka9MtltqOBg==
X-Received: by 2002:a17:902:e5d0:b0:132:36f5:72bd with SMTP id u16-20020a170902e5d000b0013236f572bdmr7812738plf.8.1631281085154;
        Fri, 10 Sep 2021 06:38:05 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id b27sm5218966pfr.121.2021.09.10.06.38.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 10 Sep 2021 06:38:04 -0700 (PDT)
Message-ID: <613b5fbc.1c69fb81.1e502.eccb@mx.google.com>
Date:   Fri, 10 Sep 2021 06:38:04 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v4.19.206-25-gdf1f6d9e7c14
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/4.19
Subject: stable-rc/queue/4.19 baseline: 165 runs,
 7 regressions (v4.19.206-25-gdf1f6d9e7c14)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.19 baseline: 165 runs, 7 regressions (v4.19.206-25-gdf1f6=
d9e7c14)

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


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.19/ker=
nel/v4.19.206-25-gdf1f6d9e7c14/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.19
  Describe: v4.19.206-25-gdf1f6d9e7c14
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      df1f6d9e7c14c45da37aeebc113684db16a3fcef =



Test Regressions
---------------- =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-baylibre  | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/613b2a596db9339399d59681

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.206=
-25-gdf1f6d9e7c14/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_=
arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.206=
-25-gdf1f6d9e7c14/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_=
arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/613b2a596db9339399d59=
682
        failing since 300 days (last pass: v4.19.157-26-gd59f3161b3a0, firs=
t fail: v4.19.157-27-g5543cc2c41d55) =

 =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-broonie   | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/613b2fcd2c2420cdd4d5967a

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.206=
-25-gdf1f6d9e7c14/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_a=
rm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.206=
-25-gdf1f6d9e7c14/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_a=
rm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/613b2fcd2c2420cdd4d59=
67b
        failing since 300 days (last pass: v4.19.157-26-gd59f3161b3a0, firs=
t fail: v4.19.157-27-g5543cc2c41d55) =

 =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-cip       | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/613b2a6fd2b04d8d6bd59670

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.206=
-25-gdf1f6d9e7c14/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-v=
ersatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.206=
-25-gdf1f6d9e7c14/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-v=
ersatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/613b2a6fd2b04d8d6bd59=
671
        failing since 300 days (last pass: v4.19.157-26-gd59f3161b3a0, firs=
t fail: v4.19.157-27-g5543cc2c41d55) =

 =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-collabora | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/613b2a08bebd00c28ad596a8

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.206=
-25-gdf1f6d9e7c14/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu=
_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.206=
-25-gdf1f6d9e7c14/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu=
_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/613b2a08bebd00c28ad59=
6a9
        failing since 300 days (last pass: v4.19.157-26-gd59f3161b3a0, firs=
t fail: v4.19.157-27-g5543cc2c41d55) =

 =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
rk3288-veyron-jaq    | arm  | lab-collabora | gcc-8    | multi_v7_defconfig=
  | 3          =


  Details:     https://kernelci.org/test/plan/id/613b333e797791d361d59666

  Results:     64 PASS, 6 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.206=
-25-gdf1f6d9e7c14/arm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-rk328=
8-veyron-jaq.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.206=
-25-gdf1f6d9e7c14/arm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-rk328=
8-veyron-jaq.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.bootrr.rockchip-iodomain-grf-probed: https://kernelci.org/test=
/case/id/613b333f797791d361d5967a
        failing since 87 days (last pass: v4.19.194-28-g6098ecdead2c, first=
 fail: v4.19.194-67-g1b5dea188d94)

    2021-09-10T10:27:52.674568  /lava-4489874/1/../bin/lava-test-case
    2021-09-10T10:27:52.692095  <8>[   18.887843] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Drockchip-iodomain-grf-probed RESULT=3Dfail>
    2021-09-10T10:27:52.692325  /lava-4489874/1/../bin/lava-test-case   =


  * baseline.bootrr.dwmmc_rockchip-sdio0-probed: https://kernelci.org/test/=
case/id/613b333f797791d361d59692
        failing since 87 days (last pass: v4.19.194-28-g6098ecdead2c, first=
 fail: v4.19.194-67-g1b5dea188d94)

    2021-09-10T10:27:50.254542  /lava-4489874/1/../bin/lava-test-case<8>[  =
 16.445612] <LAVA_SIGNAL_TESTCASE TEST_CASE_ID=3Ddwmmc_rockchip-sdio0-probe=
d RESULT=3Dfail>
    2021-09-10T10:27:50.255045  =

    2021-09-10T10:27:50.255366  /lava-4489874/1/../bin/lava-test-case   =


  * baseline.bootrr.dwmmc_rockchip-sdmmc-probed: https://kernelci.org/test/=
case/id/613b333f797791d361d59693
        failing since 87 days (last pass: v4.19.194-28-g6098ecdead2c, first=
 fail: v4.19.194-67-g1b5dea188d94)

    2021-09-10T10:27:49.214408  /lava-4489874/1/../bin/lava-test-case
    2021-09-10T10:27:49.219302  <8>[   15.426191] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Ddwmmc_rockchip-sdmmc-probed RESULT=3Dfail>   =

 =20
