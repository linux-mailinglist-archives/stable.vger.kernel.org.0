Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0BE003D7EB3
	for <lists+stable@lfdr.de>; Tue, 27 Jul 2021 21:51:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230382AbhG0TvO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Jul 2021 15:51:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38416 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229681AbhG0TvO (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 27 Jul 2021 15:51:14 -0400
Received: from mail-pl1-x62c.google.com (mail-pl1-x62c.google.com [IPv6:2607:f8b0:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6A189C061757
        for <stable@vger.kernel.org>; Tue, 27 Jul 2021 12:51:13 -0700 (PDT)
Received: by mail-pl1-x62c.google.com with SMTP id q2so1590880plr.11
        for <stable@vger.kernel.org>; Tue, 27 Jul 2021 12:51:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=D4C8eYLcWHwbTBagpL5lX9k3DG+mVSNklhtk8zLiGg0=;
        b=k35+Gjw/N6gmwummOeDardMY+jdNYlYWJylxnhDrJWqo1B1TcP1KbRgyZfd1xiOEDn
         3D0l0NVI7Z8ehKYCAbj9aNsLvjPQQO8yzfUErKepBtRzpnuGKYw1hNBr/PflZGlbDa68
         Q3OHgGaU0Pa8hLyYuCoSDhl1Hd2CnAxUAuFnCjuN1OaMhUSF5S17iYpqs0oAiFqeqYMW
         q2OregiGuqxcyuC0hW9k+ro286XIjm0XRUMAUDOYdMYd32v9kGjBRAXh6NJWmmBb8IGt
         /OzRTqLw/OXGkoJ+HSDRnsd2hTURuVjV8jbYjkccSupfQjyMXAc7PQwvVQjNEqWZIHnS
         Er7g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=D4C8eYLcWHwbTBagpL5lX9k3DG+mVSNklhtk8zLiGg0=;
        b=NWfC9XUL1hbLcfuA5Yv6/bPDJ17i6M7eGSg6Trr7iadjj7xTfvt4X1ntnMUmeo9frm
         Hj5dSKJqYZdeKsaTtcDZq4w6SI4DYMtG0uKoD/cb0h/MkmQBKW8gPprqsYjWHRf3RSyB
         8tIavMPVmYgDqwStwpKACnaeFXm7IUngtxCgTnOqyeA6Dt8FJrGcsvfYc97WCUxenkE5
         2T1OHYW0ucurMamfA5qai4CA3dYmDBAkz93BRUx/wSe3o1Nsnr2VFmROzS5j4NELPC5M
         5LRIYgQ1aYQ5LETEHLh89DkvE5tICOk+eKWrU9STS1X3ryAeOMOlemZfHahFAJWdvEa5
         EkMQ==
X-Gm-Message-State: AOAM532kx9Am6M8Va7gKBwpQFtdKgy0E4MVSBLpH1S5LqTVCf0FQaKKw
        zfnvvMcAFal50/6rB9N0PiFojAh85BB7f2Q1
X-Google-Smtp-Source: ABdhPJyA0GTkljqcZ/TzAdJpQEdCkMt2thrlQtrw+ZY2IO3j2+xUb83ZAJfEfhkYnrJdVtwHpglaBA==
X-Received: by 2002:a17:90b:1297:: with SMTP id fw23mr19763995pjb.115.1627415472762;
        Tue, 27 Jul 2021 12:51:12 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id i6sm4546898pfa.44.2021.07.27.12.51.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 27 Jul 2021 12:51:12 -0700 (PDT)
Message-ID: <610063b0.1c69fb81.46d63.e2c5@mx.google.com>
Date:   Tue, 27 Jul 2021 12:51:12 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/4.19
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v4.19.198-119-gcb4b8a3eedd5
Subject: stable-rc/queue/4.19 baseline: 162 runs,
 4 regressions (v4.19.198-119-gcb4b8a3eedd5)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.19 baseline: 162 runs, 4 regressions (v4.19.198-119-gcb4b=
8a3eedd5)

Regressions Summary
-------------------

platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-baylibre    | gcc-8    | versatile_defcon=
fig | 1          =

qemu_arm-versatilepb | arm  | lab-cip         | gcc-8    | versatile_defcon=
fig | 1          =

qemu_arm-versatilepb | arm  | lab-collabora   | gcc-8    | versatile_defcon=
fig | 1          =

qemu_arm-versatilepb | arm  | lab-linaro-lkft | gcc-8    | versatile_defcon=
fig | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.19/ker=
nel/v4.19.198-119-gcb4b8a3eedd5/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.19
  Describe: v4.19.198-119-gcb4b8a3eedd5
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      cb4b8a3eedd58d0db0c9bd492ae4de87041ae5d4 =



Test Regressions
---------------- =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-baylibre    | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/61002a1938dc90976a5018c1

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.198=
-119-gcb4b8a3eedd5/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu=
_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.198=
-119-gcb4b8a3eedd5/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu=
_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61002a1938dc90976a501=
8c2
        failing since 255 days (last pass: v4.19.157-26-gd59f3161b3a0, firs=
t fail: v4.19.157-27-g5543cc2c41d55) =

 =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-cip         | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/61002a1eda1b150a185018c4

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.198=
-119-gcb4b8a3eedd5/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-=
versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.198=
-119-gcb4b8a3eedd5/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-=
versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61002a1eda1b150a18501=
8c5
        failing since 255 days (last pass: v4.19.157-26-gd59f3161b3a0, firs=
t fail: v4.19.157-27-g5543cc2c41d55) =

 =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-collabora   | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/610029ff20adc836845018d7

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.198=
-119-gcb4b8a3eedd5/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qem=
u_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.198=
-119-gcb4b8a3eedd5/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qem=
u_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/610029ff20adc83684501=
8d8
        failing since 255 days (last pass: v4.19.157-26-gd59f3161b3a0, firs=
t fail: v4.19.157-27-g5543cc2c41d55) =

 =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-linaro-lkft | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/610029c309ae4a55885018c2

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.198=
-119-gcb4b8a3eedd5/arm/versatile_defconfig/gcc-8/lab-linaro-lkft/baseline-q=
emu_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.198=
-119-gcb4b8a3eedd5/arm/versatile_defconfig/gcc-8/lab-linaro-lkft/baseline-q=
emu_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/610029c309ae4a5588501=
8c3
        failing since 255 days (last pass: v4.19.157-26-gd59f3161b3a0, firs=
t fail: v4.19.157-27-g5543cc2c41d55) =

 =20
