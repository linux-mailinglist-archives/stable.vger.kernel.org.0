Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 29B2B2F9610
	for <lists+stable@lfdr.de>; Mon, 18 Jan 2021 00:06:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730429AbhAQXFn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 17 Jan 2021 18:05:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53516 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730135AbhAQXFk (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 17 Jan 2021 18:05:40 -0500
Received: from mail-pg1-x530.google.com (mail-pg1-x530.google.com [IPv6:2607:f8b0:4864:20::530])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0DFB3C061574
        for <stable@vger.kernel.org>; Sun, 17 Jan 2021 15:05:00 -0800 (PST)
Received: by mail-pg1-x530.google.com with SMTP id i7so9798272pgc.8
        for <stable@vger.kernel.org>; Sun, 17 Jan 2021 15:05:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=PHH16HO67FxLF5bx9JmPOLKvOgZZ2YTSMTgj4qyV1QQ=;
        b=tlQ59FeOE8Y+3z5pcdyKD1G6hDghhw1CC0asL+ACIvlEbCz2amNiOca8FbdfP7mDE3
         OZKZTBkDIV1rgS0g+ygSZs9TPwDhVMoop76/YUTjVvZ9iHCvtrjNUnMfxfzo8P3xK5nn
         oi+K86Lb1SaRjwvs8pb68viZiBAtudp2z6TosJtos7m3XWDLTuHbEWpbs2TVG3L/MqZX
         8o0nab/faTUh/VvHuKSwdOrXpsRUiXxAyVB+Gi74pVL9UknbpruTq6Sg6wP6Jj1Kw+U2
         6PgmmwYjCg346ieibpfziDD5tR8PaIJxD8Tj6kBGFFpmJ2Q2Qks9hC62I1YCGjCfthEw
         R3Ww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=PHH16HO67FxLF5bx9JmPOLKvOgZZ2YTSMTgj4qyV1QQ=;
        b=pQ6pHkBvN5Wru0YEsGqxc8+oF9cs5ZY5dPQUappPRqTzBzG2apb17h5rCRj4VNlRd0
         0i3M5XnOPvFBfrqK0qNsGKQmnuxRAZlgG23MRsHQOBJK1rFBX1hOwUmDl/BQJYplnPGg
         a+uoU4e/6IQh5HSnQ7Pwi6lPvSbXWuuOD9/vVSkzrbjibkxoRE6/hwUBOnGMtqTolygg
         gr8DiKKeVBfFvf74GAZ73N4FwLCLBlmsEjQovoN4wNnXka2OzfZos9NkfywraA9OmSKH
         syqTVdYlgV2q0Rnko/haJdpW26QVFCoKJad4ud+bOC9KV1OnQGrhKPfgYiO7vsWQ2w4k
         ogGg==
X-Gm-Message-State: AOAM5305BOGOnKbDFkWEq2xMSCrwmJVnL9fiDfzKyFiyCxYBZCglS//z
        gbyzlyHGfmxRsCq4ZX3sB5ni74XlA11+AQ==
X-Google-Smtp-Source: ABdhPJyXjsRWlG+7cwgrvfYXhQLz79mTzzkQh4Op0iW/bH5JdwihiF0bXONsHgad7ODjSTQR2LcdeQ==
X-Received: by 2002:a62:c312:0:b029:1a9:19c7:a8e with SMTP id v18-20020a62c3120000b02901a919c70a8emr23612485pfg.74.1610924699180;
        Sun, 17 Jan 2021 15:04:59 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id u126sm13613891pfu.113.2021.01.17.15.04.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 17 Jan 2021 15:04:58 -0800 (PST)
Message-ID: <6004c29a.1c69fb81.84773.21e1@mx.google.com>
Date:   Sun, 17 Jan 2021 15:04:58 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: linux-4.14.y
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v4.14.216-10-g1af529061f01
X-Kernelci-Report-Type: test
Subject: stable-rc/linux-4.14.y baseline: 151 runs,
 9 regressions (v4.14.216-10-g1af529061f01)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.14.y baseline: 151 runs, 9 regressions (v4.14.216-10-g1af=
529061f01)

Regressions Summary
-------------------

platform             | arch   | lab             | compiler | defconfig     =
      | regressions
---------------------+--------+-----------------+----------+---------------=
------+------------
meson-gxbb-p200      | arm64  | lab-baylibre    | gcc-8    | defconfig     =
      | 1          =

panda                | arm    | lab-collabora   | gcc-8    | omap2plus_defc=
onfig | 1          =

qemu_arm-versatilepb | arm    | lab-baylibre    | gcc-8    | versatile_defc=
onfig | 1          =

qemu_arm-versatilepb | arm    | lab-broonie     | gcc-8    | versatile_defc=
onfig | 1          =

qemu_arm-versatilepb | arm    | lab-cip         | gcc-8    | versatile_defc=
onfig | 1          =

qemu_arm-versatilepb | arm    | lab-collabora   | gcc-8    | versatile_defc=
onfig | 1          =

qemu_arm-versatilepb | arm    | lab-linaro-lkft | gcc-8    | versatile_defc=
onfig | 1          =

qemu_i386            | i386   | lab-baylibre    | gcc-8    | i386_defconfig=
      | 1          =

qemu_x86_64-uefi     | x86_64 | lab-baylibre    | gcc-8    | x86_64_defconf=
ig    | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-4.14.y/ker=
nel/v4.14.216-10-g1af529061f01/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-4.14.y
  Describe: v4.14.216-10-g1af529061f01
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      1af529061f01858e6e314ea54258fb1faf1a9fec =



Test Regressions
---------------- =



platform             | arch   | lab             | compiler | defconfig     =
      | regressions
---------------------+--------+-----------------+----------+---------------=
------+------------
meson-gxbb-p200      | arm64  | lab-baylibre    | gcc-8    | defconfig     =
      | 1          =


  Details:     https://kernelci.org/test/plan/id/600490b637896f5288c94cc8

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
16-10-g1af529061f01/arm64/defconfig/gcc-8/lab-baylibre/baseline-meson-gxbb-=
p200.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
16-10-g1af529061f01/arm64/defconfig/gcc-8/lab-baylibre/baseline-meson-gxbb-=
p200.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/600490b637896f5288c94=
cc9
        failing since 292 days (last pass: v4.14.172-114-g734382e2d26e, fir=
st fail: v4.14.174-131-g234ce78cac23) =

 =



platform             | arch   | lab             | compiler | defconfig     =
      | regressions
---------------------+--------+-----------------+----------+---------------=
------+------------
panda                | arm    | lab-collabora   | gcc-8    | omap2plus_defc=
onfig | 1          =


  Details:     https://kernelci.org/test/plan/id/60048ca83795c3e877c94cdc

  Results:     3 PASS, 1 FAIL, 1 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
16-10-g1af529061f01/arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-pa=
nda.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
16-10-g1af529061f01/arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-pa=
nda.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/60048ca83795c3e=
877c94ce1
        failing since 2 days (last pass: v4.14.215-29-ge0904e5ba4c7, first =
fail: v4.14.215-29-g4cfcf012355fc)
        2 lines

    2021-01-17 19:14:40.670000+00:00  kern  :emerg :  lock: emif_lock+0x0/0=
xffffed34 [emif[   20.297302] usb 3-1.1: New USB device found, idVendor=3D0=
424, idProduct=3Dec00
    2021-01-17 19:14:40.682000+00:00  ], .magic: dead4ead, .owner: <none>/-=
1, .owner_c[   20.309265] usb 3-1.1: New USB device strings: Mfr=3D0, Produ=
ct=3D0, SerialNumber=3D0
    2021-01-17 19:14:40.683000+00:00  pu: -1
    2021-01-17 19:14:40.692000+00:00  [   20.310577] <LAVA_SIGNAL_TESTCASE =
TEST_CASE_ID=3Demerg RESULT=3Dfail UNITS=3Dlines MEASUREMENT=3D2>   =

 =



platform             | arch   | lab             | compiler | defconfig     =
      | regressions
---------------------+--------+-----------------+----------+---------------=
------+------------
qemu_arm-versatilepb | arm    | lab-baylibre    | gcc-8    | versatile_defc=
onfig | 1          =


  Details:     https://kernelci.org/test/plan/id/60048af33dff80369cc94cc6

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
16-10-g1af529061f01/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qem=
u_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
16-10-g1af529061f01/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qem=
u_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60048af33dff80369cc94=
cc7
        failing since 64 days (last pass: v4.14.206-21-gf1262f26e4d0, first=
 fail: v4.14.206-23-g520c3568920c8) =

 =



platform             | arch   | lab             | compiler | defconfig     =
      | regressions
---------------------+--------+-----------------+----------+---------------=
------+------------
qemu_arm-versatilepb | arm    | lab-broonie     | gcc-8    | versatile_defc=
onfig | 1          =


  Details:     https://kernelci.org/test/plan/id/60048af26f8e071e5ec94cc8

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
16-10-g1af529061f01/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu=
_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
16-10-g1af529061f01/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu=
_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60048af26f8e071e5ec94=
cc9
        failing since 64 days (last pass: v4.14.206-21-gf1262f26e4d0, first=
 fail: v4.14.206-23-g520c3568920c8) =

 =



platform             | arch   | lab             | compiler | defconfig     =
      | regressions
---------------------+--------+-----------------+----------+---------------=
------+------------
qemu_arm-versatilepb | arm    | lab-cip         | gcc-8    | versatile_defc=
onfig | 1          =


  Details:     https://kernelci.org/test/plan/id/60048b2efd71be2be2c94cce

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
16-10-g1af529061f01/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm=
-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
16-10-g1af529061f01/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm=
-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60048b2efd71be2be2c94=
ccf
        failing since 64 days (last pass: v4.14.206-21-gf1262f26e4d0, first=
 fail: v4.14.206-23-g520c3568920c8) =

 =



platform             | arch   | lab             | compiler | defconfig     =
      | regressions
---------------------+--------+-----------------+----------+---------------=
------+------------
qemu_arm-versatilepb | arm    | lab-collabora   | gcc-8    | versatile_defc=
onfig | 1          =


  Details:     https://kernelci.org/test/plan/id/60048aaf1b02737a2bc94cc8

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
16-10-g1af529061f01/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qe=
mu_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
16-10-g1af529061f01/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qe=
mu_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60048aaf1b02737a2bc94=
cc9
        failing since 64 days (last pass: v4.14.206-21-gf1262f26e4d0, first=
 fail: v4.14.206-23-g520c3568920c8) =

 =



platform             | arch   | lab             | compiler | defconfig     =
      | regressions
---------------------+--------+-----------------+----------+---------------=
------+------------
qemu_arm-versatilepb | arm    | lab-linaro-lkft | gcc-8    | versatile_defc=
onfig | 1          =


  Details:     https://kernelci.org/test/plan/id/6004acde87623bb491c94cd6

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
16-10-g1af529061f01/arm/versatile_defconfig/gcc-8/lab-linaro-lkft/baseline-=
qemu_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
16-10-g1af529061f01/arm/versatile_defconfig/gcc-8/lab-linaro-lkft/baseline-=
qemu_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6004acde87623bb491c94=
cd7
        failing since 64 days (last pass: v4.14.206-21-gf1262f26e4d0, first=
 fail: v4.14.206-23-g520c3568920c8) =

 =



platform             | arch   | lab             | compiler | defconfig     =
      | regressions
---------------------+--------+-----------------+----------+---------------=
------+------------
qemu_i386            | i386   | lab-baylibre    | gcc-8    | i386_defconfig=
      | 1          =


  Details:     https://kernelci.org/test/plan/id/60048da4e6161a773dc94cd5

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: i386_defconfig
  Compiler:    gcc-8 (gcc (Debian 8.3.0-6) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
16-10-g1af529061f01/i386/i386_defconfig/gcc-8/lab-baylibre/baseline-qemu_i3=
86.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
16-10-g1af529061f01/i386/i386_defconfig/gcc-8/lab-baylibre/baseline-qemu_i3=
86.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/x86/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60048da4e6161a773dc94=
cd6
        new failure (last pass: v4.14.215-29-g4cfcf012355fc) =

 =



platform             | arch   | lab             | compiler | defconfig     =
      | regressions
---------------------+--------+-----------------+----------+---------------=
------+------------
qemu_x86_64-uefi     | x86_64 | lab-baylibre    | gcc-8    | x86_64_defconf=
ig    | 1          =


  Details:     https://kernelci.org/test/plan/id/60048c642e354c27bdc94cda

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig
  Compiler:    gcc-8 (gcc (Debian 8.3.0-6) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
16-10-g1af529061f01/x86_64/x86_64_defconfig/gcc-8/lab-baylibre/baseline-qem=
u_x86_64-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
16-10-g1af529061f01/x86_64/x86_64_defconfig/gcc-8/lab-baylibre/baseline-qem=
u_x86_64-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/x86/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60048c642e354c27bdc94=
cdb
        new failure (last pass: v4.14.215-29-g4cfcf012355fc) =

 =20
