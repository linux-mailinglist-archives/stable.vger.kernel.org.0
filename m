Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6698330CCF8
	for <lists+stable@lfdr.de>; Tue,  2 Feb 2021 21:23:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232933AbhBBUW6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 2 Feb 2021 15:22:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46892 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233243AbhBBUUx (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 2 Feb 2021 15:20:53 -0500
Received: from mail-pg1-x529.google.com (mail-pg1-x529.google.com [IPv6:2607:f8b0:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D67ADC06174A
        for <stable@vger.kernel.org>; Tue,  2 Feb 2021 12:20:10 -0800 (PST)
Received: by mail-pg1-x529.google.com with SMTP id c132so15662757pga.3
        for <stable@vger.kernel.org>; Tue, 02 Feb 2021 12:20:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=cUWrlC8bmu/AJsOrVlGdGKn0pDj0jJuvZngGxrVG7es=;
        b=1L+yUiztnKi/ziuSkR4MnQZuDjb2Zx6qsYT+9JErkApGqgi3bYCfBRt+kzFrtmkGso
         STnTruMNbyMVXVvU3GaHdBDqJ0SS3rRJpe25hc3oDEuK7Mse7rPPLZveKDsur3hao5Nz
         U5lBy3mvWeybQYZLUhBbXJ5A4e3SKfs/i0GZnuK6wgSiYhDC0Puc5NAVh5xHbWAoOc6s
         o5Fi7mlDSJXlHeVHIUB/VjsT/mHqYBM0Ln8CD1tL4j8TvkyDKp19oa2oei5lS9J/6tKj
         hYFUyFKGRuiO6rLM27bd+Gcf33a6/tysLL/tH1zRdW6iRwSzMi2XKhmn9sHZ/2uLSain
         kh1A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=cUWrlC8bmu/AJsOrVlGdGKn0pDj0jJuvZngGxrVG7es=;
        b=a8gzLMqpBIw0G+hXpirfVMRTqKcoALuvvAZL8YZppjluqJqqf4mDBAq7LitqB3sD+6
         vROMIZRyk3PZORDRKF7wGaZa4foycFsMw/3A11V5jYxXFvkcxHmtFUsuTUBiwd80GLWJ
         GIA0LhWXRoOBoZ1r33M1JIzZ/7Lg1IdcEkswWAyhVzZSYI60u4YPeZUe39zvHBPg3smP
         Kwjq18G3cMg1ivToJqnQUYkPGSECCDWVDnXgHkG3kw6nyui/8sXsX01oqzkL5kD9/isw
         9VHUEoPmHEO+bxUnSy3jv8NKxr8kV6n+0YfTPk7oSN+5Ij6qn7rxXXSyuBCYpJAgxtqT
         AOlQ==
X-Gm-Message-State: AOAM5303OWj9qGT7BQRPsRnByBCZu417YPgLBV0ReQb9PayY2ZeD/mZe
        DzEFhE4ssDSuzJriFwRZXtXF+LX+t0Z0QA==
X-Google-Smtp-Source: ABdhPJwk8Sep5axbdxfEMnwqpDq8wxkNWWAgeQVJ8OjsDyvy1KbKyL83xNfsLH+gQhX+l6BrG0xlUg==
X-Received: by 2002:a63:78ca:: with SMTP id t193mr24002684pgc.391.1612297210135;
        Tue, 02 Feb 2021 12:20:10 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id r194sm22785492pfr.168.2021.02.02.12.20.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 02 Feb 2021 12:20:09 -0800 (PST)
Message-ID: <6019b3f9.1c69fb81.8857e.5570@mx.google.com>
Date:   Tue, 02 Feb 2021 12:20:09 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v4.19.172-37-g4afd0e1db22a
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/4.19
Subject: stable-rc/queue/4.19 baseline: 167 runs,
 5 regressions (v4.19.172-37-g4afd0e1db22a)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.19 baseline: 167 runs, 5 regressions (v4.19.172-37-g4afd0=
e1db22a)

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


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.19/ker=
nel/v4.19.172-37-g4afd0e1db22a/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.19
  Describe: v4.19.172-37-g4afd0e1db22a
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      4afd0e1db22a0345875ac93748bca5c083d77ea8 =



Test Regressions
---------------- =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-baylibre    | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/60197c0e9704a72ca43abe65

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.172=
-37-g4afd0e1db22a/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_=
arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.172=
-37-g4afd0e1db22a/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_=
arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60197c0e9704a72ca43ab=
e66
        failing since 80 days (last pass: v4.19.157-26-gd59f3161b3a0, first=
 fail: v4.19.157-27-g5543cc2c41d55) =

 =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-broonie     | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/60197bf907d767cd593abe83

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.172=
-37-g4afd0e1db22a/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_a=
rm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.172=
-37-g4afd0e1db22a/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_a=
rm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60197bf907d767cd593ab=
e84
        failing since 80 days (last pass: v4.19.157-26-gd59f3161b3a0, first=
 fail: v4.19.157-27-g5543cc2c41d55) =

 =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-cip         | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/60197c061dad7136a23abe63

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.172=
-37-g4afd0e1db22a/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-v=
ersatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.172=
-37-g4afd0e1db22a/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-v=
ersatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60197c061dad7136a23ab=
e64
        failing since 80 days (last pass: v4.19.157-26-gd59f3161b3a0, first=
 fail: v4.19.157-27-g5543cc2c41d55) =

 =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-collabora   | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/60197bb2b0d6fb10843abe8f

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.172=
-37-g4afd0e1db22a/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu=
_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.172=
-37-g4afd0e1db22a/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu=
_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60197bb2b0d6fb10843ab=
e90
        failing since 80 days (last pass: v4.19.157-26-gd59f3161b3a0, first=
 fail: v4.19.157-27-g5543cc2c41d55) =

 =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-linaro-lkft | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/6019adb11c0320f0b83abe6a

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.172=
-37-g4afd0e1db22a/arm/versatile_defconfig/gcc-8/lab-linaro-lkft/baseline-qe=
mu_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.172=
-37-g4afd0e1db22a/arm/versatile_defconfig/gcc-8/lab-linaro-lkft/baseline-qe=
mu_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6019adb11c0320f0b83ab=
e6b
        failing since 80 days (last pass: v4.19.157-26-gd59f3161b3a0, first=
 fail: v4.19.157-27-g5543cc2c41d55) =

 =20
