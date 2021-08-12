Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 72E023EAD67
	for <lists+stable@lfdr.de>; Fri, 13 Aug 2021 00:54:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237013AbhHLWzW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 12 Aug 2021 18:55:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51938 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238415AbhHLWzU (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 12 Aug 2021 18:55:20 -0400
Received: from mail-pl1-x62d.google.com (mail-pl1-x62d.google.com [IPv6:2607:f8b0:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0D134C0617A8
        for <stable@vger.kernel.org>; Thu, 12 Aug 2021 15:54:55 -0700 (PDT)
Received: by mail-pl1-x62d.google.com with SMTP id l11so9394007plk.6
        for <stable@vger.kernel.org>; Thu, 12 Aug 2021 15:54:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=ktTjSSOPYqE6G4dn4WFeiswgJeUdLFH8zGX7kXUYf50=;
        b=tyE/Jw23IayYsJxO4pjjgB0aOOlvE37HoN/a5UzafGdkdlCTsIuiKP8BpMPtuJ9w9z
         WDGLH0+G1UjTBVBPEcHl02B6fCSI6HwWpq36GsnoCvrQRx5QHL9ZEPJig55IDIeksI6O
         Ff/R8l3iq0nXLJW/EOv5c7qkuNUe7jx9FBgnLrwREizQf3WcgIxAW5YSF/9CHqBSNXtW
         Uj2Z9BOke2a7O2RKyRng/Xb0JnceCGs0kSAk6HW7WsmFi/YXz2Xt4deyLInf4IPviatx
         wG7ET5xxElow7/hTO6UyFJTyokvl8tt+7fA2CkiAay3AQar2JgTopcPUSbFhpc/YyMDU
         OsEw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=ktTjSSOPYqE6G4dn4WFeiswgJeUdLFH8zGX7kXUYf50=;
        b=K1Dk4SIxwroqpI+rQrPLmsw7ybCs+bJM9KarHRAQO8KeWQtAzK/+6dLRq3mgky24Bn
         h+xjmYeQDZAJFtRD986BnBCyuq1LNAZokrfAc/4lY6saNpV9dRRXHolmUKYhtWo9qXG8
         23XFYHWO2dIh/ZX0qRrbJgip1tsIhweHT465By/n41XXadML2+dT4VMQyfwSPtLbcydL
         TZ4dPj8eroYYFZuMTT4owhLBB+1im1Z+bDrUYk7gr/DuyFzZ+4fYBA9duzSGx+l4cQdm
         M7T2OCYLvgV+6R0L6R+J7s/G+fGCttbRtyIkn/teHDCkWBq28QAX80SdFOQlBZlwFaVo
         c65Q==
X-Gm-Message-State: AOAM533DxDod7Op392g7BX2XFtYXhBrWN2259yCDu/eV5A04BozSI7IL
        y7mB8IdpACHBB9tUeYk07ubRN35nC7EzsJ+k
X-Google-Smtp-Source: ABdhPJyMgRL7TDb1TtZNFqIaBbUPjM19suLtFaxA4U71q3JMlmSsm3o8HNS7nL0o9mQjXxbxGMt+aA==
X-Received: by 2002:a62:8603:0:b029:3c8:3fdb:4aea with SMTP id x3-20020a6286030000b02903c83fdb4aeamr6263111pfd.6.1628808894404;
        Thu, 12 Aug 2021 15:54:54 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id g5sm4653002pfm.209.2021.08.12.15.54.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 12 Aug 2021 15:54:54 -0700 (PDT)
Message-ID: <6115a6be.1c69fb81.a70f5.db70@mx.google.com>
Date:   Thu, 12 Aug 2021 15:54:54 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: linux-4.19.y
X-Kernelci-Tree: stable
X-Kernelci-Kernel: v4.19.203
X-Kernelci-Report-Type: test
Subject: stable/linux-4.19.y baseline: 147 runs, 7 regressions (v4.19.203)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable/linux-4.19.y baseline: 147 runs, 7 regressions (v4.19.203)

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


  Details:  https://kernelci.org/test/job/stable/branch/linux-4.19.y/kernel=
/v4.19.203/plan/baseline/

  Test:     baseline
  Tree:     stable
  Branch:   linux-4.19.y
  Describe: v4.19.203
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able.git
  SHA:      addba38e7c3bc19036a05c83bcce7878dc644d87 =



Test Regressions
---------------- =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-baylibre    | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/61156efa52ee460c5eb13661

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable/linux-4.19.y/v4.19.203/=
arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.19.y/v4.19.203/=
arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_arm-versatilepb.ht=
ml
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61156efa52ee460c5eb13=
662
        failing since 266 days (last pass: v4.19.157, first fail: v4.19.158=
) =

 =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-broonie     | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/61156efc1581afec99b13680

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable/linux-4.19.y/v4.19.203/=
arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.19.y/v4.19.203/=
arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61156efc1581afec99b13=
681
        failing since 266 days (last pass: v4.19.157, first fail: v4.19.158=
) =

 =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-collabora   | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/61156eae2b1d529c0fb1366a

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable/linux-4.19.y/v4.19.203/=
arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu_arm-versatilepb.t=
xt
  HTML log:    https://storage.kernelci.org//stable/linux-4.19.y/v4.19.203/=
arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu_arm-versatilepb.h=
tml
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61156eae2b1d529c0fb13=
66b
        failing since 266 days (last pass: v4.19.157, first fail: v4.19.158=
) =

 =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-linaro-lkft | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/61156e9e2b1d529c0fb13661

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable/linux-4.19.y/v4.19.203/=
arm/versatile_defconfig/gcc-8/lab-linaro-lkft/baseline-qemu_arm-versatilepb=
.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.19.y/v4.19.203/=
arm/versatile_defconfig/gcc-8/lab-linaro-lkft/baseline-qemu_arm-versatilepb=
.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61156e9e2b1d529c0fb13=
662
        failing since 266 days (last pass: v4.19.157, first fail: v4.19.158=
) =

 =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
rk3288-veyron-jaq    | arm  | lab-collabora   | gcc-8    | multi_v7_defconf=
ig  | 3          =


  Details:     https://kernelci.org/test/plan/id/611575bff2122f2ffab136ab

  Results:     64 PASS, 6 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable/linux-4.19.y/v4.19.203/=
arm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-rk3288-veyron-jaq.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.19.y/v4.19.203/=
arm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-rk3288-veyron-jaq.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.bootrr.rockchip-iodomain-grf-probed: https://kernelci.org/test=
/case/id/611575bff2122f2ffab136c3
        failing since 57 days (last pass: v4.19.194, first fail: v4.19.195)

    2021-08-12T19:25:35.674630  /lava-4354793/1/../bin/lava-test-case<8>[  =
 18.204778] <LAVA_SIGNAL_TESTCASE TEST_CASE_ID=3Drockchip-iodomain-grf-prob=
ed RESULT=3Dfail>
    2021-08-12T19:25:35.674943  =

    2021-08-12T19:25:35.675130  /lava-4354793/1/../bin/lava-test-case   =


  * baseline.bootrr.dwmmc_rockchip-sdio0-probed: https://kernelci.org/test/=
case/id/611575bff2122f2ffab136dc
        failing since 57 days (last pass: v4.19.194, first fail: v4.19.195)

    2021-08-12T19:25:33.217517  /lava-4354793/1/../bin/lava-test-case
    2021-08-12T19:25:33.234500  <8>[   15.763369] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Ddwmmc_rockchip-sdio0-probed RESULT=3Dfail>
    2021-08-12T19:25:33.234721  /lava-4354793/1/../bin/lava-test-case   =


  * baseline.bootrr.dwmmc_rockchip-sdmmc-probed: https://kernelci.org/test/=
case/id/611575bff2122f2ffab136dd
        failing since 57 days (last pass: v4.19.194, first fail: v4.19.195)

    2021-08-12T19:25:32.202927  /lava-4354793/1/../bin/lava-test-case<8>[  =
 14.744205] <LAVA_SIGNAL_TESTCASE TEST_CASE_ID=3Ddwmmc_rockchip-sdmmc-probe=
d RESULT=3Dfail>
    2021-08-12T19:25:32.203263     =

 =20
