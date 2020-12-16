Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EE49E2DC6FA
	for <lists+stable@lfdr.de>; Wed, 16 Dec 2020 20:21:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387993AbgLPTVF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 16 Dec 2020 14:21:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57120 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387990AbgLPTVF (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 16 Dec 2020 14:21:05 -0500
Received: from mail-pl1-x629.google.com (mail-pl1-x629.google.com [IPv6:2607:f8b0:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E199CC061794
        for <stable@vger.kernel.org>; Wed, 16 Dec 2020 11:20:24 -0800 (PST)
Received: by mail-pl1-x629.google.com with SMTP id t6so13500926plq.1
        for <stable@vger.kernel.org>; Wed, 16 Dec 2020 11:20:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=D1Fzpwbhte4i7vS92DTEnJGdXNL4gQzvAy1lPyMjKQM=;
        b=0BKeBLe8JFxHHaKHQAsUmaHWK6Mbu4udru7+3LwugtwvlgFKsoGukVq4cmL4MjjOwX
         9EdOhGb/WZD1+MEHHOjyx19hPZUNRtWEijnBeXXW7geCAari1CsC7lu7x3CBZYo8NqQX
         DqszlhL+MmfzuQbA8eFGDeYqFj9WuPntzeNFnNdVHPlfWe8179OfDna5XWHpZngdCmgY
         ibZ690fOc/a/YyA22nmjap+FOhlAALgdEL/eSBmtjyauDe3yZ85H0NmZTn5OEPDVagUZ
         nLIAxUuC4klVjdv5Fov2FTV28EhwnUB/4tMZuzLXhEI0bMgWCjQI10aJ5OJEZ8vMI6uS
         7DXw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=D1Fzpwbhte4i7vS92DTEnJGdXNL4gQzvAy1lPyMjKQM=;
        b=HEFrEbrqgOZl/FdTq2UI96ScT9mAspfEa5CM0KE8AKdlJJR4VBAGTQCMdLNaTf4GvE
         dGfco1E0qeVoHcCKDERtKPr0vr/axX8V1tKDb6KvxCQFX4T0QyevUH6Smqj7vIb1iT0I
         s6XRX/8wsjMeTWLgjWr7xeg7uCkwzREJxM/m1ZmV7XV1Jv7MfOINQR0F7v3Ao6Mx57dJ
         06mQL6apwSO4vpTAIG3IiTp3NksUQ8baRNqBjaRQ9R2FYeLBFd7OqNNoknPz10kO+zzV
         zGCqc+vTnTvpfu6xGBwlv7L+squrLaof43geao7jZ4Q09VJfyZPXyGirrz6AoC0QGIkZ
         +H2A==
X-Gm-Message-State: AOAM533Yiy+udy/GsyOLaas8ReZ1G68pGfGFM4g3udJpUpiSQ7+DeZ9j
        s675XvCKyxZmhroLM43DIXQgD7FhMc7RCA==
X-Google-Smtp-Source: ABdhPJxsV3z/kAX0lvXNth3Hv3KvtixV+f09xJ5TD2MCX3D/IjCMxikwQgsgPfJ94F3TA6ys9+sVGw==
X-Received: by 2002:a17:902:7c04:b029:db:e44d:9366 with SMTP id x4-20020a1709027c04b02900dbe44d9366mr27077882pll.51.1608146424098;
        Wed, 16 Dec 2020 11:20:24 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id l197sm3396378pfd.97.2020.12.16.11.20.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 16 Dec 2020 11:20:23 -0800 (PST)
Message-ID: <5fda5df7.1c69fb81.1623f.7942@mx.google.com>
Date:   Wed, 16 Dec 2020 11:20:23 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: queue/4.19
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v4.19.163-27-g7f94b7fe203f
X-Kernelci-Report-Type: test
Subject: stable-rc/queue/4.19 baseline: 164 runs,
 5 regressions (v4.19.163-27-g7f94b7fe203f)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.19 baseline: 164 runs, 5 regressions (v4.19.163-27-g7f94b=
7fe203f)

Regressions Summary
-------------------

platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
panda                | arm  | lab-collabora   | gcc-8    | omap2plus_defcon=
fig | 1          =

qemu_arm-versatilepb | arm  | lab-baylibre    | gcc-8    | versatile_defcon=
fig | 1          =

qemu_arm-versatilepb | arm  | lab-cip         | gcc-8    | versatile_defcon=
fig | 1          =

qemu_arm-versatilepb | arm  | lab-collabora   | gcc-8    | versatile_defcon=
fig | 1          =

qemu_arm-versatilepb | arm  | lab-linaro-lkft | gcc-8    | versatile_defcon=
fig | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.19/ker=
nel/v4.19.163-27-g7f94b7fe203f/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.19
  Describe: v4.19.163-27-g7f94b7fe203f
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      7f94b7fe203fd03f76d62f30864ca0d3a2a50b13 =



Test Regressions
---------------- =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
panda                | arm  | lab-collabora   | gcc-8    | omap2plus_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/5fda2af9b593dcfb7dc94cc8

  Results:     4 PASS, 1 FAIL, 0 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.163=
-27-g7f94b7fe203f/arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-pand=
a.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.163=
-27-g7f94b7fe203f/arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-pand=
a.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/5fda2af9b593dcf=
b7dc94ccd
        failing since 5 days (last pass: v4.19.162-27-g7042181619c5, first =
fail: v4.19.162-40-gbaa0b97cc4354)
        2 lines

    2020-12-16 15:42:43.442000+00:00  kern  :emerg :  lock: emif_lock+0x0/0=
xffffed34 [emif], .magic: 00000000, .owner: <none>/-1, .owner_cpu: 0   =

 =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-baylibre    | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/5fda27f43db2b012bbc94ce2

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.163=
-27-g7f94b7fe203f/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_=
arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.163=
-27-g7f94b7fe203f/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_=
arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fda27f43db2b012bbc94=
ce3
        failing since 32 days (last pass: v4.19.157-26-gd59f3161b3a0, first=
 fail: v4.19.157-27-g5543cc2c41d55) =

 =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-cip         | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/5fda27fe3db2b012bbc94ce9

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.163=
-27-g7f94b7fe203f/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-v=
ersatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.163=
-27-g7f94b7fe203f/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-v=
ersatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fda27fe3db2b012bbc94=
cea
        failing since 32 days (last pass: v4.19.157-26-gd59f3161b3a0, first=
 fail: v4.19.157-27-g5543cc2c41d55) =

 =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-collabora   | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/5fda27d63db2b012bbc94ccd

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.163=
-27-g7f94b7fe203f/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu=
_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.163=
-27-g7f94b7fe203f/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu=
_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fda27d63db2b012bbc94=
cce
        failing since 32 days (last pass: v4.19.157-26-gd59f3161b3a0, first=
 fail: v4.19.157-27-g5543cc2c41d55) =

 =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-linaro-lkft | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/5fda27d13db2b012bbc94cca

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.163=
-27-g7f94b7fe203f/arm/versatile_defconfig/gcc-8/lab-linaro-lkft/baseline-qe=
mu_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.163=
-27-g7f94b7fe203f/arm/versatile_defconfig/gcc-8/lab-linaro-lkft/baseline-qe=
mu_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fda27d13db2b012bbc94=
ccb
        failing since 32 days (last pass: v4.19.157-26-gd59f3161b3a0, first=
 fail: v4.19.157-27-g5543cc2c41d55) =

 =20
