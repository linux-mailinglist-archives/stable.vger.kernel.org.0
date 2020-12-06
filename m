Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EE3362D0555
	for <lists+stable@lfdr.de>; Sun,  6 Dec 2020 14:46:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727395AbgLFNpa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 6 Dec 2020 08:45:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38250 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725767AbgLFNp3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 6 Dec 2020 08:45:29 -0500
Received: from mail-pf1-x432.google.com (mail-pf1-x432.google.com [IPv6:2607:f8b0:4864:20::432])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F009BC0613D1
        for <stable@vger.kernel.org>; Sun,  6 Dec 2020 05:44:43 -0800 (PST)
Received: by mail-pf1-x432.google.com with SMTP id 11so982229pfu.4
        for <stable@vger.kernel.org>; Sun, 06 Dec 2020 05:44:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=/Y1Y7Q27F7A9mVQC6Ikh4JS0qbP8+h5/8hqOB2ZPE6Y=;
        b=Xf9/CmNqTR+n2Kz0QLuQqXYZnyG6kHjYfgTzEohGMmzNstTVUOy0+ERmnR2SrPzE6Y
         6r2rXJtKpO4MNznaE3Mge0UucYaQYm5n1XvmF6HSDiCCDiVYM7fjO7kbH54OViRRFE7p
         nuqkTWzAmIMt4YJ9NjjG+KqN1f/W/VDFWvcZ0i/G+anpk0BVlV/gQi1hAQe8urT7drra
         Nhxmx4INOzeORp2RGJaOk3ec31/4OgVj39zC/VcU90fN479u8eq8sSxZ4Ges2QhYSPFM
         im4KHa7i8vjOChrDaB3Uvl+EwzbbIC+Ip02ADIlUdXEo/OohHvioDLZEU0Yh5VqPYHfG
         6r4g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=/Y1Y7Q27F7A9mVQC6Ikh4JS0qbP8+h5/8hqOB2ZPE6Y=;
        b=sTfkhcpOOYwlE7BJpFR+ilCGgAS6efVCrDnHyIpimzHF65jwqwiyh6WwQdjh78RpvB
         5UxuLCGHXttA6KgbSmGYgxZgd1Gb+BzpcgS/jOIHE6czF+LXXfxE5f3zvPWzWMeuhmH2
         GOQ9g+44TvEpuWVLRef7TtOq6p4XoFvXz29dEpxVdW4hnryUv6OV2m/WgqE596S8E50p
         UVvx6BPZYoUndTCBlFzJ+i/epq0RDIzFv9lqNHJdbp/+uDQDeg3enx2sR/MaVtq7DBhR
         2ktRE4vWNnsujrO8mOhT24QpyA9fsrDZEVjrh0VXO7obkiTD/oC37zj594CFtT4F/zH1
         /SoA==
X-Gm-Message-State: AOAM531d379FMT8dYCGipfP7LeEht9XB8AN15vI2X0QhmuJiULAGUPTe
        mNBNw3ynx24GnX2sXmvM16KErMZT6KMOxQ==
X-Google-Smtp-Source: ABdhPJzoazK8Y9joLkYn7JZ6D82KpaYTzdxHbU+mQbwbLVZ6y+Q5x1G/pbGS4PugHHA+Ki5Cjzo1LQ==
X-Received: by 2002:a63:cd01:: with SMTP id i1mr3869862pgg.83.1607262283103;
        Sun, 06 Dec 2020 05:44:43 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id h11sm11608861pfn.27.2020.12.06.05.44.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 06 Dec 2020 05:44:42 -0800 (PST)
Message-ID: <5fcce04a.1c69fb81.2803e.bc37@mx.google.com>
Date:   Sun, 06 Dec 2020 05:44:42 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: queue/4.19
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v4.19.161-27-g280e981cb1ee
X-Kernelci-Report-Type: test
Subject: stable-rc/queue/4.19 baseline: 158 runs,
 4 regressions (v4.19.161-27-g280e981cb1ee)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.19 baseline: 158 runs, 4 regressions (v4.19.161-27-g280e9=
81cb1ee)

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
nel/v4.19.161-27-g280e981cb1ee/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.19
  Describe: v4.19.161-27-g280e981cb1ee
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      280e981cb1eefb3aa46e71118fb9d2f047ccc1df =



Test Regressions
---------------- =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-baylibre    | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/5fccad6a0150f20853c94cd8

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.161=
-27-g280e981cb1ee/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_=
arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.161=
-27-g280e981cb1ee/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_=
arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fccad6a0150f20853c94=
cd9
        failing since 22 days (last pass: v4.19.157-26-gd59f3161b3a0, first=
 fail: v4.19.157-27-g5543cc2c41d55) =

 =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-broonie     | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/5fccadfd0914d67a51c94cd5

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.161=
-27-g280e981cb1ee/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_a=
rm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.161=
-27-g280e981cb1ee/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_a=
rm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fccadfd0914d67a51c94=
cd6
        failing since 22 days (last pass: v4.19.157-26-gd59f3161b3a0, first=
 fail: v4.19.157-27-g5543cc2c41d55) =

 =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-cip         | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/5fccad7da1a82a7d8fc94ce5

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.161=
-27-g280e981cb1ee/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-v=
ersatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.161=
-27-g280e981cb1ee/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-v=
ersatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fccad7da1a82a7d8fc94=
ce6
        failing since 22 days (last pass: v4.19.157-26-gd59f3161b3a0, first=
 fail: v4.19.157-27-g5543cc2c41d55) =

 =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-linaro-lkft | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/5fccad25799f548d46c94cc2

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.161=
-27-g280e981cb1ee/arm/versatile_defconfig/gcc-8/lab-linaro-lkft/baseline-qe=
mu_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.161=
-27-g280e981cb1ee/arm/versatile_defconfig/gcc-8/lab-linaro-lkft/baseline-qe=
mu_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fccad25799f548d46c94=
cc3
        failing since 22 days (last pass: v4.19.157-26-gd59f3161b3a0, first=
 fail: v4.19.157-27-g5543cc2c41d55) =

 =20
