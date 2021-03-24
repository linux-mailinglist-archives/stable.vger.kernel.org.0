Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5739D34846A
	for <lists+stable@lfdr.de>; Wed, 24 Mar 2021 23:16:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232148AbhCXWPj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Mar 2021 18:15:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38460 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232114AbhCXWPa (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 24 Mar 2021 18:15:30 -0400
Received: from mail-pg1-x533.google.com (mail-pg1-x533.google.com [IPv6:2607:f8b0:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 108FCC06174A
        for <stable@vger.kernel.org>; Wed, 24 Mar 2021 15:15:19 -0700 (PDT)
Received: by mail-pg1-x533.google.com with SMTP id h25so15746124pgm.3
        for <stable@vger.kernel.org>; Wed, 24 Mar 2021 15:15:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=hyeL7zIrCOhcfUwuqP2s6vIVDU3cO4gNVTh7Jphd+NI=;
        b=hDKdaG7n0IfjYlqqCfLuIY2OTCHuwDy1r1noMhh2u2YpkE/dpBwHH0vbKhxNHS3lqz
         woILoBrbvVsUqIXsPbirGpZmBl+k3/BCwp9PXRQQEBeKyZPHxt9/pEUDcSQUa/bohZHs
         MuOJ23et5DIKUE8VxJPdFPWGzzeuEvOT4v1hGrY3ts/5JPfcc/65gTWtvJ4+Kmb08WeY
         xh0mvBlprVzAGjh+Cl5fMOEevEhVtTKUIjX/0NUDGsUtSu4zFl9TpAAmcEjg87ci2Liq
         AlQM5dSryicjeZlGhlxCkyksbW3uNvJ181DwlzHYQZlSnJRcWJAbAQ09W3nLQoYSTrEG
         kh0A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=hyeL7zIrCOhcfUwuqP2s6vIVDU3cO4gNVTh7Jphd+NI=;
        b=bzVDdR4TLeRQwMVGmu7dxrb/Y73xP+/oBj4ejWOyaXe2r9lyZztKs0IEMehiwoeiMm
         iUmzb8FmANG0pDwMjlyKJbLNRmhrxpfRDNzeH/fq68RXEfcRMxFL5t2l4QKnmGdl9R5R
         vl+CpNQnHuubIPF/khmMRyINcUrloMomsyBDxy0k9m/TkX4ceEXF58fpKG+bPWtkRE23
         JPIpVCueL6hGDW2Kz1+T6WKF0QNeSFL8ufoCAb7KTS4vzcRyY99hX8+ZHkjwlPU1qqc6
         ZhT9CpbqhR4EmvhoDY6/K0LqmxeWL+egHsUIGiPPt+bfeJnMxAQKlYLHCMPA2wpppjq/
         /TIw==
X-Gm-Message-State: AOAM532447V5uU0aSgQopZsnQU+8+nyruVxA+0Cc7GlFvs0fsq+E+p8t
        h0rzrKfNcbiMMR3oiJ73hEe1P7H8GgKvSQ==
X-Google-Smtp-Source: ABdhPJy9fpiPlAdNp8L8QnfhzN1OFj1/HwkXmCDM1LU6x5tMQBkD59xRSAXuC6QIc3vPWJkXrY9lFQ==
X-Received: by 2002:a17:902:8f8b:b029:e6:f01d:9b9c with SMTP id z11-20020a1709028f8bb02900e6f01d9b9cmr5918972plo.64.1616624118339;
        Wed, 24 Mar 2021 15:15:18 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id a70sm3308121pfa.202.2021.03.24.15.15.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 24 Mar 2021 15:15:17 -0700 (PDT)
Message-ID: <605bb9f5.1c69fb81.8e105.8e8c@mx.google.com>
Date:   Wed, 24 Mar 2021 15:15:17 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v4.14.227
X-Kernelci-Tree: stable
X-Kernelci-Branch: linux-4.14.y
Subject: stable/linux-4.14.y baseline: 130 runs, 10 regressions (v4.14.227)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable/linux-4.14.y baseline: 130 runs, 10 regressions (v4.14.227)

Regressions Summary
-------------------

platform             | arch   | lab             | compiler | defconfig     =
      | regressions
---------------------+--------+-----------------+----------+---------------=
------+------------
meson-gxbb-p200      | arm64  | lab-baylibre    | gcc-8    | defconfig     =
      | 1          =

meson-gxm-q200       | arm64  | lab-baylibre    | gcc-8    | defconfig     =
      | 1          =

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

qemu_x86_64          | x86_64 | lab-baylibre    | gcc-8    | x86_64_defconf=
ig    | 1          =

qemu_x86_64-uefi     | x86_64 | lab-baylibre    | gcc-8    | x86_64_defconf=
ig    | 1          =


  Details:  https://kernelci.org/test/job/stable/branch/linux-4.14.y/kernel=
/v4.14.227/plan/baseline/

  Test:     baseline
  Tree:     stable
  Branch:   linux-4.14.y
  Describe: v4.14.227
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able.git
  SHA:      670d6552eda8ff0c5f396d3d6f0174237917c66c =



Test Regressions
---------------- =



platform             | arch   | lab             | compiler | defconfig     =
      | regressions
---------------------+--------+-----------------+----------+---------------=
------+------------
meson-gxbb-p200      | arm64  | lab-baylibre    | gcc-8    | defconfig     =
      | 1          =


  Details:     https://kernelci.org/test/plan/id/605b88f05d50f92eafaf02ee

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable/linux-4.14.y/v4.14.227/=
arm64/defconfig/gcc-8/lab-baylibre/baseline-meson-gxbb-p200.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.14.y/v4.14.227/=
arm64/defconfig/gcc-8/lab-baylibre/baseline-meson-gxbb-p200.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/605b88f05d50f92eafaf0=
2ef
        failing since 356 days (last pass: v4.14.172, first fail: v4.14.175=
) =

 =



platform             | arch   | lab             | compiler | defconfig     =
      | regressions
---------------------+--------+-----------------+----------+---------------=
------+------------
meson-gxm-q200       | arm64  | lab-baylibre    | gcc-8    | defconfig     =
      | 1          =


  Details:     https://kernelci.org/test/plan/id/605b940c1867b23711af02df

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable/linux-4.14.y/v4.14.227/=
arm64/defconfig/gcc-8/lab-baylibre/baseline-meson-gxm-q200.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.14.y/v4.14.227/=
arm64/defconfig/gcc-8/lab-baylibre/baseline-meson-gxm-q200.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/605b940c1867b23711af0=
2e0
        failing since 59 days (last pass: v4.14.216, first fail: v4.14.217) =

 =



platform             | arch   | lab             | compiler | defconfig     =
      | regressions
---------------------+--------+-----------------+----------+---------------=
------+------------
qemu_arm-versatilepb | arm    | lab-baylibre    | gcc-8    | versatile_defc=
onfig | 1          =


  Details:     https://kernelci.org/test/plan/id/605b8762b8e4173198af02dd

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable/linux-4.14.y/v4.14.227/=
arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.14.y/v4.14.227/=
arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_arm-versatilepb.ht=
ml
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/605b8762b8e4173198af0=
2de
        failing since 125 days (last pass: v4.14.206, first fail: v4.14.207=
) =

 =



platform             | arch   | lab             | compiler | defconfig     =
      | regressions
---------------------+--------+-----------------+----------+---------------=
------+------------
qemu_arm-versatilepb | arm    | lab-broonie     | gcc-8    | versatile_defc=
onfig | 1          =


  Details:     https://kernelci.org/test/plan/id/605b875bb8e4173198af02d5

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable/linux-4.14.y/v4.14.227/=
arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.14.y/v4.14.227/=
arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/605b875bb8e4173198af0=
2d6
        failing since 125 days (last pass: v4.14.206, first fail: v4.14.207=
) =

 =



platform             | arch   | lab             | compiler | defconfig     =
      | regressions
---------------------+--------+-----------------+----------+---------------=
------+------------
qemu_arm-versatilepb | arm    | lab-cip         | gcc-8    | versatile_defc=
onfig | 1          =


  Details:     https://kernelci.org/test/plan/id/605b874f6dcd523be0af02b3

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable/linux-4.14.y/v4.14.227/=
arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.14.y/v4.14.227/=
arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/605b874f6dcd523be0af0=
2b4
        failing since 125 days (last pass: v4.14.206, first fail: v4.14.207=
) =

 =



platform             | arch   | lab             | compiler | defconfig     =
      | regressions
---------------------+--------+-----------------+----------+---------------=
------+------------
qemu_arm-versatilepb | arm    | lab-collabora   | gcc-8    | versatile_defc=
onfig | 1          =


  Details:     https://kernelci.org/test/plan/id/605b8913b0f5a9a5f1af02ec

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable/linux-4.14.y/v4.14.227/=
arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu_arm-versatilepb.t=
xt
  HTML log:    https://storage.kernelci.org//stable/linux-4.14.y/v4.14.227/=
arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu_arm-versatilepb.h=
tml
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/605b8913b0f5a9a5f1af0=
2ed
        failing since 125 days (last pass: v4.14.206, first fail: v4.14.207=
) =

 =



platform             | arch   | lab             | compiler | defconfig     =
      | regressions
---------------------+--------+-----------------+----------+---------------=
------+------------
qemu_arm-versatilepb | arm    | lab-linaro-lkft | gcc-8    | versatile_defc=
onfig | 1          =


  Details:     https://kernelci.org/test/plan/id/605b8706a60429728faf02c2

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable/linux-4.14.y/v4.14.227/=
arm/versatile_defconfig/gcc-8/lab-linaro-lkft/baseline-qemu_arm-versatilepb=
.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.14.y/v4.14.227/=
arm/versatile_defconfig/gcc-8/lab-linaro-lkft/baseline-qemu_arm-versatilepb=
.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/605b8706a60429728faf0=
2c3
        failing since 125 days (last pass: v4.14.206, first fail: v4.14.207=
) =

 =



platform             | arch   | lab             | compiler | defconfig     =
      | regressions
---------------------+--------+-----------------+----------+---------------=
------+------------
qemu_i386            | i386   | lab-baylibre    | gcc-8    | i386_defconfig=
      | 1          =


  Details:     https://kernelci.org/test/plan/id/605b87db22375be448af02ae

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: i386_defconfig
  Compiler:    gcc-8 (gcc (Debian 8.3.0-6) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable/linux-4.14.y/v4.14.227/=
i386/i386_defconfig/gcc-8/lab-baylibre/baseline-qemu_i386.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.14.y/v4.14.227/=
i386/i386_defconfig/gcc-8/lab-baylibre/baseline-qemu_i386.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/x86/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/605b87db22375be448af0=
2af
        failing since 17 days (last pass: v4.14.220, first fail: v4.14.224) =

 =



platform             | arch   | lab             | compiler | defconfig     =
      | regressions
---------------------+--------+-----------------+----------+---------------=
------+------------
qemu_x86_64          | x86_64 | lab-baylibre    | gcc-8    | x86_64_defconf=
ig    | 1          =


  Details:     https://kernelci.org/test/plan/id/605b869ae236a34ad9af02b9

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig
  Compiler:    gcc-8 (gcc (Debian 8.3.0-6) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable/linux-4.14.y/v4.14.227/=
x86_64/x86_64_defconfig/gcc-8/lab-baylibre/baseline-qemu_x86_64.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.14.y/v4.14.227/=
x86_64/x86_64_defconfig/gcc-8/lab-baylibre/baseline-qemu_x86_64.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/x86/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/605b869ae236a34ad9af0=
2ba
        new failure (last pass: v4.14.224) =

 =



platform             | arch   | lab             | compiler | defconfig     =
      | regressions
---------------------+--------+-----------------+----------+---------------=
------+------------
qemu_x86_64-uefi     | x86_64 | lab-baylibre    | gcc-8    | x86_64_defconf=
ig    | 1          =


  Details:     https://kernelci.org/test/plan/id/605b86eacf3c5c6e5faf02ca

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig
  Compiler:    gcc-8 (gcc (Debian 8.3.0-6) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable/linux-4.14.y/v4.14.227/=
x86_64/x86_64_defconfig/gcc-8/lab-baylibre/baseline-qemu_x86_64-uefi.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.14.y/v4.14.227/=
x86_64/x86_64_defconfig/gcc-8/lab-baylibre/baseline-qemu_x86_64-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/x86/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/605b86eacf3c5c6e5faf0=
2cb
        new failure (last pass: v4.14.224) =

 =20
