Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6E5DB37EF8C
	for <lists+stable@lfdr.de>; Thu, 13 May 2021 01:21:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231867AbhELXN0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 May 2021 19:13:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47676 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242255AbhELVvV (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 12 May 2021 17:51:21 -0400
Received: from mail-pf1-x42d.google.com (mail-pf1-x42d.google.com [IPv6:2607:f8b0:4864:20::42d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AFDE4C061763
        for <stable@vger.kernel.org>; Wed, 12 May 2021 14:50:04 -0700 (PDT)
Received: by mail-pf1-x42d.google.com with SMTP id h127so19723634pfe.9
        for <stable@vger.kernel.org>; Wed, 12 May 2021 14:50:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=wm1WCmbn8dIL6nX4KaxiUYHYotV2pubPUYde2MjAk6M=;
        b=kJazKrdMZgeegAIt/FVgT4JQiUZCFwAVMuqDTNBYakxcOi8W6YkNQykAUH5+gwyCqw
         IMZB8lLuLVaOlN0GvizaudKV27c5NBtjOHoVeQ1CCX/l75LSuzqWrrVvlXE05OSBwjRw
         SJkOUnqBZVD5nS/+vbLhGhhRn0mdXrWY/fcwNP4rpbhatJX7ijKMZPVOpMGJRoyeQgVf
         Knr0CVNaG9IRLoktziWvE/kDBzeOVYJrT+AfwqBgl6TOKefg35IrLZjzuPCrwy/FaKMB
         f2+tEt0sM05zrYNExdS0PpszgZvpYFoCRCKhJHHoU2LRtfLzeFJr3b8utZkVULHd1jud
         pWpg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=wm1WCmbn8dIL6nX4KaxiUYHYotV2pubPUYde2MjAk6M=;
        b=e8gw9p8i/mU5q1rN1Uon9iGcacGmJHX6rJaanxmWW5Qm3xppMx9EJ9iWayJCVPIiZA
         dKrmSH1bPjap4FmT3EVRIC8shjKHVfEEjNYIt+WPD70ZrQfyQAaxh6iBCy72sQ8fmXTo
         1gC+vL1snxK2c8grxSMJEsioK69Rv/i8yPCVZGcgw5Rbh1/CyaVp9qFK1fGTsEGLX+Tb
         aB/qZx4Xtjus7vRJKOTqb5zoNQZS4vm/XHFyaQQsJB5kf6VRJRtvtuWLvuRDGjd8H6tw
         oZDnvHcR8O/swi/3T3nFYg/6R201xDCu58b8WYjtVNk2OQf0hsy3BwThgr72ghc3MRSv
         3JkA==
X-Gm-Message-State: AOAM532wO6j3Z0WllfIMz1pSqddHGey8F/jPnQdkf3OU+hKC7YnJN5/U
        8chnmFRqs2E7fPul2fCqAcy+AVreT9kXK+xU
X-Google-Smtp-Source: ABdhPJzUrSCe3Ip2VEPpmdfHxZOP+o6h8i2gZqkgGMYfrfSnnly0jdxF++uUVxG5WzOAMBl5Ce5THw==
X-Received: by 2002:a17:90a:b292:: with SMTP id c18mr708217pjr.179.1620856203907;
        Wed, 12 May 2021 14:50:03 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id f6sm588995pfe.74.2021.05.12.14.50.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 12 May 2021 14:50:03 -0700 (PDT)
Message-ID: <609c4d8b.1c69fb81.2af02.2c6a@mx.google.com>
Date:   Wed, 12 May 2021 14:50:03 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v4.9.268-171-g717040c3166d8
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-4.9.y
Subject: stable-rc/linux-4.9.y baseline: 108 runs,
 6 regressions (v4.9.268-171-g717040c3166d8)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.9.y baseline: 108 runs, 6 regressions (v4.9.268-171-g7170=
40c3166d8)

Regressions Summary
-------------------

platform                   | arch  | lab             | compiler | defconfig=
           | regressions
---------------------------+-------+-----------------+----------+----------=
-----------+------------
imx27-phytec-phycard-s-rdk | arm   | lab-pengutronix | gcc-8    | multi_v5_=
defconfig  | 1          =

qemu_arm-versatilepb       | arm   | lab-baylibre    | gcc-8    | versatile=
_defconfig | 1          =

qemu_arm-versatilepb       | arm   | lab-broonie     | gcc-8    | versatile=
_defconfig | 1          =

qemu_arm-versatilepb       | arm   | lab-cip         | gcc-8    | versatile=
_defconfig | 1          =

qemu_arm-versatilepb       | arm   | lab-collabora   | gcc-8    | versatile=
_defconfig | 1          =

r8a7795-salvator-x         | arm64 | lab-baylibre    | gcc-8    | defconfig=
           | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-4.9.y/kern=
el/v4.9.268-171-g717040c3166d8/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-4.9.y
  Describe: v4.9.268-171-g717040c3166d8
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      717040c3166d89f294c116d92d477b511d0b66bc =



Test Regressions
---------------- =



platform                   | arch  | lab             | compiler | defconfig=
           | regressions
---------------------------+-------+-----------------+----------+----------=
-----------+------------
imx27-phytec-phycard-s-rdk | arm   | lab-pengutronix | gcc-8    | multi_v5_=
defconfig  | 1          =


  Details:     https://kernelci.org/test/plan/id/609c1a4e37d347f85a199294

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v5_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.268=
-171-g717040c3166d8/arm/multi_v5_defconfig/gcc-8/lab-pengutronix/baseline-i=
mx27-phytec-phycard-s-rdk.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.268=
-171-g717040c3166d8/arm/multi_v5_defconfig/gcc-8/lab-pengutronix/baseline-i=
mx27-phytec-phycard-s-rdk.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/609c1a4e37d347f85a199=
295
        new failure (last pass: v4.9.268-68-gca5b891582b9) =

 =



platform                   | arch  | lab             | compiler | defconfig=
           | regressions
---------------------------+-------+-----------------+----------+----------=
-----------+------------
qemu_arm-versatilepb       | arm   | lab-baylibre    | gcc-8    | versatile=
_defconfig | 1          =


  Details:     https://kernelci.org/test/plan/id/609c1a887c92cc56201992b2

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.268=
-171-g717040c3166d8/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qem=
u_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.268=
-171-g717040c3166d8/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qem=
u_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/609c1a887c92cc5620199=
2b3
        failing since 179 days (last pass: v4.9.243-17-g9c24315b745a0, firs=
t fail: v4.9.243-26-g7b603f689c1c) =

 =



platform                   | arch  | lab             | compiler | defconfig=
           | regressions
---------------------------+-------+-----------------+----------+----------=
-----------+------------
qemu_arm-versatilepb       | arm   | lab-broonie     | gcc-8    | versatile=
_defconfig | 1          =


  Details:     https://kernelci.org/test/plan/id/609c1a61c2be16306719927a

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.268=
-171-g717040c3166d8/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu=
_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.268=
-171-g717040c3166d8/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu=
_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/609c1a61c2be163067199=
27b
        failing since 179 days (last pass: v4.9.243-17-g9c24315b745a0, firs=
t fail: v4.9.243-26-g7b603f689c1c) =

 =



platform                   | arch  | lab             | compiler | defconfig=
           | regressions
---------------------------+-------+-----------------+----------+----------=
-----------+------------
qemu_arm-versatilepb       | arm   | lab-cip         | gcc-8    | versatile=
_defconfig | 1          =


  Details:     https://kernelci.org/test/plan/id/609c19db3b22c4bf841992a8

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.268=
-171-g717040c3166d8/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm=
-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.268=
-171-g717040c3166d8/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm=
-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/609c19db3b22c4bf84199=
2a9
        failing since 179 days (last pass: v4.9.243-17-g9c24315b745a0, firs=
t fail: v4.9.243-26-g7b603f689c1c) =

 =



platform                   | arch  | lab             | compiler | defconfig=
           | regressions
---------------------------+-------+-----------------+----------+----------=
-----------+------------
qemu_arm-versatilepb       | arm   | lab-collabora   | gcc-8    | versatile=
_defconfig | 1          =


  Details:     https://kernelci.org/test/plan/id/609c1995d174c0e35319927f

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.268=
-171-g717040c3166d8/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qe=
mu_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.268=
-171-g717040c3166d8/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qe=
mu_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/609c1995d174c0e353199=
280
        failing since 179 days (last pass: v4.9.243-17-g9c24315b745a0, firs=
t fail: v4.9.243-26-g7b603f689c1c) =

 =



platform                   | arch  | lab             | compiler | defconfig=
           | regressions
---------------------------+-------+-----------------+----------+----------=
-----------+------------
r8a7795-salvator-x         | arm64 | lab-baylibre    | gcc-8    | defconfig=
           | 1          =


  Details:     https://kernelci.org/test/plan/id/609c1ba8b031acd491199283

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.268=
-171-g717040c3166d8/arm64/defconfig/gcc-8/lab-baylibre/baseline-r8a7795-sal=
vator-x.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.268=
-171-g717040c3166d8/arm64/defconfig/gcc-8/lab-baylibre/baseline-r8a7795-sal=
vator-x.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/609c1ba8b031acd491199=
284
        failing since 175 days (last pass: v4.9.243-17-g9c24315b745a0, firs=
t fail: v4.9.243-79-gd3e70b39d31a) =

 =20
