Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CF21E376D27
	for <lists+stable@lfdr.de>; Sat,  8 May 2021 01:04:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229880AbhEGXF3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 7 May 2021 19:05:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57398 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229812AbhEGXF2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 7 May 2021 19:05:28 -0400
Received: from mail-pl1-x635.google.com (mail-pl1-x635.google.com [IPv6:2607:f8b0:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1566CC061574
        for <stable@vger.kernel.org>; Fri,  7 May 2021 16:04:28 -0700 (PDT)
Received: by mail-pl1-x635.google.com with SMTP id p17so5997846plf.12
        for <stable@vger.kernel.org>; Fri, 07 May 2021 16:04:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=6ZSyJWNvpKfvcsiEzUlJVGsbKogIiD0UkpC0XoaWGJw=;
        b=hjcKPxQd7Xp5+qYqJ86VW/Lz/nKDnujm9nbFw7bk2IBWIrjV0bX8OZ6mMgTXyybZ8c
         puw9acGZjSYX/j5NMlVFObmi2/wi7VmsvSnNjPKzB1Nlw4eaXlRrH+2YTzcdjMCtUhJV
         07hTPIZAHNAmpXq6iVOmgJmCmfQ9X5em1k26aU5WlMxGOe9nuvqToO2IaIuPh3NZY7Gr
         GNOfzN/J9zof2LpwdqVAqReYIVFPbdgMObagst0DmXwsSTsmstLHuWMlA1KtRgbi8HkC
         oL2TOOnTcU7/28pfdREDv3oXgpR3ktG5yrcFSqcfkhaQBS513DpzgcW5CqbdV/6e3Enl
         IFZg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=6ZSyJWNvpKfvcsiEzUlJVGsbKogIiD0UkpC0XoaWGJw=;
        b=MkmZoI13OmcBGmdaA5SkgBqxzczmRLIibwEtA0ZVlfnF15hMpVH61u2qe59/Gi/ahf
         o8RMkX6OtRZu1+BNUDhf1qFw1Jm+k5yM6VFCgUGK4N3RFKsSt7XFZMoUN8MV3Si4Fr8I
         fjKse7mZhiLXZklgpCrZgKyVzLl19ENnMnMvl64Dc9aFt2zp6JwuaYPmahtcpbOpl0F7
         39EEMDxNeE9CYysTSZrbqI54T2Zik2Z/ntwnL4dHtZbiM52CY8VrqHa9MKt3vQmwSWce
         Es2T+0VAWhripb3QI5q9m2z0PB3O+04mAz0X09hRlQyCV3w1wahESjg5jBH8dawFNY6F
         rTGQ==
X-Gm-Message-State: AOAM5310XZfP9oUOLyghGU4hZen5dAqOnigk5Wb4Q/HDgL6uF/vjjMoB
        DzL0gJpkKguXtjyvOWhlnuWS+a5zPtvCovQk
X-Google-Smtp-Source: ABdhPJx1pm8cNnyVocQ0P6Xr8rBkNkoEO1yc/62pB7pBmM8VmgVAfAgu71AZ+HnyYWzw5VWS2kFERw==
X-Received: by 2002:a17:902:e353:b029:ed:866b:7624 with SMTP id p19-20020a170902e353b02900ed866b7624mr12804304plc.25.1620428667421;
        Fri, 07 May 2021 16:04:27 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id b1sm6039167pgf.84.2021.05.07.16.04.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 07 May 2021 16:04:27 -0700 (PDT)
Message-ID: <6095c77b.1c69fb81.9e72d.2a0d@mx.google.com>
Date:   Fri, 07 May 2021 16:04:27 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v4.14.232-29-g881adbe5d1e00
X-Kernelci-Branch: queue/4.14
Subject: stable-rc/queue/4.14 baseline: 99 runs,
 5 regressions (v4.14.232-29-g881adbe5d1e00)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.14 baseline: 99 runs, 5 regressions (v4.14.232-29-g881adb=
e5d1e00)

Regressions Summary
-------------------

platform             | arch  | lab           | compiler | defconfig        =
   | regressions
---------------------+-------+---------------+----------+------------------=
---+------------
meson-gxm-q200       | arm64 | lab-baylibre  | gcc-8    | defconfig        =
   | 1          =

qemu_arm-versatilepb | arm   | lab-baylibre  | gcc-8    | versatile_defconf=
ig | 1          =

qemu_arm-versatilepb | arm   | lab-broonie   | gcc-8    | versatile_defconf=
ig | 1          =

qemu_arm-versatilepb | arm   | lab-cip       | gcc-8    | versatile_defconf=
ig | 1          =

qemu_arm-versatilepb | arm   | lab-collabora | gcc-8    | versatile_defconf=
ig | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.14/ker=
nel/v4.14.232-29-g881adbe5d1e00/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.14
  Describe: v4.14.232-29-g881adbe5d1e00
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      881adbe5d1e000c1fa9fe899c95537ac72d94980 =



Test Regressions
---------------- =



platform             | arch  | lab           | compiler | defconfig        =
   | regressions
---------------------+-------+---------------+----------+------------------=
---+------------
meson-gxm-q200       | arm64 | lab-baylibre  | gcc-8    | defconfig        =
   | 1          =


  Details:     https://kernelci.org/test/plan/id/609597ef4b6a5be7486f5481

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.232=
-29-g881adbe5d1e00/arm64/defconfig/gcc-8/lab-baylibre/baseline-meson-gxm-q2=
00.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.232=
-29-g881adbe5d1e00/arm64/defconfig/gcc-8/lab-baylibre/baseline-meson-gxm-q2=
00.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/609597ef4b6a5be7486f5=
482
        failing since 67 days (last pass: v4.14.222-11-g13b8482a0f700, firs=
t fail: v4.14.222-120-gdc8887cba23e) =

 =



platform             | arch  | lab           | compiler | defconfig        =
   | regressions
---------------------+-------+---------------+----------+------------------=
---+------------
qemu_arm-versatilepb | arm   | lab-baylibre  | gcc-8    | versatile_defconf=
ig | 1          =


  Details:     https://kernelci.org/test/plan/id/6095946fec4e38c7de6f5480

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.232=
-29-g881adbe5d1e00/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu=
_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.232=
-29-g881adbe5d1e00/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu=
_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6095946fec4e38c7de6f5=
481
        failing since 174 days (last pass: v4.14.206-21-g787a7a3ca16c, firs=
t fail: v4.14.206-22-ga949bf40fb01) =

 =



platform             | arch  | lab           | compiler | defconfig        =
   | regressions
---------------------+-------+---------------+----------+------------------=
---+------------
qemu_arm-versatilepb | arm   | lab-broonie   | gcc-8    | versatile_defconf=
ig | 1          =


  Details:     https://kernelci.org/test/plan/id/6095945482997ecd736f5575

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.232=
-29-g881adbe5d1e00/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_=
arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.232=
-29-g881adbe5d1e00/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_=
arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6095945482997ecd736f5=
576
        failing since 174 days (last pass: v4.14.206-21-g787a7a3ca16c, firs=
t fail: v4.14.206-22-ga949bf40fb01) =

 =



platform             | arch  | lab           | compiler | defconfig        =
   | regressions
---------------------+-------+---------------+----------+------------------=
---+------------
qemu_arm-versatilepb | arm   | lab-cip       | gcc-8    | versatile_defconf=
ig | 1          =


  Details:     https://kernelci.org/test/plan/id/6095947c4f25a0cb7b6f5472

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.232=
-29-g881adbe5d1e00/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-=
versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.232=
-29-g881adbe5d1e00/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-=
versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6095947c4f25a0cb7b6f5=
473
        failing since 174 days (last pass: v4.14.206-21-g787a7a3ca16c, firs=
t fail: v4.14.206-22-ga949bf40fb01) =

 =



platform             | arch  | lab           | compiler | defconfig        =
   | regressions
---------------------+-------+---------------+----------+------------------=
---+------------
qemu_arm-versatilepb | arm   | lab-collabora | gcc-8    | versatile_defconf=
ig | 1          =


  Details:     https://kernelci.org/test/plan/id/6095940541d9be60c06f54a0

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.232=
-29-g881adbe5d1e00/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qem=
u_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.232=
-29-g881adbe5d1e00/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qem=
u_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6095940541d9be60c06f5=
4a1
        failing since 174 days (last pass: v4.14.206-21-g787a7a3ca16c, firs=
t fail: v4.14.206-22-ga949bf40fb01) =

 =20
