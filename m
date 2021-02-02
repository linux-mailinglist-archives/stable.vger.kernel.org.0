Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 59D5830BA7B
	for <lists+stable@lfdr.de>; Tue,  2 Feb 2021 10:01:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232553AbhBBI7Y (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 2 Feb 2021 03:59:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41122 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232517AbhBBI7S (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 2 Feb 2021 03:59:18 -0500
Received: from mail-pg1-x52d.google.com (mail-pg1-x52d.google.com [IPv6:2607:f8b0:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 76FC0C06178C
        for <stable@vger.kernel.org>; Tue,  2 Feb 2021 00:58:00 -0800 (PST)
Received: by mail-pg1-x52d.google.com with SMTP id o16so14472820pgg.5
        for <stable@vger.kernel.org>; Tue, 02 Feb 2021 00:58:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=igKTlVgaYkSU0Lppw4bklwu8y62al00SDxoQW7HuTYo=;
        b=PB200EiP5k9zGFHEgVNcW1JxuDLpQn8/ljkIIkmoEtL73DYswZ62oGsDxeDP5rVjC6
         M5xQVCCvDUEms08bWgdQvDjBa5ePd534XXPT+DdfwZLcZCfetwJ4jRIeXm/gjmVFwMth
         0Vcyo5EvBUzvdzTApjvSWopow0VaePr6e+A0DHCC28Ms7NHyoNtqQ3rAisgOV1P40dpO
         rbe3IgfwG7AraEpHEw/OJ+gg4L4d/uA4wx9AoXdbqrWJSZoki2/+IZCQSn5EIxHcX+mO
         u/ZTdBaiqlLoSOVnCt5aXFoo275Ul2L3srr4v78vA1z3U04fzZb9JROhCCcXajhbO9Md
         3v7Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=igKTlVgaYkSU0Lppw4bklwu8y62al00SDxoQW7HuTYo=;
        b=lizJBkbRLgqlMkwSfdi7xmXtbwEr/fpWwM6iFsOYQsV5XXVXPTcv8GZTyDFslr4qW4
         Elquf+h0Qtn+ARvXg37juBS91UKfESE14OTg6IOIcFEHLzIOaeoDHyudo2hw/yy0w7GZ
         Lvw9d+GBDMUmJfZ0Bfep4F3OfKi1JPELNSiCe6lhJkJQbXo7byoPx6tD8BpVASb+7drG
         s7RmOTw7EzNBk9s8D6ndvgOfW4M+83gpRmlHbnK18dMa5s85Dus7TImFFIuMdV6srZq+
         JPh/hkT/SWP6Go0Re6dJ4Y73a3QKRKUHroPb9cWh1ktan37Enhv426Lyrj8IrwQUpkrP
         LIBw==
X-Gm-Message-State: AOAM532n1/wOukSrithW+Fp59UfWBM4asagVGnmi7e6kdReeyKIfxQ5D
        g6URsiMXwEGo7STQH4t/jKXMnGnKWgZ7vg==
X-Google-Smtp-Source: ABdhPJzEdHVEDtE/0x4Y9rEo/J8L5YkUXrMvOTKIl3+hV3+efJHLdi5eGTT1m92Ui8EEB7IP7uNNig==
X-Received: by 2002:a05:6a00:8d0:b029:1b6:3581:4f41 with SMTP id s16-20020a056a0008d0b02901b635814f41mr19903378pfu.56.1612256279731;
        Tue, 02 Feb 2021 00:57:59 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id 145sm22089811pge.88.2021.02.02.00.57.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 02 Feb 2021 00:57:56 -0800 (PST)
Message-ID: <60191414.1c69fb81.1d436.41fd@mx.google.com>
Date:   Tue, 02 Feb 2021 00:57:56 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v4.19.172-22-gabf72a457de5b
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-4.19.y
Subject: stable-rc/linux-4.19.y baseline: 158 runs,
 5 regressions (v4.19.172-22-gabf72a457de5b)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.19.y baseline: 158 runs, 5 regressions (v4.19.172-22-gabf=
72a457de5b)

Regressions Summary
-------------------

platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
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


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-4.19.y/ker=
nel/v4.19.172-22-gabf72a457de5b/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-4.19.y
  Describe: v4.19.172-22-gabf72a457de5b
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      abf72a457de5b6331e913125891a625badbf8f29 =



Test Regressions
---------------- =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-baylibre    | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/6018a1a1bb937ebfd6d3e028

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.1=
72-22-gabf72a457de5b/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qe=
mu_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.1=
72-22-gabf72a457de5b/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qe=
mu_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6018a1a1bb937ebfd6d3e=
029
        failing since 75 days (last pass: v4.19.157-26-ga8e7fec1fea1, first=
 fail: v4.19.157-102-g1d674327c1b7) =

 =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-broonie     | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/6018a7dc53c586f9ded3dfd0

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.1=
72-22-gabf72a457de5b/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qem=
u_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.1=
72-22-gabf72a457de5b/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qem=
u_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6018a7dc53c586f9ded3d=
fd1
        failing since 75 days (last pass: v4.19.157-26-ga8e7fec1fea1, first=
 fail: v4.19.157-102-g1d674327c1b7) =

 =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-cip         | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/6018a18d8d45a248fad3dfdf

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.1=
72-22-gabf72a457de5b/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_ar=
m-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.1=
72-22-gabf72a457de5b/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_ar=
m-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6018a18d8d45a248fad3d=
fe0
        failing since 75 days (last pass: v4.19.157-26-ga8e7fec1fea1, first=
 fail: v4.19.157-102-g1d674327c1b7) =

 =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-collabora   | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/6018a165831e765c6cd3e025

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.1=
72-22-gabf72a457de5b/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-q=
emu_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.1=
72-22-gabf72a457de5b/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-q=
emu_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6018a165831e765c6cd3e=
026
        failing since 75 days (last pass: v4.19.157-26-ga8e7fec1fea1, first=
 fail: v4.19.157-102-g1d674327c1b7) =

 =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-linaro-lkft | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/6018b3d60b99a8631ed3dfe0

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.1=
72-22-gabf72a457de5b/arm/versatile_defconfig/gcc-8/lab-linaro-lkft/baseline=
-qemu_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.1=
72-22-gabf72a457de5b/arm/versatile_defconfig/gcc-8/lab-linaro-lkft/baseline=
-qemu_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6018b3d60b99a8631ed3d=
fe1
        failing since 75 days (last pass: v4.19.157-26-ga8e7fec1fea1, first=
 fail: v4.19.157-102-g1d674327c1b7) =

 =20
