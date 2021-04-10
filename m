Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1224F35B047
	for <lists+stable@lfdr.de>; Sat, 10 Apr 2021 22:05:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234536AbhDJUFt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 10 Apr 2021 16:05:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43846 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234439AbhDJUFt (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 10 Apr 2021 16:05:49 -0400
Received: from mail-pj1-x102f.google.com (mail-pj1-x102f.google.com [IPv6:2607:f8b0:4864:20::102f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 650F9C06138A
        for <stable@vger.kernel.org>; Sat, 10 Apr 2021 13:05:34 -0700 (PDT)
Received: by mail-pj1-x102f.google.com with SMTP id t23so4569520pjy.3
        for <stable@vger.kernel.org>; Sat, 10 Apr 2021 13:05:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=a4VLm/yjZR5VaMWLKUxknjT9RF2JtC/MCzYMYQIBUv0=;
        b=vuigDuIa/KmxbewUzuR+DKMr1lEV8x3WfQWeip/gbf9B8WaY1i8NQ3OdML5bhtyR7M
         qFtAP7Wje0kpdcn+GmXVBTj13yTOcnPToQA5uahAnmfJsoPwAoTnG5dQozbg0wczqMAE
         tXb9hQRs1jvIUBAAiQoDK0DmeceXMUEPVWowExBxSvu5TptVmdFB8I95HDx6oZbmcNwm
         6UGgZkpGr1GlnhaqYdXPArcyOPTE45H40Cu7f3UdNJL3iu3sU4IwLV8y1rCue5Z+pMfG
         9k6ooyL5qvFp91Q8e2cY979eBOi/Jt1NBrx3JPaPe+mLwoN5u8G4/0/ZyrUfKHsCJn6L
         ycoA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=a4VLm/yjZR5VaMWLKUxknjT9RF2JtC/MCzYMYQIBUv0=;
        b=f5hC88HvXTY3i3eDe9LcvIIaxem15Lz0NDzuOz8wtloMWk9BxGdBQqG4aVOSQMZViF
         hzy9hGHCg9d7tr6QuCHVXxTzWLqKepZ1ONMouvcOLoS6JVH8BJXdzNlyQuNy3yAEStoO
         g9NYXX1F1/Qi3rVp7rn/9RH/Suwowk3zZ2ZKJD3m0MMlinBm1z8mW8IhhoWjBCXzAXWR
         VULbMTjC3pjirU4b57yc41oVZ+RP77wzzsYcQnLw4rsSUY95kVG0UMabaPhd2xnTZ7xi
         CMSSzqLWiJY+Kk7rJQ66l78R+i3/fMi64G240jWPi+tEHWWJxFiFKe2I6Euvdbm48M/v
         mFLw==
X-Gm-Message-State: AOAM531PDRl02Tv/wBhsM/UyWySZoN3RV60RHQsHOD0VfBrwXGHCHSIJ
        1aWW9tHQZQbtpXNktIXU3awW8D1wvYg1cC1g
X-Google-Smtp-Source: ABdhPJw0KJZ/08GuttRv3KW7UE06PtHj6Qk8KuhLemdHGqDbxRV8Oe0+35hdAU13vBM+j0ivIq73SA==
X-Received: by 2002:a17:902:8f8d:b029:ea:e059:84a6 with SMTP id z13-20020a1709028f8db02900eae05984a6mr361863plo.35.1618085133594;
        Sat, 10 Apr 2021 13:05:33 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id y189sm5594819pfy.8.2021.04.10.13.05.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 10 Apr 2021 13:05:33 -0700 (PDT)
Message-ID: <6072050d.1c69fb81.a2eae.e10f@mx.google.com>
Date:   Sat, 10 Apr 2021 13:05:33 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v4.14.230
X-Kernelci-Branch: linux-4.14.y
X-Kernelci-Tree: stable-rc
Subject: stable-rc/linux-4.14.y baseline: 138 runs, 7 regressions (v4.14.230)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.14.y baseline: 138 runs, 7 regressions (v4.14.230)

Regressions Summary
-------------------

platform             | arch  | lab             | compiler | defconfig      =
     | regressions
---------------------+-------+-----------------+----------+----------------=
-----+------------
meson-gxbb-p200      | arm64 | lab-baylibre    | gcc-8    | defconfig      =
     | 1          =

panda                | arm   | lab-collabora   | gcc-8    | omap2plus_defco=
nfig | 1          =

qemu_arm-versatilepb | arm   | lab-baylibre    | gcc-8    | versatile_defco=
nfig | 1          =

qemu_arm-versatilepb | arm   | lab-broonie     | gcc-8    | versatile_defco=
nfig | 1          =

qemu_arm-versatilepb | arm   | lab-cip         | gcc-8    | versatile_defco=
nfig | 1          =

qemu_arm-versatilepb | arm   | lab-collabora   | gcc-8    | versatile_defco=
nfig | 1          =

qemu_arm-versatilepb | arm   | lab-linaro-lkft | gcc-8    | versatile_defco=
nfig | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-4.14.y/ker=
nel/v4.14.230/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-4.14.y
  Describe: v4.14.230
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      958e517f4e16952e9a2e2d58fd32d28ae4e23dda =



Test Regressions
---------------- =



platform             | arch  | lab             | compiler | defconfig      =
     | regressions
---------------------+-------+-----------------+----------+----------------=
-----+------------
meson-gxbb-p200      | arm64 | lab-baylibre    | gcc-8    | defconfig      =
     | 1          =


  Details:     https://kernelci.org/test/plan/id/6071c8d7b4c60e8144dac6b5

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
30/arm64/defconfig/gcc-8/lab-baylibre/baseline-meson-gxbb-p200.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
30/arm64/defconfig/gcc-8/lab-baylibre/baseline-meson-gxbb-p200.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6071c8d7b4c60e8144dac=
6b6
        failing since 375 days (last pass: v4.14.172-114-g734382e2d26e, fir=
st fail: v4.14.174-131-g234ce78cac23) =

 =



platform             | arch  | lab             | compiler | defconfig      =
     | regressions
---------------------+-------+-----------------+----------+----------------=
-----+------------
panda                | arm   | lab-collabora   | gcc-8    | omap2plus_defco=
nfig | 1          =


  Details:     https://kernelci.org/test/plan/id/6071c834784a363515dac6e3

  Results:     3 PASS, 1 FAIL, 1 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
30/arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-panda.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
30/arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-panda.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/6071c834784a363=
515dac6ea
        new failure (last pass: v4.14.229-15-gbbc0ac1df3446)
        2 lines

    2021-04-10 15:45:50.783000+00:00  kern  :emerg : BUG: spinlock bad magi=
c on CPU#0, udevd/97
    2021-04-10 15:45:50.792000+00:00  kern  :emerg :  lock: emif_lock+0x0/0=
xffffed34 [emif], .magic: dead4ead, .owner: <none>/-1, .owner_cpu: -1   =

 =



platform             | arch  | lab             | compiler | defconfig      =
     | regressions
---------------------+-------+-----------------+----------+----------------=
-----+------------
qemu_arm-versatilepb | arm   | lab-baylibre    | gcc-8    | versatile_defco=
nfig | 1          =


  Details:     https://kernelci.org/test/plan/id/6071c334de2a36fa6cdac6de

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
30/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_arm-versatilepb=
.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
30/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_arm-versatilepb=
.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6071c334de2a36fa6cdac=
6df
        failing since 147 days (last pass: v4.14.206-21-gf1262f26e4d0, firs=
t fail: v4.14.206-23-g520c3568920c8) =

 =



platform             | arch  | lab             | compiler | defconfig      =
     | regressions
---------------------+-------+-----------------+----------+----------------=
-----+------------
qemu_arm-versatilepb | arm   | lab-broonie     | gcc-8    | versatile_defco=
nfig | 1          =


  Details:     https://kernelci.org/test/plan/id/6071c32fc42d087fc4dac6c2

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
30/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_arm-versatilepb.=
txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
30/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_arm-versatilepb.=
html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6071c32fc42d087fc4dac=
6c3
        failing since 147 days (last pass: v4.14.206-21-gf1262f26e4d0, firs=
t fail: v4.14.206-23-g520c3568920c8) =

 =



platform             | arch  | lab             | compiler | defconfig      =
     | regressions
---------------------+-------+-----------------+----------+----------------=
-----+------------
qemu_arm-versatilepb | arm   | lab-cip         | gcc-8    | versatile_defco=
nfig | 1          =


  Details:     https://kernelci.org/test/plan/id/6071c32ade2a36fa6cdac6d0

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
30/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
30/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6071c32ade2a36fa6cdac=
6d1
        failing since 147 days (last pass: v4.14.206-21-gf1262f26e4d0, firs=
t fail: v4.14.206-23-g520c3568920c8) =

 =



platform             | arch  | lab             | compiler | defconfig      =
     | regressions
---------------------+-------+-----------------+----------+----------------=
-----+------------
qemu_arm-versatilepb | arm   | lab-collabora   | gcc-8    | versatile_defco=
nfig | 1          =


  Details:     https://kernelci.org/test/plan/id/6071c2c8287f016deadac6ba

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
30/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu_arm-versatilep=
b.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
30/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu_arm-versatilep=
b.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6071c2c8287f016deadac=
6bb
        failing since 147 days (last pass: v4.14.206-21-gf1262f26e4d0, firs=
t fail: v4.14.206-23-g520c3568920c8) =

 =



platform             | arch  | lab             | compiler | defconfig      =
     | regressions
---------------------+-------+-----------------+----------+----------------=
-----+------------
qemu_arm-versatilepb | arm   | lab-linaro-lkft | gcc-8    | versatile_defco=
nfig | 1          =


  Details:     https://kernelci.org/test/plan/id/6071ef8599a4d74f5bdac6e8

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
30/arm/versatile_defconfig/gcc-8/lab-linaro-lkft/baseline-qemu_arm-versatil=
epb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
30/arm/versatile_defconfig/gcc-8/lab-linaro-lkft/baseline-qemu_arm-versatil=
epb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6071ef8599a4d74f5bdac=
6e9
        failing since 147 days (last pass: v4.14.206-21-gf1262f26e4d0, firs=
t fail: v4.14.206-23-g520c3568920c8) =

 =20
