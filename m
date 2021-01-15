Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 69AC82F7F6B
	for <lists+stable@lfdr.de>; Fri, 15 Jan 2021 16:23:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727335AbhAOPWX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 15 Jan 2021 10:22:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47334 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726370AbhAOPWW (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 15 Jan 2021 10:22:22 -0500
Received: from mail-pj1-x102b.google.com (mail-pj1-x102b.google.com [IPv6:2607:f8b0:4864:20::102b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4E6ACC061757
        for <stable@vger.kernel.org>; Fri, 15 Jan 2021 07:21:42 -0800 (PST)
Received: by mail-pj1-x102b.google.com with SMTP id l23so5382557pjg.1
        for <stable@vger.kernel.org>; Fri, 15 Jan 2021 07:21:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=BFUDmnXgElQVKLbAcw8aP8Xi6EHj1GpmyYm9PF899u0=;
        b=U2Ouoov98N7+h2knuvikSmCRgRN9t9wdGDKZEqyDhuh+ld+tZ+3KjBMmeTXHLHO3RT
         0ymk7qn0TK8vq2JawM1OKbiz2biTEgoY4lsXT+kQEABVd9/p0aNI/pqe7x5KPJeSxtOR
         7IO7xJb+WaZepa2v8aqfYsq+ZxtzcLAmcx4zzKKHVts/Ao8bB7aVX2/HkiiRfXk8szyN
         ouZvozodXx+DGWtUKLpTFDxR7lQEHgUhDGIh0AgkLk/7ze7HQ0uqI0oXwP16VDktZ7QM
         hbZd3hP2qXnutvFZVQnRVrtIke/uu/9fPvvrI31YssVZKLzJZmPJy3CW3SqjeqYDJVKm
         knMQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=BFUDmnXgElQVKLbAcw8aP8Xi6EHj1GpmyYm9PF899u0=;
        b=WWyDmm6rggYPgC/Wf6W0ovp3kIO97Hlxk1e0GfSXPpfZdDqLBwN99qkOetgXZyK7JL
         m/t8pUbXgMnQCjY+T9CccMoQIHwH8//z8JDzBavWnTdtJhSJcEVL/GWrZKU2KJ4kRg7s
         j5VPFqsm96Vih8n69XRfx5+0kbTYDZiOn/F0nA/s2kDMW6CBaYR8FzykkNq40biGOUdK
         otSajDXOe6WyjvPMtaDvhaOFKVi42TZ/aMruUlHh/LgUOntES1z6S1iymGY/4v7VMgkD
         ltf7uqAgFCZvnIobDM2AFUyh7RmtWqAbmROdWK3Y2i0bh4+tjuAIzWGJL4NoUa254soE
         L8JQ==
X-Gm-Message-State: AOAM530O4Y06Tasu1o2Jg3P9QN1ikPm6cBkn9JO5Vt7YcHPB8HbxLJLd
        Ok2fjxHGhX1Zv14/XntbrSLuy9YVaSxi0g==
X-Google-Smtp-Source: ABdhPJys09gTEcptt3x9IleBGGqR+nQued69rqvRGHMXo0JixsDsgULj/xyFF97dtCwiXaHnrnbLuQ==
X-Received: by 2002:a17:902:7007:b029:dc:e89:50f1 with SMTP id y7-20020a1709027007b02900dc0e8950f1mr13266796plk.72.1610724101286;
        Fri, 15 Jan 2021 07:21:41 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id gl21sm8294699pjb.0.2021.01.15.07.21.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 15 Jan 2021 07:21:40 -0800 (PST)
Message-ID: <6001b304.1c69fb81.97e3e.4539@mx.google.com>
Date:   Fri, 15 Jan 2021 07:21:40 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: queue/4.14
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v4.14.215-13-g8ae2c946e835
X-Kernelci-Report-Type: test
Subject: stable-rc/queue/4.14 baseline: 130 runs,
 6 regressions (v4.14.215-13-g8ae2c946e835)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.14 baseline: 130 runs, 6 regressions (v4.14.215-13-g8ae2c=
946e835)

Regressions Summary
-------------------

platform             | arch  | lab           | compiler | defconfig        =
   | regressions
---------------------+-------+---------------+----------+------------------=
---+------------
meson-gxm-q200       | arm64 | lab-baylibre  | gcc-8    | defconfig        =
   | 1          =

panda                | arm   | lab-collabora | gcc-8    | omap2plus_defconf=
ig | 1          =

qemu_arm-versatilepb | arm   | lab-baylibre  | gcc-8    | versatile_defconf=
ig | 1          =

qemu_arm-versatilepb | arm   | lab-broonie   | gcc-8    | versatile_defconf=
ig | 1          =

qemu_arm-versatilepb | arm   | lab-cip       | gcc-8    | versatile_defconf=
ig | 1          =

qemu_arm-versatilepb | arm   | lab-collabora | gcc-8    | versatile_defconf=
ig | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.14/ker=
nel/v4.14.215-13-g8ae2c946e835/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.14
  Describe: v4.14.215-13-g8ae2c946e835
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      8ae2c946e835f427aa9f2447640833b668985fc5 =



Test Regressions
---------------- =



platform             | arch  | lab           | compiler | defconfig        =
   | regressions
---------------------+-------+---------------+----------+------------------=
---+------------
meson-gxm-q200       | arm64 | lab-baylibre  | gcc-8    | defconfig        =
   | 1          =


  Details:     https://kernelci.org/test/plan/id/60017e75987de1b4c4c94cee

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.215=
-13-g8ae2c946e835/arm64/defconfig/gcc-8/lab-baylibre/baseline-meson-gxm-q20=
0.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.215=
-13-g8ae2c946e835/arm64/defconfig/gcc-8/lab-baylibre/baseline-meson-gxm-q20=
0.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60017e75987de1b4c4c94=
cef
        failing since 37 days (last pass: v4.14.210-20-gc32b9f7cbda7, first=
 fail: v4.14.210-20-g5ea7913395d3) =

 =



platform             | arch  | lab           | compiler | defconfig        =
   | regressions
---------------------+-------+---------------+----------+------------------=
---+------------
panda                | arm   | lab-collabora | gcc-8    | omap2plus_defconf=
ig | 1          =


  Details:     https://kernelci.org/test/plan/id/6001790a0423a438e0c94d2a

  Results:     3 PASS, 1 FAIL, 1 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.215=
-13-g8ae2c946e835/arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-pand=
a.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.215=
-13-g8ae2c946e835/arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-pand=
a.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/6001790a0423a43=
8e0c94d2f
        failing since 1 day (last pass: v4.14.214-56-g995bc2469cc73, first =
fail: v4.14.215-1-gbdd6da9c099fa)
        2 lines

    2021-01-15 11:14:14.273000+00:00  [   20.208068] usb 3-1.1: New USB dev=
ice found, idVendor=3D0424, idProduct=3Dec00
    2021-01-15 11:14:14.281000+00:00  [   20.214385] usb 3-1.1: New USB dev=
ice strings: Mfr=3D0, Product=3D0, SerialNumber=3D0
    2021-01-15 11:14:14.307000+00:00  [   20.246795] smsc95xx v1.0.6
    2021-01-15 11:14:14.323000+00:00  kern  :emerg : BUG: spinlock bad magi=
c on CPU#0, udevd/100
    2021-01-15 11:14:14.332000+00:00  kern  :emerg :  lock: emif_lock+0x0/0=
xffffed34 [emif], .magic: 00000000, .owner: <none>/-1, .owner_cpu: 0   =

 =



platform             | arch  | lab           | compiler | defconfig        =
   | regressions
---------------------+-------+---------------+----------+------------------=
---+------------
qemu_arm-versatilepb | arm   | lab-baylibre  | gcc-8    | versatile_defconf=
ig | 1          =


  Details:     https://kernelci.org/test/plan/id/6001767e92d3a0f51ac94cd0

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.215=
-13-g8ae2c946e835/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_=
arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.215=
-13-g8ae2c946e835/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_=
arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6001767e92d3a0f51ac94=
cd1
        failing since 62 days (last pass: v4.14.206-21-g787a7a3ca16c, first=
 fail: v4.14.206-22-ga949bf40fb01) =

 =



platform             | arch  | lab           | compiler | defconfig        =
   | regressions
---------------------+-------+---------------+----------+------------------=
---+------------
qemu_arm-versatilepb | arm   | lab-broonie   | gcc-8    | versatile_defconf=
ig | 1          =


  Details:     https://kernelci.org/test/plan/id/600176323a152a998dc94cc8

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.215=
-13-g8ae2c946e835/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_a=
rm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.215=
-13-g8ae2c946e835/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_a=
rm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/600176323a152a998dc94=
cc9
        failing since 62 days (last pass: v4.14.206-21-g787a7a3ca16c, first=
 fail: v4.14.206-22-ga949bf40fb01) =

 =



platform             | arch  | lab           | compiler | defconfig        =
   | regressions
---------------------+-------+---------------+----------+------------------=
---+------------
qemu_arm-versatilepb | arm   | lab-cip       | gcc-8    | versatile_defconf=
ig | 1          =


  Details:     https://kernelci.org/test/plan/id/6001762fa6e8d164e8c94cb9

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.215=
-13-g8ae2c946e835/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-v=
ersatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.215=
-13-g8ae2c946e835/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-v=
ersatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6001762fa6e8d164e8c94=
cba
        failing since 62 days (last pass: v4.14.206-21-g787a7a3ca16c, first=
 fail: v4.14.206-22-ga949bf40fb01) =

 =



platform             | arch  | lab           | compiler | defconfig        =
   | regressions
---------------------+-------+---------------+----------+------------------=
---+------------
qemu_arm-versatilepb | arm   | lab-collabora | gcc-8    | versatile_defconf=
ig | 1          =


  Details:     https://kernelci.org/test/plan/id/600193b86bf7a137d1c94cd6

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.215=
-13-g8ae2c946e835/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu=
_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.215=
-13-g8ae2c946e835/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu=
_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/600193b86bf7a137d1c94=
cd7
        failing since 62 days (last pass: v4.14.206-21-g787a7a3ca16c, first=
 fail: v4.14.206-22-ga949bf40fb01) =

 =20
