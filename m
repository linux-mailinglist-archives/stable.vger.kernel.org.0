Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 117382B2950
	for <lists+stable@lfdr.de>; Sat, 14 Nov 2020 00:47:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726081AbgKMXrY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 13 Nov 2020 18:47:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34210 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726042AbgKMXrX (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 13 Nov 2020 18:47:23 -0500
Received: from mail-pg1-x52d.google.com (mail-pg1-x52d.google.com [IPv6:2607:f8b0:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ACFDDC0613D1
        for <stable@vger.kernel.org>; Fri, 13 Nov 2020 15:47:23 -0800 (PST)
Received: by mail-pg1-x52d.google.com with SMTP id r186so8398946pgr.0
        for <stable@vger.kernel.org>; Fri, 13 Nov 2020 15:47:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=PQ9cBn5ZcDKRGbWkgBBJ6PdCIuBmgIDN+plmGVhYLps=;
        b=Wf4iVNJ4oRth05fc9qnUVPg9+0TTahZRWEjcM2uWWVHnNz6L3yyiT+v5tQQ0gGLror
         /GtfsDCNaTwsQ63qjngS7E+f0Cj7VCbnuglKZnAG3kMG6sR0ueofWPu/RrERy8pxttjo
         tReJ+RuUya/PmsKX2V3T/vzaGwhlHOnSXSqetET5C6mjnJ2tXpSbb/9zrc/YrF2Wq4R7
         bXBu4UV7FY0SigIKutucSu8C0Y690sEIpsvJUNFpeMJlog5YPXbqWONRTToRnzgP0gsT
         PxNXqY70sMz5KTpo3wH5fuMchMkPWTRT6Kp38Lt91DogWekHyV0xw6/KsU1t1DIoYfFp
         Mp1A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=PQ9cBn5ZcDKRGbWkgBBJ6PdCIuBmgIDN+plmGVhYLps=;
        b=p4i+LxqU/MpudN4PRSAzH8kHaYd8In+haQwIq18KHWLoYZRtbX5KduXXFPXWxawX7r
         b9kjwYufNUKp/Gv9yexnZ0/EZ2nVusVzGAX/+aA0fi3ZPCJO6tTyLmnCXt9g4YHfBVI1
         sC24gvZdNTodCvJgEeR219pn+wBoBEUV+7ZEZnfd9roCXh8UwFHcOQlzVEA9vNxKwRMs
         r0lV0jbjKvDIFoQaf1QrHzRWE+ggx3W/ghGyddtKiE6MbZ2wezo5yfTkWTAUv4YsvTcM
         X6xA+JmUxTxrNvc/BVOyLFloPO9uPenK/GlVZOikRgYkBAvbD8LWtYQ4IRFPRkj+SHB7
         gjLw==
X-Gm-Message-State: AOAM533lxIKEyTjPzhFMss6JY21lGALy79iocv4jmlhErNdEZ2zn4bZx
        iCup6uD+em/wOnRNCllV0KFLvKW19RTgEQ==
X-Google-Smtp-Source: ABdhPJxBIBpcFoATc4Z90PsaXWSTFKMa3450n5uTqqF+eXvFE6UCPaCHM1GCSwl/w6orAtrgFMcXYg==
X-Received: by 2002:a17:90a:7e0f:: with SMTP id i15mr3460170pjl.93.1605311242973;
        Fri, 13 Nov 2020 15:47:22 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id y129sm9555298pgy.84.2020.11.13.15.47.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 13 Nov 2020 15:47:21 -0800 (PST)
Message-ID: <5faf1b09.1c69fb81.bff3a.3c69@mx.google.com>
Date:   Fri, 13 Nov 2020 15:47:21 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: queue/4.14
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v4.14.206-22-ga949bf40fb01
X-Kernelci-Report-Type: test
Subject: stable-rc/queue/4.14 baseline: 132 runs,
 6 regressions (v4.14.206-22-ga949bf40fb01)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.14 baseline: 132 runs, 6 regressions (v4.14.206-22-ga949b=
f40fb01)

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
nel/v4.14.206-22-ga949bf40fb01/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.14
  Describe: v4.14.206-22-ga949bf40fb01
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      a949bf40fb018104b85518657b5532d092050fcb =



Test Regressions
---------------- =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
panda                | arm  | lab-collabora   | gcc-8    | omap2plus_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/5faee37f475d02b31579b8bb

  Results:     3 PASS, 1 FAIL, 1 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.206=
-22-ga949bf40fb01/arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-pand=
a.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.206=
-22-ga949bf40fb01/arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-pand=
a.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/5faee380475d02b=
31579b8c2
        new failure (last pass: v4.14.206-21-g787a7a3ca16c)
        2 lines =

 =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-baylibre    | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/5faee4e02e02da26ff79b8b4

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.206=
-22-ga949bf40fb01/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_=
arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.206=
-22-ga949bf40fb01/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_=
arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5faee4e02e02da26ff79b=
8b5
        new failure (last pass: v4.14.206-21-g787a7a3ca16c) =

 =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-broonie     | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/5faee4e82e02da26ff79b8c0

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.206=
-22-ga949bf40fb01/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_a=
rm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.206=
-22-ga949bf40fb01/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_a=
rm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5faee4e82e02da26ff79b=
8c1
        new failure (last pass: v4.14.206-21-g787a7a3ca16c) =

 =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-cip         | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/5faee4d82e02da26ff79b8b1

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.206=
-22-ga949bf40fb01/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-v=
ersatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.206=
-22-ga949bf40fb01/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-v=
ersatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5faee4d82e02da26ff79b=
8b2
        new failure (last pass: v4.14.206-21-g787a7a3ca16c) =

 =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-collabora   | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/5faee49a6c640e4ae879b8bc

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.206=
-22-ga949bf40fb01/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu=
_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.206=
-22-ga949bf40fb01/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu=
_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5faee49a6c640e4ae879b=
8bd
        new failure (last pass: v4.14.206-21-g787a7a3ca16c) =

 =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-linaro-lkft | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/5faee49f11b0da77a779b8b0

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.206=
-22-ga949bf40fb01/arm/versatile_defconfig/gcc-8/lab-linaro-lkft/baseline-qe=
mu_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.206=
-22-ga949bf40fb01/arm/versatile_defconfig/gcc-8/lab-linaro-lkft/baseline-qe=
mu_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5faee49f11b0da77a779b=
8b1
        new failure (last pass: v4.14.206-21-g787a7a3ca16c) =

 =20
