Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2DA2E3DE20B
	for <lists+stable@lfdr.de>; Mon,  2 Aug 2021 23:59:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231609AbhHBV7I (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 2 Aug 2021 17:59:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48458 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230313AbhHBV7H (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 2 Aug 2021 17:59:07 -0400
Received: from mail-pj1-x102b.google.com (mail-pj1-x102b.google.com [IPv6:2607:f8b0:4864:20::102b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0FAF4C06175F
        for <stable@vger.kernel.org>; Mon,  2 Aug 2021 14:58:58 -0700 (PDT)
Received: by mail-pj1-x102b.google.com with SMTP id o44-20020a17090a0a2fb0290176ca3e5a2fso1982140pjo.1
        for <stable@vger.kernel.org>; Mon, 02 Aug 2021 14:58:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=JpauGAPWZnkSyCUNC6YUpMIKA0Zzki645dp8XRUkJfs=;
        b=NWR1QvVvKEhu2lfR64qfgZ4WugrjLEAqa+GTK+GQaKw8/NkyGg5IkvN92QBM6ork44
         6aAali04be2aysS3dw7rpe+9EFzCMCD5RHk2J4wr2oalGTxWo51M22p72oUZVi8I7TJc
         7PDedVopbdgG418XkhBTwFo2pvNss4pjIzE2jHBvXE0Z0lFaTqq/sgDf+2kDdiydGUyF
         tTh1/UzgsPZ90w9xfUwpm6edxKL9LBl3RvfcMwqbc9NvRmTJdjMWAc4SkGdAPXQRri1e
         EaTaZ+yVTM7dSk4ZuJKsswozeaMtK9qH9jW4l/FlWCqzS0ZxdqSuACoA8PP6cowWzRlm
         MLGQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=JpauGAPWZnkSyCUNC6YUpMIKA0Zzki645dp8XRUkJfs=;
        b=BcdY7vCacePVySXw08vz/BSRpAbEdsnPQiTT79dUOoQQxRKIkPH+afpunsCVMdKX4g
         801cmtyPht4sP/EsggS1NlvYIfHtNjgPobQcSzZ5B9UMbM/iAr9wCcsQ0Pc8mTlL1fXn
         5L0xoaer2iqN5Jcu2rKhCyNgk2TRwvvxcUli8Zw6AR3g/n7ZM9SN4hEnvS/6R8OuKJ70
         hzSc+A5q2mphUk9Dx1tHgafdkBmFOiimeDXT3k2ibx16fBKbmp0ALZMSKfmFkd5QdrZH
         C5Ca/SC0tVij0uGB8BqBeIIuzA0yV7rcLerJ5KVq39RLhCZF8gmFQMgFy8dQme90z1/h
         Y9Kg==
X-Gm-Message-State: AOAM531zBgSVk9IEntXFlpuHQY+JbmRmPZSWp996exVvZ3EzvzttSd8N
        zz/uNTbdfrOyJpIdmbDWFQn0chnrn4NBA6K6
X-Google-Smtp-Source: ABdhPJyMH3GOqnFRRCf5jyUaTCWv6JOIKfKhkfPCX5XqM7FaYVdy/EjBWkxMe/Mgxzcy4eqn+Y8CiA==
X-Received: by 2002:a63:a0f:: with SMTP id 15mr1161015pgk.80.1627941537367;
        Mon, 02 Aug 2021 14:58:57 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id j187sm12820325pfb.132.2021.08.02.14.58.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 02 Aug 2021 14:58:57 -0700 (PDT)
Message-ID: <61086aa1.1c69fb81.43289.4ade@mx.google.com>
Date:   Mon, 02 Aug 2021 14:58:57 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: linux-4.19.y
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v4.19.200-31-g7d0b2cf6631f
X-Kernelci-Report-Type: test
Subject: stable-rc/linux-4.19.y baseline: 149 runs,
 7 regressions (v4.19.200-31-g7d0b2cf6631f)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.19.y baseline: 149 runs, 7 regressions (v4.19.200-31-g7d0=
b2cf6631f)

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
nel/v4.19.200-31-g7d0b2cf6631f/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-4.19.y
  Describe: v4.19.200-31-g7d0b2cf6631f
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      7d0b2cf6631fd9776096a6a1bc52a89946f15d4c =



Test Regressions
---------------- =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-baylibre  | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/61082f0a6cb064b910b13675

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.2=
00-31-g7d0b2cf6631f/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qem=
u_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.2=
00-31-g7d0b2cf6631f/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qem=
u_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61082f0a6cb064b910b13=
676
        failing since 257 days (last pass: v4.19.157-26-ga8e7fec1fea1, firs=
t fail: v4.19.157-102-g1d674327c1b7) =

 =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-broonie   | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/610833274eae391786b13693

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.2=
00-31-g7d0b2cf6631f/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu=
_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.2=
00-31-g7d0b2cf6631f/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu=
_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/610833274eae391786b13=
694
        failing since 257 days (last pass: v4.19.157-26-ga8e7fec1fea1, firs=
t fail: v4.19.157-102-g1d674327c1b7) =

 =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-cip       | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/61082ecb4aee950b56b1369e

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.2=
00-31-g7d0b2cf6631f/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm=
-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.2=
00-31-g7d0b2cf6631f/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm=
-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61082ecb4aee950b56b13=
69f
        failing since 257 days (last pass: v4.19.157-26-ga8e7fec1fea1, firs=
t fail: v4.19.157-102-g1d674327c1b7) =

 =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-collabora | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/610835081ebcef7d16b13662

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.2=
00-31-g7d0b2cf6631f/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qe=
mu_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.2=
00-31-g7d0b2cf6631f/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qe=
mu_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/610835081ebcef7d16b13=
663
        failing since 257 days (last pass: v4.19.157-26-ga8e7fec1fea1, firs=
t fail: v4.19.157-102-g1d674327c1b7) =

 =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
rk3288-veyron-jaq    | arm  | lab-collabora | gcc-8    | multi_v7_defconfig=
  | 3          =


  Details:     https://kernelci.org/test/plan/id/610852bf82d6e3770bb1367d

  Results:     64 PASS, 6 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.2=
00-31-g7d0b2cf6631f/arm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-rk3=
288-veyron-jaq.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.2=
00-31-g7d0b2cf6631f/arm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-rk3=
288-veyron-jaq.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.bootrr.rockchip-iodomain-grf-probed: https://kernelci.org/test=
/case/id/610852bf82d6e3770bb13695
        failing since 48 days (last pass: v4.19.194, first fail: v4.19.194-=
68-g3c1f7bd17074)

    2021-08-02T20:16:54.798211  /lava-4309350/1/../bin/lava-test-case
    2021-08-02T20:16:54.814112  <8>[   17.285468] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Drockchip-iodomain-grf-probed RESULT=3Dfail>
    2021-08-02T20:16:54.814680  /lava-4309350/1/../bin/lava-test-case   =


  * baseline.bootrr.dwmmc_rockchip-sdio0-probed: https://kernelci.org/test/=
case/id/610852bf82d6e3770bb136a9
        failing since 48 days (last pass: v4.19.194, first fail: v4.19.194-=
68-g3c1f7bd17074)

    2021-08-02T20:16:52.373299  /lava-4309350/1/../bin/lava-test-case<8>[  =
 14.843765] <LAVA_SIGNAL_TESTCASE TEST_CASE_ID=3Ddwmmc_rockchip-sdio0-probe=
d RESULT=3Dfail>
    2021-08-02T20:16:52.373726  =

    2021-08-02T20:16:52.374014  /lava-4309350/1/../bin/lava-test-case   =


  * baseline.bootrr.dwmmc_rockchip-sdmmc-probed: https://kernelci.org/test/=
case/id/610852bf82d6e3770bb136aa
        failing since 48 days (last pass: v4.19.194, first fail: v4.19.194-=
68-g3c1f7bd17074)

    2021-08-02T20:16:51.336452  /lava-4309350/1/../bin/lava-test-case
    2021-08-02T20:16:51.342082  <8>[   13.824345] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Ddwmmc_rockchip-sdmmc-probed RESULT=3Dfail>   =

 =20
