Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 975432C742A
	for <lists+stable@lfdr.de>; Sat, 28 Nov 2020 23:18:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388966AbgK1Vts (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 28 Nov 2020 16:49:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35008 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728340AbgK1SFy (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 28 Nov 2020 13:05:54 -0500
Received: from mail-pf1-x435.google.com (mail-pf1-x435.google.com [IPv6:2607:f8b0:4864:20::435])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 390FBC02A1A6
        for <stable@vger.kernel.org>; Sat, 28 Nov 2020 10:05:08 -0800 (PST)
Received: by mail-pf1-x435.google.com with SMTP id b10so5854983pfo.4
        for <stable@vger.kernel.org>; Sat, 28 Nov 2020 10:05:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=GOCWwhUyArtuf0pWpOMyaX5F496INN1xv2Sz71dngTs=;
        b=IDrkaNygMGXWbrZs59I6hNeCv0dgvU+K8iatvn2QtaeOoLKKeWX1IC0it3zbj0Z4Q4
         KYGH/Bz44YRP11UY5H6U2i34MabI/x78TRmvfSN3B4EyWNQYhMB3TWfqUJ/X1Cn9WVhv
         coN3/GjIoeZPDfZ3X8nFv+4xlvVevg2FcB8J0j6RBpg9MeHSTJ9eQOR5Dsc8pnVOiUBX
         xzjCFv4b0a3I5w0JLvhDLPZNuUqyPxR/JuL3s+LmEU1tnnmuIBYi8bnA4eZBDktaLkhX
         oW80/a+uQDveoP5clD45mJYK4hlBZ08gDVFdmot4m/tYU17x1/vcEV/ecDQRxRxnwkxh
         hHoQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=GOCWwhUyArtuf0pWpOMyaX5F496INN1xv2Sz71dngTs=;
        b=Qkd/AICzNIhAevfQyl+tN7NZqMC0Z6di1Cb+QxQpGiBEBP31ZGjIaR7ECRNID22WUj
         uh0fm1OalDv+VfYkry0Gj6Q7CYbTVaJp4P9e3cpSDiUIPJ6bK0JWOIJXG0FPj0EjVJ4S
         kWeivNKmuznkqllXgnj78tWYZbY0s8WNwwMFIFVtyshBgjLtNfdRXvyrkhYqsO4IAvw0
         5TTQm65mhuvfqbrWPCv5dQOsb7H67MXor2fMus6DJC5NdvGjYJWWZXgftRpL1HOVTNbL
         7njq9zXrN2DryJF187KmYyVaoiqIr44MphNaW74vjoY/tTcOSb8dgz3cMpJZ9dcrkRPu
         ZOpQ==
X-Gm-Message-State: AOAM530dfNV1iWSlolZ3m7qaTFY3HUbLTjSkAt8yeVY+BObF9yVfIh+k
        6VH2ZcBtAS+T2b7cE6+o2OCFawJTfEfAIA==
X-Google-Smtp-Source: ABdhPJx1E0nsx1WJb58kU2eSxNovxeL0vfFTUwLirj2qYGz5nfNMVLvw2DE+5ert/VIPvVtBZQ9+6g==
X-Received: by 2002:a17:90a:9f8e:: with SMTP id o14mr17423821pjp.89.1606586707428;
        Sat, 28 Nov 2020 10:05:07 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id e1sm11141011pfi.158.2020.11.28.10.05.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 28 Nov 2020 10:05:06 -0800 (PST)
Message-ID: <5fc29152.1c69fb81.38019.9a64@mx.google.com>
Date:   Sat, 28 Nov 2020 10:05:06 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: queue/5.4
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v5.4.80-20-g57a08d5fbf90
X-Kernelci-Report-Type: test
Subject: stable-rc/queue/5.4 baseline: 216 runs,
 7 regressions (v5.4.80-20-g57a08d5fbf90)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.4 baseline: 216 runs, 7 regressions (v5.4.80-20-g57a08d5f=
bf90)

Regressions Summary
-------------------

platform              | arch  | lab             | compiler | defconfig     =
      | regressions
----------------------+-------+-----------------+----------+---------------=
------+------------
at91-sama5d4_xplained | arm   | lab-baylibre    | gcc-8    | sama5_defconfi=
g     | 1          =

hifive-unleashed-a00  | riscv | lab-baylibre    | gcc-8    | defconfig     =
      | 1          =

qemu_arm-versatilepb  | arm   | lab-baylibre    | gcc-8    | versatile_defc=
onfig | 1          =

qemu_arm-versatilepb  | arm   | lab-broonie     | gcc-8    | versatile_defc=
onfig | 1          =

qemu_arm-versatilepb  | arm   | lab-cip         | gcc-8    | versatile_defc=
onfig | 1          =

qemu_arm-versatilepb  | arm   | lab-collabora   | gcc-8    | versatile_defc=
onfig | 1          =

qemu_arm-versatilepb  | arm   | lab-linaro-lkft | gcc-8    | versatile_defc=
onfig | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.4/kern=
el/v5.4.80-20-g57a08d5fbf90/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.4
  Describe: v5.4.80-20-g57a08d5fbf90
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      57a08d5fbf901fdc0be97f9e5213b41b87c5cd59 =



Test Regressions
---------------- =



platform              | arch  | lab             | compiler | defconfig     =
      | regressions
----------------------+-------+-----------------+----------+---------------=
------+------------
at91-sama5d4_xplained | arm   | lab-baylibre    | gcc-8    | sama5_defconfi=
g     | 1          =


  Details:     https://kernelci.org/test/plan/id/5fc25e1f6fb3c89c3bc94cdb

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: sama5_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.80-20=
-g57a08d5fbf90/arm/sama5_defconfig/gcc-8/lab-baylibre/baseline-at91-sama5d4=
_xplained.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.80-20=
-g57a08d5fbf90/arm/sama5_defconfig/gcc-8/lab-baylibre/baseline-at91-sama5d4=
_xplained.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fc25e1f6fb3c89c3bc94=
cdc
        failing since 30 days (last pass: v5.4.72-409-gbbe9df5e07cf, first =
fail: v5.4.72-409-ga6e47f533653) =

 =



platform              | arch  | lab             | compiler | defconfig     =
      | regressions
----------------------+-------+-----------------+----------+---------------=
------+------------
hifive-unleashed-a00  | riscv | lab-baylibre    | gcc-8    | defconfig     =
      | 1          =


  Details:     https://kernelci.org/test/plan/id/5fc25deaf3ba82d3bbc94cde

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (riscv64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.80-20=
-g57a08d5fbf90/riscv/defconfig/gcc-8/lab-baylibre/baseline-hifive-unleashed=
-a00.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.80-20=
-g57a08d5fbf90/riscv/defconfig/gcc-8/lab-baylibre/baseline-hifive-unleashed=
-a00.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/riscv/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fc25deaf3ba82d3bbc94=
cdf
        failing since 8 days (last pass: v5.4.78-5-g843222460ebea, first fa=
il: v5.4.78-13-g81acf0f7c6ec) =

 =



platform              | arch  | lab             | compiler | defconfig     =
      | regressions
----------------------+-------+-----------------+----------+---------------=
------+------------
qemu_arm-versatilepb  | arm   | lab-baylibre    | gcc-8    | versatile_defc=
onfig | 1          =


  Details:     https://kernelci.org/test/plan/id/5fc25b3fdbd8b07fd0c94ce2

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.80-20=
-g57a08d5fbf90/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_arm=
-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.80-20=
-g57a08d5fbf90/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_arm=
-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fc25b3fdbd8b07fd0c94=
ce3
        failing since 14 days (last pass: v5.4.77-44-gce6b18c3a8969, first =
fail: v5.4.77-45-gfd610189f77e1) =

 =



platform              | arch  | lab             | compiler | defconfig     =
      | regressions
----------------------+-------+-----------------+----------+---------------=
------+------------
qemu_arm-versatilepb  | arm   | lab-broonie     | gcc-8    | versatile_defc=
onfig | 1          =


  Details:     https://kernelci.org/test/plan/id/5fc25b5c376f620940c94cdb

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.80-20=
-g57a08d5fbf90/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_arm-=
versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.80-20=
-g57a08d5fbf90/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_arm-=
versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fc25b5c376f620940c94=
cdc
        failing since 14 days (last pass: v5.4.77-44-gce6b18c3a8969, first =
fail: v5.4.77-45-gfd610189f77e1) =

 =



platform              | arch  | lab             | compiler | defconfig     =
      | regressions
----------------------+-------+-----------------+----------+---------------=
------+------------
qemu_arm-versatilepb  | arm   | lab-cip         | gcc-8    | versatile_defc=
onfig | 1          =


  Details:     https://kernelci.org/test/plan/id/5fc25b5132f12e91fcc94cd8

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.80-20=
-g57a08d5fbf90/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-vers=
atilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.80-20=
-g57a08d5fbf90/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-vers=
atilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fc25b5132f12e91fcc94=
cd9
        failing since 14 days (last pass: v5.4.77-44-gce6b18c3a8969, first =
fail: v5.4.77-45-gfd610189f77e1) =

 =



platform              | arch  | lab             | compiler | defconfig     =
      | regressions
----------------------+-------+-----------------+----------+---------------=
------+------------
qemu_arm-versatilepb  | arm   | lab-collabora   | gcc-8    | versatile_defc=
onfig | 1          =


  Details:     https://kernelci.org/test/plan/id/5fc25be2166aa21ab8c94d05

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.80-20=
-g57a08d5fbf90/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu_ar=
m-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.80-20=
-g57a08d5fbf90/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu_ar=
m-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fc25be2166aa21ab8c94=
d06
        failing since 14 days (last pass: v5.4.77-44-gce6b18c3a8969, first =
fail: v5.4.77-45-gfd610189f77e1) =

 =



platform              | arch  | lab             | compiler | defconfig     =
      | regressions
----------------------+-------+-----------------+----------+---------------=
------+------------
qemu_arm-versatilepb  | arm   | lab-linaro-lkft | gcc-8    | versatile_defc=
onfig | 1          =


  Details:     https://kernelci.org/test/plan/id/5fc25b16d83e20c0acc94dc8

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.80-20=
-g57a08d5fbf90/arm/versatile_defconfig/gcc-8/lab-linaro-lkft/baseline-qemu_=
arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.80-20=
-g57a08d5fbf90/arm/versatile_defconfig/gcc-8/lab-linaro-lkft/baseline-qemu_=
arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fc25b16d83e20c0acc94=
dc9
        failing since 14 days (last pass: v5.4.77-44-gce6b18c3a8969, first =
fail: v5.4.77-45-gfd610189f77e1) =

 =20
