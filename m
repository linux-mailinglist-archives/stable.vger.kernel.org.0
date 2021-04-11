Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4549335B469
	for <lists+stable@lfdr.de>; Sun, 11 Apr 2021 15:16:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235592AbhDKM6P (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 11 Apr 2021 08:58:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34066 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235095AbhDKM6O (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 11 Apr 2021 08:58:14 -0400
Received: from mail-pj1-x1035.google.com (mail-pj1-x1035.google.com [IPv6:2607:f8b0:4864:20::1035])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D9BB7C061574
        for <stable@vger.kernel.org>; Sun, 11 Apr 2021 05:57:58 -0700 (PDT)
Received: by mail-pj1-x1035.google.com with SMTP id e8-20020a17090a7288b029014e51f5a6baso247274pjg.2
        for <stable@vger.kernel.org>; Sun, 11 Apr 2021 05:57:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=d2fTSBj3I0w5fqptqCsAcwAOnQbei5d5pMkSNEQ4xzM=;
        b=rQ8g+xyjmaT6KDGxhn78psktmpLDAmGKEIBAtN/f3j7dkqOLbN6eDpMG29LOLi5yF2
         rXsoy1cTtGiG27cMxJVHpX+baWUrlVhWXwSipvscnsj0DNwLs9klCDl/llxarsYVTTAs
         IPn4pXilr4Sk2vG+S3M3pfH+DGSQlGhD6ZS9nwXmXXZZpHomT591U9Dsf/E4gDPHWeOY
         wi3uvBJSGRCyP7E5y7Kj6Pn2AaCd+G75QR8udXOgjXhYgnn0vLS6NrLiCmESMr5ZZ1n8
         lcooCBBHmwGh4RE0zNLUs1gw+lCj1oDpFVMQLE96uUXD9ehaG+9MXk5/IZLc0lmd7Zc+
         JG0g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=d2fTSBj3I0w5fqptqCsAcwAOnQbei5d5pMkSNEQ4xzM=;
        b=PKWWeUaiGoOSLaM3MRiTf/eQ0gVRBJVYEYGuKLCKVTzfTI8T3HVRVchIRJGHXlbGMe
         Rv9+lK3d1UTTzV0SIHpLpOvmQYerS+/BoZhxAyME2zpNX7RsC33ceek2CsbdeFuo0av2
         4yrR/mX27lFNkvVesHvj6Ol12Jcq8pVsIZoAvbDphyaO8vvjxogu6N4Q9iUptTqcqzP3
         oJ3wARZBT3HoSFPj5lqRk1uU4UdkOxG+diAcw6wIa6InFzFQAbdF2byNgTqJYAxzNI4D
         lN43ChOyZ6acelY31VO4kxiK0t+JVBNt+yl5mS2jAJlo7+s6Nu/uqWJ3QT14cKmK+kmY
         CdoA==
X-Gm-Message-State: AOAM532Ml1nxCYu7jRp3wiFQFCtP8Vd3LO2KjsG9oXJKSWXcNi0x832t
        rB9k8fCu2Jj6K6AxUKm55NhhWnZIF6flVA/G
X-Google-Smtp-Source: ABdhPJynssSGq5rGpwnJmwynF7PPNbskpS4JSC2GqkUbpkwouOSWJ8DEJ0aDcTFp+MOhPPv7uKtIcQ==
X-Received: by 2002:a17:902:f212:b029:e9:56f2:18ba with SMTP id m18-20020a170902f212b02900e956f218bamr21291541plc.75.1618145878231;
        Sun, 11 Apr 2021 05:57:58 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id b140sm7531185pfb.98.2021.04.11.05.57.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 11 Apr 2021 05:57:57 -0700 (PDT)
Message-ID: <6072f255.1c69fb81.460e7.246d@mx.google.com>
Date:   Sun, 11 Apr 2021 05:57:57 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v4.19.186-26-g1cf6baf20e3e1
X-Kernelci-Branch: queue/4.19
X-Kernelci-Tree: stable-rc
Subject: stable-rc/queue/4.19 baseline: 153 runs,
 7 regressions (v4.19.186-26-g1cf6baf20e3e1)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.19 baseline: 153 runs, 7 regressions (v4.19.186-26-g1cf6b=
af20e3e1)

Regressions Summary
-------------------

platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
beaglebone-black     | arm  | lab-cip         | gcc-8    | omap2plus_defcon=
fig | 1          =

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


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.19/ker=
nel/v4.19.186-26-g1cf6baf20e3e1/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.19
  Describe: v4.19.186-26-g1cf6baf20e3e1
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      1cf6baf20e3e18c2c942539ba2310ce8c1d7e558 =



Test Regressions
---------------- =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
beaglebone-black     | arm  | lab-cip         | gcc-8    | omap2plus_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/6072bfa733b882d78cdac6c5

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.186=
-26-g1cf6baf20e3e1/arm/omap2plus_defconfig/gcc-8/lab-cip/baseline-beaglebon=
e-black.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.186=
-26-g1cf6baf20e3e1/arm/omap2plus_defconfig/gcc-8/lab-cip/baseline-beaglebon=
e-black.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6072bfa733b882d78cdac=
6c6
        new failure (last pass: v4.19.186-21-g4659135847508) =

 =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
panda                | arm  | lab-collabora   | gcc-8    | omap2plus_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/6072bec27c23d26465dac6b1

  Results:     4 PASS, 1 FAIL, 0 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.186=
-26-g1cf6baf20e3e1/arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-pan=
da.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.186=
-26-g1cf6baf20e3e1/arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-pan=
da.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/6072bec27c23d26=
465dac6b8
        failing since 0 day (last pass: v4.19.185-18-gb9c63423ccf3, first f=
ail: v4.19.186-21-g4659135847508)
        2 lines

    2021-04-11 09:17:49.496000+00:00  kern  :emerg :  lock: emif_lock+0x0/0=
xffffed34 [emif], .magic: 00000000, .owner: <none>/-1, .owner_cpu: 0   =

 =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-baylibre    | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/6072b97670773d3746dac6d8

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.186=
-26-g1cf6baf20e3e1/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu=
_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.186=
-26-g1cf6baf20e3e1/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu=
_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6072b97670773d3746dac=
6d9
        failing since 148 days (last pass: v4.19.157-26-gd59f3161b3a0, firs=
t fail: v4.19.157-27-g5543cc2c41d55) =

 =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-broonie     | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/6072b96302774ae9a3dac6c9

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.186=
-26-g1cf6baf20e3e1/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_=
arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.186=
-26-g1cf6baf20e3e1/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_=
arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6072b96302774ae9a3dac=
6ca
        failing since 148 days (last pass: v4.19.157-26-gd59f3161b3a0, firs=
t fail: v4.19.157-27-g5543cc2c41d55) =

 =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-cip         | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/6072b96eacb08f923ddac6b1

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.186=
-26-g1cf6baf20e3e1/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-=
versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.186=
-26-g1cf6baf20e3e1/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-=
versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6072b96eacb08f923ddac=
6b2
        failing since 148 days (last pass: v4.19.157-26-gd59f3161b3a0, firs=
t fail: v4.19.157-27-g5543cc2c41d55) =

 =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-collabora   | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/6072b90ce983297ce6dac6be

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.186=
-26-g1cf6baf20e3e1/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qem=
u_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.186=
-26-g1cf6baf20e3e1/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qem=
u_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6072b90ce983297ce6dac=
6bf
        failing since 148 days (last pass: v4.19.157-26-gd59f3161b3a0, firs=
t fail: v4.19.157-27-g5543cc2c41d55) =

 =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-linaro-lkft | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/6072b9279dc0838734dac6b1

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.186=
-26-g1cf6baf20e3e1/arm/versatile_defconfig/gcc-8/lab-linaro-lkft/baseline-q=
emu_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.186=
-26-g1cf6baf20e3e1/arm/versatile_defconfig/gcc-8/lab-linaro-lkft/baseline-q=
emu_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6072b9279dc0838734dac=
6b2
        failing since 148 days (last pass: v4.19.157-26-gd59f3161b3a0, firs=
t fail: v4.19.157-27-g5543cc2c41d55) =

 =20
