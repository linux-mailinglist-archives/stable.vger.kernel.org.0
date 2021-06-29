Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 69BE33B7749
	for <lists+stable@lfdr.de>; Tue, 29 Jun 2021 19:35:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232164AbhF2Rhx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 29 Jun 2021 13:37:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59698 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232308AbhF2Rhw (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 29 Jun 2021 13:37:52 -0400
Received: from mail-pl1-x633.google.com (mail-pl1-x633.google.com [IPv6:2607:f8b0:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 74AA9C061760
        for <stable@vger.kernel.org>; Tue, 29 Jun 2021 10:35:24 -0700 (PDT)
Received: by mail-pl1-x633.google.com with SMTP id u19so5612564plc.3
        for <stable@vger.kernel.org>; Tue, 29 Jun 2021 10:35:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=vnjnO7M1oCjnx+fAnTVwCz+yoEOUimf10mD5ysLwub4=;
        b=RURtbfUWtA9zIXD1xW9OXasS46tFdJBRgdkmQ6j/KYj0h1zrsXfK2iBkh04pLG1FYm
         1UXrayQDuJgNUpcjCB3PTCW2me9+Fz4b4MQ5bXSX5ef+k+c4SORZQAaeMeazyY42KtqJ
         hPwtl8m6HTIU6wuXv36ebdzxgCPQMAYj3Q6FtE7iC2lF9LYxqLTKWIVztyOLOHZhfzNA
         P42k0KaltdiauxC3m2QcZVEcsy0V32jz6B2HNLNNrftAgFaFOrxp+ORVyLiRQZ4YPg+t
         R8zl5z1MILrueQWbEV0Q1lNOifSx7tCiQ0q3RbMF0a174VUHzSJ8yUzHIE4zMWpbO16R
         xKZg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=vnjnO7M1oCjnx+fAnTVwCz+yoEOUimf10mD5ysLwub4=;
        b=m3IxWft+zhgQ09zmb35wDFC2Ujj0HB318tRa79CHjmt6bXW/2eO2ZHyTsbHlSqmsv7
         XoZm/s1mAt8LrKSyS2ucpDP6Coin3rxitpsdv4uJYIfZ79z+rRuQmbqNVZ0Ef8G1odWq
         wDBQhUrvdYrB7CXN7XOXB4yUjujbYROTABpOU+SrzCHVsrMGXSPGdFBBL2W61dC7y5TM
         hksHG36/7IATDXu3oExjjWRIgn806T2c3zgPx0fQzANELTzyEaa8vqUxfC8OFs3csHwe
         TuDJuCpvM7mZpqcUJutNIwv+rhwlPZ5naFbXAnTjJJwBZhXF1349vl/RpUygnQ/LU53f
         SHuA==
X-Gm-Message-State: AOAM532SjGvNpWD9YfW8N1/hX4UUYMDc5/eNnErkF/Rp7dwj3Lacl8Xf
        W6daJGrFm9fKzIAaM4UngPYR0Fy9LQTOEVzm
X-Google-Smtp-Source: ABdhPJwCeBPjW3QXP+jS0CNShYiwEE///Ym/sg3fK2Xe4IQNP8W3JuRuiVuyDHgd48xmTcY8rj+y6A==
X-Received: by 2002:a17:90a:a50d:: with SMTP id a13mr22778pjq.22.1624988123846;
        Tue, 29 Jun 2021 10:35:23 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id x5sm18348071pfu.116.2021.06.29.10.35.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 29 Jun 2021 10:35:23 -0700 (PDT)
Message-ID: <60db59db.1c69fb81.a63b6.5b92@mx.google.com>
Date:   Tue, 29 Jun 2021 10:35:23 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v4.19.195-108-gae220303f794
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/4.19
Subject: stable-rc/queue/4.19 baseline: 150 runs,
 8 regressions (v4.19.195-108-gae220303f794)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.19 baseline: 150 runs, 8 regressions (v4.19.195-108-gae22=
0303f794)

Regressions Summary
-------------------

platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
beaglebone-black     | arm  | lab-cip         | gcc-8    | multi_v7_defconf=
ig  | 1          =

qemu_arm-versatilepb | arm  | lab-baylibre    | gcc-8    | versatile_defcon=
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
nel/v4.19.195-108-gae220303f794/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.19
  Describe: v4.19.195-108-gae220303f794
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      ae220303f7944e97e3a0b1dbd9b4fa04c784db28 =



Test Regressions
---------------- =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
beaglebone-black     | arm  | lab-cip         | gcc-8    | multi_v7_defconf=
ig  | 1          =


  Details:     https://kernelci.org/test/plan/id/60db273731d834a70023bbd1

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.195=
-108-gae220303f794/arm/multi_v7_defconfig/gcc-8/lab-cip/baseline-beaglebone=
-black.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.195=
-108-gae220303f794/arm/multi_v7_defconfig/gcc-8/lab-cip/baseline-beaglebone=
-black.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60db273731d834a70023b=
bd2
        new failure (last pass: v4.19.195-105-g61716bbe0763) =

 =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-baylibre    | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/60db257622808ce8e823bbde

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.195=
-108-gae220303f794/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu=
_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.195=
-108-gae220303f794/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu=
_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60db257622808ce8e823b=
bdf
        failing since 227 days (last pass: v4.19.157-26-gd59f3161b3a0, firs=
t fail: v4.19.157-27-g5543cc2c41d55) =

 =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-cip         | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/60db247be89ed794bd23bbbf

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.195=
-108-gae220303f794/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-=
versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.195=
-108-gae220303f794/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-=
versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60db247be89ed794bd23b=
bc0
        failing since 227 days (last pass: v4.19.157-26-gd59f3161b3a0, firs=
t fail: v4.19.157-27-g5543cc2c41d55) =

 =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-collabora   | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/60db26cb755bbb75d823bbc6

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.195=
-108-gae220303f794/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qem=
u_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.195=
-108-gae220303f794/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qem=
u_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60db26cb755bbb75d823b=
bc7
        failing since 227 days (last pass: v4.19.157-26-gd59f3161b3a0, firs=
t fail: v4.19.157-27-g5543cc2c41d55) =

 =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-linaro-lkft | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/60db241ad411e8cc9523bc28

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.195=
-108-gae220303f794/arm/versatile_defconfig/gcc-8/lab-linaro-lkft/baseline-q=
emu_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.195=
-108-gae220303f794/arm/versatile_defconfig/gcc-8/lab-linaro-lkft/baseline-q=
emu_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60db241ad411e8cc9523b=
c29
        failing since 227 days (last pass: v4.19.157-26-gd59f3161b3a0, firs=
t fail: v4.19.157-27-g5543cc2c41d55) =

 =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
rk3288-veyron-jaq    | arm  | lab-collabora   | gcc-8    | multi_v7_defconf=
ig  | 3          =


  Details:     https://kernelci.org/test/plan/id/60db30ef2551ce2be123bbe6

  Results:     64 PASS, 6 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.195=
-108-gae220303f794/arm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-rk32=
88-veyron-jaq.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.195=
-108-gae220303f794/arm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-rk32=
88-veyron-jaq.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.bootrr.dwmmc_rockchip-sdmmc-probed: https://kernelci.org/test/=
case/id/60db30ef2551ce2be123bbff
        failing since 14 days (last pass: v4.19.194-28-g6098ecdead2c, first=
 fail: v4.19.194-67-g1b5dea188d94)

    2021-06-29T14:40:40.133772  /lava-4111952/1/../bin/lava-test-case<8>[  =
 14.063359] <LAVA_SIGNAL_TESTCASE TEST_CASE_ID=3Ddwmmc_rockchip-sdmmc-probe=
d RESULT=3Dfail>
    2021-06-29T14:40:40.134393     =


  * baseline.bootrr.dwmmc_rockchip-sdio0-probed: https://kernelci.org/test/=
case/id/60db30ef2551ce2be123bc00
        failing since 14 days (last pass: v4.19.194-28-g6098ecdead2c, first=
 fail: v4.19.194-67-g1b5dea188d94)

    2021-06-29T14:40:41.147156  /lava-4111952/1/../bin/lava-test-case
    2021-06-29T14:40:41.164337  <8>[   15.082537] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Ddwmmc_rockchip-sdio0-probed RESULT=3Dfail>
    2021-06-29T14:40:41.164921  /lava-4111952/1/../bin/lava-test-case   =


  * baseline.bootrr.rockchip-iodomain-grf-probed: https://kernelci.org/test=
/case/id/60db30ef2551ce2be123bc19
        failing since 14 days (last pass: v4.19.194-28-g6098ecdead2c, first=
 fail: v4.19.194-67-g1b5dea188d94)

    2021-06-29T14:40:43.587764  /lava-4111952/1/../bin/lava-test-case
    2021-06-29T14:40:43.604485  <8>[   17.524150] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Drockchip-iodomain-grf-probed RESULT=3Dfail>   =

 =20
