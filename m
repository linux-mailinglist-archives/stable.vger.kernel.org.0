Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A222F37AF14
	for <lists+stable@lfdr.de>; Tue, 11 May 2021 21:07:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232123AbhEKTIh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 11 May 2021 15:08:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56024 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231858AbhEKTIf (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 11 May 2021 15:08:35 -0400
Received: from mail-pj1-x102e.google.com (mail-pj1-x102e.google.com [IPv6:2607:f8b0:4864:20::102e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D2209C061574
        for <stable@vger.kernel.org>; Tue, 11 May 2021 12:07:26 -0700 (PDT)
Received: by mail-pj1-x102e.google.com with SMTP id gj14so12197671pjb.5
        for <stable@vger.kernel.org>; Tue, 11 May 2021 12:07:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=khpvVZ5/FwsVYwvEpJayMomT5Iu+DsR08RjNpqiif48=;
        b=PIFvSpcjSPbbyfJSFs4Xc6INPqIlZzwekBBP/VraMUhmNYKS7OLB/fK/4LECv+91s3
         rmrYlb/rczjBVde6MOEPgB/M82ve1woPyQHCxrLv2NLYWFJ6iz0+hdNK2NhpO/PK5Qe5
         1zFm8bXZobtM1A9YIX+p/1aNkbyIv4qJbq0meMyzXe9jgcrIgKBn2BB6LkVsC4xXAHXo
         e9VHT42DVLX12rS9d9Mym4jWq3e6r+LFGH8v7LJKegSvD2JE+F8suEvhzij3JScFC1qS
         rhfwVhRYPa7tFU+kQmp/cp+n9hG1wvWtfqMSfsM418vbmDDNddVdhlp5X4+T+urY31Fh
         Ljjw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=khpvVZ5/FwsVYwvEpJayMomT5Iu+DsR08RjNpqiif48=;
        b=GpZoJFQ3HnEbSmZ38B61KUNeYWP9Ytq8SouKRsnr5g55vvlT+xGFnyK9Bz+8v3B1OW
         co0gTqJOOJoFZ4Iqr4Y9dWqtxjN/+jRy4AhH91C0oJVguGnYWXd1YeAKTZbD3u1pHlHS
         y+KCFs7rK8QkofZ8yRwSPR6VuD09z74G1bJ6Y+/vwTV53/yYNd1R8K0xl5VMzKF42B3f
         9teFuSRK0InV6LwNZSHHauSV0IdkXGBz7HLKbKRrMsYkB3XEB79HdkN0Fz2xj3TG7mpR
         bDWgPkZkvtdALNezlYlCBSuPwdjTHXB1fMFMO1KiBab/aLJLz7fuBrQ12H6ubCxqIPYE
         ONPQ==
X-Gm-Message-State: AOAM532Yb87cCMUYu4Ut70E2WqWD5fhhLxcQxDQH60q2ZDHbHqVFMmxF
        d0StJKk7KSUdz3a53Ne4YmgK4XOdi8cG6Alw
X-Google-Smtp-Source: ABdhPJxM7CEYNbfmHDg7m7epEXejLOc7xsQHfRmm2xJqaxa1izfXxaOLdWXA967vTUgMU2gDWkLzvQ==
X-Received: by 2002:a17:90a:af85:: with SMTP id w5mr18551636pjq.115.1620760046181;
        Tue, 11 May 2021 12:07:26 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id w14sm14463922pff.94.2021.05.11.12.07.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 11 May 2021 12:07:25 -0700 (PDT)
Message-ID: <609ad5ed.1c69fb81.25229.cd66@mx.google.com>
Date:   Tue, 11 May 2021 12:07:25 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.19.190-127-g357aab07cc5ee
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/4.19
X-Kernelci-Report-Type: test
Subject: stable-rc/queue/4.19 baseline: 87 runs,
 4 regressions (v4.19.190-127-g357aab07cc5ee)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.19 baseline: 87 runs, 4 regressions (v4.19.190-127-g357aa=
b07cc5ee)

Regressions Summary
-------------------

platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-broonie     | gcc-8    | versatile_defcon=
fig | 1          =

qemu_arm-versatilepb | arm  | lab-cip         | gcc-8    | versatile_defcon=
fig | 1          =

qemu_arm-versatilepb | arm  | lab-collabora   | gcc-8    | versatile_defcon=
fig | 1          =

qemu_arm-versatilepb | arm  | lab-linaro-lkft | gcc-8    | versatile_defcon=
fig | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.19/ker=
nel/v4.19.190-127-g357aab07cc5ee/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.19
  Describe: v4.19.190-127-g357aab07cc5ee
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      357aab07cc5ee4ea195f8f5ddcc0e008fea60343 =



Test Regressions
---------------- =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-broonie     | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/609aa0ff77bcdb4e87d08f29

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.190=
-127-g357aab07cc5ee/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu=
_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.190=
-127-g357aab07cc5ee/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu=
_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/609aa0ff77bcdb4e87d08=
f2a
        failing since 178 days (last pass: v4.19.157-26-gd59f3161b3a0, firs=
t fail: v4.19.157-27-g5543cc2c41d55) =

 =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-cip         | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/609aa183d1d95bd53cd08f33

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.190=
-127-g357aab07cc5ee/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm=
-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.190=
-127-g357aab07cc5ee/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm=
-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/609aa183d1d95bd53cd08=
f34
        failing since 178 days (last pass: v4.19.157-26-gd59f3161b3a0, firs=
t fail: v4.19.157-27-g5543cc2c41d55) =

 =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-collabora   | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/609aa080492c9ac913d08f22

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.190=
-127-g357aab07cc5ee/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qe=
mu_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.190=
-127-g357aab07cc5ee/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qe=
mu_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/609aa080492c9ac913d08=
f23
        failing since 178 days (last pass: v4.19.157-26-gd59f3161b3a0, firs=
t fail: v4.19.157-27-g5543cc2c41d55) =

 =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-linaro-lkft | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/609ab6e5d24fde6fb3d08f3f

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.190=
-127-g357aab07cc5ee/arm/versatile_defconfig/gcc-8/lab-linaro-lkft/baseline-=
qemu_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.190=
-127-g357aab07cc5ee/arm/versatile_defconfig/gcc-8/lab-linaro-lkft/baseline-=
qemu_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/609ab6e6d24fde6fb3d08=
f40
        failing since 178 days (last pass: v4.19.157-26-gd59f3161b3a0, firs=
t fail: v4.19.157-27-g5543cc2c41d55) =

 =20
