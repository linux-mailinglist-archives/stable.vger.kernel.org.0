Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C089B332A9D
	for <lists+stable@lfdr.de>; Tue,  9 Mar 2021 16:36:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231229AbhCIPgK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 9 Mar 2021 10:36:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44834 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230215AbhCIPfj (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 9 Mar 2021 10:35:39 -0500
Received: from mail-pf1-x434.google.com (mail-pf1-x434.google.com [IPv6:2607:f8b0:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2D0B5C06174A
        for <stable@vger.kernel.org>; Tue,  9 Mar 2021 07:35:39 -0800 (PST)
Received: by mail-pf1-x434.google.com with SMTP id t85so4418512pfc.13
        for <stable@vger.kernel.org>; Tue, 09 Mar 2021 07:35:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=JbR12RFxAn0shaBAnNDsLOcd/B5Ge1ktCtvPGFmOxBM=;
        b=DouZspOzEzVSyb/Yh6EixejElhDgj8DZHombuZ96G1foICTD3T3W+FJByOpiYhvdyN
         L1Cm+NSfK6riFI3I2En60/dZlbLlzi1cQFnFqm9JpiTluykTa8kTxYNDD/HSTqW9uJdP
         GjhZOcL9kAZboCIjzwC3BNOkFduZ96BIM2IqBKhXBcTNKBeQ6AWI2uUMnK+BzJq0zsbS
         +0USR49D9dPBeRP4t1xnT6EB4IZDY56tXwTWoiYP+ORUvRcST2+mvoT5HrDV4k70IY1q
         ITvSwzQJjs4G4GmtEdGaAY89JW3sEzXRgsgtOlPeWorHiqJppDIPmwkII3b5tkXd0T6e
         qNLw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=JbR12RFxAn0shaBAnNDsLOcd/B5Ge1ktCtvPGFmOxBM=;
        b=eXhEf9V0HYivJRbRd6n65AtC3exqJXNm4CFchudJ0blWG2UXljytJPBkp2n15sHyq6
         To9MVINUzAsZ0ulYrm5Y0iqpTis/PsF3M1lIZKb5aaklkp6iK4tW7Wvow2KuZFGjRBz7
         NRGNogYdywTP+JKF7Crb61uIQRTcC6kI9LfeZN0JVVQgQxL0zf1Ag10p9r3O28NqGRSP
         d2H0EcoM5CIKfOsR+6xjz5OcqutHak1LowfM6AN24uBFu4fE9XPh5fHzzLBzsOjaUGO4
         pUpANi6NtuJqnHXw0ElYgfcuTXm4U+2Y4kVOelwkZHIEcfKjgK5VZhCAlynA7ZYwkaoA
         vnEg==
X-Gm-Message-State: AOAM5309TwT3KtYlsFf0rOI3xrTM8yvZBETjXkbwUrhwNZeyhLi1qkDm
        IxTy9PGcWc4X90HX8JUhBirtWCUuaw/la4Ce
X-Google-Smtp-Source: ABdhPJy1S0z2gXlWxkdh+jYB9HOljJq0ug5FE5FTflKj5QTagly9i99ziQua4D8IJTfiW5mObgFRLg==
X-Received: by 2002:a62:2c85:0:b029:1ed:39f4:ca0f with SMTP id s127-20020a622c850000b02901ed39f4ca0fmr4145924pfs.11.1615304138364;
        Tue, 09 Mar 2021 07:35:38 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id l2sm3317709pjg.50.2021.03.09.07.35.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 09 Mar 2021 07:35:38 -0800 (PST)
Message-ID: <604795ca.1c69fb81.d3d7c.8533@mx.google.com>
Date:   Tue, 09 Mar 2021 07:35:38 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.19.179-21-gaab4fb7b1ffaf
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/4.19
Subject: stable-rc/queue/4.19 baseline: 141 runs,
 5 regressions (v4.19.179-21-gaab4fb7b1ffaf)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.19 baseline: 141 runs, 5 regressions (v4.19.179-21-gaab4f=
b7b1ffaf)

Regressions Summary
-------------------

platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
panda                | arm  | lab-collabora | gcc-8    | omap2plus_defconfi=
g | 1          =

qemu_arm-versatilepb | arm  | lab-baylibre  | gcc-8    | versatile_defconfi=
g | 1          =

qemu_arm-versatilepb | arm  | lab-broonie   | gcc-8    | versatile_defconfi=
g | 1          =

qemu_arm-versatilepb | arm  | lab-cip       | gcc-8    | versatile_defconfi=
g | 1          =

qemu_arm-versatilepb | arm  | lab-collabora | gcc-8    | versatile_defconfi=
g | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.19/ker=
nel/v4.19.179-21-gaab4fb7b1ffaf/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.19
  Describe: v4.19.179-21-gaab4fb7b1ffaf
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      aab4fb7b1ffaf9ae4f131431b3b6b8a1dd406f02 =



Test Regressions
---------------- =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
panda                | arm  | lab-collabora | gcc-8    | omap2plus_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/60475f24f298f8c847addd29

  Results:     4 PASS, 1 FAIL, 0 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.179=
-21-gaab4fb7b1ffaf/arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-pan=
da.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.179=
-21-gaab4fb7b1ffaf/arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-pan=
da.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/60475f24f298f8c=
847addd2e
        new failure (last pass: v4.19.179-20-g3db9265bc3729)
        2 lines

    2021-03-09 11:42:24.128000+00:00  kern  :emerg :  lock: emif_lock+0x0/0=
xffffed34 [emif], .magic: dead4ead, .owner: <none>/-1, .owner_cpu: -1   =

 =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-baylibre  | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/60475c9d5aefb749f1addcc4

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.179=
-21-gaab4fb7b1ffaf/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu=
_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.179=
-21-gaab4fb7b1ffaf/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu=
_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60475c9d5aefb749f1add=
cc5
        failing since 115 days (last pass: v4.19.157-26-gd59f3161b3a0, firs=
t fail: v4.19.157-27-g5543cc2c41d55) =

 =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-broonie   | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/604761596f64ead1efaddd29

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.179=
-21-gaab4fb7b1ffaf/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_=
arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.179=
-21-gaab4fb7b1ffaf/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_=
arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/604761596f64ead1efadd=
d2a
        failing since 115 days (last pass: v4.19.157-26-gd59f3161b3a0, firs=
t fail: v4.19.157-27-g5543cc2c41d55) =

 =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-cip       | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/60475c76150c27d6b3addcb4

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.179=
-21-gaab4fb7b1ffaf/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-=
versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.179=
-21-gaab4fb7b1ffaf/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-=
versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60475c76150c27d6b3add=
cb5
        failing since 115 days (last pass: v4.19.157-26-gd59f3161b3a0, firs=
t fail: v4.19.157-27-g5543cc2c41d55) =

 =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-collabora | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/60475c20fbab5eb910addcc7

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.179=
-21-gaab4fb7b1ffaf/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qem=
u_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.179=
-21-gaab4fb7b1ffaf/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qem=
u_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60475c20fbab5eb910add=
cc8
        failing since 115 days (last pass: v4.19.157-26-gd59f3161b3a0, firs=
t fail: v4.19.157-27-g5543cc2c41d55) =

 =20
