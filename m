Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8D3203012F7
	for <lists+stable@lfdr.de>; Sat, 23 Jan 2021 05:16:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726590AbhAWEQZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 22 Jan 2021 23:16:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60848 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726533AbhAWEQV (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 22 Jan 2021 23:16:21 -0500
Received: from mail-pl1-x62e.google.com (mail-pl1-x62e.google.com [IPv6:2607:f8b0:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 895DDC0613D6
        for <stable@vger.kernel.org>; Fri, 22 Jan 2021 20:15:40 -0800 (PST)
Received: by mail-pl1-x62e.google.com with SMTP id b8so4388549plh.12
        for <stable@vger.kernel.org>; Fri, 22 Jan 2021 20:15:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=re0r0KB1iWN1UVBRQcZNWNVexdsQII4iZlIj2DNJZhs=;
        b=TUMq5J3KZywt7te1lfCUzWz0/LpVr7DrNDiWgtAL2Bg8crDWIELi4IvmEbPvQ/1kpC
         6zIUuN5JsLOlgpAo9zo4xhR1OD76i7jH4YM22pZQX79Ne1/uNPauIpmL6Hf0QR1CYkCf
         o0cLOeJP5X7thZzqLN9o5e0QaKsGzUA4jd4SHKZC8pHE1vtSSy9jp4PBwnIMqtQJKrNk
         mBvyIUaCIosYZ9F+kze3kneTAJhoc/Br6kdJnKhjFBWWU8Sh5PgIoRjj7jQhbiLZn/VL
         kPW01nV9b3+VGgJsIMV/eT0q/ZphZ+s9+BrA7fSKorCe/NfkN2Mnaa7/IJ9nngJteRp/
         vetg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=re0r0KB1iWN1UVBRQcZNWNVexdsQII4iZlIj2DNJZhs=;
        b=sxkL/LVYkjfvLZaEcoki51vTxvtue8dzmBaLy7IzXAtTbywAlOqpH2FmgaoRsFcK7s
         2+A8TVjPTDVvTHQ58HnrPh9ODznyFOEy4k8knjfgTdVEO12DBh8m3C4nBA3Cbznw4Zr6
         xcellqFRMSRiMwkyHkhBd1b8imkA9vE/dduIVE8wfQyBE5B1ppf2LlYt2fhLd5DzWfYQ
         ekFniPEjyPYSdfvYH1VDXPdyW1zPIzNc/zPyQLgkkiSTeheCYEvmQ67hq+2j2Xb3DuUn
         kDRIaeeoMqaZWaaqD/mydyasbkLA+2sDbum8m3qLz4ZbYON6w1SFERnLzaq1fVJVRIYL
         6o6Q==
X-Gm-Message-State: AOAM533qWwaTaHR41q5TpnUyvH0uGLW11Va8S571kQeFMGNfCHbjTbMW
        1+ZrLPBf3sFZAA/2Zg/vvEEdtk14wB1eS2rP
X-Google-Smtp-Source: ABdhPJwwniGT/CFyeFu98pC06TApJt48UqN+JcF/c2en8kJPHEC1ZNA8YbdAVTC4HJ63Os7WgaWaSQ==
X-Received: by 2002:a17:90a:f28d:: with SMTP id fs13mr2650601pjb.22.1611375339506;
        Fri, 22 Jan 2021 20:15:39 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id kr9sm10887334pjb.0.2021.01.22.20.15.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 22 Jan 2021 20:15:38 -0800 (PST)
Message-ID: <600ba2ea.1c69fb81.c2106.a347@mx.google.com>
Date:   Fri, 22 Jan 2021 20:15:38 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.19.169-23-g6cb90163efb7
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-4.19.y
Subject: stable-rc/linux-4.19.y baseline: 170 runs,
 5 regressions (v4.19.169-23-g6cb90163efb7)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.19.y baseline: 170 runs, 5 regressions (v4.19.169-23-g6cb=
90163efb7)

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


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-4.19.y/ker=
nel/v4.19.169-23-g6cb90163efb7/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-4.19.y
  Describe: v4.19.169-23-g6cb90163efb7
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      6cb90163efb77ad3afe6d40720f0b7cdd0a94812 =



Test Regressions
---------------- =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
panda                | arm  | lab-collabora | gcc-8    | omap2plus_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/600b77220c5a3dd17dd3e03f

  Results:     4 PASS, 1 FAIL, 0 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.1=
69-23-g6cb90163efb7/arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-pa=
nda.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.1=
69-23-g6cb90163efb7/arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-pa=
nda.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/600b77220c5a3dd=
17dd3e046
        failing since 5 days (last pass: v4.19.167-44-g710affe26b436, first=
 fail: v4.19.168-13-g245da3579887f)
        2 lines

    2021-01-23 01:08:41.924000+00:00  kern  :emerg : BUG: spinlock bad magi=
c on CPU#0, udevd/108
    2021-01-23 01:08:41.933000+00:00  kern  :emerg :  lock: emif_lock+0x0/0=
xffffed34 [emif], .magic: 00000000, .owner: <none>/-1, .owner_cpu: 0   =

 =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-baylibre  | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/600b6eb668b8852263d3dfc9

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.1=
69-23-g6cb90163efb7/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qem=
u_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.1=
69-23-g6cb90163efb7/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qem=
u_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/600b6eb668b8852263d3d=
fca
        failing since 65 days (last pass: v4.19.157-26-ga8e7fec1fea1, first=
 fail: v4.19.157-102-g1d674327c1b7) =

 =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-broonie   | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/600b6ec8fba94f337dd3dfd9

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.1=
69-23-g6cb90163efb7/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu=
_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.1=
69-23-g6cb90163efb7/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu=
_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/600b6ec8fba94f337dd3d=
fda
        failing since 65 days (last pass: v4.19.157-26-ga8e7fec1fea1, first=
 fail: v4.19.157-102-g1d674327c1b7) =

 =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-cip       | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/600b6ec6fba94f337dd3dfd4

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.1=
69-23-g6cb90163efb7/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm=
-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.1=
69-23-g6cb90163efb7/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm=
-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/600b6ec6fba94f337dd3d=
fd5
        failing since 65 days (last pass: v4.19.157-26-ga8e7fec1fea1, first=
 fail: v4.19.157-102-g1d674327c1b7) =

 =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-collabora | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/600b76c2d9ca4b74d8d3e00a

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.1=
69-23-g6cb90163efb7/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qe=
mu_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.1=
69-23-g6cb90163efb7/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qe=
mu_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/600b76c2d9ca4b74d8d3e=
00b
        failing since 65 days (last pass: v4.19.157-26-ga8e7fec1fea1, first=
 fail: v4.19.157-102-g1d674327c1b7) =

 =20
