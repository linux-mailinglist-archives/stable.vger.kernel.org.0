Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A82E62D2D37
	for <lists+stable@lfdr.de>; Tue,  8 Dec 2020 15:30:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729674AbgLHO3r (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Dec 2020 09:29:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37522 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729625AbgLHO3p (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 8 Dec 2020 09:29:45 -0500
Received: from mail-pg1-x52e.google.com (mail-pg1-x52e.google.com [IPv6:2607:f8b0:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8A444C0613D6
        for <stable@vger.kernel.org>; Tue,  8 Dec 2020 06:28:59 -0800 (PST)
Received: by mail-pg1-x52e.google.com with SMTP id m9so12329668pgb.4
        for <stable@vger.kernel.org>; Tue, 08 Dec 2020 06:28:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=YZs78ZyXkqlK3nYFNFDcan91ZmS3FMWKgt4QFeKi6yU=;
        b=x3nSNnlEPCPlRqXXzPX+QmA2Nse4rbRZ+vw8uSqxflUoZAb8OOFVOPxkFIbLWPgVu2
         LSc3yjWV/7wpkh47O2fper1U5Kc8zyLa0qolRgQEkTuJa45PrhXhRINt5sHxNE4p6ivl
         PZEzecNRSTg2U9UbaJXXkooVoxMHWysuwyZKeQFLcv1m1yNf2z5BUnJ0vOKBF2++2pmf
         oFlpJXR14xleRieMaOQx8Y0Zi9dRsmi/bJvYd32DUMz6RHlVX8B4yEqINvtWj6sFmhFd
         RxeGwcgJsNduDSf8lE/S16P+MRNtvz/Xh88AZ6rpngPnTbsRML5/h8+n/IsXMQSQBif4
         ycvA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=YZs78ZyXkqlK3nYFNFDcan91ZmS3FMWKgt4QFeKi6yU=;
        b=DCbzLTxCPJpIiC/YEwsuk30uiIebB13q614M+VPs4fb0P6bVq7Ts2QzpVKUOcm/S90
         joysESkRULCcvksHVBzhoTKJvUCGj/6rJl33I1Q0Dr6mQChpmBatnDncqR7iYa8XLjjd
         5fbfADLNfS2qMc/Q4wwOTbbPtscJj1dcE90csTcN3UWkOJPL0hpO1+Vg8+MPRANXzfpr
         YfJ08+IA7+f5rlVSR5Y0wl2o+FvLUB7EFXFT79XlfKKitbcv3aiPZzvsO63Q624ppeer
         wnSaP3bVt8D5s/DBsFEqKmyRI2cvfY4NBdQ4mgOT2jfWdv3HfHHqv4cW5/Qb4ODQOFcn
         8DKg==
X-Gm-Message-State: AOAM5303SpbUZI7aUtAY3cLFWVlry0378z9CUjRHPoEitU0iFujX6WX1
        jxxdcOv/7YNzz1J4eA22GxQwcxNFSZ8owg==
X-Google-Smtp-Source: ABdhPJxyCiALzJa2u717ibe2WXK2p/EbMHXCrffxaIprxbaqywvkTh9hs/y7XmfSpx5T4fUE8/QcHA==
X-Received: by 2002:a17:90b:4a84:: with SMTP id lp4mr4588508pjb.218.1607437738451;
        Tue, 08 Dec 2020 06:28:58 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id u11sm4358588pgf.12.2020.12.08.06.28.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 08 Dec 2020 06:28:57 -0800 (PST)
Message-ID: <5fcf8da9.1c69fb81.52baf.93b5@mx.google.com>
Date:   Tue, 08 Dec 2020 06:28:57 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: queue/4.19
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v4.19.161-31-gbbd6b5813fe2
X-Kernelci-Report-Type: test
Subject: stable-rc/queue/4.19 baseline: 195 runs,
 6 regressions (v4.19.161-31-gbbd6b5813fe2)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.19 baseline: 195 runs, 6 regressions (v4.19.161-31-gbbd6b=
5813fe2)

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


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.19/ker=
nel/v4.19.161-31-gbbd6b5813fe2/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.19
  Describe: v4.19.161-31-gbbd6b5813fe2
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      bbd6b5813fe2575464934bb50652476c81742ac4 =



Test Regressions
---------------- =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
panda                | arm  | lab-collabora   | gcc-8    | omap2plus_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/5fcf5c9f6bdfd76464c94ccd

  Results:     4 PASS, 1 FAIL, 0 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.161=
-31-gbbd6b5813fe2/arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-pand=
a.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.161=
-31-gbbd6b5813fe2/arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-pand=
a.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/5fcf5ca06bdfd76=
464c94cd2
        failing since 8 days (last pass: v4.19.160-13-g8733751e476a, first =
fail: v4.19.160-50-ge829433bf8e6)
        2 lines

    2020-12-08 10:59:38.107000+00:00  kern  :emerg : BUG: spinlock bad magi=
c on CPU#0, udevd/103
    2020-12-08 10:59:38.116000+00:00  kern  :emerg :  lock: emif_lock+0x0/0=
xffffed34 [emif], .magic: dead4ead, .owner: <none>/-1, .owner_cpu: -1   =

 =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-baylibre    | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/5fcf58aeb6f9a39206c94cbf

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.161=
-31-gbbd6b5813fe2/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_=
arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.161=
-31-gbbd6b5813fe2/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_=
arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fcf58aeb6f9a39206c94=
cc0
        failing since 24 days (last pass: v4.19.157-26-gd59f3161b3a0, first=
 fail: v4.19.157-27-g5543cc2c41d55) =

 =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-broonie     | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/5fcf59d864950ca5b9c94d3a

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.161=
-31-gbbd6b5813fe2/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_a=
rm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.161=
-31-gbbd6b5813fe2/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_a=
rm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fcf59d864950ca5b9c94=
d3b
        failing since 24 days (last pass: v4.19.157-26-gd59f3161b3a0, first=
 fail: v4.19.157-27-g5543cc2c41d55) =

 =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-cip         | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/5fcf5be90aaa419abdc94cc1

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.161=
-31-gbbd6b5813fe2/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-v=
ersatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.161=
-31-gbbd6b5813fe2/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-v=
ersatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fcf5be90aaa419abdc94=
cc2
        failing since 24 days (last pass: v4.19.157-26-gd59f3161b3a0, first=
 fail: v4.19.157-27-g5543cc2c41d55) =

 =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-collabora   | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/5fcf5864a04f8f9ad6c94cba

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.161=
-31-gbbd6b5813fe2/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu=
_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.161=
-31-gbbd6b5813fe2/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu=
_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fcf5864a04f8f9ad6c94=
cbb
        failing since 24 days (last pass: v4.19.157-26-gd59f3161b3a0, first=
 fail: v4.19.157-27-g5543cc2c41d55) =

 =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-linaro-lkft | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/5fcf5875b1fed4e6dec94ce3

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.161=
-31-gbbd6b5813fe2/arm/versatile_defconfig/gcc-8/lab-linaro-lkft/baseline-qe=
mu_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.161=
-31-gbbd6b5813fe2/arm/versatile_defconfig/gcc-8/lab-linaro-lkft/baseline-qe=
mu_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fcf5875b1fed4e6dec94=
ce4
        failing since 24 days (last pass: v4.19.157-26-gd59f3161b3a0, first=
 fail: v4.19.157-27-g5543cc2c41d55) =

 =20
