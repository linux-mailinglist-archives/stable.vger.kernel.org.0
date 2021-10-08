Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4F3BE426FC1
	for <lists+stable@lfdr.de>; Fri,  8 Oct 2021 19:51:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231234AbhJHRxx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 8 Oct 2021 13:53:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37274 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231217AbhJHRxx (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 8 Oct 2021 13:53:53 -0400
Received: from mail-pl1-x629.google.com (mail-pl1-x629.google.com [IPv6:2607:f8b0:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B0ACDC061570
        for <stable@vger.kernel.org>; Fri,  8 Oct 2021 10:51:57 -0700 (PDT)
Received: by mail-pl1-x629.google.com with SMTP id n11so6233938plf.4
        for <stable@vger.kernel.org>; Fri, 08 Oct 2021 10:51:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=c+TPoUu9CetJZSbwwnlJqpPZvzt2TTsuLwyGEbgvQ6k=;
        b=0dgfSUHnrezRkyaBgVGTM6T/+6C1XAiDvUZcmofA1/FEuB72py1TqCKKVEcWdRK2mY
         Yg92Ih8dX8D0YT2Rlp+4p0r0ZeFCVntZl0PCznPAZbjlkQBBAOqrLiBzGQKvFQfQyZAs
         V0l8a8s2XlaXx8DPoWNqX7ueGqktI51w7r3DIuSsfe/QTg4dWxSttHIey+D+Ifz2aDut
         8iyJVhdKLMZyouTCzMdWHRi6S86R32RRh9k9RJXCc+k37zEQywJJ/TSCs5wghtM3mIRw
         0tTNCwJWP0UdGuQOTH3JNXmm44lZJRG0Cvt6iZR8KKy4wAf3DsGlW0m+wg1vbkqBGMmk
         WnTQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=c+TPoUu9CetJZSbwwnlJqpPZvzt2TTsuLwyGEbgvQ6k=;
        b=lei+1HB8x0m0JzCCbY9tBlPDbrj7sVOtEuIGP4bB/XCPPEcqO5a0fqhyHpO8hxrYjw
         Gy4yhNA6A+IazTY5M7fga6ovUGMvbm1+YGf/AjfZxIbg7yaP5s6JbStfX2+wUEzR16NN
         HMd//JpFJmInG+dJNROssU/9VMEI0e/a2liGrTvCwprhBOLrURSXEeFsA5pXhntv5dJN
         CqXzItzZo7tgYH1TVeXgjHch6OxwD0U7jVAJUEbELBXrXhvWK4HMMZNa44BFkoJyaKwe
         oAqrNdqYt5rPYordVoEjtZKdKkZ3c+ryGIA1H4ChVt/qnEnaLkkYBR+A57/GCA+T2P0w
         m9Fw==
X-Gm-Message-State: AOAM530QKx5CrSJ8OXTFXNsqKHVoWTkG7N3vu33Dcp2z7fgN7vxDtTz4
        g7EWJGWmaz8JcxlY5/h1LfsjXBV1njjxj9X6
X-Google-Smtp-Source: ABdhPJzk6FGI2VNe6Rhbbk5ENjMwqtAAkbZhG/RTLk/0xR1uZ9sN38lpnT9MSDu+SDveFRdzvfPRQQ==
X-Received: by 2002:a17:902:7e8a:b0:13d:95e2:d9c2 with SMTP id z10-20020a1709027e8a00b0013d95e2d9c2mr10882210pla.8.1633715517033;
        Fri, 08 Oct 2021 10:51:57 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id e2sm11305380pjl.31.2021.10.08.10.51.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 08 Oct 2021 10:51:56 -0700 (PDT)
Message-ID: <6160853c.1c69fb81.a77e5.0a4d@mx.google.com>
Date:   Fri, 08 Oct 2021 10:51:56 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.9.285-9-gb57b518625d9
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-4.9.y
Subject: stable-rc/linux-4.9.y baseline: 112 runs,
 5 regressions (v4.9.285-9-gb57b518625d9)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.9.y baseline: 112 runs, 5 regressions (v4.9.285-9-gb57b51=
8625d9)

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

qemu_arm-versatilepb | arm  | lab-collabora   | gcc-8    | versatile_defcon=
fig | 1          =

qemu_arm-versatilepb | arm  | lab-linaro-lkft | gcc-8    | versatile_defcon=
fig | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-4.9.y/kern=
el/v4.9.285-9-gb57b518625d9/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-4.9.y
  Describe: v4.9.285-9-gb57b518625d9
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      b57b518625d959467e72b2a28682237a0b7973c6 =



Test Regressions
---------------- =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-baylibre    | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/61604daf9eec28ce1099a2e3

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.285=
-9-gb57b518625d9/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_a=
rm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.285=
-9-gb57b518625d9/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_a=
rm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61604daf9eec28ce1099a=
2e4
        failing since 327 days (last pass: v4.9.243-17-g9c24315b745a0, firs=
t fail: v4.9.243-26-g7b603f689c1c) =

 =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-broonie     | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/61607e4e585db30a0d99a306

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.285=
-9-gb57b518625d9/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_ar=
m-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.285=
-9-gb57b518625d9/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_ar=
m-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61607e4e585db30a0d99a=
307
        failing since 327 days (last pass: v4.9.243-17-g9c24315b745a0, firs=
t fail: v4.9.243-26-g7b603f689c1c) =

 =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-cip         | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/61604f3ce36fac0d6099a2e2

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.285=
-9-gb57b518625d9/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-ve=
rsatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.285=
-9-gb57b518625d9/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-ve=
rsatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61604f3ce36fac0d6099a=
2e3
        failing since 327 days (last pass: v4.9.243-17-g9c24315b745a0, firs=
t fail: v4.9.243-26-g7b603f689c1c) =

 =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-collabora   | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/61606238de6878716c99a2db

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.285=
-9-gb57b518625d9/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu_=
arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.285=
-9-gb57b518625d9/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu_=
arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61606238de6878716c99a=
2dc
        failing since 327 days (last pass: v4.9.243-17-g9c24315b745a0, firs=
t fail: v4.9.243-26-g7b603f689c1c) =

 =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-linaro-lkft | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/61604d3ae42ff5a8b699a2db

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.285=
-9-gb57b518625d9/arm/versatile_defconfig/gcc-8/lab-linaro-lkft/baseline-qem=
u_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.285=
-9-gb57b518625d9/arm/versatile_defconfig/gcc-8/lab-linaro-lkft/baseline-qem=
u_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61604d3ae42ff5a8b699a=
2dc
        failing since 327 days (last pass: v4.9.243-17-g9c24315b745a0, firs=
t fail: v4.9.243-26-g7b603f689c1c) =

 =20
