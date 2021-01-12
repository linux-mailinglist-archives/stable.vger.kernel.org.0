Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E3DEB2F35D1
	for <lists+stable@lfdr.de>; Tue, 12 Jan 2021 17:31:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392687AbhALQaG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 12 Jan 2021 11:30:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34700 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2392645AbhALQaG (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 12 Jan 2021 11:30:06 -0500
Received: from mail-pf1-x434.google.com (mail-pf1-x434.google.com [IPv6:2607:f8b0:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 30D76C061795
        for <stable@vger.kernel.org>; Tue, 12 Jan 2021 08:29:26 -0800 (PST)
Received: by mail-pf1-x434.google.com with SMTP id h186so1703348pfe.0
        for <stable@vger.kernel.org>; Tue, 12 Jan 2021 08:29:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=EZ5xBhoDKC5XsFNWYNfKBFwX1nuZZZomEuaq47WT2bg=;
        b=d+bP8n/AzgEg8rMD8uuwb1qtIzST1DvwfciZ1pxP6lzJo6E1gz10OslSsoulU5HPqy
         UKmQEw2fUGzKcdTi4ENwvkXvRxFXczTZo5QrGU4VhK8xXxSkkOAOtci2uzOwaMOBcaGZ
         prQMspv6fD/RQrHm+d5hVksARETmhDPGqkegSgVO5KPyXc+N6mvi9cbOBab7j4MFfecQ
         MifgkOFW4Q7J+sUnyI6oP3M7us6MEjTKB5Oc47/j7lQ2BL1ROh75ub4gDoCnxFDM9w5p
         q+bFa+iRN67Esvik5foqyXrTTm8xsbNA/BS8E6Kq+954g4QbbEX2VDH8gZWYJmkV53/r
         gsGA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=EZ5xBhoDKC5XsFNWYNfKBFwX1nuZZZomEuaq47WT2bg=;
        b=RjmD1tYFEJ1zTpErxZB/ygUkIE+iw34M+cHHIx2V9WtmkpKvGoHK6ifgIP0HUqsAXL
         3WS/VwyaA6sjE5qhHnTP10lSCdcgFihN4AJE43kDmv1oqX9n1Zd8TbTZVy9RtBAerE3b
         FHeXgyryHiI33Tmmu6+g0PJ6NGy2/4lUD2d2cVCETnFspqdA5Dzh9ISkBn1KZW66kY6h
         ihC0/vD7CcCnZ6sQqmaeOyxRKos3J0AuKyApvlROeO7b5oiJL0k27BxJ8p6o52zJJM3H
         zSVNlud2vi3pe4S1DZxyttGhWJE/l+mj6wYCwrt0aOkRABU9unaCDNOvwWO8Cevyq3D5
         Bzlg==
X-Gm-Message-State: AOAM532i0xeoVAZvvnicBQgSS2dhKqfRoTjVnWwffrwu9Dtq5CJjbms5
        zPXRvDSnANTayW1fQzMD2X1n1r5P6CyLjg==
X-Google-Smtp-Source: ABdhPJy8YARXYGbuHs1XNaZM4uiPSCloGv8pSHM1lGj8zynfxV2mdfPQ5ss5VLPCePX4Xm/0usfhBA==
X-Received: by 2002:a63:4e1a:: with SMTP id c26mr5572775pgb.32.1610468965331;
        Tue, 12 Jan 2021 08:29:25 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id k64sm3781626pfd.75.2021.01.12.08.29.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 12 Jan 2021 08:29:24 -0800 (PST)
Message-ID: <5ffdce64.1c69fb81.9fe1.84df@mx.google.com>
Date:   Tue, 12 Jan 2021 08:29:24 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: linux-4.9.y
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v4.9.250-46-g6d954ea12bd6f
X-Kernelci-Report-Type: test
Subject: stable-rc/linux-4.9.y baseline: 137 runs,
 8 regressions (v4.9.250-46-g6d954ea12bd6f)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.9.y baseline: 137 runs, 8 regressions (v4.9.250-46-g6d954=
ea12bd6f)

Regressions Summary
-------------------

platform             | arch  | lab             | compiler | defconfig      =
     | regressions
---------------------+-------+-----------------+----------+----------------=
-----+------------
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

qemu_i386-uefi       | i386  | lab-broonie     | gcc-8    | i386_defconfig =
     | 1          =

r8a7795-salvator-x   | arm64 | lab-baylibre    | gcc-8    | defconfig      =
     | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-4.9.y/kern=
el/v4.9.250-46-g6d954ea12bd6f/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-4.9.y
  Describe: v4.9.250-46-g6d954ea12bd6f
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      6d954ea12bd6f384f3129de8f74bb0a30baffa7b =



Test Regressions
---------------- =



platform             | arch  | lab             | compiler | defconfig      =
     | regressions
---------------------+-------+-----------------+----------+----------------=
-----+------------
panda                | arm   | lab-collabora   | gcc-8    | omap2plus_defco=
nfig | 1          =


  Details:     https://kernelci.org/test/plan/id/5ffd96d905a4d63c4cc94cd7

  Results:     3 PASS, 1 FAIL, 1 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.250=
-46-g6d954ea12bd6f/arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-pan=
da.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.250=
-46-g6d954ea12bd6f/arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-pan=
da.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/5ffd96d905a4d63=
c4cc94cdc
        failing since 21 days (last pass: v4.9.248-26-g45e6bbdf655a5, first=
 fail: v4.9.248)
        2 lines

    2021-01-12 12:32:21.428000+00:00  kern  :emerg : BUG: spinlock bad magi=
c on CPU#0, udevd/128
    2021-01-12 12:32:21.438000+00:00  kern  :emerg :  lock: emif_lock+0x0/0=
xfffff24c [emif], .magic: dead4ead, .owner: <none>/-1, .owner_cpu: -1   =

 =



platform             | arch  | lab             | compiler | defconfig      =
     | regressions
---------------------+-------+-----------------+----------+----------------=
-----+------------
qemu_arm-versatilepb | arm   | lab-baylibre    | gcc-8    | versatile_defco=
nfig | 1          =


  Details:     https://kernelci.org/test/plan/id/5ffd94e8bc9fd4e30cc94cce

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.250=
-46-g6d954ea12bd6f/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu=
_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.250=
-46-g6d954ea12bd6f/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu=
_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5ffd94e8bc9fd4e30cc94=
ccf
        failing since 58 days (last pass: v4.9.243-17-g9c24315b745a0, first=
 fail: v4.9.243-26-g7b603f689c1c) =

 =



platform             | arch  | lab             | compiler | defconfig      =
     | regressions
---------------------+-------+-----------------+----------+----------------=
-----+------------
qemu_arm-versatilepb | arm   | lab-broonie     | gcc-8    | versatile_defco=
nfig | 1          =


  Details:     https://kernelci.org/test/plan/id/5ffd94f883443e0f49c94ce4

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.250=
-46-g6d954ea12bd6f/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_=
arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.250=
-46-g6d954ea12bd6f/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_=
arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5ffd94f883443e0f49c94=
ce5
        failing since 58 days (last pass: v4.9.243-17-g9c24315b745a0, first=
 fail: v4.9.243-26-g7b603f689c1c) =

 =



platform             | arch  | lab             | compiler | defconfig      =
     | regressions
---------------------+-------+-----------------+----------+----------------=
-----+------------
qemu_arm-versatilepb | arm   | lab-cip         | gcc-8    | versatile_defco=
nfig | 1          =


  Details:     https://kernelci.org/test/plan/id/5ffd954452e3aaa4c1c94cc2

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.250=
-46-g6d954ea12bd6f/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-=
versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.250=
-46-g6d954ea12bd6f/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-=
versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5ffd954452e3aaa4c1c94=
cc3
        failing since 58 days (last pass: v4.9.243-17-g9c24315b745a0, first=
 fail: v4.9.243-26-g7b603f689c1c) =

 =



platform             | arch  | lab             | compiler | defconfig      =
     | regressions
---------------------+-------+-----------------+----------+----------------=
-----+------------
qemu_arm-versatilepb | arm   | lab-collabora   | gcc-8    | versatile_defco=
nfig | 1          =


  Details:     https://kernelci.org/test/plan/id/5ffd99185f5c1fa52ac94cb9

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.250=
-46-g6d954ea12bd6f/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qem=
u_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.250=
-46-g6d954ea12bd6f/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qem=
u_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5ffd99185f5c1fa52ac94=
cba
        failing since 58 days (last pass: v4.9.243-17-g9c24315b745a0, first=
 fail: v4.9.243-26-g7b603f689c1c) =

 =



platform             | arch  | lab             | compiler | defconfig      =
     | regressions
---------------------+-------+-----------------+----------+----------------=
-----+------------
qemu_arm-versatilepb | arm   | lab-linaro-lkft | gcc-8    | versatile_defco=
nfig | 1          =


  Details:     https://kernelci.org/test/plan/id/5ffd94bc48b0847dadc94d3c

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.250=
-46-g6d954ea12bd6f/arm/versatile_defconfig/gcc-8/lab-linaro-lkft/baseline-q=
emu_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.250=
-46-g6d954ea12bd6f/arm/versatile_defconfig/gcc-8/lab-linaro-lkft/baseline-q=
emu_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5ffd94bc48b0847dadc94=
d3d
        failing since 58 days (last pass: v4.9.243-17-g9c24315b745a0, first=
 fail: v4.9.243-26-g7b603f689c1c) =

 =



platform             | arch  | lab             | compiler | defconfig      =
     | regressions
---------------------+-------+-----------------+----------+----------------=
-----+------------
qemu_i386-uefi       | i386  | lab-broonie     | gcc-8    | i386_defconfig =
     | 1          =


  Details:     https://kernelci.org/test/plan/id/5ffd948248b0847dadc94cc6

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: i386_defconfig
  Compiler:    gcc-8 (gcc (Debian 8.3.0-6) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.250=
-46-g6d954ea12bd6f/i386/i386_defconfig/gcc-8/lab-broonie/baseline-qemu_i386=
-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.250=
-46-g6d954ea12bd6f/i386/i386_defconfig/gcc-8/lab-broonie/baseline-qemu_i386=
-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/x86/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5ffd948248b0847dadc94=
cc7
        new failure (last pass: v4.9.250) =

 =



platform             | arch  | lab             | compiler | defconfig      =
     | regressions
---------------------+-------+-----------------+----------+----------------=
-----+------------
r8a7795-salvator-x   | arm64 | lab-baylibre    | gcc-8    | defconfig      =
     | 1          =


  Details:     https://kernelci.org/test/plan/id/5ffd949cadca3d5d14c94cdc

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.250=
-46-g6d954ea12bd6f/arm64/defconfig/gcc-8/lab-baylibre/baseline-r8a7795-salv=
ator-x.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.250=
-46-g6d954ea12bd6f/arm64/defconfig/gcc-8/lab-baylibre/baseline-r8a7795-salv=
ator-x.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5ffd949cadca3d5d14c94=
cdd
        failing since 55 days (last pass: v4.9.243-17-g9c24315b745a0, first=
 fail: v4.9.243-79-gd3e70b39d31a) =

 =20
