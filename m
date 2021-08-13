Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4A5FA3EBE45
	for <lists+stable@lfdr.de>; Sat, 14 Aug 2021 00:25:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235098AbhHMWZ5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 13 Aug 2021 18:25:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33672 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235029AbhHMWZ4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 13 Aug 2021 18:25:56 -0400
Received: from mail-pl1-x62c.google.com (mail-pl1-x62c.google.com [IPv6:2607:f8b0:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 716C0C061756
        for <stable@vger.kernel.org>; Fri, 13 Aug 2021 15:25:29 -0700 (PDT)
Received: by mail-pl1-x62c.google.com with SMTP id n12so13176441plf.4
        for <stable@vger.kernel.org>; Fri, 13 Aug 2021 15:25:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=ObIipe+GXLzvtZ4nzfp9TOPFbG7qZbJWaqbOvAInO1w=;
        b=AIucV3DHksHk+qGmosRWcvMjetQgzfSvmyuuC+4D9zc3725DC2j4zll0G8gDmHDpRG
         BE0sWsGcP3uoqQ92WJUd2lsHETb97PkPtVtyenCAoEv/2vUkHdoX9Vr42IOB62Jva6ks
         XbD90hMkE7xMFFZPWoHVnv6NPd+ORZDjWg+AgzYJ5StXfNe0bnRS3CFjigrZgxA1+f6L
         x/PVCKJ09/0zsUFwGiDdN+H7HM3BqLrnopjShkHru0Dv0T+lVQ5Vxl9f9MBwi+aaWKkF
         Otnm4KConyMO+YdkLy3zFU0H+SPkuc4f1lUvpVOTHiLDUYAkQG467ElhKAPTf4pxy2MS
         DAeg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=ObIipe+GXLzvtZ4nzfp9TOPFbG7qZbJWaqbOvAInO1w=;
        b=hfnW8PJwhzxhyL77R0ZPtBnsdm8Fb0WnVysgMu1ov0L7KGxL5q2ZAD/tP9XnUazZsD
         5xB3cOnuS0h2HjysTBAshCR+AJ6uqmxXqqy9iqeg+iV+TAMDfGfbtTyQgJk+0k2xnYeb
         PCN9lRt2m0SGaBme5KttkDbb+HT4QaVjhOu25sdZzPyzqbqQWWavT8hibE43IRdSiVqw
         ydaRaKYHg+FHVjXhrfpLayFyPqL1joHPSqWZw85VElrYhL/RpNrS3MU3Bsx/Q/Z+z2oo
         kwcHMgkc+AzFkSUtdc4zkEm1joYpryMPlYxxVSpm/tcPh8rxp0f0V6hR+6mK5nOJ/39t
         b9jg==
X-Gm-Message-State: AOAM5333IciQyrIuAilblSiI8395/FiYYPVXmC6pG42hUaZG+5oHMr0L
        MsZBMaHrJrd5FVwsVOlxplpo4DRiMiSFmLqe
X-Google-Smtp-Source: ABdhPJyI30NjoQB7MIw51XKDZJJBovSqyzVp/3KgqhIolt1qiQxM5YVb4P+dEMNG5ufjqopixk30hw==
X-Received: by 2002:a17:90a:f314:: with SMTP id ca20mr4801953pjb.210.1628893528637;
        Fri, 13 Aug 2021 15:25:28 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id fa21sm2785820pjb.20.2021.08.13.15.25.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 13 Aug 2021 15:25:28 -0700 (PDT)
Message-ID: <6116f158.1c69fb81.19ba.756c@mx.google.com>
Date:   Fri, 13 Aug 2021 15:25:28 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: queue/4.19
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v4.19.202-65-g492cef3bc78d
X-Kernelci-Report-Type: test
Subject: stable-rc/queue/4.19 baseline: 139 runs,
 6 regressions (v4.19.202-65-g492cef3bc78d)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.19 baseline: 139 runs, 6 regressions (v4.19.202-65-g492ce=
f3bc78d)

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


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.19/ker=
nel/v4.19.202-65-g492cef3bc78d/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.19
  Describe: v4.19.202-65-g492cef3bc78d
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      492cef3bc78dd1de47c01428a62c009955e9739c =



Test Regressions
---------------- =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-baylibre  | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/6116ba61cc28d2b9a3b13669

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.202=
-65-g492cef3bc78d/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_=
arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.202=
-65-g492cef3bc78d/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_=
arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6116ba61cc28d2b9a3b13=
66a
        failing since 272 days (last pass: v4.19.157-26-gd59f3161b3a0, firs=
t fail: v4.19.157-27-g5543cc2c41d55) =

 =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-broonie   | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/6116ba9ddf6ec514a8b13661

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.202=
-65-g492cef3bc78d/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_a=
rm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.202=
-65-g492cef3bc78d/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_a=
rm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6116ba9ddf6ec514a8b13=
662
        failing since 272 days (last pass: v4.19.157-26-gd59f3161b3a0, firs=
t fail: v4.19.157-27-g5543cc2c41d55) =

 =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-collabora | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/6116c456c42b4132a6b1368a

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.202=
-65-g492cef3bc78d/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu=
_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.202=
-65-g492cef3bc78d/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu=
_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6116c456c42b4132a6b13=
68b
        failing since 272 days (last pass: v4.19.157-26-gd59f3161b3a0, firs=
t fail: v4.19.157-27-g5543cc2c41d55) =

 =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
rk3288-veyron-jaq    | arm  | lab-collabora | gcc-8    | multi_v7_defconfig=
  | 3          =


  Details:     https://kernelci.org/test/plan/id/6116bc1ab4838b7cd0b1368c

  Results:     64 PASS, 6 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.202=
-65-g492cef3bc78d/arm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-rk328=
8-veyron-jaq.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.202=
-65-g492cef3bc78d/arm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-rk328=
8-veyron-jaq.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.bootrr.rockchip-iodomain-grf-probed: https://kernelci.org/test=
/case/id/6116bc1ab4838b7cd0b136a4
        failing since 59 days (last pass: v4.19.194-28-g6098ecdead2c, first=
 fail: v4.19.194-67-g1b5dea188d94)

    2021-08-13T18:38:07.955947  /lava-4359761/1/../bin/lava-test-case
    2021-08-13T18:38:07.972981  <8>[   17.659972] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Drockchip-iodomain-grf-probed RESULT=3Dfail>
    2021-08-13T18:38:07.973317  /lava-4359761/1/../bin/lava-test-case   =


  * baseline.bootrr.dwmmc_rockchip-sdio0-probed: https://kernelci.org/test/=
case/id/6116bc1ab4838b7cd0b136bd
        failing since 59 days (last pass: v4.19.194-28-g6098ecdead2c, first=
 fail: v4.19.194-67-g1b5dea188d94)

    2021-08-13T18:38:05.514960  /lava-4359761/1/../bin/lava-test-case
    2021-08-13T18:38:05.532965  <8>[   15.217835] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Ddwmmc_rockchip-sdio0-probed RESULT=3Dfail>
    2021-08-13T18:38:05.533233  /lava-4359761/1/../bin/lava-test-case   =


  * baseline.bootrr.dwmmc_rockchip-sdmmc-probed: https://kernelci.org/test/=
case/id/6116bc1ab4838b7cd0b136be
        failing since 59 days (last pass: v4.19.194-28-g6098ecdead2c, first=
 fail: v4.19.194-67-g1b5dea188d94)

    2021-08-13T18:38:04.500486  /lava-4359761/1/../bin/lava-test-case<8>[  =
 14.198531] <LAVA_SIGNAL_TESTCASE TEST_CASE_ID=3Ddwmmc_rockchip-sdmmc-probe=
d RESULT=3Dfail>
    2021-08-13T18:38:04.500795     =

 =20
