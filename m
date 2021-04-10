Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4BAEE35AF12
	for <lists+stable@lfdr.de>; Sat, 10 Apr 2021 18:37:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234668AbhDJQiC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 10 Apr 2021 12:38:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55900 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234392AbhDJQiC (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 10 Apr 2021 12:38:02 -0400
Received: from mail-pg1-x529.google.com (mail-pg1-x529.google.com [IPv6:2607:f8b0:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C0CA4C06138A
        for <stable@vger.kernel.org>; Sat, 10 Apr 2021 09:37:47 -0700 (PDT)
Received: by mail-pg1-x529.google.com with SMTP id f29so6116675pgm.8
        for <stable@vger.kernel.org>; Sat, 10 Apr 2021 09:37:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=tWXxaejOQsE37ELoYqJPVd0cLW7oVjsyLB81np6ib4s=;
        b=wq4JrS+oiyoXYzkSDvCS4/oRtWocOxMVQcdZEmFawd30ycMn8CoqwDJ3LxuPi9erms
         MOArPfQa78In19cqnsjw9TWVjlxn5EY4HCYceiHhYEPCyVnVFbu3P2jWyOS1MT6WWyms
         Dp41j2a8woUNtNDjCrKCqz8wZjoe0jJqqf254W7m6GXJTbGySrOdeYBc4P9ZfzSLkeLf
         GClouUyiD0QQnC3hM4xKVeYWth+oZCiYYoB0g5QR/ztcLkRNUI3V055UYlA7Hy4JU4zt
         tuGxct8pgDE2a8RIaq3TfSYDWLjTsXxTEH7G+NHmN0cguCEPKmMDf1/Imzav6Mzppv+d
         7N1w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=tWXxaejOQsE37ELoYqJPVd0cLW7oVjsyLB81np6ib4s=;
        b=tJW++3GPFsi4Ak6q2xEFpdezrB+H+1VUnX9LqgBtEG3xrE2yZf2KKM8NTmu75LMH8h
         g4DiCwjBfG5JkzFCEj0KKuk86w5dJrYO0d2m0Jfgeql19NQilL7HyS1rMjU1Vit4yg8N
         0SLocu//MOyF3+yLRleeX91imnxL5rOrnCkumDpT1EEPX9Yyz2TWrEG9CATH6CYhEwIn
         6SM8jP0mNmu+JZfcmtRIsPCEqhWhOGrN06iYIWhCSgPl5gfapx+Adxyh/ZuQqBEca9aQ
         nG0IPfcwargj1xDrDJTvg9WlOXbRcaEb6wxDVd6a7VMD47NpdbdXRaH2qIfE0RHpmKuC
         u9oA==
X-Gm-Message-State: AOAM530ngpeb1mLXrTBWCfW02fND2zekzW3znZFpHDFhA4wybazxgg73
        mvGFCIvzNdTavQ9cQFxNPZCTpuHH+ePsHMyR
X-Google-Smtp-Source: ABdhPJxEgWLM9QF2idatC9MMu63e93MWG22AAjHfFAqfvOMT7EKisVg9+onTE193iWZy81NqvzwE2w==
X-Received: by 2002:a63:d242:: with SMTP id t2mr18314654pgi.431.1618072666873;
        Sat, 10 Apr 2021 09:37:46 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id 205sm5410098pfc.201.2021.04.10.09.37.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 10 Apr 2021 09:37:46 -0700 (PDT)
Message-ID: <6071d45a.1c69fb81.bcee1.da40@mx.google.com>
Date:   Sat, 10 Apr 2021 09:37:46 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v4.14.230
X-Kernelci-Branch: linux-4.14.y
X-Kernelci-Tree: stable
Subject: stable/linux-4.14.y baseline: 96 runs, 6 regressions (v4.14.230)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable/linux-4.14.y baseline: 96 runs, 6 regressions (v4.14.230)

Regressions Summary
-------------------

platform             | arch   | lab             | compiler | defconfig     =
      | regressions
---------------------+--------+-----------------+----------+---------------=
------+------------
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

qemu_x86_64-uefi     | x86_64 | lab-broonie     | gcc-8    | x86_64_defconf=
ig    | 1          =


  Details:  https://kernelci.org/test/job/stable/branch/linux-4.14.y/kernel=
/v4.14.230/plan/baseline/

  Test:     baseline
  Tree:     stable
  Branch:   linux-4.14.y
  Describe: v4.14.230
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able.git
  SHA:      958e517f4e16952e9a2e2d58fd32d28ae4e23dda =



Test Regressions
---------------- =



platform             | arch   | lab             | compiler | defconfig     =
      | regressions
---------------------+--------+-----------------+----------+---------------=
------+------------
qemu_arm-versatilepb | arm    | lab-baylibre    | gcc-8    | versatile_defc=
onfig | 1          =


  Details:     https://kernelci.org/test/plan/id/6071975531373fa59edac6b1

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable/linux-4.14.y/v4.14.230/=
arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.14.y/v4.14.230/=
arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_arm-versatilepb.ht=
ml
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6071975531373fa59edac=
6b2
        failing since 142 days (last pass: v4.14.206, first fail: v4.14.207=
) =

 =



platform             | arch   | lab             | compiler | defconfig     =
      | regressions
---------------------+--------+-----------------+----------+---------------=
------+------------
qemu_arm-versatilepb | arm    | lab-broonie     | gcc-8    | versatile_defc=
onfig | 1          =


  Details:     https://kernelci.org/test/plan/id/6071976431373fa59edac72b

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable/linux-4.14.y/v4.14.230/=
arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.14.y/v4.14.230/=
arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6071976431373fa59edac=
72c
        failing since 142 days (last pass: v4.14.206, first fail: v4.14.207=
) =

 =



platform             | arch   | lab             | compiler | defconfig     =
      | regressions
---------------------+--------+-----------------+----------+---------------=
------+------------
qemu_arm-versatilepb | arm    | lab-cip         | gcc-8    | versatile_defc=
onfig | 1          =


  Details:     https://kernelci.org/test/plan/id/607197752eaa71ed4fdac6e4

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable/linux-4.14.y/v4.14.230/=
arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.14.y/v4.14.230/=
arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/607197752eaa71ed4fdac=
6e5
        failing since 142 days (last pass: v4.14.206, first fail: v4.14.207=
) =

 =



platform             | arch   | lab             | compiler | defconfig     =
      | regressions
---------------------+--------+-----------------+----------+---------------=
------+------------
qemu_arm-versatilepb | arm    | lab-collabora   | gcc-8    | versatile_defc=
onfig | 1          =


  Details:     https://kernelci.org/test/plan/id/6071970ae29e7f1ac0dac74a

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable/linux-4.14.y/v4.14.230/=
arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu_arm-versatilepb.t=
xt
  HTML log:    https://storage.kernelci.org//stable/linux-4.14.y/v4.14.230/=
arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu_arm-versatilepb.h=
tml
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6071970ae29e7f1ac0dac=
74b
        failing since 142 days (last pass: v4.14.206, first fail: v4.14.207=
) =

 =



platform             | arch   | lab             | compiler | defconfig     =
      | regressions
---------------------+--------+-----------------+----------+---------------=
------+------------
qemu_arm-versatilepb | arm    | lab-linaro-lkft | gcc-8    | versatile_defc=
onfig | 1          =


  Details:     https://kernelci.org/test/plan/id/607197216e3cc668b8dac6c0

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable/linux-4.14.y/v4.14.230/=
arm/versatile_defconfig/gcc-8/lab-linaro-lkft/baseline-qemu_arm-versatilepb=
.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.14.y/v4.14.230/=
arm/versatile_defconfig/gcc-8/lab-linaro-lkft/baseline-qemu_arm-versatilepb=
.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/607197216e3cc668b8dac=
6c1
        failing since 142 days (last pass: v4.14.206, first fail: v4.14.207=
) =

 =



platform             | arch   | lab             | compiler | defconfig     =
      | regressions
---------------------+--------+-----------------+----------+---------------=
------+------------
qemu_x86_64-uefi     | x86_64 | lab-broonie     | gcc-8    | x86_64_defconf=
ig    | 1          =


  Details:     https://kernelci.org/test/plan/id/60719a42ef6e5dc9e2dac6b1

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig
  Compiler:    gcc-8 (gcc (Debian 8.3.0-6) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable/linux-4.14.y/v4.14.230/=
x86_64/x86_64_defconfig/gcc-8/lab-broonie/baseline-qemu_x86_64-uefi.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.14.y/v4.14.230/=
x86_64/x86_64_defconfig/gcc-8/lab-broonie/baseline-qemu_x86_64-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/x86/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60719a42ef6e5dc9e2dac=
6b2
        new failure (last pass: v4.14.229) =

 =20
