Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D4AFE331807
	for <lists+stable@lfdr.de>; Mon,  8 Mar 2021 21:01:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231657AbhCHUAx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 8 Mar 2021 15:00:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44622 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231571AbhCHUAq (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 8 Mar 2021 15:00:46 -0500
Received: from mail-pf1-x42a.google.com (mail-pf1-x42a.google.com [IPv6:2607:f8b0:4864:20::42a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BAC2FC06174A
        for <stable@vger.kernel.org>; Mon,  8 Mar 2021 12:00:46 -0800 (PST)
Received: by mail-pf1-x42a.google.com with SMTP id l7so7932681pfd.3
        for <stable@vger.kernel.org>; Mon, 08 Mar 2021 12:00:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=a7lPLR9Lm0kUcnho2wUgVkkc0avWNRvFUM8NO15lyU8=;
        b=pvuVlKTJ9gRuovwj+/8+xMTzLkLmTTbPNi/c0fKPU/GjWJvaxm5LiDwr7xKJJ4gffw
         DPoPpse3X6AzTdF6NKUUbiqvi4gePodss+7PXFTl8lrNbHniAbfU5vDbmpDnYm5QV9dN
         vm99WTYPIxtuzrvgwc9j01YL/JFiBgTcSBxWXOi27tsJPL7nMmUpHGnRz7ncnLMf1IVH
         UI39lz8P0Ah+IrC4lwkyMjayOrGtFg/67rB2CIBeCP4P6Z8Lv1lQuPEEg8FAIQ6ArFp8
         9/OLUTbBzucnpDjRBKpJqmSslYu9xb2vNvrGDMBZxD9mX4EdhbqdfAITg3wEFJLBW6oK
         s38w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=a7lPLR9Lm0kUcnho2wUgVkkc0avWNRvFUM8NO15lyU8=;
        b=p6+qsdvPk9kHRhdButlonnVAa73fwa+JLXsOm4f4k/R1esSHBim2KJeNW+qrquyh1L
         pVTgc8LnltI6ATZ3OL4+164aIWF8UFslQQeMoUUR0Yx7XrL4rLJg2LSwOboeBR/NYqP/
         SxvCppUFLhrLTRlJMw4E/Op1yCJZt1cufQBmvvzJcRDg1RTSlWVwKGCvlx5uKfEWWbPQ
         JqcpU0ZufmP5/xWb/TeKH9EvmXBfcDEZ8UxKp/X3ZTAk2TkSR26M0KkfhdnuyjP6C5qI
         g2nZFJ+nP5Gk+e7knjgesPGi3QkrrJvGxou2vMJWG7wR53+MYa8ZCh3OqXCaTq80FOQl
         GVww==
X-Gm-Message-State: AOAM533IqIvMxFG2o/LzlkW029MBJhh7azjLCrcN8cWnJryZRgbdg/t3
        yl7rRw3RT9c1sfKZUooPsa5psHa7HUpa8bHL
X-Google-Smtp-Source: ABdhPJxeHaAi9+TMTubRRTG/WOeeyyBQDYTOBZFba5oTmvjkGhd/UL6BIoCvf6p4+Vde+Xxxsdfmyw==
X-Received: by 2002:a63:cd09:: with SMTP id i9mr22361654pgg.407.1615233646133;
        Mon, 08 Mar 2021 12:00:46 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id 35sm10181009pgr.14.2021.03.08.12.00.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 08 Mar 2021 12:00:45 -0800 (PST)
Message-ID: <6046826d.1c69fb81.11433.82a3@mx.google.com>
Date:   Mon, 08 Mar 2021 12:00:45 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.19.179-21-gf762c2b38d8c
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-4.19.y
Subject: stable-rc/linux-4.19.y baseline: 106 runs,
 4 regressions (v4.19.179-21-gf762c2b38d8c)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.19.y baseline: 106 runs, 4 regressions (v4.19.179-21-gf76=
2c2b38d8c)

Regressions Summary
-------------------

platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-broonie     | gcc-8    | versatile_defcon=
fig | 1          =

qemu_arm-versatilepb | arm  | lab-cip         | gcc-8    | versatile_defcon=
fig | 1          =

qemu_arm-versatilepb | arm  | lab-collabora   | gcc-8    | versatile_defcon=
fig | 1          =

qemu_arm-versatilepb | arm  | lab-linaro-lkft | gcc-8    | versatile_defcon=
fig | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-4.19.y/ker=
nel/v4.19.179-21-gf762c2b38d8c/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-4.19.y
  Describe: v4.19.179-21-gf762c2b38d8c
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      f762c2b38d8c35bbff24048b06b88be5f46bddbe =



Test Regressions
---------------- =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-broonie     | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/60464cb122b0e5f112addcb8

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.1=
79-21-gf762c2b38d8c/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu=
_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.1=
79-21-gf762c2b38d8c/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu=
_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60464cb122b0e5f112add=
cb9
        failing since 110 days (last pass: v4.19.157-26-ga8e7fec1fea1, firs=
t fail: v4.19.157-102-g1d674327c1b7) =

 =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-cip         | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/60464c9a02589148eeaddcc0

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.1=
79-21-gf762c2b38d8c/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm=
-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.1=
79-21-gf762c2b38d8c/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm=
-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60464c9a02589148eeadd=
cc1
        failing since 110 days (last pass: v4.19.157-26-ga8e7fec1fea1, firs=
t fail: v4.19.157-102-g1d674327c1b7) =

 =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-collabora   | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/60464c5a98f33f2dcbaddcdb

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.1=
79-21-gf762c2b38d8c/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qe=
mu_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.1=
79-21-gf762c2b38d8c/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qe=
mu_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60464c5a98f33f2dcbadd=
cdc
        failing since 110 days (last pass: v4.19.157-26-ga8e7fec1fea1, firs=
t fail: v4.19.157-102-g1d674327c1b7) =

 =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-linaro-lkft | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/604680a901dbee08ddaddcb1

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.1=
79-21-gf762c2b38d8c/arm/versatile_defconfig/gcc-8/lab-linaro-lkft/baseline-=
qemu_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.1=
79-21-gf762c2b38d8c/arm/versatile_defconfig/gcc-8/lab-linaro-lkft/baseline-=
qemu_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/604680a901dbee08ddadd=
cb2
        failing since 110 days (last pass: v4.19.157-26-ga8e7fec1fea1, firs=
t fail: v4.19.157-102-g1d674327c1b7) =

 =20
