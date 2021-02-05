Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AFCBB31114D
	for <lists+stable@lfdr.de>; Fri,  5 Feb 2021 20:36:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231524AbhBERx6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 5 Feb 2021 12:53:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60294 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233333AbhBEPpw (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 5 Feb 2021 10:45:52 -0500
Received: from mail-pf1-x434.google.com (mail-pf1-x434.google.com [IPv6:2607:f8b0:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B78D6C061786
        for <stable@vger.kernel.org>; Fri,  5 Feb 2021 09:27:34 -0800 (PST)
Received: by mail-pf1-x434.google.com with SMTP id 18so2623209pfz.3
        for <stable@vger.kernel.org>; Fri, 05 Feb 2021 09:27:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=vB2bhoTKkxDwFxGK2Z5ibnqocDEc1qCavROL1ol4Phs=;
        b=ArMf4h3MpAW4bBIKfkJN6YA9ERg8bZb0PCVS4/8QqDi5PWEK66vTo94oxjN0yWH0GR
         xTYG/EQY0vvG6WozlqBj6UULdn6HoaKx1nnZqS7D3s6jttVkZXdOsigIumtAjRp6aUrJ
         vEHLt6nMIj5QmSvnjD0bYfWv1h4wqWPQ2x3Mpa0Il32/43/rCT0+Mcxp9bGnD1i7XpLU
         OZsaNnkthUcZ2GlbMN1kABfu7X5L03eEHqD9kVTP40KMGp7TuSu544x+3HK4R+BEQdSg
         QSt+DKZeAIhiYh+6LxTfvtv1KpyZLBoNiN7WKyCIU3kmvyZ9g7gLJTDp1HXq3Aq2ztNq
         rPVA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=vB2bhoTKkxDwFxGK2Z5ibnqocDEc1qCavROL1ol4Phs=;
        b=R/d313ilomR6SRo2NOeVhU4u3Sod8TridNXMa8CPADnodZZM86JjN0muld7jspARZa
         XqFXT78vvxc8c6tWuQOYrmzV/dMPYfA2ojo0ClDSpTnwOR8vh0OujoWzsjn0KUb1nX4n
         vPMoLOTSjOtC72nC9txNE3x65TaakGODD36gmbnKIInHiwPORkhFFLET5ekAfI3Cgkk2
         Gn3Ez+CB0dq+jKqvWRLSBBqbRFmTfqVB4aEjB0QkBVyk5FvS05b16Der00B+vCHtpZvP
         XI4Q3vgCeyqlIu15EcInvzzjLFqvfk29iv+GNaYRA0VSEtzhG06Z7URm+euXJVg3ExtS
         pG2A==
X-Gm-Message-State: AOAM530H+eKp5l4M0PRYayGwvwEfoaPiu4qF9Ig0cO+FBz5kS562l/KN
        +s7Dj6Kp3TcD/livAQomVvTu3U2TtxHioQ==
X-Google-Smtp-Source: ABdhPJzcTnv5hZk9pSe+ekjaQupKbQtbEqIgp1UKTIJRfFD5UFh0aYkgGCEXUgNCr6T60DWcv65soA==
X-Received: by 2002:a63:1a58:: with SMTP id a24mr5224492pgm.33.1612546053886;
        Fri, 05 Feb 2021 09:27:33 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id l1sm10056091pgt.26.2021.02.05.09.27.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 05 Feb 2021 09:27:33 -0800 (PST)
Message-ID: <601d8005.1c69fb81.dca9.5ab9@mx.google.com>
Date:   Fri, 05 Feb 2021 09:27:33 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v4.14.219-7-gdff7aa6e5aaa
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/4.14
Subject: stable-rc/queue/4.14 baseline: 115 runs,
 5 regressions (v4.14.219-7-gdff7aa6e5aaa)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.14 baseline: 115 runs, 5 regressions (v4.14.219-7-gdff7aa=
6e5aaa)

Regressions Summary
-------------------

platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
panda                | arm  | lab-collabora | gcc-8    | omap2plus_defconfi=
g | 1          =

qemu_arm-versatilepb | arm  | lab-baylibre  | gcc-8    | versatile_defconfi=
g | 1          =

qemu_arm-versatilepb | arm  | lab-broonie   | gcc-8    | versatile_defconfi=
g | 1          =

qemu_arm-versatilepb | arm  | lab-cip       | gcc-8    | versatile_defconfi=
g | 1          =

qemu_arm-versatilepb | arm  | lab-collabora | gcc-8    | versatile_defconfi=
g | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.14/ker=
nel/v4.14.219-7-gdff7aa6e5aaa/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.14
  Describe: v4.14.219-7-gdff7aa6e5aaa
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      dff7aa6e5aaa414795c4ffb8c1dafd39e703a859 =



Test Regressions
---------------- =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
panda                | arm  | lab-collabora | gcc-8    | omap2plus_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/601d4d177e66d7dcb03abe91

  Results:     3 PASS, 1 FAIL, 1 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.219=
-7-gdff7aa6e5aaa/arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-panda=
.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.219=
-7-gdff7aa6e5aaa/arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-panda=
.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/601d4d177e66d7d=
cb03abe98
        new failure (last pass: v4.14.219-4-g73b0dbfe84596)
        2 lines

    2021-02-05 13:50:11.790000+00:00  kern  :emerg : BUG: spinlock bad magi=
c on CPU#0, udevd/106
    2021-02-05 13:50:11.799000+00:00  kern  :emerg :  lock: emif_lock+0x0/0=
xffffed34 [emif], .magic: 00000000, .owner: <none>/-1, .owner_cpu: 0   =

 =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-baylibre  | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/601d4c82ff9112e0243abe84

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.219=
-7-gdff7aa6e5aaa/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_a=
rm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.219=
-7-gdff7aa6e5aaa/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_a=
rm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/601d4c82ff9112e0243ab=
e85
        failing since 83 days (last pass: v4.14.206-21-g787a7a3ca16c, first=
 fail: v4.14.206-22-ga949bf40fb01) =

 =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-broonie   | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/601d4e36546ebb75683abe72

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.219=
-7-gdff7aa6e5aaa/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_ar=
m-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.219=
-7-gdff7aa6e5aaa/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_ar=
m-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/601d4e36546ebb75683ab=
e73
        failing since 83 days (last pass: v4.14.206-21-g787a7a3ca16c, first=
 fail: v4.14.206-22-ga949bf40fb01) =

 =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-cip       | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/601d4c866619d8007b3abe65

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.219=
-7-gdff7aa6e5aaa/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-ve=
rsatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.219=
-7-gdff7aa6e5aaa/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-ve=
rsatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/601d4c866619d8007b3ab=
e66
        failing since 83 days (last pass: v4.14.206-21-g787a7a3ca16c, first=
 fail: v4.14.206-22-ga949bf40fb01) =

 =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-collabora | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/601d4c294db91e036d3abe83

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.219=
-7-gdff7aa6e5aaa/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu_=
arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.219=
-7-gdff7aa6e5aaa/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu_=
arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/601d4c294db91e036d3ab=
e84
        failing since 83 days (last pass: v4.14.206-21-g787a7a3ca16c, first=
 fail: v4.14.206-22-ga949bf40fb01) =

 =20
