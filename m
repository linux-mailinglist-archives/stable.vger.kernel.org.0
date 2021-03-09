Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 288A2331F6C
	for <lists+stable@lfdr.de>; Tue,  9 Mar 2021 07:41:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230046AbhCIGki (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 9 Mar 2021 01:40:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41584 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229527AbhCIGkM (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 9 Mar 2021 01:40:12 -0500
Received: from mail-pj1-x1035.google.com (mail-pj1-x1035.google.com [IPv6:2607:f8b0:4864:20::1035])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8B88FC06174A
        for <stable@vger.kernel.org>; Mon,  8 Mar 2021 22:40:12 -0800 (PST)
Received: by mail-pj1-x1035.google.com with SMTP id q22so204998pjd.0
        for <stable@vger.kernel.org>; Mon, 08 Mar 2021 22:40:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=woJL68x4Kc2ODRIFrPboTKMDAyV1c5URtFgs6vkvmVw=;
        b=jLQ8Jiix2vVY3DAkXIgpHJbro73x6PmVn18qKJrYIF4a6HlBF9RY+2aR6F9Tynx/O+
         mORlIHY22ZjL1jzRyUEEdbhODbGUSHvoYRoDNzt/f5LvKVX4mu+kN4VwuS584hb4um1h
         7lQeGzTLHxzwDMgXlscwWqh+Ab4npeZ8XmPatY4lnWuf4l3jsRuDHmZ+WC7cOjqIS7ti
         VtzipyfIDCtC5AY+ak39WINq2VlMsbgnEhZdylNyh5OYHOiMupeLPAEBIgL7MaR9B3FP
         kyqkApdAX+9bc+Paqdg7mRhG4HlUiLEjGXW/9pZ79lEXjQG+QZCPik+su2eoGGPUoO0p
         uupw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=woJL68x4Kc2ODRIFrPboTKMDAyV1c5URtFgs6vkvmVw=;
        b=JjkgmPP3uL45mhkShU5XZxU/bdBhvjue5Y69snHDAxU4pXztIkD9dIiWjBxdthlT2J
         4toO+PEOIgdsNRLMzkNshuUGZHS9Qz3FnjjSqedBhcMnekFmesMY/OAp71YtNuO4nFyu
         2cG1+I6khwbqLmH+AqdCXm2FCOyiMtNxmqQSXpE81xUS6UAlv+dLT3pvXb30TpzndkRV
         JF/67FhybcTOi8Y3STbe8zgo+YgR9ToHS1e8+BIAg3XM9lDdR4r6QfYZNCekqryHxz69
         t7lAHhrVGi04a8aP3/ZlkDEZX3T2psMgNYbwpxd7KLnu/PdSaxA4776mHwW5thNhsAZJ
         bJxw==
X-Gm-Message-State: AOAM532BdKiO7WI+qmcn9Fzab3wHTLBY0JRtLgfkmryq5E6OZt4qxB1Y
        +wxqbJ/61EdCKcLOE1kPGDkfCVWYZXEAwhEm
X-Google-Smtp-Source: ABdhPJzdTFV0qqITeN2Jz6xpHvoW47BJq9HWddr7x+qeemPfYYNJnqLMNWaIDbqXJwo747NXCh50JA==
X-Received: by 2002:a17:90a:314:: with SMTP id 20mr3189818pje.72.1615272011828;
        Mon, 08 Mar 2021 22:40:11 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id c16sm5547642pfc.112.2021.03.08.22.40.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 08 Mar 2021 22:40:11 -0800 (PST)
Message-ID: <6047184b.1c69fb81.342f9.d8f0@mx.google.com>
Date:   Mon, 08 Mar 2021 22:40:11 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.9.260-6-g7bc765dbe5c5b
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-4.9.y
Subject: stable-rc/linux-4.9.y baseline: 90 runs,
 4 regressions (v4.9.260-6-g7bc765dbe5c5b)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.9.y baseline: 90 runs, 4 regressions (v4.9.260-6-g7bc765d=
be5c5b)

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


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-4.9.y/kern=
el/v4.9.260-6-g7bc765dbe5c5b/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-4.9.y
  Describe: v4.9.260-6-g7bc765dbe5c5b
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      7bc765dbe5c5b43140b852049b85839ab429896e =



Test Regressions
---------------- =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-broonie     | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/6046ecd711b2a61865addcca

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.260=
-6-g7bc765dbe5c5b/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_a=
rm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.260=
-6-g7bc765dbe5c5b/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_a=
rm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6046ecd711b2a61865add=
ccb
        failing since 114 days (last pass: v4.9.243-17-g9c24315b745a0, firs=
t fail: v4.9.243-26-g7b603f689c1c) =

 =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-cip         | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/6046e8fff40a27f11eaddcc0

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.260=
-6-g7bc765dbe5c5b/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-v=
ersatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.260=
-6-g7bc765dbe5c5b/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-v=
ersatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6046e8fff40a27f11eadd=
cc1
        failing since 114 days (last pass: v4.9.243-17-g9c24315b745a0, firs=
t fail: v4.9.243-26-g7b603f689c1c) =

 =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-collabora   | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/6046e515db66daa325addd24

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.260=
-6-g7bc765dbe5c5b/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu=
_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.260=
-6-g7bc765dbe5c5b/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu=
_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6046e515db66daa325add=
d25
        failing since 114 days (last pass: v4.9.243-17-g9c24315b745a0, firs=
t fail: v4.9.243-26-g7b603f689c1c) =

 =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-linaro-lkft | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/6046e4e4fe55058473addcdd

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.260=
-6-g7bc765dbe5c5b/arm/versatile_defconfig/gcc-8/lab-linaro-lkft/baseline-qe=
mu_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.260=
-6-g7bc765dbe5c5b/arm/versatile_defconfig/gcc-8/lab-linaro-lkft/baseline-qe=
mu_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6046e4e4fe55058473add=
cde
        failing since 114 days (last pass: v4.9.243-17-g9c24315b745a0, firs=
t fail: v4.9.243-26-g7b603f689c1c) =

 =20
