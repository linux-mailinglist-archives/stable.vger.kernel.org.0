Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C76293D0B6A
	for <lists+stable@lfdr.de>; Wed, 21 Jul 2021 11:21:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237454AbhGUIjv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 21 Jul 2021 04:39:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41564 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236260AbhGUIhX (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 21 Jul 2021 04:37:23 -0400
Received: from mail-pg1-x52d.google.com (mail-pg1-x52d.google.com [IPv6:2607:f8b0:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 63EBDC0613E4
        for <stable@vger.kernel.org>; Wed, 21 Jul 2021 02:17:45 -0700 (PDT)
Received: by mail-pg1-x52d.google.com with SMTP id u14so1265508pga.11
        for <stable@vger.kernel.org>; Wed, 21 Jul 2021 02:17:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=pm+uE2W4vLtJ/8I1xp7P1BoG4yRNrUhb32mI+QrlVnY=;
        b=ysXbfUn2OMsJXl4NBxRee07UguLfNSgMzO/LGgp6sVeGzGi/9Z6FtsTNxealOmR5G1
         ag4ubF7TXCMLIJYmzmlfF7l93NymGrzZxMeSzRgNfcvQaPIHm/6Bzx6oH48LcE99DnSA
         9E76H0VohqdtkwR0oCOHWHaRXyHSNx0z5q/fnDejOkyZ+kWkUqoOgZulOmWj8sj9KuRp
         /HgH7DGhm5+BlffPeNwvBVmP67moNYlZpi+S5MweUHgdhOTd+7qCdKwJZsC+EKDf6eqk
         cGgV2R/MBXrDU2ZF3dGEiMwTi/qzBy2dNkE3xYsMVoFhrofkqsk5iy4upT6rpAWIXsWD
         EXBQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=pm+uE2W4vLtJ/8I1xp7P1BoG4yRNrUhb32mI+QrlVnY=;
        b=T0RaOuOf7XvRUi1CWyh/R+ZslI7/aF2sstEGZdn17fjCziIe2LJQUz14mgL6PBviLP
         DP34CPHxD4jjWcgkHVHNb4buhACI850SeaG9tpsREXVq6C3Rg7cfaGgs7iTumgwfcEvL
         vMEbOSrXDkWjB1DunXcvC+AV2+ZuT4KH4A0+axuyRFM+e4ju9CqhSy6tdTXR+kWHqFk6
         qoaH63OkaufYj6BgzpMpwlHF3EY06RKBcQpkoVfooZoJdo4B0qQM3OAwd8Fa/hsxn2QL
         tInkxor3Md7BbI1BZWg/N9IpFhly5KZ7mhOogDHjX7VFcaIh7UeV8WSsnGgtsU2IZsny
         lh8w==
X-Gm-Message-State: AOAM532tUwcZdtrZvfU6I0ZvmkE20N23KwCVUervK4yySbgYR3/PoyrQ
        SVLNYVhyrjN3kjahRB15NcTF7CH6JwdX0PoY
X-Google-Smtp-Source: ABdhPJyxrJb5Xin4zv0slU3DFdl0Igg6+++KXOAMYVyckDx+KU+LvMxQByBDosOScegEkzzx3z4RaQ==
X-Received: by 2002:a65:6441:: with SMTP id s1mr34327299pgv.214.1626859064802;
        Wed, 21 Jul 2021 02:17:44 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id u33sm26757385pfg.3.2021.07.21.02.17.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 21 Jul 2021 02:17:44 -0700 (PDT)
Message-ID: <60f7e638.1c69fb81.e1ca1.f151@mx.google.com>
Date:   Wed, 21 Jul 2021 02:17:44 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: linux-4.19.y
X-Kernelci-Kernel: v4.19.198
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable
Subject: stable/linux-4.19.y baseline: 156 runs, 6 regressions (v4.19.198)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable/linux-4.19.y baseline: 156 runs, 6 regressions (v4.19.198)

Regressions Summary
-------------------

platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-baylibre  | gcc-8    | versatile_defconfi=
g | 1          =

qemu_arm-versatilepb | arm  | lab-cip       | gcc-8    | versatile_defconfi=
g | 1          =

qemu_arm-versatilepb | arm  | lab-collabora | gcc-8    | versatile_defconfi=
g | 1          =

rk3288-veyron-jaq    | arm  | lab-collabora | gcc-8    | multi_v7_defconfig=
  | 3          =


  Details:  https://kernelci.org/test/job/stable/branch/linux-4.19.y/kernel=
/v4.19.198/plan/baseline/

  Test:     baseline
  Tree:     stable
  Branch:   linux-4.19.y
  Describe: v4.19.198
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able.git
  SHA:      4938296e03bd227e5020d63d418956fe52baf97c =



Test Regressions
---------------- =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-baylibre  | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/60f7c111ffd73d9dc385c266

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable/linux-4.19.y/v4.19.198/=
arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.19.y/v4.19.198/=
arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_arm-versatilepb.ht=
ml
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60f7c111ffd73d9dc385c=
267
        failing since 244 days (last pass: v4.19.157, first fail: v4.19.158=
) =

 =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-cip       | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/60f7acbc69d3f1708185c25c

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable/linux-4.19.y/v4.19.198/=
arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.19.y/v4.19.198/=
arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60f7acbc69d3f1708185c=
25d
        failing since 244 days (last pass: v4.19.157, first fail: v4.19.158=
) =

 =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-collabora | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/60f7b297cc77a80c9785c2b6

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable/linux-4.19.y/v4.19.198/=
arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu_arm-versatilepb.t=
xt
  HTML log:    https://storage.kernelci.org//stable/linux-4.19.y/v4.19.198/=
arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu_arm-versatilepb.h=
tml
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60f7b297cc77a80c9785c=
2b7
        failing since 244 days (last pass: v4.19.157, first fail: v4.19.158=
) =

 =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
rk3288-veyron-jaq    | arm  | lab-collabora | gcc-8    | multi_v7_defconfig=
  | 3          =


  Details:     https://kernelci.org/test/plan/id/60f7d3ac0b4c0356fb85c2d9

  Results:     64 PASS, 6 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable/linux-4.19.y/v4.19.198/=
arm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-rk3288-veyron-jaq.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.19.y/v4.19.198/=
arm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-rk3288-veyron-jaq.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.bootrr.rockchip-iodomain-grf-probed: https://kernelci.org/test=
/case/id/60f7d3ac0b4c0356fb85c2ed
        failing since 34 days (last pass: v4.19.194, first fail: v4.19.195)

    2021-07-21T07:58:26.425301  /lava-4223496/1/../bin/lava-test-case<8>[  =
 17.820292] <LAVA_SIGNAL_TESTCASE TEST_CASE_ID=3Drockchip-iodomain-grf-prob=
ed RESULT=3Dfail>
    2021-07-21T07:58:26.425841  =

    2021-07-21T07:58:26.426265  /lava-4223496/1/../bin/lava-test-case   =


  * baseline.bootrr.dwmmc_rockchip-sdio0-probed: https://kernelci.org/test/=
case/id/60f7d3ac0b4c0356fb85c303
        failing since 34 days (last pass: v4.19.194, first fail: v4.19.195)

    2021-07-21T07:58:23.966733  /lava-4223496/1/../bin/lava-test-case
    2021-07-21T07:58:23.985261  <8>[   15.378314] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Ddwmmc_rockchip-sdio0-probed RESULT=3Dfail>
    2021-07-21T07:58:23.985760  /lava-4223496/1/../bin/lava-test-case   =


  * baseline.bootrr.dwmmc_rockchip-sdmmc-probed: https://kernelci.org/test/=
case/id/60f7d3ac0b4c0356fb85c304
        failing since 34 days (last pass: v4.19.194, first fail: v4.19.195)

    2021-07-21T07:58:22.952577  /lava-4223496/1/../bin/lava-test-case<8>[  =
 14.359181] <LAVA_SIGNAL_TESTCASE TEST_CASE_ID=3Ddwmmc_rockchip-sdmmc-probe=
d RESULT=3Dfail>
    2021-07-21T07:58:22.952921     =

 =20
