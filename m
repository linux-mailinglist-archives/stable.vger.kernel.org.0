Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B8BD82DF046
	for <lists+stable@lfdr.de>; Sat, 19 Dec 2020 16:47:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726765AbgLSPqb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 19 Dec 2020 10:46:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37740 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726740AbgLSPqb (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 19 Dec 2020 10:46:31 -0500
Received: from mail-pl1-x632.google.com (mail-pl1-x632.google.com [IPv6:2607:f8b0:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5BDD7C0617B0
        for <stable@vger.kernel.org>; Sat, 19 Dec 2020 07:45:51 -0800 (PST)
Received: by mail-pl1-x632.google.com with SMTP id s2so3042586plr.9
        for <stable@vger.kernel.org>; Sat, 19 Dec 2020 07:45:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=ykoz1rdw39P0zYYYmeVjsZ6OvSRpfQ8POj29k3B//hg=;
        b=ZtqkpoOOIuJYZmhnwjysEHUP0YG1rS1Zl8aWfIz6D3+hFQdMIvMYM1IVnenuArK5K+
         lQxIPibW+ojBeobAXuCQVm3MU3a0PTG+ysLqFsNl0tDybLRMzAdBDZIqnXWCJMfKQ5D+
         ZJorJREDg3aVw2wzSMuJwOAys54aP5CDkn2rAyg92x24TH7dH5f5ggnXJxwuXmP8kuFR
         rPAbXOxTWJ8VU1WDW0p15mQ2mjBlzhLJOEw322Cyfh+d0yOTk8kPrjCR5M3v9J3w9LEQ
         avwg7lBRFGXmyP7IKIf/Xo53pjrHkOKe/AEQz4ePWRnq7nBgtBCLK44uE7GgXvv8uZuI
         xXjw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=ykoz1rdw39P0zYYYmeVjsZ6OvSRpfQ8POj29k3B//hg=;
        b=Xo15YANJpnLAFJRDrs4we5Ur50LxW/pqjZDROYkkHXEfmar4rXDOsW4C1BDA5siZnT
         bt1KDg3pXxrw4H9fz7KMCu2xPt5UWeFfvGfFcCuvCl9yRmtD0LJ99IoT38j3cKpnqDd9
         NL7LUct2qlY0AzbsaDenOfluYUV8i2WgYoSiQXCHtAnd9EhK9mX3yyq32X09qxfiwvAR
         H27Lxf13hTgmC6KTxNqUPOjP6e2/Xqk/842flbqS4H+itYUwX1qXwu7U63mxiorZ7Tea
         J7r+zB0BvI7UBZyW6JVSjEV0KgbRNqDe0Uewam6NbutfmcgjfQO/wQGg6CLVWtIuhEh/
         OSqg==
X-Gm-Message-State: AOAM530f0IO7q9a9iDc1gfmjZjpuxXF1dKkxSjnaOWe2j8v1pJeIq1b0
        NiSkc2LKmfCTnCgOgbsWIyyao9Vgq2/WAQ==
X-Google-Smtp-Source: ABdhPJxMo4Ie5c5Gnd+jx3ADQuSmWAEsCCjXsoptIl6W7XVHos8/y3e12LlW8kt2raEX3ERFPI/nyQ==
X-Received: by 2002:a17:90a:f40e:: with SMTP id ch14mr9412037pjb.172.1608392750544;
        Sat, 19 Dec 2020 07:45:50 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id mr7sm10212807pjb.31.2020.12.19.07.45.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 19 Dec 2020 07:45:49 -0800 (PST)
Message-ID: <5fde202d.1c69fb81.5a8bb.c501@mx.google.com>
Date:   Sat, 19 Dec 2020 07:45:49 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: queue/4.19
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v4.19.163-37-g6af0543972ee
X-Kernelci-Report-Type: test
Subject: stable-rc/queue/4.19 baseline: 147 runs,
 5 regressions (v4.19.163-37-g6af0543972ee)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.19 baseline: 147 runs, 5 regressions (v4.19.163-37-g6af05=
43972ee)

Regressions Summary
-------------------

platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
panda                | arm  | lab-collabora   | gcc-8    | omap2plus_defcon=
fig | 1          =

qemu_arm-versatilepb | arm  | lab-baylibre    | gcc-8    | versatile_defcon=
fig | 1          =

qemu_arm-versatilepb | arm  | lab-cip         | gcc-8    | versatile_defcon=
fig | 1          =

qemu_arm-versatilepb | arm  | lab-collabora   | gcc-8    | versatile_defcon=
fig | 1          =

qemu_arm-versatilepb | arm  | lab-linaro-lkft | gcc-8    | versatile_defcon=
fig | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.19/ker=
nel/v4.19.163-37-g6af0543972ee/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.19
  Describe: v4.19.163-37-g6af0543972ee
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      6af0543972ee2892463a4af8d89ece76f3dff176 =



Test Regressions
---------------- =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
panda                | arm  | lab-collabora   | gcc-8    | omap2plus_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/5fddecfaad1d93dab4c94cc4

  Results:     4 PASS, 1 FAIL, 0 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.163=
-37-g6af0543972ee/arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-pand=
a.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.163=
-37-g6af0543972ee/arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-pand=
a.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/5fddecfaad1d93d=
ab4c94cc9
        failing since 8 days (last pass: v4.19.162-27-g7042181619c5, first =
fail: v4.19.162-40-gbaa0b97cc4354)
        2 lines =

 =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-baylibre    | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/5fddeb6758ab5cc0bcc94ccf

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.163=
-37-g6af0543972ee/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_=
arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.163=
-37-g6af0543972ee/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_=
arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fddeb6758ab5cc0bcc94=
cd0
        failing since 35 days (last pass: v4.19.157-26-gd59f3161b3a0, first=
 fail: v4.19.157-27-g5543cc2c41d55) =

 =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-cip         | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/5fddeb625ba8a7712ac94cd5

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.163=
-37-g6af0543972ee/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-v=
ersatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.163=
-37-g6af0543972ee/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-v=
ersatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fddeb625ba8a7712ac94=
cd6
        failing since 35 days (last pass: v4.19.157-26-gd59f3161b3a0, first=
 fail: v4.19.157-27-g5543cc2c41d55) =

 =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-collabora   | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/5fddeb1315fd1e5890c94cdf

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.163=
-37-g6af0543972ee/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu=
_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.163=
-37-g6af0543972ee/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu=
_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fddeb1315fd1e5890c94=
ce0
        failing since 35 days (last pass: v4.19.157-26-gd59f3161b3a0, first=
 fail: v4.19.157-27-g5543cc2c41d55) =

 =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-linaro-lkft | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/5fddeb29c60e7e3d3bc94cfa

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.163=
-37-g6af0543972ee/arm/versatile_defconfig/gcc-8/lab-linaro-lkft/baseline-qe=
mu_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.163=
-37-g6af0543972ee/arm/versatile_defconfig/gcc-8/lab-linaro-lkft/baseline-qe=
mu_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fddeb29c60e7e3d3bc94=
cfb
        failing since 35 days (last pass: v4.19.157-26-gd59f3161b3a0, first=
 fail: v4.19.157-27-g5543cc2c41d55) =

 =20
