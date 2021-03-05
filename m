Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D2D1332EB1A
	for <lists+stable@lfdr.de>; Fri,  5 Mar 2021 13:43:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233235AbhCEMmC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 5 Mar 2021 07:42:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39440 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233483AbhCEMln (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 5 Mar 2021 07:41:43 -0500
Received: from mail-pl1-x62a.google.com (mail-pl1-x62a.google.com [IPv6:2607:f8b0:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6560AC061574
        for <stable@vger.kernel.org>; Fri,  5 Mar 2021 04:41:43 -0800 (PST)
Received: by mail-pl1-x62a.google.com with SMTP id s7so1362520plg.5
        for <stable@vger.kernel.org>; Fri, 05 Mar 2021 04:41:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=shhf6ivjp63jhSBT5SPxy/Qj0toVKkd9fmX5Uq/KLB8=;
        b=Od6uvsB8RwZjZTE5a/c2N0HTHzm+I13U7tu+nyQKwKBF0VeWYKs5GamhnHRndBW4WD
         wXsKey3kl8HKn2Z2eOiAYdmW3SLchzzMi9KmnQvZq7FZD7dyalodk01zqHrFx52ASGE2
         cl36ceWb5nVvjvq+xaJ14f3+3ChRWI2t4w+t7VOWpDmxTEMYXiM2YjMFX9i+ek+BxNck
         TlPXB3GJvtVFH533LEfhtAyzvn+GWSt1GC9SDuLaSWR14noe9RbZQwFqA45qfIXnLQQq
         kScenTVEEX/8ffYriH4lrw16n20t6/hCJxdAHhSonDb6Jjs4vI4SnraJVCiwXv7fZ5SH
         yyvA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=shhf6ivjp63jhSBT5SPxy/Qj0toVKkd9fmX5Uq/KLB8=;
        b=F+a3miHqPeAOw2zC7hfL+I5WyJy3hqR2yW2wXPU0GfwunhbkGX+yec43/vnXEMnPwe
         AQ1quqRl/iVXjrh5+StDLzIRTm8H8EmLNiAqlsmniWyBX8DaYkQZRDMUpULoC8Q43jrh
         IUBtdpnOK3qLXFNRPWpzwXPYZKKDUbdzx2CddM4VEhOi8n6YX1a6ALyK69K+jBcBKwAW
         Z9c7bOKPQ+SFTAdvrvCFFPOzlwYhF9i+Sc2MeVrjIu7phsRqfzNdpZu2CDNYTVB0Cnkh
         oRuAxyXg2Ye2hBcdPWNc2SdxZUZ+K0f3FInRk2gIB8d/HtqmP1NdnwuXD2iEFM/7fdVO
         9qGA==
X-Gm-Message-State: AOAM530nY9Mc4JdDhf6P2xmo7q1c5f/v/wwNbgh1gtt+wZn3gmpMU67V
        0jOwvs3zme2O6nYdJ99RspTHJ7CLoOv5AXtW
X-Google-Smtp-Source: ABdhPJxWc8BZjkjuQ0Qk7G0z47d/ACDEFoob7iYhUQqn+vz24KSJjpkuQY+YEwt7oMeYKFrG5C5N2Q==
X-Received: by 2002:a17:90a:c289:: with SMTP id f9mr10333551pjt.105.1614948102815;
        Fri, 05 Mar 2021 04:41:42 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id k3sm2361412pgq.21.2021.03.05.04.41.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 05 Mar 2021 04:41:42 -0800 (PST)
Message-ID: <60422706.1c69fb81.ace82.63dc@mx.google.com>
Date:   Fri, 05 Mar 2021 04:41:42 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.19.178-49-g917d9b2e2d35d
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/4.19
Subject: stable-rc/queue/4.19 baseline: 107 runs,
 4 regressions (v4.19.178-49-g917d9b2e2d35d)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.19 baseline: 107 runs, 4 regressions (v4.19.178-49-g917d9=
b2e2d35d)

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
nel/v4.19.178-49-g917d9b2e2d35d/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.19
  Describe: v4.19.178-49-g917d9b2e2d35d
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      917d9b2e2d35d3cfb57d6464c48fcd9bc874748f =



Test Regressions
---------------- =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-broonie     | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/60421594e65cb3de68addcb4

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.178=
-49-g917d9b2e2d35d/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_=
arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.178=
-49-g917d9b2e2d35d/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_=
arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60421594e65cb3de68add=
cb5
        failing since 111 days (last pass: v4.19.157-26-gd59f3161b3a0, firs=
t fail: v4.19.157-27-g5543cc2c41d55) =

 =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-cip         | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/604206609aa485aa7aaddcc3

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.178=
-49-g917d9b2e2d35d/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-=
versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.178=
-49-g917d9b2e2d35d/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-=
versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/604206609aa485aa7aadd=
cc4
        failing since 111 days (last pass: v4.19.157-26-gd59f3161b3a0, firs=
t fail: v4.19.157-27-g5543cc2c41d55) =

 =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-collabora   | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/6041f37b39e6c9f2faaddcc9

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.178=
-49-g917d9b2e2d35d/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qem=
u_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.178=
-49-g917d9b2e2d35d/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qem=
u_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6041f37b39e6c9f2faadd=
cca
        failing since 111 days (last pass: v4.19.157-26-gd59f3161b3a0, firs=
t fail: v4.19.157-27-g5543cc2c41d55) =

 =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-linaro-lkft | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/6041f36a708d304bb9addcd3

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.178=
-49-g917d9b2e2d35d/arm/versatile_defconfig/gcc-8/lab-linaro-lkft/baseline-q=
emu_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.178=
-49-g917d9b2e2d35d/arm/versatile_defconfig/gcc-8/lab-linaro-lkft/baseline-q=
emu_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6041f36a708d304bb9add=
cd4
        failing since 111 days (last pass: v4.19.157-26-gd59f3161b3a0, firs=
t fail: v4.19.157-27-g5543cc2c41d55) =

 =20
