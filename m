Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8466B3F1209
	for <lists+stable@lfdr.de>; Thu, 19 Aug 2021 05:41:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236304AbhHSDmG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 18 Aug 2021 23:42:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35286 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236203AbhHSDmG (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 18 Aug 2021 23:42:06 -0400
Received: from mail-pj1-x102c.google.com (mail-pj1-x102c.google.com [IPv6:2607:f8b0:4864:20::102c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 89BD4C061764
        for <stable@vger.kernel.org>; Wed, 18 Aug 2021 20:41:30 -0700 (PDT)
Received: by mail-pj1-x102c.google.com with SMTP id m24-20020a17090a7f98b0290178b1a81700so3813514pjl.4
        for <stable@vger.kernel.org>; Wed, 18 Aug 2021 20:41:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=9/w/9w8wbYQQd3nXoUQ8yWNtubV8jP+0DxGJKHLmFsc=;
        b=VLO7bSDb6U0koxx2AKdGWySLXunWMuf98Ecp/eMbfEplHBiMrErYUsdekBHSdho++q
         mMiliQ6K6Q6rN147wc01yr6Rs1GdymeBaFMYHJPNof8YJD4p9CWFGTIIxg1IqwN7iWfJ
         Z6SlShO2lM8Z62ccqgVNTao/J+lhzysKCI1CxGi9kklTXjv9q0kOZeKwaxnDo/sViAcA
         d/ArjA72swID4/KH99THEv1pXZHunEwwAz9fIn74ufwjYYPw4YJhvYhK/v4VcZaJE0qU
         cgw6zcvYvHYCkmezmBHeItgfDpruQ8owCwPh0y+whwXNQZ74bXKiocyosvs/UYUCSGWz
         3iCw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=9/w/9w8wbYQQd3nXoUQ8yWNtubV8jP+0DxGJKHLmFsc=;
        b=qYEd/U4bOAM8tE4ZIe8Vnxqe7RSSiuhKRPFEIiW+0iaVHIdgiZAFw6XNjt8MEIFBWz
         eimFhOHVDpppk6Pzn3JDF/Z6e53WMWe/DwAxn/m8n99eywTHZiewCZaJ87L+I5Vfk154
         zpT46i+OyVMQyokxoISM1BnuKaBpO+oY/er5l7yiW1QjfeUgFJRCfbukVppNAVUIqKAp
         rfbxg4VP68AwHIukX2qVoSA1M8UBvBdiC/mjcvMudpgRZC7YBzNtn2clj50JsskFcEVT
         HbM/zDWeuJsq7IR8hbsLapCHQby5X8w1iW6sFnPgEYYIyMPgHox4fQbxmloSrE/HKCTZ
         YmzA==
X-Gm-Message-State: AOAM532oy2xijxMG1hM71hRBt95l3jRVmKWTr4D/d/WpyIYWdWDi85U3
        h/dxA0QxGFRqRqU1rl2UrwU/r49Vy8qKQE4R
X-Google-Smtp-Source: ABdhPJwBxA2l41LfMK9SKMe34zSSKBUaGb2WOC3+dQN6murYSbhyQhnE+SjzG6IrGVP662WGZnKj6A==
X-Received: by 2002:a17:902:8606:b029:12c:2625:76cf with SMTP id f6-20020a1709028606b029012c262576cfmr10078266plo.17.1629344489972;
        Wed, 18 Aug 2021 20:41:29 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id gd14sm6593082pjb.4.2021.08.18.20.41.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 18 Aug 2021 20:41:29 -0700 (PDT)
Message-ID: <611dd2e9.1c69fb81.25485.40d5@mx.google.com>
Date:   Wed, 18 Aug 2021 20:41:29 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: queue/4.19
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v4.19.204-49-g65ce90cc8079
X-Kernelci-Report-Type: test
Subject: stable-rc/queue/4.19 baseline: 129 runs,
 6 regressions (v4.19.204-49-g65ce90cc8079)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.19 baseline: 129 runs, 6 regressions (v4.19.204-49-g65ce9=
0cc8079)

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


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.19/ker=
nel/v4.19.204-49-g65ce90cc8079/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.19
  Describe: v4.19.204-49-g65ce90cc8079
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      65ce90cc80793e808f33ef0edff06ff7dcb969f6 =



Test Regressions
---------------- =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-baylibre  | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/611da081cd7309dda0b1366c

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.204=
-49-g65ce90cc8079/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_=
arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.204=
-49-g65ce90cc8079/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_=
arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/611da081cd7309dda0b13=
66d
        failing since 278 days (last pass: v4.19.157-26-gd59f3161b3a0, firs=
t fail: v4.19.157-27-g5543cc2c41d55) =

 =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-cip       | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/611d9c085e4bed560bb1366e

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.204=
-49-g65ce90cc8079/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-v=
ersatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.204=
-49-g65ce90cc8079/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-v=
ersatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/611d9c085e4bed560bb13=
66f
        failing since 278 days (last pass: v4.19.157-26-gd59f3161b3a0, firs=
t fail: v4.19.157-27-g5543cc2c41d55) =

 =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-collabora | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/611d9c285482f92083b13682

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.204=
-49-g65ce90cc8079/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu=
_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.204=
-49-g65ce90cc8079/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu=
_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/611d9c285482f92083b13=
683
        failing since 278 days (last pass: v4.19.157-26-gd59f3161b3a0, firs=
t fail: v4.19.157-27-g5543cc2c41d55) =

 =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
rk3288-veyron-jaq    | arm  | lab-collabora | gcc-8    | multi_v7_defconfig=
  | 3          =


  Details:     https://kernelci.org/test/plan/id/611da857a5920062fab13682

  Results:     64 PASS, 6 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.204=
-49-g65ce90cc8079/arm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-rk328=
8-veyron-jaq.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.204=
-49-g65ce90cc8079/arm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-rk328=
8-veyron-jaq.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.bootrr.rockchip-iodomain-grf-probed: https://kernelci.org/test=
/case/id/611da857a5920062fab1369a
        failing since 64 days (last pass: v4.19.194-28-g6098ecdead2c, first=
 fail: v4.19.194-67-g1b5dea188d94)

    2021-08-19T00:39:37.716502  /lava-4381347/1/../bin/lava-test-case
    2021-08-19T00:39:37.734113  <8>[   18.129858] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Drockchip-iodomain-grf-probed RESULT=3Dfail>
    2021-08-19T00:39:37.734701  /lava-4381347/1/../bin/lava-test-case   =


  * baseline.bootrr.dwmmc_rockchip-sdio0-probed: https://kernelci.org/test/=
case/id/611da857a5920062fab136b3
        failing since 64 days (last pass: v4.19.194-28-g6098ecdead2c, first=
 fail: v4.19.194-67-g1b5dea188d94)

    2021-08-19T00:39:35.275725  /lava-4381347/1/../bin/lava-test-case
    2021-08-19T00:39:35.293025  <8>[   15.687966] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Ddwmmc_rockchip-sdio0-probed RESULT=3Dfail>
    2021-08-19T00:39:35.293491  /lava-4381347/1/../bin/lava-test-case   =


  * baseline.bootrr.dwmmc_rockchip-sdmmc-probed: https://kernelci.org/test/=
case/id/611da857a5920062fab136b4
        failing since 64 days (last pass: v4.19.194-28-g6098ecdead2c, first=
 fail: v4.19.194-67-g1b5dea188d94)

    2021-08-19T00:39:34.262550  /lava-4381347/1/../bin/lava-test-case<8>[  =
 14.668789] <LAVA_SIGNAL_TESTCASE TEST_CASE_ID=3Ddwmmc_rockchip-sdmmc-probe=
d RESULT=3Dfail>
    2021-08-19T00:39:34.263171     =

 =20
