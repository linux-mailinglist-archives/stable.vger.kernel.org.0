Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B89A13C3FCC
	for <lists+stable@lfdr.de>; Mon, 12 Jul 2021 00:46:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229770AbhGKWtd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 11 Jul 2021 18:49:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37742 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229544AbhGKWtc (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 11 Jul 2021 18:49:32 -0400
Received: from mail-pg1-x530.google.com (mail-pg1-x530.google.com [IPv6:2607:f8b0:4864:20::530])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A98B2C0613DD
        for <stable@vger.kernel.org>; Sun, 11 Jul 2021 15:46:44 -0700 (PDT)
Received: by mail-pg1-x530.google.com with SMTP id t9so16269462pgn.4
        for <stable@vger.kernel.org>; Sun, 11 Jul 2021 15:46:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=1jD5JC9fymuFvQqJAUNlJIkHErP16DwxmWzBkjqLl3E=;
        b=vzg9kWO7YvWjPHNTU/bNXvOswZSGgKuWE86vhih7+blBYELp5dgnnkghH5DFNWeF9j
         LB9r66eQRKGkscuxhZ4s+ybmzT/JgZ/KqeZVudBO5IEGxxvs2mtdZJd6xSPT5uZHHFRM
         X5ux7XurTEgAfjuALDcrHjAsW7HzoVjMVt122XFddA+veKQOizYcv4pWaALsR/XodZfc
         zKsiE8H9qaMlSU3cuyvYK58NHI7i32oQK9FpX3oqWhbFLbV36clDr9xCHfk8nLBPh6Bx
         sLaUU4GwwlqO+6FaW60bbgX8o+GedEVwJ2rW94o4cGsargc6xqvB3h0qfOz2xx6iTAIM
         6tpg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=1jD5JC9fymuFvQqJAUNlJIkHErP16DwxmWzBkjqLl3E=;
        b=QRP12cfkMGJelEEclgG4Igfv6IsV19IphUY82gpJTECwLwOY+AG3Sj60SEo3upNAZu
         mt0nveZgUQnIONwC5uw0N61fCUw1W0e5gPtPvvoJwXi7q7+wWc054t9u6fmzrWgamQ//
         nJVQKp+q7eyZKruXoTzhgEGhpqNlYlvmFeTq+mgZCVYmk0O0Te6UJAhD7sqFwUeCbHG4
         fqRBsjfQZCXZjXPilFapebbYZDWzBR+46tsjwIRz/5hKMR9zoBQEir+Qaul83MEheLrc
         7vjwb02g8Rvv9V3c3dUVOo3KsUJ5qpew+4aNNNknNTMMIzq5VNBaSvCb9pP10Bv5ZaCT
         iR7A==
X-Gm-Message-State: AOAM531qKHZZmxBJAQTN7SSK5QSKid8H9gDNC3b7/SZo3k4ZGHtel5yr
        7uOB53Yb6F6ChrTq4R9MbbXHdeFOHwv8elgq
X-Google-Smtp-Source: ABdhPJxJH6DftrHj+/IJMae66xqS4i+NaTabbfptMzJ47ly6O2SfPF0iDsLYI/YSbqTMNNVEDBWZ0A==
X-Received: by 2002:a62:2e07:0:b029:320:d352:89da with SMTP id u7-20020a622e070000b0290320d35289damr38293501pfu.28.1626043603918;
        Sun, 11 Jul 2021 15:46:43 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id o3sm18622610pjp.27.2021.07.11.15.46.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 11 Jul 2021 15:46:43 -0700 (PDT)
Message-ID: <60eb74d3.1c69fb81.6ffc8.8cfa@mx.google.com>
Date:   Sun, 11 Jul 2021 15:46:43 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.19.197-224-gd8feefb59b6d
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/4.19
Subject: stable-rc/queue/4.19 baseline: 128 runs,
 7 regressions (v4.19.197-224-gd8feefb59b6d)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.19 baseline: 128 runs, 7 regressions (v4.19.197-224-gd8fe=
efb59b6d)

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
nel/v4.19.197-224-gd8feefb59b6d/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.19
  Describe: v4.19.197-224-gd8feefb59b6d
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      d8feefb59b6d1808d80139ba5d79e5064af23a03 =



Test Regressions
---------------- =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-baylibre  | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/60eb3990f16636a5b611797e

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.197=
-224-gd8feefb59b6d/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu=
_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.197=
-224-gd8feefb59b6d/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu=
_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60eb3990f16636a5b6117=
97f
        failing since 239 days (last pass: v4.19.157-26-gd59f3161b3a0, firs=
t fail: v4.19.157-27-g5543cc2c41d55) =

 =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-broonie   | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/60eb3ea1d078b33935117975

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.197=
-224-gd8feefb59b6d/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_=
arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.197=
-224-gd8feefb59b6d/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_=
arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60eb3ea1d078b33935117=
976
        failing since 239 days (last pass: v4.19.157-26-gd59f3161b3a0, firs=
t fail: v4.19.157-27-g5543cc2c41d55) =

 =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-cip       | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/60eb397429efee3233117999

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.197=
-224-gd8feefb59b6d/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-=
versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.197=
-224-gd8feefb59b6d/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-=
versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60eb397429efee3233117=
99a
        failing since 239 days (last pass: v4.19.157-26-gd59f3161b3a0, firs=
t fail: v4.19.157-27-g5543cc2c41d55) =

 =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-collabora | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/60eb43f11e9f12398611796f

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.197=
-224-gd8feefb59b6d/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qem=
u_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.197=
-224-gd8feefb59b6d/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qem=
u_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60eb43f11e9f123986117=
970
        failing since 239 days (last pass: v4.19.157-26-gd59f3161b3a0, firs=
t fail: v4.19.157-27-g5543cc2c41d55) =

 =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
rk3288-veyron-jaq    | arm  | lab-collabora | gcc-8    | multi_v7_defconfig=
  | 3          =


  Details:     https://kernelci.org/test/plan/id/60eb69a9a0952d2fc2117998

  Results:     64 PASS, 6 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.197=
-224-gd8feefb59b6d/arm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-rk32=
88-veyron-jaq.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.197=
-224-gd8feefb59b6d/arm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-rk32=
88-veyron-jaq.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.bootrr.rockchip-iodomain-grf-probed: https://kernelci.org/test=
/case/id/60eb69a9a0952d2fc21179ac
        failing since 26 days (last pass: v4.19.194-28-g6098ecdead2c, first=
 fail: v4.19.194-67-g1b5dea188d94)

    2021-07-11T21:58:50.174880  /lava-4178219/1/../bin/lava-test-case<8>[  =
 18.135104] <LAVA_SIGNAL_TESTCASE TEST_CASE_ID=3Drockchip-iodomain-grf-prob=
ed RESULT=3Dfail>
    2021-07-11T21:58:50.175415  =

    2021-07-11T21:58:50.175792  /lava-4178219/1/../bin/lava-test-case   =


  * baseline.bootrr.dwmmc_rockchip-sdio0-probed: https://kernelci.org/test/=
case/id/60eb69a9a0952d2fc21179c5
        failing since 26 days (last pass: v4.19.194-28-g6098ecdead2c, first=
 fail: v4.19.194-67-g1b5dea188d94)

    2021-07-11T21:58:47.734152  /lava-4178219/1/../bin/lava-test-case<8>[  =
 15.693096] <LAVA_SIGNAL_TESTCASE TEST_CASE_ID=3Ddwmmc_rockchip-sdio0-probe=
d RESULT=3Dfail>
    2021-07-11T21:58:47.734732  =

    2021-07-11T21:58:47.735079  /lava-4178219/1/../bin/lava-test-case   =


  * baseline.bootrr.dwmmc_rockchip-sdmmc-probed: https://kernelci.org/test/=
case/id/60eb69a9a0952d2fc21179c6
        failing since 26 days (last pass: v4.19.194-28-g6098ecdead2c, first=
 fail: v4.19.194-67-g1b5dea188d94)

    2021-07-11T21:58:46.687981  /lava-4178219/1/../bin/lava-test-case
    2021-07-11T21:58:46.698865  <8>[   14.673625] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Ddwmmc_rockchip-sdmmc-probed RESULT=3Dfail>   =

 =20
