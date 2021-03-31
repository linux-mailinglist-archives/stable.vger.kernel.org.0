Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D2D0134FAB3
	for <lists+stable@lfdr.de>; Wed, 31 Mar 2021 09:48:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233830AbhCaHrv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 31 Mar 2021 03:47:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43282 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234142AbhCaHre (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 31 Mar 2021 03:47:34 -0400
Received: from mail-pg1-x52a.google.com (mail-pg1-x52a.google.com [IPv6:2607:f8b0:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9E14BC061574
        for <stable@vger.kernel.org>; Wed, 31 Mar 2021 00:47:34 -0700 (PDT)
Received: by mail-pg1-x52a.google.com with SMTP id y32so12459641pga.11
        for <stable@vger.kernel.org>; Wed, 31 Mar 2021 00:47:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=hRSDGnIKN3BisSSJVgf62ESJYSodJIIDLqS3Vw6P9OM=;
        b=Eb9SIzGenS2aPzwxprosyGtQuJ3sszYSeEBEort12NKAvuh+FZF3dZ2Gp+/ycKAy7K
         +GIKJ8CPhaaXEc5nTKrwZ4sChey6OMeE33XLNIlE/njF+C/fs76aoQ+qX/+j0bNJrQhk
         Tn/B50WXpW5/XCIUX8YAoAYzoYqEwco4Unvc+8H9umKhWmdOHN+gbSx3X4z2srX4+1Uo
         3r82/qtY/gjAPyUC/ZlEwPzkd0Q5H8JiGD2V/et/b7xm1p9I3s6johnhtMawS8D/WsiP
         BXDaVH1QN29nlfGwB/jg16dQZG3uSg3bLApNwjjScnc0gzdnntyO+7ezmjF2Zpl05T04
         2zqg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=hRSDGnIKN3BisSSJVgf62ESJYSodJIIDLqS3Vw6P9OM=;
        b=odlQNClLwAOYhPB/0TvtgNC5N/pCezTS8zjOZ2t5UIMwWzSmRQH2/rXHFP0G+gZ4PQ
         Ptiz6y6wb+MlyW0YXSv+SiIBtqHCBNTdcFgQ7lzZ8q/yuGPMAG4/sGlh81gywRjRqmsb
         16cHcNyeaHM44u+guvd1NiElZQoE1jg01rFF8084wl5IaFuJp+DWzgNPTm/UjiJKGs6a
         ONQgIB9E4vShT9Ej5ACwPOjQFBE80M5iX58XVoSAVaUb2GaAITWviTQelR9KXfbBcCut
         7N3ydikw2G6s381qlNKQ+yGgYVG6I1VqCm+T11V0YwMO89Kw4/muCXAnn5aEFGdpZB8+
         G+qg==
X-Gm-Message-State: AOAM533dVLtW9MUKX6WUtbvBuQl1Fj83Rq9JOfhQchnCtDS2yhPXn7TC
        2msFUg1elZghfLidye3EvlaFFpMrlzDwcA==
X-Google-Smtp-Source: ABdhPJw3jltLEQBbtjiPE1c6NK1gxp06HSttIKEse7Y3F1BoDYAANpmpl930iV507GSHp7peDCwFKA==
X-Received: by 2002:a63:af51:: with SMTP id s17mr1989894pgo.405.1617176854044;
        Wed, 31 Mar 2021 00:47:34 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id ch15sm1146140pjb.46.2021.03.31.00.47.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 31 Mar 2021 00:47:33 -0700 (PDT)
Message-ID: <60642915.1c69fb81.c6d77.33f9@mx.google.com>
Date:   Wed, 31 Mar 2021 00:47:33 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v4.19.184-22-g70b975d7af0f3
X-Kernelci-Branch: queue/4.19
X-Kernelci-Tree: stable-rc
Subject: stable-rc/queue/4.19 baseline: 136 runs,
 4 regressions (v4.19.184-22-g70b975d7af0f3)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.19 baseline: 136 runs, 4 regressions (v4.19.184-22-g70b97=
5d7af0f3)

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

qemu_arm-versatilepb | arm  | lab-linaro-lkft | gcc-8    | versatile_defcon=
fig | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.19/ker=
nel/v4.19.184-22-g70b975d7af0f3/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.19
  Describe: v4.19.184-22-g70b975d7af0f3
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      70b975d7af0f3296291be508ad65ca45a4c4b302 =



Test Regressions
---------------- =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-baylibre    | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/6063f48bb4c8600e21dac6c2

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.184=
-22-g70b975d7af0f3/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu=
_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.184=
-22-g70b975d7af0f3/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu=
_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6063f48bb4c8600e21dac=
6c3
        failing since 137 days (last pass: v4.19.157-26-gd59f3161b3a0, firs=
t fail: v4.19.157-27-g5543cc2c41d55) =

 =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-broonie     | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/6063f48af408383aaddac6b5

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.184=
-22-g70b975d7af0f3/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_=
arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.184=
-22-g70b975d7af0f3/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_=
arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6063f48af408383aaddac=
6b6
        failing since 137 days (last pass: v4.19.157-26-gd59f3161b3a0, firs=
t fail: v4.19.157-27-g5543cc2c41d55) =

 =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-cip         | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/6063f485b4c8600e21dac6bc

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.184=
-22-g70b975d7af0f3/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-=
versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.184=
-22-g70b975d7af0f3/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-=
versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6063f485b4c8600e21dac=
6bd
        failing since 137 days (last pass: v4.19.157-26-gd59f3161b3a0, firs=
t fail: v4.19.157-27-g5543cc2c41d55) =

 =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-linaro-lkft | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/6063f435bb2dd94e2fdac6c5

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.184=
-22-g70b975d7af0f3/arm/versatile_defconfig/gcc-8/lab-linaro-lkft/baseline-q=
emu_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.184=
-22-g70b975d7af0f3/arm/versatile_defconfig/gcc-8/lab-linaro-lkft/baseline-q=
emu_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6063f435bb2dd94e2fdac=
6c6
        failing since 137 days (last pass: v4.19.157-26-gd59f3161b3a0, firs=
t fail: v4.19.157-27-g5543cc2c41d55) =

 =20
