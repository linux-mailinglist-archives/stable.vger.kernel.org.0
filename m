Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 27DA3373200
	for <lists+stable@lfdr.de>; Tue,  4 May 2021 23:45:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231293AbhEDVqK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 4 May 2021 17:46:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42986 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230490AbhEDVqK (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 4 May 2021 17:46:10 -0400
Received: from mail-pf1-x42c.google.com (mail-pf1-x42c.google.com [IPv6:2607:f8b0:4864:20::42c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 41879C061574
        for <stable@vger.kernel.org>; Tue,  4 May 2021 14:45:15 -0700 (PDT)
Received: by mail-pf1-x42c.google.com with SMTP id i13so509742pfu.2
        for <stable@vger.kernel.org>; Tue, 04 May 2021 14:45:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=jbUZVDUug7ZKIQynGstvHf217Qr6YMyySHNWvoB7PoU=;
        b=ppPBgS9pSUkcetLGrdAXvnTPEKdau8XqaqWZIITGOMXVYp/5pGrigmUCLqxuVzwvlY
         0vtN3INkXr0Pbou8oYMGFGZKN7gWzXKIq8ISCQK9aK5P56V/5mmjlPyNcuPuG1dVM4Uw
         /OXU+Fpl8yEzReW/nqrlKaJVEunnqkK2//3XSdwCG/fE/zIWFCNDrxafd/NHwwNEgvkB
         RJur1636RuSbm1CAJDgK8eimhxtZqrOckHMKnlkbrzDydilXvcYKS5mhmKRZN4pNLMVo
         stM/uu62Rh9AbSKwGvIOk6KFwOetwlcUoRH5YvJveGwfyunuHWbZ5y+T+7WPQapPwM5f
         5hTg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=jbUZVDUug7ZKIQynGstvHf217Qr6YMyySHNWvoB7PoU=;
        b=dOkXyouMaNk//e+2poVs76SOSVex2v2IIb/FI2cnuU9fJNC5/Tko20q2fFvOjXjkvx
         lqTArAQkadtCRgOX71SFlUad5l1oYSnv4O1ljzUuR2HRHlKx9x0xWCcXxhBVgzur2WVr
         RghUNPK2ooGGCDHK1VVfbHvUGC3mqBPd5rMBAV5E+D7N7NFppWZuWHuF8feUjQCJJ281
         ZY21lwBLElFkJlu6vm1X5GwWBJilrVUJCpi1f+v3DXCBf28ueJNbAFcmvuEOi36jC6l/
         zp42XeqZyncbu2+/8ckDkeG9852M2zTfKddncxqn0VKXGNZWazdRZ2gt+BSnTO4arBDF
         ri7w==
X-Gm-Message-State: AOAM533mBqTha459Ultzq5vZ6GULY0PP1KLii7Kf5qct5jSGD/miPtaP
        sz34ipx5G36c9uaiCO6ZK625SK8dJ1QQBZ7y
X-Google-Smtp-Source: ABdhPJzJ+0DNDvqPhv3kmvj35tbQTNtu7g92COBsAy4e7K31e81yTE2WNtTn6heNqwqHTXgLTSJj0w==
X-Received: by 2002:a17:90a:8c03:: with SMTP id a3mr29689482pjo.187.1620164709030;
        Tue, 04 May 2021 14:45:09 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id c23sm4339325pgj.50.2021.05.04.14.45.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 04 May 2021 14:45:08 -0700 (PDT)
Message-ID: <6091c064.1c69fb81.917c2.8c93@mx.google.com>
Date:   Tue, 04 May 2021 14:45:08 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.9.268-2-gc42f89a7ad6f2
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/4.9
Subject: stable-rc/queue/4.9 baseline: 57 runs,
 5 regressions (v4.9.268-2-gc42f89a7ad6f2)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.9 baseline: 57 runs, 5 regressions (v4.9.268-2-gc42f89a7a=
d6f2)

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

qemu_arm-versatilepb | arm  | lab-linaro-lkft | gcc-8    | versatile_defcon=
fig | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.9/kern=
el/v4.9.268-2-gc42f89a7ad6f2/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.9
  Describe: v4.9.268-2-gc42f89a7ad6f2
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      c42f89a7ad6f2bd1f5e16f6b2a6c65ed3cf2d298 =



Test Regressions
---------------- =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
panda                | arm  | lab-collabora   | gcc-8    | omap2plus_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/6091b5803d58105d12843f20

  Results:     3 PASS, 1 FAIL, 1 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.268-2=
-gc42f89a7ad6f2/arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-panda.=
txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.268-2=
-gc42f89a7ad6f2/arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-panda.=
html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/6091b5803d58105=
d12843f25
        failing since 0 day (last pass: v4.9.268-1-gf945683b79529, first fa=
il: v4.9.268-1-gf967fc4704b0c)
        2 lines

    2021-05-04 20:58:36.162000+00:00  kern  :emerg : BUG: spinlock bad magi=
c on CPU#0, udevd/124
    2021-05-04 20:58:36.171000+00:00  kern  :emerg :  lock: emif_lock+0x0/0=
xfffff24c [emif], .magic: 00000000, .owner: <none>/-1, .owner_cpu: 0   =

 =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-baylibre    | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/6091875b2de3155bcf843f23

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.268-2=
-gc42f89a7ad6f2/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_ar=
m-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.268-2=
-gc42f89a7ad6f2/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_ar=
m-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6091875b2de3155bcf843=
f24
        failing since 171 days (last pass: v4.9.243-16-gd8d67e375b0a, first=
 fail: v4.9.243-25-ga01fe8e99a22) =

 =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-broonie     | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/60918765707828cbf7843f21

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.268-2=
-gc42f89a7ad6f2/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_arm=
-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.268-2=
-gc42f89a7ad6f2/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_arm=
-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60918765707828cbf7843=
f22
        failing since 171 days (last pass: v4.9.243-16-gd8d67e375b0a, first=
 fail: v4.9.243-25-ga01fe8e99a22) =

 =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-cip         | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/6091875fd6ad24262c843f18

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.268-2=
-gc42f89a7ad6f2/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-ver=
satilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.268-2=
-gc42f89a7ad6f2/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-ver=
satilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6091875fd6ad24262c843=
f19
        failing since 171 days (last pass: v4.9.243-16-gd8d67e375b0a, first=
 fail: v4.9.243-25-ga01fe8e99a22) =

 =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-linaro-lkft | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/609187066bbb8ed78e843f19

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.268-2=
-gc42f89a7ad6f2/arm/versatile_defconfig/gcc-8/lab-linaro-lkft/baseline-qemu=
_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.268-2=
-gc42f89a7ad6f2/arm/versatile_defconfig/gcc-8/lab-linaro-lkft/baseline-qemu=
_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/609187066bbb8ed78e843=
f1a
        failing since 171 days (last pass: v4.9.243-16-gd8d67e375b0a, first=
 fail: v4.9.243-25-ga01fe8e99a22) =

 =20
