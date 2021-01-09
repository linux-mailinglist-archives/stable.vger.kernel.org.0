Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3D8B22F0332
	for <lists+stable@lfdr.de>; Sat,  9 Jan 2021 20:33:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726059AbhAITd4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 9 Jan 2021 14:33:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53764 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725999AbhAITd4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 9 Jan 2021 14:33:56 -0500
Received: from mail-pg1-x52a.google.com (mail-pg1-x52a.google.com [IPv6:2607:f8b0:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4DF5EC061786
        for <stable@vger.kernel.org>; Sat,  9 Jan 2021 11:33:10 -0800 (PST)
Received: by mail-pg1-x52a.google.com with SMTP id n10so9851222pgl.10
        for <stable@vger.kernel.org>; Sat, 09 Jan 2021 11:33:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=FbccBNc1OXjtqolstPs0GWVbkrxzrhIWYG6uxYVCgE4=;
        b=SssqYwB1ihYYZlpaEWTmoguerCrBmrxNID2m+RpkXcfyT2o58osfEcMqbQyLvJKpx0
         b+/nPZ07bFqkU1OFPcfifPCgBQecThvxRsBpYYLd4PUKWeMquT33xr3FDlt1IGJwlksk
         36oreD++S/PU15G7fnDpwLO1zTOvmZcY40lM7qdHTmcGNsqBfhs0OxekhKw8rqb80Ahh
         gxQPEXcAD2Xhh32yBG1Z/vtZibbyLQ7jlau+PmQoO94laMz4kBi51mM1qmBew3lUBcuO
         nhAO2zphPhn5pHx+iXlC3fx8DBKTCicrXnpkMBaOJFEwUyPtKjENZy8CJvnwIDtxtA84
         hnHw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=FbccBNc1OXjtqolstPs0GWVbkrxzrhIWYG6uxYVCgE4=;
        b=NajstIrvenXxMNAdYiYAYx+Wbn0zDZ4m/9q0BeO7FLWtGXCDS0X+txW/AaabD5CgN6
         Djgh6I49pH1rcMEbsxe4s0A1mxOeP1cNWZgHWAwvUJoJqRRPst0S80pgRgsSobGoIZtF
         ICGBLidcJ+CRsCg2GxOFkeQm+UvmeDTjcg9MgjFhnbLemmzkgjOB2fEJr1mTU3348jvi
         1vNdn13KoGYuCPxBCPMvBOxxjzYZ48+mkXcfqjrTf/gL1ScMKkDjOjcEl1zJPOikeMSk
         2xn1kmhsu90qak/BR7OgVxkS56strngUnsFTV9aKb6fqxrtT6Pmg9i+G0RGu42WB5vZD
         xE6A==
X-Gm-Message-State: AOAM532CVNf+OpLpFwmVKMR6O/Q8JFsqdNDGX0NDZIvA5f3ufomrcsYR
        GyYFDLbUir1HRv7wAkECJJORPoOwG/q5NQ==
X-Google-Smtp-Source: ABdhPJwaU7KjIvJxchki/cVsKACmxTkfXXSSJGFQrZIU514Wfu0b9b13Jc3PjqPAUsZgakZNUKQXmQ==
X-Received: by 2002:aa7:9707:0:b029:19d:c5a8:155e with SMTP id a7-20020aa797070000b029019dc5a8155emr9693468pfg.62.1610220789253;
        Sat, 09 Jan 2021 11:33:09 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id c14sm13807697pfp.167.2021.01.09.11.33.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 09 Jan 2021 11:33:08 -0800 (PST)
Message-ID: <5ffa04f4.1c69fb81.1c374.e3d1@mx.google.com>
Date:   Sat, 09 Jan 2021 11:33:08 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: queue/4.14
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v4.14.214-5-gd70de3dbd6983
X-Kernelci-Report-Type: test
Subject: stable-rc/queue/4.14 baseline: 141 runs,
 6 regressions (v4.14.214-5-gd70de3dbd6983)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.14 baseline: 141 runs, 6 regressions (v4.14.214-5-gd70de3=
dbd6983)

Regressions Summary
-------------------

platform             | arch  | lab           | compiler | defconfig        =
   | regressions
---------------------+-------+---------------+----------+------------------=
---+------------
meson-gxm-q200       | arm64 | lab-baylibre  | gcc-8    | defconfig        =
   | 1          =

panda                | arm   | lab-collabora | gcc-8    | omap2plus_defconf=
ig | 1          =

qemu_arm-versatilepb | arm   | lab-baylibre  | gcc-8    | versatile_defconf=
ig | 1          =

qemu_arm-versatilepb | arm   | lab-broonie   | gcc-8    | versatile_defconf=
ig | 1          =

qemu_arm-versatilepb | arm   | lab-cip       | gcc-8    | versatile_defconf=
ig | 1          =

qemu_arm-versatilepb | arm   | lab-collabora | gcc-8    | versatile_defconf=
ig | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.14/ker=
nel/v4.14.214-5-gd70de3dbd6983/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.14
  Describe: v4.14.214-5-gd70de3dbd6983
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      d70de3dbd6983cf635ab2cd2dc99bfde77fdc787 =



Test Regressions
---------------- =



platform             | arch  | lab           | compiler | defconfig        =
   | regressions
---------------------+-------+---------------+----------+------------------=
---+------------
meson-gxm-q200       | arm64 | lab-baylibre  | gcc-8    | defconfig        =
   | 1          =


  Details:     https://kernelci.org/test/plan/id/5ff9e211f72b60aed3c94cd0

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.214=
-5-gd70de3dbd6983/arm64/defconfig/gcc-8/lab-baylibre/baseline-meson-gxm-q20=
0.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.214=
-5-gd70de3dbd6983/arm64/defconfig/gcc-8/lab-baylibre/baseline-meson-gxm-q20=
0.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5ff9e211f72b60aed3c94=
cd1
        failing since 32 days (last pass: v4.14.210-20-gc32b9f7cbda7, first=
 fail: v4.14.210-20-g5ea7913395d3) =

 =



platform             | arch  | lab           | compiler | defconfig        =
   | regressions
---------------------+-------+---------------+----------+------------------=
---+------------
panda                | arm   | lab-collabora | gcc-8    | omap2plus_defconf=
ig | 1          =


  Details:     https://kernelci.org/test/plan/id/5ff9d1ffebbe9a8d2dc94cc2

  Results:     3 PASS, 1 FAIL, 1 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.214=
-5-gd70de3dbd6983/arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-pand=
a.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.214=
-5-gd70de3dbd6983/arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-pand=
a.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/5ff9d1ffebbe9a8=
d2dc94cc7
        failing since 2 days (last pass: v4.14.213-25-g4d76bd8af5ced, first=
 fail: v4.14.213-28-g9affacc59660e)
        2 lines

    2021-01-09 15:55:38.933000+00:00  kern  :emerg : BUG: spinlock bad magi=
c on CPU#0, udevd/95
    2021-01-09 15:55:38.942000+00:00  kern  :emerg :  lock: emif_lock+0x0/0=
xffffed34 [emif], .magic: 00000000, .owner: <none>/-1, .owner_cpu: 0   =

 =



platform             | arch  | lab           | compiler | defconfig        =
   | regressions
---------------------+-------+---------------+----------+------------------=
---+------------
qemu_arm-versatilepb | arm   | lab-baylibre  | gcc-8    | versatile_defconf=
ig | 1          =


  Details:     https://kernelci.org/test/plan/id/5ff9cf13bae68251d8c94cb9

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.214=
-5-gd70de3dbd6983/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_=
arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.214=
-5-gd70de3dbd6983/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_=
arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5ff9cf13bae68251d8c94=
cba
        failing since 56 days (last pass: v4.14.206-21-g787a7a3ca16c, first=
 fail: v4.14.206-22-ga949bf40fb01) =

 =



platform             | arch  | lab           | compiler | defconfig        =
   | regressions
---------------------+-------+---------------+----------+------------------=
---+------------
qemu_arm-versatilepb | arm   | lab-broonie   | gcc-8    | versatile_defconf=
ig | 1          =


  Details:     https://kernelci.org/test/plan/id/5ff9cf16bae68251d8c94cbe

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.214=
-5-gd70de3dbd6983/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_a=
rm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.214=
-5-gd70de3dbd6983/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_a=
rm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5ff9cf16bae68251d8c94=
cbf
        failing since 56 days (last pass: v4.14.206-21-g787a7a3ca16c, first=
 fail: v4.14.206-22-ga949bf40fb01) =

 =



platform             | arch  | lab           | compiler | defconfig        =
   | regressions
---------------------+-------+---------------+----------+------------------=
---+------------
qemu_arm-versatilepb | arm   | lab-cip       | gcc-8    | versatile_defconf=
ig | 1          =


  Details:     https://kernelci.org/test/plan/id/5ff9cf0f4ddc1fe217c94ce3

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.214=
-5-gd70de3dbd6983/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-v=
ersatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.214=
-5-gd70de3dbd6983/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-v=
ersatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5ff9cf0f4ddc1fe217c94=
ce4
        failing since 56 days (last pass: v4.14.206-21-g787a7a3ca16c, first=
 fail: v4.14.206-22-ga949bf40fb01) =

 =



platform             | arch  | lab           | compiler | defconfig        =
   | regressions
---------------------+-------+---------------+----------+------------------=
---+------------
qemu_arm-versatilepb | arm   | lab-collabora | gcc-8    | versatile_defconf=
ig | 1          =


  Details:     https://kernelci.org/test/plan/id/5ff9cecaec3b58da2ac94cb9

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.214=
-5-gd70de3dbd6983/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu=
_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.214=
-5-gd70de3dbd6983/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu=
_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5ff9cecaec3b58da2ac94=
cba
        failing since 56 days (last pass: v4.14.206-21-g787a7a3ca16c, first=
 fail: v4.14.206-22-ga949bf40fb01) =

 =20
