Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 408A02B2C6F
	for <lists+stable@lfdr.de>; Sat, 14 Nov 2020 10:33:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726481AbgKNJdL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 14 Nov 2020 04:33:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39042 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726478AbgKNJdK (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 14 Nov 2020 04:33:10 -0500
Received: from mail-pf1-x431.google.com (mail-pf1-x431.google.com [IPv6:2607:f8b0:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B11BCC0613D1
        for <stable@vger.kernel.org>; Sat, 14 Nov 2020 01:33:10 -0800 (PST)
Received: by mail-pf1-x431.google.com with SMTP id w14so9547848pfd.7
        for <stable@vger.kernel.org>; Sat, 14 Nov 2020 01:33:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=pfHT3IL6UarZN83aqrFgkLd9nE2XCHWXCTHklN9v6cs=;
        b=qZtuYnOfhoUJIL81y35mupRa0DBBqPnhge5AgFzWX5BHX2cafrN/wZzDo1GnGRq6Hx
         gdLzj4x6dO436TmjNv981i2oD0J2V/6WqmyPJ38hckXPUwRW+69TcB8Y2YDD6GGMRHVl
         O14yThkocYvj44bzW3ZY9UiJNgnESvmDUf5NYCgKCmcSKjg7/QvYz7QkypD/+mX7vsyZ
         2QZVjZnkLjjXklkTds0GfS3ELwgW+d06HR4KhGuOuj9ssX5DfCngddfEQLQnpZptdsFo
         O040UdzpzO4SRYVYD2xUoTviR6tCXxl1zHp2/UCPRMXVSxlSNQ6i1Y4DXDQeJjXq+5Mw
         waeA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=pfHT3IL6UarZN83aqrFgkLd9nE2XCHWXCTHklN9v6cs=;
        b=fQzZOFGwDQkdlpGBpB/F/6RdNL9ZqfP8RBYyIj+s3Uw7//NNXFLY1A9dDttzJWYAxr
         +YaYDSmCmo2SN1LPH90GzDz2xFDUVg4BOs7UuhBHPYurJtP2xSzJ1j2ww6y4CxWnF+fu
         1esGt1mVHWuyr4cwTu4vb3EWzW9lm5m0B8jPPcZct+2ixPJ/nlzlhow1qHt0keztInsU
         6VwKDZ6IS65YQIwt+UQo+MzfK+V4A+ZlsyGBiTMAj1LhQtu+WaosKQAXiIJV3d6a7WMp
         1q2EJicK72Tb+cE+Ks6wPtH646GX5HeMFZ11CJ0xexJ6hQYMbw+9STSRLrHd8pfPS4Cl
         9dDA==
X-Gm-Message-State: AOAM533mkOyq55fPWlC6Tm+PTeFdHsq7XVqunNCsFa4FZv0cqKL/W9jI
        qkYyG7r22LdSrt2zoh7Xwv5ZSA1oOqR9Dg==
X-Google-Smtp-Source: ABdhPJzqCZDtzej/f7F7OmNpNRNrsJ8S68sM8zXub9clF4RGV27bHo2mju+zpt33gRt6PEg24KJ9BA==
X-Received: by 2002:a65:4c01:: with SMTP id u1mr4726249pgq.35.1605346389948;
        Sat, 14 Nov 2020 01:33:09 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id z206sm12760765pfc.3.2020.11.14.01.33.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 14 Nov 2020 01:33:09 -0800 (PST)
Message-ID: <5fafa455.1c69fb81.f6a8f.b6d4@mx.google.com>
Date:   Sat, 14 Nov 2020 01:33:09 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: queue/4.19
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v4.19.157-28-g97b0493da936
X-Kernelci-Report-Type: test
Subject: stable-rc/queue/4.19 baseline: 183 runs,
 6 regressions (v4.19.157-28-g97b0493da936)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.19 baseline: 183 runs, 6 regressions (v4.19.157-28-g97b04=
93da936)

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


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.19/ker=
nel/v4.19.157-28-g97b0493da936/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.19
  Describe: v4.19.157-28-g97b0493da936
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      97b0493da936c03768c8a9b7b7ec7b53a416cb6f =



Test Regressions
---------------- =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
panda                | arm  | lab-collabora   | gcc-8    | omap2plus_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/5faf6bc96d563f4f1479b8b0

  Results:     4 PASS, 1 FAIL, 0 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.157=
-28-g97b0493da936/arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-pand=
a.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.157=
-28-g97b0493da936/arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-pand=
a.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/5faf6bc96d563f4=
f1479b8b7
        failing since 0 day (last pass: v4.19.157-26-gd59f3161b3a0, first f=
ail: v4.19.157-27-g5543cc2c41d55)
        2 lines

    2020-11-14 05:31:47.888000+00:00  kern  :emerg :  lock: emif_lock+0x0/0=
xffffed34 [emif], .magic: dead4ead, .owner: <none>/-1, .owner_cpu: -1   =

 =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-baylibre    | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/5faf66a9f22c2be5b879b89e

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.157=
-28-g97b0493da936/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_=
arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.157=
-28-g97b0493da936/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_=
arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5faf66a9f22c2be5b879b=
89f
        failing since 0 day (last pass: v4.19.157-26-gd59f3161b3a0, first f=
ail: v4.19.157-27-g5543cc2c41d55) =

 =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-broonie     | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/5faf66b5b746cc958c79b8ae

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.157=
-28-g97b0493da936/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_a=
rm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.157=
-28-g97b0493da936/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_a=
rm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5faf66b5b746cc958c79b=
8af
        failing since 0 day (last pass: v4.19.157-26-gd59f3161b3a0, first f=
ail: v4.19.157-27-g5543cc2c41d55) =

 =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-cip         | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/5faf66b4f22c2be5b879b8a1

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.157=
-28-g97b0493da936/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-v=
ersatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.157=
-28-g97b0493da936/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-v=
ersatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5faf66b4f22c2be5b879b=
8a2
        failing since 0 day (last pass: v4.19.157-26-gd59f3161b3a0, first f=
ail: v4.19.157-27-g5543cc2c41d55) =

 =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-collabora   | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/5faf6667f1f839cb5a79b8a1

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.157=
-28-g97b0493da936/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu=
_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.157=
-28-g97b0493da936/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu=
_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5faf6667f1f839cb5a79b=
8a2
        failing since 0 day (last pass: v4.19.157-26-gd59f3161b3a0, first f=
ail: v4.19.157-27-g5543cc2c41d55) =

 =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-linaro-lkft | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/5faf667924557f555079b897

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.157=
-28-g97b0493da936/arm/versatile_defconfig/gcc-8/lab-linaro-lkft/baseline-qe=
mu_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.157=
-28-g97b0493da936/arm/versatile_defconfig/gcc-8/lab-linaro-lkft/baseline-qe=
mu_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5faf667924557f555079b=
898
        failing since 0 day (last pass: v4.19.157-26-gd59f3161b3a0, first f=
ail: v4.19.157-27-g5543cc2c41d55) =

 =20
