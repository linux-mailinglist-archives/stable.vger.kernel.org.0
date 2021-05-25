Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5FA8D390173
	for <lists+stable@lfdr.de>; Tue, 25 May 2021 14:59:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232957AbhEYNBB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 25 May 2021 09:01:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54968 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232956AbhEYNBA (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 25 May 2021 09:01:00 -0400
Received: from mail-pg1-x52b.google.com (mail-pg1-x52b.google.com [IPv6:2607:f8b0:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2B91EC061574
        for <stable@vger.kernel.org>; Tue, 25 May 2021 05:59:30 -0700 (PDT)
Received: by mail-pg1-x52b.google.com with SMTP id e22so6933145pgv.10
        for <stable@vger.kernel.org>; Tue, 25 May 2021 05:59:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=jkZhk4unmdh1F0SrA0n4a5zMqaLVhURzB9fw2kiNsMU=;
        b=IWHTA+qL8YvpqPltH+AGhhX3YzesAdKLx9U+Hy47o029B94HeIFv585ui5M1YbyYC0
         EOXhCI6+NZii9nL5/oeqeL9zStJeWpGt5hETasVW1PD4JMvKriFb3AP2wratkJwkevff
         HsbrXcibYFmXEnsIIGneq//kvm2HZUJoFX8ZWwQaJsU+stKDpGTHLZfc7TYtlCkOappC
         9eOfPnjmzK7NPy7LQDyddhtBFaV0/uAcivSYwwL4FRDarB6KykFg8NSsaFAgz98gDo/f
         OLUhPUozmVqLaHZTjEI6y0ObTK8M4rAFlGEpnW23dMlp3ZT5QKI1+R+2KIPSH0ecn6Jo
         gWZA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=jkZhk4unmdh1F0SrA0n4a5zMqaLVhURzB9fw2kiNsMU=;
        b=mYXcjvxnE6gpTWt58rnk6+CzoV7AoMT3Wy4+X/xRnLMOekflyVMCpZQE5yRKoeWlnq
         X8xgSncbiCpeEkOLnZ+w+cTbi0/qTjfCl9axt8kMQn0lxKvduOXoyqgi+yAHvGu3Azmp
         QfI1rGhFnqfCamR6kN7zRts51U67YsI1RuX+OZf1+512zJCgCnKRfNrMoNjODJfSKMKp
         wXyejEQV/1DeBYK15E4H2TGbWk1VTMoqlNpUXUrnt7x9GWo2f1WLSHH5+RRZSuBPkAp0
         0M4Tcbs1+vcMTWYNqYzv3iUT6cQG4VZ9FUNzMKbi4qtyOZIW6/oVw9FGRRZ+1w8xFwKv
         6mng==
X-Gm-Message-State: AOAM531lo5x3QRgazu7DSputB7MmrwK7V7Ifn6oUInj+eMkJIGGzRZB7
        miKlf6Ww+gd7MGt8H1cnUQk1r9tTNECwRxU/
X-Google-Smtp-Source: ABdhPJxDdkybwZqRGwaKX7nhXXBrp4PFmQLRNmUp/ZnbsSYekOcCYvQCeRWeWzN4bwV3GP50LgotFg==
X-Received: by 2002:a65:644d:: with SMTP id s13mr18753086pgv.362.1621947569489;
        Tue, 25 May 2021 05:59:29 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id s48sm13187171pfw.205.2021.05.25.05.59.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 25 May 2021 05:59:29 -0700 (PDT)
Message-ID: <60acf4b1.1c69fb81.85c1b.be25@mx.google.com>
Date:   Tue, 25 May 2021 05:59:29 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v4.19.191-48-g46e352d7f437
X-Kernelci-Branch: queue/4.19
X-Kernelci-Report-Type: test
Subject: stable-rc/queue/4.19 baseline: 113 runs,
 4 regressions (v4.19.191-48-g46e352d7f437)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.19 baseline: 113 runs, 4 regressions (v4.19.191-48-g46e35=
2d7f437)

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
nel/v4.19.191-48-g46e352d7f437/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.19
  Describe: v4.19.191-48-g46e352d7f437
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      46e352d7f437bdb001fa9ecaef484726cf738f02 =



Test Regressions
---------------- =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-broonie     | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/60acca3967e958cee3b3afa4

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.191=
-48-g46e352d7f437/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_a=
rm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.191=
-48-g46e352d7f437/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_a=
rm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60acca3967e958cee3b3a=
fa5
        failing since 192 days (last pass: v4.19.157-26-gd59f3161b3a0, firs=
t fail: v4.19.157-27-g5543cc2c41d55) =

 =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-cip         | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/60acc2610ca54ddcd0b3afa7

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.191=
-48-g46e352d7f437/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-v=
ersatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.191=
-48-g46e352d7f437/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-v=
ersatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60acc2610ca54ddcd0b3a=
fa8
        failing since 192 days (last pass: v4.19.157-26-gd59f3161b3a0, firs=
t fail: v4.19.157-27-g5543cc2c41d55) =

 =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-collabora   | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/60acd26cdd50a5899fb3af98

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.191=
-48-g46e352d7f437/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu=
_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.191=
-48-g46e352d7f437/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu=
_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60acd26cdd50a5899fb3a=
f99
        failing since 192 days (last pass: v4.19.157-26-gd59f3161b3a0, firs=
t fail: v4.19.157-27-g5543cc2c41d55) =

 =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-linaro-lkft | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/60acd46f835df94224b3afce

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.191=
-48-g46e352d7f437/arm/versatile_defconfig/gcc-8/lab-linaro-lkft/baseline-qe=
mu_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.191=
-48-g46e352d7f437/arm/versatile_defconfig/gcc-8/lab-linaro-lkft/baseline-qe=
mu_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60acd46f835df94224b3a=
fcf
        failing since 192 days (last pass: v4.19.157-26-gd59f3161b3a0, firs=
t fail: v4.19.157-27-g5543cc2c41d55) =

 =20
