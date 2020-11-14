Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8E5EE2B3046
	for <lists+stable@lfdr.de>; Sat, 14 Nov 2020 20:48:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726121AbgKNTsr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 14 Nov 2020 14:48:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48336 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726112AbgKNTsr (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 14 Nov 2020 14:48:47 -0500
Received: from mail-pl1-x630.google.com (mail-pl1-x630.google.com [IPv6:2607:f8b0:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 81EB7C0613D1
        for <stable@vger.kernel.org>; Sat, 14 Nov 2020 11:48:47 -0800 (PST)
Received: by mail-pl1-x630.google.com with SMTP id s2so6131340plr.9
        for <stable@vger.kernel.org>; Sat, 14 Nov 2020 11:48:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=GCnqACUwNYmXgNBcykUrm7leRkcLmeCSFhIqJdlf+YE=;
        b=sDTi0lDYKhiEBDyeYLU1u7JqhsUIVHug+D3a7TIFIOVvYwVDUxqXdLy+Kxw0A0dzk7
         p9VWg6oS+UchHYnOP8e+kdMdzmE6LUuOljXzeN2+Q1OcX5KCHKxk/gp94DnqysEAgZiI
         AMEfKJln/W7xx8Fy/IN6qdLeDYUkvAtexsFLIHcSqw5nLRCu6dhUg/RaDgBHqn9h2KvW
         l1+2l9Xze7jPm5iKoYfzVO8qUFpUD2jfQA+IDfSJCtNuJPdlsK+fyqOvkxq9/ZZgtCrE
         TFFS1aZARHBFnHG5qMGMXcAM1Q+jH5l19pqJv2UzMO1JYBc4uR3EtJGQ8bV7r/xjC2Xs
         eInA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=GCnqACUwNYmXgNBcykUrm7leRkcLmeCSFhIqJdlf+YE=;
        b=io3Ev/upKtM38dUceMBTVHOqoQouUG+le7w6jyu9wTF7l9HlbZVzYi1DhM2nQsPhDY
         3eYDZQvsrF8PBT7gQ7uLc+kXO3eXX5BmmIA+USMuXuzw7+9dtlzqX2IZ8AlKNIjVwhg9
         T2BnRqOxuJikUil2GbYIwe8ukoMtG23KKYeUqDp2DmYaRmug0D0UOP1En6EjwDfX8ttR
         s1LxB34iESs2IqTRuAhj68jNdzLjZW5Is+wfMjVeHqfDua0MVNa0gMIYS8vc5xpQMWiw
         zg4T3yvCqhKUfuME+7ctygwJ6PkuJjiqdOWo3emggD2a2fOL7ylo7P8i4AFOxVa2TRUR
         EavA==
X-Gm-Message-State: AOAM533lN4tN+LDaqkZNYrFm27BCRsKZam4emvl8C6A9ZVVZJKXX9Kvz
        GY+zHSt0pQFcB7s/nzvgxkL1PhEGCYr3bQ==
X-Google-Smtp-Source: ABdhPJz4c0nTJnrn7wONvR+im3MjGIDxoLhoZgoM3Pak913j6TZRwiexf7QDwYRZsiYvwKKPoSXe0g==
X-Received: by 2002:a17:90a:e2c5:: with SMTP id fr5mr8204228pjb.86.1605383326665;
        Sat, 14 Nov 2020 11:48:46 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id m66sm14397895pfm.54.2020.11.14.11.48.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 14 Nov 2020 11:48:45 -0800 (PST)
Message-ID: <5fb0349d.1c69fb81.bd357.e52e@mx.google.com>
Date:   Sat, 14 Nov 2020 11:48:45 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: linux-4.9.y
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v4.9.243-26-g7b603f689c1c
X-Kernelci-Report-Type: test
Subject: stable-rc/linux-4.9.y baseline: 70 runs,
 6 regressions (v4.9.243-26-g7b603f689c1c)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.9.y baseline: 70 runs, 6 regressions (v4.9.243-26-g7b603f=
689c1c)

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


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-4.9.y/kern=
el/v4.9.243-26-g7b603f689c1c/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-4.9.y
  Describe: v4.9.243-26-g7b603f689c1c
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      7b603f689c1ca091cb68f85afed913ada6c098a1 =



Test Regressions
---------------- =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
panda                | arm  | lab-collabora   | gcc-8    | omap2plus_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/5faff956225e79f48979b8ac

  Results:     3 PASS, 1 FAIL, 1 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.243=
-26-g7b603f689c1c/arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-pand=
a.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.243=
-26-g7b603f689c1c/arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-pand=
a.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/5faff956225e79f=
48979b8b3
        failing since 2 days (last pass: v4.9.243, first fail: v4.9.243-17-=
g9c24315b745a0)
        2 lines

    2020-11-14 15:35:46.340000+00:00  kern  :emerg : BUG: spinlock bad magi=
c on CPU#0, udevd/127
    2020-11-14 15:35:46.349000+00:00  kern  :emerg :  lock: emif_lock+0x0/0=
xfffff24c [emif], .magic: dead4ead, .owner: <none>/-1, .owner_cpu: -1   =

 =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-baylibre    | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/5faff49bfcc80976e779b897

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.243=
-26-g7b603f689c1c/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_=
arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.243=
-26-g7b603f689c1c/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_=
arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5faff49bfcc80976e779b=
898
        new failure (last pass: v4.9.243-17-g9c24315b745a0) =

 =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-broonie     | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/5faff49934e88a998479b8a3

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.243=
-26-g7b603f689c1c/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_a=
rm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.243=
-26-g7b603f689c1c/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_a=
rm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5faff49934e88a998479b=
8a4
        new failure (last pass: v4.9.243-17-g9c24315b745a0) =

 =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-cip         | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/5faff49634e88a998479b89e

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.243=
-26-g7b603f689c1c/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-v=
ersatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.243=
-26-g7b603f689c1c/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-v=
ersatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5faff49634e88a998479b=
89f
        new failure (last pass: v4.9.243-17-g9c24315b745a0) =

 =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-collabora   | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/5faff45ac92bcb595579b89e

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.243=
-26-g7b603f689c1c/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu=
_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.243=
-26-g7b603f689c1c/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu=
_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5faff45ac92bcb595579b=
89f
        new failure (last pass: v4.9.243-17-g9c24315b745a0) =

 =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-linaro-lkft | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/5faffe7234792e18c679b8a1

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.243=
-26-g7b603f689c1c/arm/versatile_defconfig/gcc-8/lab-linaro-lkft/baseline-qe=
mu_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.243=
-26-g7b603f689c1c/arm/versatile_defconfig/gcc-8/lab-linaro-lkft/baseline-qe=
mu_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5faffe7234792e18c679b=
8a2
        new failure (last pass: v4.9.243-17-g9c24315b745a0) =

 =20
