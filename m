Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A62453B4679
	for <lists+stable@lfdr.de>; Fri, 25 Jun 2021 17:19:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229813AbhFYPWH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 25 Jun 2021 11:22:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40602 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229445AbhFYPWH (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 25 Jun 2021 11:22:07 -0400
Received: from mail-pf1-x436.google.com (mail-pf1-x436.google.com [IPv6:2607:f8b0:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 78997C061574
        for <stable@vger.kernel.org>; Fri, 25 Jun 2021 08:19:45 -0700 (PDT)
Received: by mail-pf1-x436.google.com with SMTP id g192so8288227pfb.6
        for <stable@vger.kernel.org>; Fri, 25 Jun 2021 08:19:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=vwVfMJ8g7y0CzBoscfu8pCofFCZ63FuqUysamvWP1ec=;
        b=B5n8rR/Pb9xxy/Xi4FAIOqDIIx69WjGkMmtHkJ5l/xoDZajQtIXoNkEbTN89g9QXr/
         JxcNslgRZV3L6+2FkjVlutaIFHHhXqR2SXnzSQciKA+TWlF4jLFOWGqEEKnbmkpMl++y
         t5ST68zPLDvqTl26vakRBvvXW0awXBp7DMfHMH3luyZWufKHkNbvs1+VWfWmhsijPhTo
         4GBhZ5ADHqyol9+JSWmHVOJVfe2x7LJ+SSWXzYIufKoHbHl4K6XT6F4tHwLsniE9gQsY
         hObr1Rlek6COec2gS6siV8lcqjwq5PzANedM7cEpdcShCx9anPGNW1X11POEwKkB1G1Y
         Q9tg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=vwVfMJ8g7y0CzBoscfu8pCofFCZ63FuqUysamvWP1ec=;
        b=CCu1xWlStePEiBJehsTbJMIRDxbu+/Eu5jSmrUESxujld4NbE0+OpBzdkIGFXCj+0s
         jGEDjYlMUwL/CwnR7T4A7m6jrl+an9Ei4+ZXRXvvhz+lVAfTEFx5MFQqjtQTGijShNnL
         sPuTgoeik++H8Wvqibrzs2tvkHAoWB3P57LbIv850RDKdHGH1HjN+30nTt1ww+1LpM0G
         RSp69fJUDnU0Rfn7B1R1AL+sprZ1Hgp+EZ1690dY3CYM1ldM6xH3DnAj89vCsXkXiqBb
         eN1HuHiJStD/r9Q4nGtY3Q+IxeX3R0Rf6zLamvUWeRRMsp0+d0XJVs+2IY3Lwl+Vnlks
         P5ng==
X-Gm-Message-State: AOAM530x26XuNUzVNY9TH15x/vYUg2qzrBN/JwSXKv6lyLcFZCyHxd39
        fyQ1iQBDYZNH06KBNQunEeMnihCiEXHYerc6
X-Google-Smtp-Source: ABdhPJwIgEuVZ6+EqC7iXkAKE1I+Q7LZEMkGqYh/4ucWYO/puLGc7HV2jSCjf3DdsqJApMo2H4jk5Q==
X-Received: by 2002:a05:6a00:2403:b029:309:8a37:2d51 with SMTP id z3-20020a056a002403b02903098a372d51mr3216205pfh.79.1624634384905;
        Fri, 25 Jun 2021 08:19:44 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id x13sm6064100pjh.30.2021.06.25.08.19.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 25 Jun 2021 08:19:44 -0700 (PDT)
Message-ID: <60d5f410.1c69fb81.1aad8.06e7@mx.google.com>
Date:   Fri, 25 Jun 2021 08:19:44 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v4.19.195-88-ga82ee375fa05
X-Kernelci-Branch: queue/4.19
X-Kernelci-Tree: stable-rc
Subject: stable-rc/queue/4.19 baseline: 141 runs,
 7 regressions (v4.19.195-88-ga82ee375fa05)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.19 baseline: 141 runs, 7 regressions (v4.19.195-88-ga82ee=
375fa05)

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
nel/v4.19.195-88-ga82ee375fa05/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.19
  Describe: v4.19.195-88-ga82ee375fa05
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      a82ee375fa05e60be30ff67968e144522a324a7f =



Test Regressions
---------------- =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-baylibre  | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/60d5bbbfdb359df73a41327e

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.195=
-88-ga82ee375fa05/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_=
arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.195=
-88-ga82ee375fa05/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_=
arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60d5bbbfdb359df73a413=
27f
        failing since 223 days (last pass: v4.19.157-26-gd59f3161b3a0, firs=
t fail: v4.19.157-27-g5543cc2c41d55) =

 =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-broonie   | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/60d5bbf8c636bc93c1413290

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.195=
-88-ga82ee375fa05/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_a=
rm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.195=
-88-ga82ee375fa05/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_a=
rm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60d5bbf8c636bc93c1413=
291
        failing since 223 days (last pass: v4.19.157-26-gd59f3161b3a0, firs=
t fail: v4.19.157-27-g5543cc2c41d55) =

 =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-cip       | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/60d5bbb5061fdcde6741328b

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.195=
-88-ga82ee375fa05/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-v=
ersatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.195=
-88-ga82ee375fa05/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-v=
ersatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60d5bbb5061fdcde67413=
28c
        failing since 223 days (last pass: v4.19.157-26-gd59f3161b3a0, firs=
t fail: v4.19.157-27-g5543cc2c41d55) =

 =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-collabora | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/60d5c905222efd020241326b

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.195=
-88-ga82ee375fa05/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu=
_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.195=
-88-ga82ee375fa05/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu=
_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60d5c905222efd0202413=
26c
        failing since 223 days (last pass: v4.19.157-26-gd59f3161b3a0, firs=
t fail: v4.19.157-27-g5543cc2c41d55) =

 =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
rk3288-veyron-jaq    | arm  | lab-collabora | gcc-8    | multi_v7_defconfig=
  | 3          =


  Details:     https://kernelci.org/test/plan/id/60d5caf2658083ad33413284

  Results:     63 PASS, 6 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.195=
-88-ga82ee375fa05/arm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-rk328=
8-veyron-jaq.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.195=
-88-ga82ee375fa05/arm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-rk328=
8-veyron-jaq.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.bootrr.dwmmc_rockchip-sdmmc-probed: https://kernelci.org/test/=
case/id/60d5caf2658083ad334132a0
        failing since 10 days (last pass: v4.19.194-28-g6098ecdead2c, first=
 fail: v4.19.194-67-g1b5dea188d94)

    2021-06-25T12:24:10.480302  /lava-4093975/1/../bin/lava-test-case<8>[  =
 14.615696] <LAVA_SIGNAL_TESTCASE TEST_CASE_ID=3Ddwmmc_rockchip-sdmmc-probe=
d RESULT=3Dfail>
    2021-06-25T12:24:10.480705     =


  * baseline.bootrr.dwmmc_rockchip-sdio0-probed: https://kernelci.org/test/=
case/id/60d5caf2658083ad334132a1
        failing since 10 days (last pass: v4.19.194-28-g6098ecdead2c, first=
 fail: v4.19.194-67-g1b5dea188d94)

    2021-06-25T12:24:11.492803  /lava-4093975/1/../bin/lava-test-case
    2021-06-25T12:24:11.510942  <8>[   15.634939] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Ddwmmc_rockchip-sdio0-probed RESULT=3Dfail>
    2021-06-25T12:24:11.511249  /lava-4093975/1/../bin/lava-test-case   =


  * baseline.bootrr.rockchip-iodomain-grf-probed: https://kernelci.org/test=
/case/id/60d5caf2658083ad334132ba
        failing since 10 days (last pass: v4.19.194-28-g6098ecdead2c, first=
 fail: v4.19.194-67-g1b5dea188d94)

    2021-06-25T12:24:13.952176  /lava-4093975/1/../bin/lava-test-case<8>[  =
 18.076945] <LAVA_SIGNAL_TESTCASE TEST_CASE_ID=3Drockchip-iodomain-grf-prob=
ed RESULT=3Dfail>
    2021-06-25T12:24:13.952624  =

    2021-06-25T12:24:13.952905  /lava-4093975/1/../bin/lava-test-case   =

 =20
