Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8F31B372533
	for <lists+stable@lfdr.de>; Tue,  4 May 2021 06:43:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229722AbhEDEoW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 4 May 2021 00:44:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40396 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229715AbhEDEoV (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 4 May 2021 00:44:21 -0400
Received: from mail-pg1-x52f.google.com (mail-pg1-x52f.google.com [IPv6:2607:f8b0:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BE1B3C061574
        for <stable@vger.kernel.org>; Mon,  3 May 2021 21:43:27 -0700 (PDT)
Received: by mail-pg1-x52f.google.com with SMTP id d10so5619662pgf.12
        for <stable@vger.kernel.org>; Mon, 03 May 2021 21:43:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=ZAy9ZmCLObyNWv6GH5+XxP2lBI4e6hLXAh+MzSZRrww=;
        b=Lc5mFLHi/aZyl6WfEbAXmC7QMtPGWirbZD6cXxd7NDLocSVoQmU9KcuH6f9rOA1uPN
         7SLZNxpbtOAA9KaKu2sBI50DhBL2q3oL9mDBiVfpnk6KTPru1EGoJpXpblUh9UeDTrSx
         Sk9Usu0vccKfXEGZffjwDLUMqNVvPP2cBvZjXpLnELZXha8QYl92xzqWi0KBNzR+w90Q
         LPhwrJ6gWnGQhVvXe3NhY95E0OKgtp2H+72hX7WBikDmic2E52nch7/nXUypTPoIvx4J
         cn154xQYs+NBToHntezuNU2V98yueOy7ogENDjkuUH3RGu7jDV3QPlF3X9pAFET8nS+j
         F4lA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=ZAy9ZmCLObyNWv6GH5+XxP2lBI4e6hLXAh+MzSZRrww=;
        b=Aa7mVJOT2KaJ48flqfqrk5VgrrWVb4EZAUZm1QyI8IEkty6UEku64tJzoomfO99UzT
         xVC03WXiY7dY7M/kuB85PF5b69AEq/hnxhwNzgR7yQ3k5cuW902+MiADpTatrDsfmNmA
         2A1tWTUjCA5isU4cMGpRk8FOSnz1nDRVtp6O2pd2DZewkdZgkK0rSCnATQa18Cjn3bLr
         GmH0HCQ1+/YmStR8iQA5hHIDc+IH9xP+JP4f0yJv36/8s07W3TCOFKXZd/TwQGAI3aZM
         Xy6Uoylu2CuQ+wBDOeRDfX/9yikHzt3LDsjzm+pggG/JGcLzTl5phJ9T84zyc7MvuzOD
         bI8w==
X-Gm-Message-State: AOAM531A2wJIaF6iWEs1nFuOx3H/ksVeqDMD4XC8sJcQh2kOQ/8YP1+R
        AtTR8/OXQB/i25oR4+ThKVOEEegD9Md7ug/+
X-Google-Smtp-Source: ABdhPJwWHvEcYZcD5CQxDYpJ04Yy+2+KVKe3M7u3Eq0P6pYq4dicVV32PdrjBHGzbz42C7xomtLg1Q==
X-Received: by 2002:a17:90a:e00c:: with SMTP id u12mr912280pjy.155.1620103407080;
        Mon, 03 May 2021 21:43:27 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id g6sm5356561pfr.213.2021.05.03.21.43.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 03 May 2021 21:43:26 -0700 (PDT)
Message-ID: <6090d0ee.1c69fb81.0649.ea0b@mx.google.com>
Date:   Mon, 03 May 2021 21:43:26 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Branch: queue/4.14
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v4.14.232-6-g3e09bac2a801
Subject: stable-rc/queue/4.14 baseline: 83 runs,
 6 regressions (v4.14.232-6-g3e09bac2a801)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.14 baseline: 83 runs, 6 regressions (v4.14.232-6-g3e09bac=
2a801)

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

qemu_arm-versatilepb | arm  | lab-broonie     | gcc-8    | versatile_defcon=
fig | 1          =

qemu_arm-versatilepb | arm  | lab-cip         | gcc-8    | versatile_defcon=
fig | 1          =

qemu_arm-versatilepb | arm  | lab-collabora   | gcc-8    | versatile_defcon=
fig | 1          =

qemu_arm-versatilepb | arm  | lab-linaro-lkft | gcc-8    | versatile_defcon=
fig | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.14/ker=
nel/v4.14.232-6-g3e09bac2a801/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.14
  Describe: v4.14.232-6-g3e09bac2a801
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      3e09bac2a801a30c8867f1948c05f626861d9760 =



Test Regressions
---------------- =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
panda                | arm  | lab-collabora   | gcc-8    | omap2plus_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/6090a1058bc1eac747c918c3

  Results:     3 PASS, 1 FAIL, 1 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.232=
-6-g3e09bac2a801/arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-panda=
.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.232=
-6-g3e09bac2a801/arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-panda=
.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/6090a1058bc1eac=
747c918c8
        failing since 3 days (last pass: v4.14.231-51-g09d3b447c34f, first =
fail: v4.14.232-1-gcc63f168dbc1c)
        2 lines

    2021-05-04 01:18:57.226000+00:00  kern  :emerg : BUG: spinlock bad magi=
c on CPU#0, udevd/103
    2021-05-04 01:18:57.239000+00:00  kern  :emerg :  lock[   20.478637] sm=
sc95xx 3-1.1:1.0 eth0: register 'smsc95xx' at usb-4a064c00.ehci-1.1, smsc95=
xx USB 2.0 Ethernet, 8a:3a:ce:16:2d:00
    2021-05-04 01:18:57.250000+00:00  : emif_lock+0x0/0xffffed34 [emif], .m=
agic: 00000[   20.495666] usbcore: registered new interface driver smsc95xx
    2021-05-04 01:18:57.253000+00:00  000, .owner: <none>/-1, .owner_cpu: 0
    2021-05-04 01:18:57.277000+00:00  [   20.523773] <LAVA_SIGNAL_TESTCASE =
TEST_CASE_ID=3Demerg RESULT=3Dfail UNITS=3Dlines MEASUREMENT=3D2>   =

 =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-baylibre    | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/6090967c73860c8654c917cf

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.232=
-6-g3e09bac2a801/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_a=
rm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.232=
-6-g3e09bac2a801/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_a=
rm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6090967c73860c8654c91=
7d0
        failing since 171 days (last pass: v4.14.206-21-g787a7a3ca16c, firs=
t fail: v4.14.206-22-ga949bf40fb01) =

 =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-broonie     | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/609096773aab3c988ac917cc

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.232=
-6-g3e09bac2a801/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_ar=
m-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.232=
-6-g3e09bac2a801/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_ar=
m-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/609096773aab3c988ac91=
7cd
        failing since 171 days (last pass: v4.14.206-21-g787a7a3ca16c, firs=
t fail: v4.14.206-22-ga949bf40fb01) =

 =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-cip         | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/6090967c348c61d30bc917cc

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.232=
-6-g3e09bac2a801/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-ve=
rsatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.232=
-6-g3e09bac2a801/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-ve=
rsatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6090967c348c61d30bc91=
7cd
        failing since 171 days (last pass: v4.14.206-21-g787a7a3ca16c, firs=
t fail: v4.14.206-22-ga949bf40fb01) =

 =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-collabora   | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/6090a56a0ba3474e74c917d0

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.232=
-6-g3e09bac2a801/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu_=
arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.232=
-6-g3e09bac2a801/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu_=
arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6090a56a0ba3474e74c91=
7d1
        failing since 171 days (last pass: v4.14.206-21-g787a7a3ca16c, firs=
t fail: v4.14.206-22-ga949bf40fb01) =

 =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-linaro-lkft | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/6090a5d1bfdc93839ac917c8

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.232=
-6-g3e09bac2a801/arm/versatile_defconfig/gcc-8/lab-linaro-lkft/baseline-qem=
u_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.232=
-6-g3e09bac2a801/arm/versatile_defconfig/gcc-8/lab-linaro-lkft/baseline-qem=
u_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6090a5d1bfdc93839ac91=
7c9
        failing since 171 days (last pass: v4.14.206-21-g787a7a3ca16c, firs=
t fail: v4.14.206-22-ga949bf40fb01) =

 =20
