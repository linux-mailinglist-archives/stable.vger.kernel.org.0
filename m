Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D78B1301313
	for <lists+stable@lfdr.de>; Sat, 23 Jan 2021 05:40:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726598AbhAWEkV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 22 Jan 2021 23:40:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37690 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726597AbhAWEkU (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 22 Jan 2021 23:40:20 -0500
Received: from mail-pl1-x635.google.com (mail-pl1-x635.google.com [IPv6:2607:f8b0:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 08388C06174A
        for <stable@vger.kernel.org>; Fri, 22 Jan 2021 20:39:39 -0800 (PST)
Received: by mail-pl1-x635.google.com with SMTP id h15so1941472pli.8
        for <stable@vger.kernel.org>; Fri, 22 Jan 2021 20:39:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=PAB2B9T42FwgQ2t/agtYk/+FZMhn2pxOXkUOCXES9GY=;
        b=RJi4bQ2xN3uavA5dwLKNpX4Twej+40733T0tt+KdWQ8NUjctWYmAI8OYpFzjs4kG3X
         LTsCNg1gJrBlN4oSchIGcgquHFfhDLxOEml5ZhucsaFCzQ/KVZr069BulKd/kkky1nD/
         qJzJk6BazOrqP+CA2rbwLbI4yruTNqBOkohv8wNospkuq6pvZGfBbEzDcrdNkdL/aPlI
         1GOwfZkPNul/qO3pL+PwP190pXO/32NDwkzlGiKRuGM2zswQT63NViKhXKqmF0uyVM2C
         qrqxa37ODXWt7Mmi/VkpFJAkHhq1wGmwGJjmzkRQwXOGoxrX19prliJkatTml+2Igh67
         Reuw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=PAB2B9T42FwgQ2t/agtYk/+FZMhn2pxOXkUOCXES9GY=;
        b=bgAyQgbBYzIM1Okct7yXn0N1VP/BTCW6k1HaadiG6OIpoIDfWbSrcpYKh0yIDxPgN/
         88O+8V3g8ckrDiJb4+pE9TWrVfOXkaNcdWCf9PzXcoLmG+Qa5dBc2oHHdDfcavY0Ab3Y
         BtKg1k6SLn21AjXLaD006V1BRjd+/tUQb6x+se9tfQWXFW7Euyl4O/sUQxrhJTnYXDzW
         VIB+eo6oKEFMo5+wYPUVLJ4dcZpuZtmDPw/dHOkgFb8Rt2HPgzG0IH+6zaER4cKeJ7EK
         SeZ368s8snCvCRM1xrDa1aT6UBa/K8ugVf0BvKL9Mpcv2YSGKqa39TBPfssfYJuDwK0L
         UYaQ==
X-Gm-Message-State: AOAM5305bmyA9w43VveKHbqwFQGC6qbcey4/1DxyFZbrwkF9RzNLOSZ+
        TGHY3yK9qZv5AxvylDiNjwCiTzRyWuJopaec
X-Google-Smtp-Source: ABdhPJy1mxD1abP9uLfIx4A6pbmN/jiu1GaZmknQ5+zqs45V5Fc7Z75QYsWeB1UtPVh7QQMD2ptoUw==
X-Received: by 2002:a17:90a:cb0f:: with SMTP id z15mr9516033pjt.88.1611376779121;
        Fri, 22 Jan 2021 20:39:39 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id b5sm9899424pfi.1.2021.01.22.20.39.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 22 Jan 2021 20:39:38 -0800 (PST)
Message-ID: <600ba88a.1c69fb81.87d2c.8d72@mx.google.com>
Date:   Fri, 22 Jan 2021 20:39:38 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.14.216-49-g10fddc03bd61
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-4.14.y
Subject: stable-rc/linux-4.14.y baseline: 114 runs,
 5 regressions (v4.14.216-49-g10fddc03bd61)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.14.y baseline: 114 runs, 5 regressions (v4.14.216-49-g10f=
ddc03bd61)

Regressions Summary
-------------------

platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
panda                | arm  | lab-collabora   | gcc-8    | omap2plus_defcon=
fig | 1          =

qemu_arm-versatilepb | arm  | lab-broonie     | gcc-8    | versatile_defcon=
fig | 1          =

qemu_arm-versatilepb | arm  | lab-cip         | gcc-8    | versatile_defcon=
fig | 1          =

qemu_arm-versatilepb | arm  | lab-collabora   | gcc-8    | versatile_defcon=
fig | 1          =

qemu_arm-versatilepb | arm  | lab-linaro-lkft | gcc-8    | versatile_defcon=
fig | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-4.14.y/ker=
nel/v4.14.216-49-g10fddc03bd61/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-4.14.y
  Describe: v4.14.216-49-g10fddc03bd61
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      10fddc03bd61fb44e84e0fd3550f78e950cbe2a2 =



Test Regressions
---------------- =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
panda                | arm  | lab-collabora   | gcc-8    | omap2plus_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/600b7904156e1af53bd3dff9

  Results:     3 PASS, 1 FAIL, 1 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
16-49-g10fddc03bd61/arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-pa=
nda.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
16-49-g10fddc03bd61/arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-pa=
nda.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/600b7904156e1af=
53bd3e000
        failing since 7 days (last pass: v4.14.215-29-ge0904e5ba4c7, first =
fail: v4.14.215-29-g4cfcf012355fc)
        2 lines

    2021-01-23 01:16:43.805000+00:00  kern  :emerg : BUG: spinlock bad magi=
c on CPU#0, udevd/96
    2021-01-23 01:16:43.814000+00:00  kern  :emerg :  lock: emif_lock+0x0/0=
xffffed34 [emif], .magic: dead4ead, .owner: <none>/-1, .owner_cpu: -1   =

 =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-broonie     | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/600b73ded252ae5289d3dfdc

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
16-49-g10fddc03bd61/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu=
_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
16-49-g10fddc03bd61/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu=
_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/600b73ded252ae5289d3d=
fdd
        failing since 69 days (last pass: v4.14.206-21-gf1262f26e4d0, first=
 fail: v4.14.206-23-g520c3568920c8) =

 =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-cip         | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/600b73ccc664350ff8d3dfe8

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
16-49-g10fddc03bd61/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm=
-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
16-49-g10fddc03bd61/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm=
-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/600b73ccc664350ff8d3d=
fe9
        failing since 69 days (last pass: v4.14.206-21-gf1262f26e4d0, first=
 fail: v4.14.206-23-g520c3568920c8) =

 =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-collabora   | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/600b78252d430faf97d3dfdc

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
16-49-g10fddc03bd61/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qe=
mu_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
16-49-g10fddc03bd61/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qe=
mu_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/600b78252d430faf97d3d=
fdd
        failing since 69 days (last pass: v4.14.206-21-gf1262f26e4d0, first=
 fail: v4.14.206-23-g520c3568920c8) =

 =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-linaro-lkft | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/600b793bc00993917dd3dfc9

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
16-49-g10fddc03bd61/arm/versatile_defconfig/gcc-8/lab-linaro-lkft/baseline-=
qemu_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
16-49-g10fddc03bd61/arm/versatile_defconfig/gcc-8/lab-linaro-lkft/baseline-=
qemu_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/600b793bc00993917dd3d=
fca
        failing since 69 days (last pass: v4.14.206-21-gf1262f26e4d0, first=
 fail: v4.14.206-23-g520c3568920c8) =

 =20
