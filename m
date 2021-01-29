Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1AB7F30836F
	for <lists+stable@lfdr.de>; Fri, 29 Jan 2021 02:55:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229627AbhA2Byu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 28 Jan 2021 20:54:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49032 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229757AbhA2Byo (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 28 Jan 2021 20:54:44 -0500
Received: from mail-pf1-x429.google.com (mail-pf1-x429.google.com [IPv6:2607:f8b0:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 88AB7C061573
        for <stable@vger.kernel.org>; Thu, 28 Jan 2021 17:54:04 -0800 (PST)
Received: by mail-pf1-x429.google.com with SMTP id o20so5253374pfu.0
        for <stable@vger.kernel.org>; Thu, 28 Jan 2021 17:54:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=N+i4MZzHI5VLYPt8iYUh1fam1D2oB0qZ5H7GCr2iMjQ=;
        b=p0YRGE2vn6lSezkz6hTmFGKMSOS6dZd1WR8WOQm8XzZscTllBV8UPfMdL6q1/U42GS
         JYWZqGyIPb0iX0FeHSRUndTPyP13UBM02Y/q0xTRi/KWOXekM9BbGvlhbAFobp1JaZJf
         d2vrXBzwZONBWRy91nnv3bd/KTAnRjhyBpudFIC3F9TzWe4WfOxud5tK296KO2T1+1hL
         /ukQnE0mtNKEgiTSECIrzkKwdtguRXxh2T0dQnfOZV1btyZVM4HH8npkz3CZg/Hcg3WL
         NPzUaOTTpkQiEtUtAQhmwg7pGRc3Bb3zF1n6pBI6CDhxQrVsGilyTded3+c0fkGxsTL8
         nbKA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=N+i4MZzHI5VLYPt8iYUh1fam1D2oB0qZ5H7GCr2iMjQ=;
        b=DQ3Sco2DwXc2fJsqfK3hfhvAzTivOhn/uhvY1DpB3l3ILaQXBnN8AmHEsT0CAOzw21
         c28jM6htOrnwqR3+NoaOfvUsM3ghVTWZOBmkYuWgMeJnogkillRZnPKjG3YrnbBeL5fN
         jhO27YUVejji2tZzowwYd6tKgk7EIBQXv+saEbqmj6+i9AQrU8A4Uq7HtA8f7HPMC4DI
         DaJvrZ7HmEclFkD9MotuJ/d+LCGiqtGDouhC0jGw5upXk63kKyZvEBuUZ+WAQE1WazMs
         YN4QjcAWZg0cDJCSOAtxspXoiJLLGWiD4TmNPfepXPSWe2uN4GQgdnOsxVb1W3vRyav2
         6+dw==
X-Gm-Message-State: AOAM531mQzbP9MfDr0kXYNgZqbT4WIKZcP5xGCfcqXgYA5nVjgRqEvRc
        9T1ViAmUlsxNGp94z22rpqQBth8gfhBFgg==
X-Google-Smtp-Source: ABdhPJwJiTxd1aAvo81z7wnZ2a7UBWAFu00PLd/PrnjrQc215GGWJcxehMMN6hM4JhV3CVlk1rpUEQ==
X-Received: by 2002:aa7:8f13:0:b029:1bd:f965:66d8 with SMTP id x19-20020aa78f130000b02901bdf96566d8mr2154198pfr.80.1611885243719;
        Thu, 28 Jan 2021 17:54:03 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id g15sm6580316pfb.30.2021.01.28.17.54.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 28 Jan 2021 17:54:02 -0800 (PST)
Message-ID: <60136aba.1c69fb81.e7528.11b9@mx.google.com>
Date:   Thu, 28 Jan 2021 17:54:02 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.19.171-13-ga54dbc3b3b91
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/4.19
Subject: stable-rc/queue/4.19 baseline: 168 runs,
 9 regressions (v4.19.171-13-ga54dbc3b3b91)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.19 baseline: 168 runs, 9 regressions (v4.19.171-13-ga54db=
c3b3b91)

Regressions Summary
-------------------

platform             | arch   | lab             | compiler | defconfig     =
        | regressions
---------------------+--------+-----------------+----------+---------------=
--------+------------
da850-lcdk           | arm    | lab-baylibre    | gcc-8    | davinci_all_de=
fconfig | 2          =

panda                | arm    | lab-collabora   | gcc-8    | omap2plus_defc=
onfig   | 1          =

qemu_arm-versatilepb | arm    | lab-baylibre    | gcc-8    | versatile_defc=
onfig   | 1          =

qemu_arm-versatilepb | arm    | lab-broonie     | gcc-8    | versatile_defc=
onfig   | 1          =

qemu_arm-versatilepb | arm    | lab-cip         | gcc-8    | versatile_defc=
onfig   | 1          =

qemu_arm-versatilepb | arm    | lab-collabora   | gcc-8    | versatile_defc=
onfig   | 1          =

qemu_arm-versatilepb | arm    | lab-linaro-lkft | gcc-8    | versatile_defc=
onfig   | 1          =

qemu_x86_64          | x86_64 | lab-baylibre    | gcc-8    | x86_64_defconf=
ig      | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.19/ker=
nel/v4.19.171-13-ga54dbc3b3b91/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.19
  Describe: v4.19.171-13-ga54dbc3b3b91
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      a54dbc3b3b91149b680f579ee0a8ec9181073252 =



Test Regressions
---------------- =



platform             | arch   | lab             | compiler | defconfig     =
        | regressions
---------------------+--------+-----------------+----------+---------------=
--------+------------
da850-lcdk           | arm    | lab-baylibre    | gcc-8    | davinci_all_de=
fconfig | 2          =


  Details:     https://kernelci.org/test/plan/id/6013365cd03d9278fed3dfcf

  Results:     3 PASS, 2 FAIL, 0 SKIP
  Full config: davinci_all_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.171=
-13-ga54dbc3b3b91/arm/davinci_all_defconfig/gcc-8/lab-baylibre/baseline-da8=
50-lcdk.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.171=
-13-ga54dbc3b3b91/arm/davinci_all_defconfig/gcc-8/lab-baylibre/baseline-da8=
50-lcdk.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.dmesg.alert: https://kernelci.org/test/case/id/6013365cd03d927=
8fed3dfd3
        new failure (last pass: v4.19.171-11-gd6c7d50dfd0f)
        3 lines

    2021-01-28 22:10:30.313000+00:00  kern  :alert : raw: 00000000 00000100=
 00000200 00000000 00000004 0000000a ffffff7f 00000000
    2021-01-28 22:10:30.313000+00:00  kern  :alert : page dumped because: n=
onzero mapcount
    2021-01-28 22:10:30.373000+00:00  <8><LAVA_SIGNAL_TESTCASE TEST_CASE_ID=
=3Dalert RESULT=3Dfail UNITS=3Dlines MEASUREMENT=3D3>   =


  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/6013365cd03d927=
8fed3dfd4
        new failure (last pass: v4.19.171-11-gd6c7d50dfd0f)
        2 lines

    2021-01-28 22:10:30.514000+00:00  kern  :emerg : flags: 0x0()
    2021-01-28 22:10:30.600000+00:00  <8><LAVA_SIGNAL_TESTCASE TEST_CASE_ID=
=3Demerg RESULT=3Dfail UNITS=3Dlines MEASUREMENT=3D2>
    2021-01-28 22:10:30.600000+00:00  + set +x
    2021-01-28 22:10:30.601000+00:00  <8><LAVA_SIGNAL_ENDRUN 0_dmesg 647544=
_1.5.2.4.1>
    2021-01-28 22:10:30.705000+00:00  #   =

 =



platform             | arch   | lab             | compiler | defconfig     =
        | regressions
---------------------+--------+-----------------+----------+---------------=
--------+------------
panda                | arm    | lab-collabora   | gcc-8    | omap2plus_defc=
onfig   | 1          =


  Details:     https://kernelci.org/test/plan/id/601337b976adec98dcd3dfda

  Results:     4 PASS, 1 FAIL, 0 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.171=
-13-ga54dbc3b3b91/arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-pand=
a.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.171=
-13-ga54dbc3b3b91/arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-pand=
a.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/601337b976adec9=
8dcd3dfdf
        failing since 11 days (last pass: v4.19.167-43-g7a15ea567512, first=
 fail: v4.19.167-55-gb4942424ad93)
        2 lines

    2021-01-28 22:16:18.876000+00:00  kern  :emerg :  lock: emif_lock+0x0/0=
xffffed34 [emif], .magic: dead4ead, .owner: <none>/-1, .owner_cpu: -1
    2021-01-28 22:16:18.890000+00:00  <8>[   22.704559] <LAVA_SIGNAL_TESTCA=
SE TEST_CASE_ID=3Demerg RESULT=3Dfail UNITS=3Dlines MEASUREMENT=3D2>   =

 =



platform             | arch   | lab             | compiler | defconfig     =
        | regressions
---------------------+--------+-----------------+----------+---------------=
--------+------------
qemu_arm-versatilepb | arm    | lab-baylibre    | gcc-8    | versatile_defc=
onfig   | 1          =


  Details:     https://kernelci.org/test/plan/id/6013367e8c6c36db36d3dfdb

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.171=
-13-ga54dbc3b3b91/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_=
arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.171=
-13-ga54dbc3b3b91/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_=
arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6013367e8c6c36db36d3d=
fdc
        failing since 76 days (last pass: v4.19.157-26-gd59f3161b3a0, first=
 fail: v4.19.157-27-g5543cc2c41d55) =

 =



platform             | arch   | lab             | compiler | defconfig     =
        | regressions
---------------------+--------+-----------------+----------+---------------=
--------+------------
qemu_arm-versatilepb | arm    | lab-broonie     | gcc-8    | versatile_defc=
onfig   | 1          =


  Details:     https://kernelci.org/test/plan/id/601343eb9b689e0fbad3dffb

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.171=
-13-ga54dbc3b3b91/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_a=
rm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.171=
-13-ga54dbc3b3b91/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_a=
rm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/601343eb9b689e0fbad3d=
ffc
        failing since 76 days (last pass: v4.19.157-26-gd59f3161b3a0, first=
 fail: v4.19.157-27-g5543cc2c41d55) =

 =



platform             | arch   | lab             | compiler | defconfig     =
        | regressions
---------------------+--------+-----------------+----------+---------------=
--------+------------
qemu_arm-versatilepb | arm    | lab-cip         | gcc-8    | versatile_defc=
onfig   | 1          =


  Details:     https://kernelci.org/test/plan/id/601336713d94488d3dd3dfe4

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.171=
-13-ga54dbc3b3b91/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-v=
ersatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.171=
-13-ga54dbc3b3b91/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-v=
ersatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/601336713d94488d3dd3d=
fe5
        failing since 76 days (last pass: v4.19.157-26-gd59f3161b3a0, first=
 fail: v4.19.157-27-g5543cc2c41d55) =

 =



platform             | arch   | lab             | compiler | defconfig     =
        | regressions
---------------------+--------+-----------------+----------+---------------=
--------+------------
qemu_arm-versatilepb | arm    | lab-collabora   | gcc-8    | versatile_defc=
onfig   | 1          =


  Details:     https://kernelci.org/test/plan/id/6013362858857317f1d3dfd5

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.171=
-13-ga54dbc3b3b91/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu=
_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.171=
-13-ga54dbc3b3b91/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu=
_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6013362858857317f1d3d=
fd6
        failing since 76 days (last pass: v4.19.157-26-gd59f3161b3a0, first=
 fail: v4.19.157-27-g5543cc2c41d55) =

 =



platform             | arch   | lab             | compiler | defconfig     =
        | regressions
---------------------+--------+-----------------+----------+---------------=
--------+------------
qemu_arm-versatilepb | arm    | lab-linaro-lkft | gcc-8    | versatile_defc=
onfig   | 1          =


  Details:     https://kernelci.org/test/plan/id/60133640729557d80bd3dfee

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.171=
-13-ga54dbc3b3b91/arm/versatile_defconfig/gcc-8/lab-linaro-lkft/baseline-qe=
mu_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.171=
-13-ga54dbc3b3b91/arm/versatile_defconfig/gcc-8/lab-linaro-lkft/baseline-qe=
mu_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60133640729557d80bd3d=
fef
        failing since 76 days (last pass: v4.19.157-26-gd59f3161b3a0, first=
 fail: v4.19.157-27-g5543cc2c41d55) =

 =



platform             | arch   | lab             | compiler | defconfig     =
        | regressions
---------------------+--------+-----------------+----------+---------------=
--------+------------
qemu_x86_64          | x86_64 | lab-baylibre    | gcc-8    | x86_64_defconf=
ig      | 1          =


  Details:     https://kernelci.org/test/plan/id/6013357bd38fd8c484d3dfe3

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig
  Compiler:    gcc-8 (gcc (Debian 8.3.0-6) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.171=
-13-ga54dbc3b3b91/x86_64/x86_64_defconfig/gcc-8/lab-baylibre/baseline-qemu_=
x86_64.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.171=
-13-ga54dbc3b3b91/x86_64/x86_64_defconfig/gcc-8/lab-baylibre/baseline-qemu_=
x86_64.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/x86/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6013357bd38fd8c484d3d=
fe4
        new failure (last pass: v4.19.171-11-gd6c7d50dfd0f) =

 =20
