Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 471D33CA186
	for <lists+stable@lfdr.de>; Thu, 15 Jul 2021 17:32:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238973AbhGOPfr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 15 Jul 2021 11:35:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39256 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237550AbhGOPfr (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 15 Jul 2021 11:35:47 -0400
Received: from mail-pl1-x632.google.com (mail-pl1-x632.google.com [IPv6:2607:f8b0:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 18A47C061760
        for <stable@vger.kernel.org>; Thu, 15 Jul 2021 08:32:54 -0700 (PDT)
Received: by mail-pl1-x632.google.com with SMTP id b12so3538583plh.10
        for <stable@vger.kernel.org>; Thu, 15 Jul 2021 08:32:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=hXEn4SNZ8GVJhdZfy8rz6BNLG+94hXjpI/MzsAVSvWE=;
        b=vAXzVp+qM2MUasjdk1fQmnFZjOVqD/nZFugZYOstHFadUTz76c+99r9E5RM8Dr8C+k
         +M/hJvzq5UI2KS5+JDV0aztK49owEU8gnvXg6Dn4aKGcvnS2zaTqV+TODXVPa9DMdgqj
         ozSxJLWcxASSFvQsZk/0/PqJR+Gl0Fk//RSPbrUTrn6RuR62c1r8rD1YkNgho+f7iYcw
         fc1DT4jQVPCFSsBGfXlUFurH7o1ZIlCOEV5ecZ8AMbB3oE8QHdeAN+wcg60oJAP3h3mp
         CqG1ZfKh5rBOjg6WlI64s9IWCOCUuqy3Fv0YU9NzqXMxDz52w7krEUyMs0S/b/Sxh98a
         h28w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=hXEn4SNZ8GVJhdZfy8rz6BNLG+94hXjpI/MzsAVSvWE=;
        b=jnf4XnLFTqMfiWhyCrpdoNtvo3f7fneIiAxd2dj62JFQu+yAQyPRPDW0za8zLxD+YR
         cT0a6XDMFXwNEV2O5mjmVz8ybhi/PqGMCPH8r4z1IdWHEuB57ac54cLT8v9EhLQ29PrS
         mD9S9uVVOeztfLlB5xW8FRL/FkTkm9GVy4zXeRhR/wKyJtfOryo33Gbw/pTZT0Kmvo8q
         ynFg6ithSfBWaegP3q537OXFdRCjAqUUsfL173Fgzq4g2SOVbDlTnBL/G8J36X3wf07g
         2j9lTxqqNc873sv1HrcNorNBhxAcm7hsQXfieOwmxOVIUVJaIyPdF+6YF3E+6m6TLRjb
         b30g==
X-Gm-Message-State: AOAM531+8JSGsANJXTZGhzOjGlpxE6gfdwrDMC4Rw/H5mE3KHN2JNRtr
        CBCVHUl05GbQJwSHvTSOjJS1TiMkrz3uWUPQ
X-Google-Smtp-Source: ABdhPJyC8YM0GGk7r3ZDFkRODrbbhkGf0OtU4JYNGoRv29ArL2eCLyQyuTCZpmnCBFufoyTIk612Sg==
X-Received: by 2002:a17:902:c213:b029:12a:fb53:35cb with SMTP id 19-20020a170902c213b029012afb5335cbmr3971823pll.49.1626363173390;
        Thu, 15 Jul 2021 08:32:53 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id l6sm7098305pff.74.2021.07.15.08.32.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 15 Jul 2021 08:32:53 -0700 (PDT)
Message-ID: <60f05525.1c69fb81.22357.4b30@mx.google.com>
Date:   Thu, 15 Jul 2021 08:32:53 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/4.19
X-Kernelci-Kernel: v4.19.197-279-g088e1d22d7f1
Subject: stable-rc/queue/4.19 baseline: 159 runs,
 8 regressions (v4.19.197-279-g088e1d22d7f1)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.19 baseline: 159 runs, 8 regressions (v4.19.197-279-g088e=
1d22d7f1)

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

qemu_arm-versatilepb | arm  | lab-collabora   | gcc-8    | versatile_defcon=
fig | 1          =

qemu_arm-versatilepb | arm  | lab-linaro-lkft | gcc-8    | versatile_defcon=
fig | 1          =

rk3288-veyron-jaq    | arm  | lab-collabora   | gcc-8    | multi_v7_defconf=
ig  | 3          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.19/ker=
nel/v4.19.197-279-g088e1d22d7f1/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.19
  Describe: v4.19.197-279-g088e1d22d7f1
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      088e1d22d7f1d6cb4f582c2cdd0a041117668b66 =



Test Regressions
---------------- =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-baylibre    | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/60f01bccba8b65ffa98a93ad

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.197=
-279-g088e1d22d7f1/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu=
_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.197=
-279-g088e1d22d7f1/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu=
_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60f01bccba8b65ffa98a9=
3ae
        failing since 243 days (last pass: v4.19.157-26-gd59f3161b3a0, firs=
t fail: v4.19.157-27-g5543cc2c41d55) =

 =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-broonie     | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/60f01bcae9433428928a93bc

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.197=
-279-g088e1d22d7f1/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_=
arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.197=
-279-g088e1d22d7f1/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_=
arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60f01bcae9433428928a9=
3bd
        failing since 243 days (last pass: v4.19.157-26-gd59f3161b3a0, firs=
t fail: v4.19.157-27-g5543cc2c41d55) =

 =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-cip         | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/60f01bdb0f029973c78a939c

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.197=
-279-g088e1d22d7f1/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-=
versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.197=
-279-g088e1d22d7f1/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-=
versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60f01bdb0f029973c78a9=
39d
        failing since 243 days (last pass: v4.19.157-26-gd59f3161b3a0, firs=
t fail: v4.19.157-27-g5543cc2c41d55) =

 =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-collabora   | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/60f01b785e4d20e8978a93a6

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.197=
-279-g088e1d22d7f1/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qem=
u_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.197=
-279-g088e1d22d7f1/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qem=
u_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60f01b785e4d20e8978a9=
3a7
        failing since 243 days (last pass: v4.19.157-26-gd59f3161b3a0, firs=
t fail: v4.19.157-27-g5543cc2c41d55) =

 =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-linaro-lkft | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/60f024a3a358bf7d858a93b5

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.197=
-279-g088e1d22d7f1/arm/versatile_defconfig/gcc-8/lab-linaro-lkft/baseline-q=
emu_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.197=
-279-g088e1d22d7f1/arm/versatile_defconfig/gcc-8/lab-linaro-lkft/baseline-q=
emu_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60f024a3a358bf7d858a9=
3b6
        failing since 243 days (last pass: v4.19.157-26-gd59f3161b3a0, firs=
t fail: v4.19.157-27-g5543cc2c41d55) =

 =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
rk3288-veyron-jaq    | arm  | lab-collabora   | gcc-8    | multi_v7_defconf=
ig  | 3          =


  Details:     https://kernelci.org/test/plan/id/60f01fba0cce0001348a93b5

  Results:     64 PASS, 6 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.197=
-279-g088e1d22d7f1/arm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-rk32=
88-veyron-jaq.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.197=
-279-g088e1d22d7f1/arm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-rk32=
88-veyron-jaq.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.bootrr.rockchip-iodomain-grf-probed: https://kernelci.org/test=
/case/id/60f01fba0cce0001348a93c9
        failing since 30 days (last pass: v4.19.194-28-g6098ecdead2c, first=
 fail: v4.19.194-67-g1b5dea188d94)

    2021-07-15T11:44:40.187830  /lava-4203198/1/../bin/lava-test-case
    2021-07-15T11:44:40.203598  <8>[   17.656872] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Drockchip-iodomain-grf-probed RESULT=3Dfail>   =


  * baseline.bootrr.dwmmc_rockchip-sdio0-probed: https://kernelci.org/test/=
case/id/60f01fba0cce0001348a93e2
        failing since 30 days (last pass: v4.19.194-28-g6098ecdead2c, first=
 fail: v4.19.194-67-g1b5dea188d94)

    2021-07-15T11:44:37.746698  /lava-4203198/1/../bin/lava-test-case
    2021-07-15T11:44:37.764332  <8>[   15.216411] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Ddwmmc_rockchip-sdio0-probed RESULT=3Dfail>   =


  * baseline.bootrr.dwmmc_rockchip-sdmmc-probed: https://kernelci.org/test/=
case/id/60f01fba0cce0001348a93e3
        failing since 30 days (last pass: v4.19.194-28-g6098ecdead2c, first=
 fail: v4.19.194-67-g1b5dea188d94)

    2021-07-15T11:44:36.727843  /lava-4203198/1/../bin/lava-test-case
    2021-07-15T11:44:36.733324  <8>[   14.197098] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Ddwmmc_rockchip-sdmmc-probed RESULT=3Dfail>   =

 =20
