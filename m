Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0BF8234D7BF
	for <lists+stable@lfdr.de>; Mon, 29 Mar 2021 21:06:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230359AbhC2TFx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Mar 2021 15:05:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48758 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230122AbhC2TFU (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 29 Mar 2021 15:05:20 -0400
Received: from mail-pf1-x42f.google.com (mail-pf1-x42f.google.com [IPv6:2607:f8b0:4864:20::42f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3CD93C061574
        for <stable@vger.kernel.org>; Mon, 29 Mar 2021 12:05:20 -0700 (PDT)
Received: by mail-pf1-x42f.google.com with SMTP id l123so10469700pfl.8
        for <stable@vger.kernel.org>; Mon, 29 Mar 2021 12:05:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=v9dqqGCDyFrZqFqIqWpVaydIthXxJtFNunZgXkcHebc=;
        b=ZCsfsNppmgf5r/pxj7YuseeNn3nvt5ETX/2+QYo9w+V9OIHQcAl5weEj42rPER+nkw
         Z20Bw/OCdyQ/Nnz+Bmd060ER2HcuTKxOX1uY3tjcpFtdJmQJmyVF0RtfMcMu7K+eGh+U
         vxIHiIo1UCRe1D8ZVQvWYQJZrGVe3ZundVg/2YEcjLQ1miQJe6LJQpFmhbHH7V7/pH9G
         XGoFF/Q1Zvr7vO9ed72BkaY/ySt0EN0w6m5c4fmyDLiBdiGUHB/1a59UfeZ3d9mKsCwy
         rl5br5w95UTiv1toxkAcjJ9N8/tNy3tMqFy6Ak9IsvG+IClDRUjBuT/owW7I2nv2wOs2
         e+bQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=v9dqqGCDyFrZqFqIqWpVaydIthXxJtFNunZgXkcHebc=;
        b=LeecHwsymJVFhOlPhWzizR64XKJUJRB+3D8UXDi3xvsnLOVCDZr8Ux3H2X0VCHzuue
         2YOaWfNwF+GMrT4IIrOALcExTDWMW6g4mBXaYk2lSCnWVIazH1LoeY91oBrkNcGNKYt3
         ftLiJqLtPdo37Sgd2fYKDfCVbMfdSP8vE0moKbOnHKNspGoRa6PrvBTj8HHI3FVMGXdu
         YBYhA/bU3jo/J0d/yxn2+9s2Yz+vbP1SXSRW7aMPrVFIknU4awLze5ZR838zMaDVk1Zv
         zcRFKJTHBtzpKX67Dn12dmTXSdviTUtFFzPfESd0klv7zOwj453fw+3ut5mnli7z/3fE
         YxgQ==
X-Gm-Message-State: AOAM532N9/TDQjxxyprv9IPqMraB6r+4TkYqyBjUpvgc2IlzfippUVon
        lq7RWqynYIVUb41XCF7K2ZLjWagZlmoF/1Sb
X-Google-Smtp-Source: ABdhPJz5kz2775Rjw/xSj5J578IwWJ4/bw7MrulzPJig/npDHbRbqGFtMiQAmCnoKPv1kMWP6krqDw==
X-Received: by 2002:a63:e713:: with SMTP id b19mr25355028pgi.425.1617044719055;
        Mon, 29 Mar 2021 12:05:19 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id a13sm16487459pgm.43.2021.03.29.12.05.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 29 Mar 2021 12:05:18 -0700 (PDT)
Message-ID: <606224ee.1c69fb81.2d97f.8d4b@mx.google.com>
Date:   Mon, 29 Mar 2021 12:05:18 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v5.4.108-112-g7b78fa4bf15f0
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-5.4.y
Subject: stable-rc/linux-5.4.y baseline: 160 runs,
 5 regressions (v5.4.108-112-g7b78fa4bf15f0)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-5.4.y baseline: 160 runs, 5 regressions (v5.4.108-112-g7b78=
fa4bf15f0)

Regressions Summary
-------------------

platform             | arch  | lab           | compiler | defconfig        =
   | regressions
---------------------+-------+---------------+----------+------------------=
---+------------
hifive-unleashed-a00 | riscv | lab-baylibre  | gcc-8    | defconfig        =
   | 1          =

qemu_arm-versatilepb | arm   | lab-baylibre  | gcc-8    | versatile_defconf=
ig | 1          =

qemu_arm-versatilepb | arm   | lab-broonie   | gcc-8    | versatile_defconf=
ig | 1          =

qemu_arm-versatilepb | arm   | lab-cip       | gcc-8    | versatile_defconf=
ig | 1          =

qemu_arm-versatilepb | arm   | lab-collabora | gcc-8    | versatile_defconf=
ig | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-5.4.y/kern=
el/v5.4.108-112-g7b78fa4bf15f0/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-5.4.y
  Describe: v5.4.108-112-g7b78fa4bf15f0
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      7b78fa4bf15f02997c4dba22fe2bf2ca8aa9906f =



Test Regressions
---------------- =



platform             | arch  | lab           | compiler | defconfig        =
   | regressions
---------------------+-------+---------------+----------+------------------=
---+------------
hifive-unleashed-a00 | riscv | lab-baylibre  | gcc-8    | defconfig        =
   | 1          =


  Details:     https://kernelci.org/test/plan/id/6061eed1e75476daa4af02bc

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (riscv64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.108=
-112-g7b78fa4bf15f0/riscv/defconfig/gcc-8/lab-baylibre/baseline-hifive-unle=
ashed-a00.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.108=
-112-g7b78fa4bf15f0/riscv/defconfig/gcc-8/lab-baylibre/baseline-hifive-unle=
ashed-a00.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/riscv/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6061eed1e75476daa4af0=
2bd
        failing since 129 days (last pass: v5.4.77-152-ga3746663c3479, firs=
t fail: v5.4.78) =

 =



platform             | arch  | lab           | compiler | defconfig        =
   | regressions
---------------------+-------+---------------+----------+------------------=
---+------------
qemu_arm-versatilepb | arm   | lab-baylibre  | gcc-8    | versatile_defconf=
ig | 1          =


  Details:     https://kernelci.org/test/plan/id/6061ef11ab0a1dd13faf02b2

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.108=
-112-g7b78fa4bf15f0/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qem=
u_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.108=
-112-g7b78fa4bf15f0/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qem=
u_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6061ef11ab0a1dd13faf0=
2b3
        failing since 134 days (last pass: v5.4.77-44-g28fe0e171c204, first=
 fail: v5.4.77-46-ga3e34830d912) =

 =



platform             | arch  | lab           | compiler | defconfig        =
   | regressions
---------------------+-------+---------------+----------+------------------=
---+------------
qemu_arm-versatilepb | arm   | lab-broonie   | gcc-8    | versatile_defconf=
ig | 1          =


  Details:     https://kernelci.org/test/plan/id/6061eef65794fbb3f8af02bf

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.108=
-112-g7b78fa4bf15f0/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu=
_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.108=
-112-g7b78fa4bf15f0/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu=
_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6061eef65794fbb3f8af0=
2c0
        failing since 134 days (last pass: v5.4.77-44-g28fe0e171c204, first=
 fail: v5.4.77-46-ga3e34830d912) =

 =



platform             | arch  | lab           | compiler | defconfig        =
   | regressions
---------------------+-------+---------------+----------+------------------=
---+------------
qemu_arm-versatilepb | arm   | lab-cip       | gcc-8    | versatile_defconf=
ig | 1          =


  Details:     https://kernelci.org/test/plan/id/6061ef04665910c864af02b0

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.108=
-112-g7b78fa4bf15f0/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm=
-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.108=
-112-g7b78fa4bf15f0/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm=
-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6061ef04665910c864af0=
2b1
        failing since 134 days (last pass: v5.4.77-44-g28fe0e171c204, first=
 fail: v5.4.77-46-ga3e34830d912) =

 =



platform             | arch  | lab           | compiler | defconfig        =
   | regressions
---------------------+-------+---------------+----------+------------------=
---+------------
qemu_arm-versatilepb | arm   | lab-collabora | gcc-8    | versatile_defconf=
ig | 1          =


  Details:     https://kernelci.org/test/plan/id/6062112c06dcf20439af02dd

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.108=
-112-g7b78fa4bf15f0/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qe=
mu_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.108=
-112-g7b78fa4bf15f0/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qe=
mu_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6062112c06dcf20439af0=
2de
        failing since 134 days (last pass: v5.4.77-44-g28fe0e171c204, first=
 fail: v5.4.77-46-ga3e34830d912) =

 =20
