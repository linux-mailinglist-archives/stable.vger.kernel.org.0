Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 27CFA2D4E4C
	for <lists+stable@lfdr.de>; Wed,  9 Dec 2020 23:45:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388366AbgLIWot (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 9 Dec 2020 17:44:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56546 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388241AbgLIWot (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 9 Dec 2020 17:44:49 -0500
Received: from mail-pl1-x632.google.com (mail-pl1-x632.google.com [IPv6:2607:f8b0:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 69B9CC0613D6
        for <stable@vger.kernel.org>; Wed,  9 Dec 2020 14:44:09 -0800 (PST)
Received: by mail-pl1-x632.google.com with SMTP id bj5so1748485plb.4
        for <stable@vger.kernel.org>; Wed, 09 Dec 2020 14:44:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=cVDMUf8AKgRoi7M7Ias8CElX5ZgIrrK+L8qpu6v9jG4=;
        b=eN3EHUy/kM7C+B3f/nL/Ttl6nQV8r1eGPF5zQEHEAd7AHhweD/4gpaeGPzUlNzMMqg
         ykuHSRGFJCKbxuhfsKYbx6vT7Mveky8pKXyp986Tw/7w5sSLIfw659V9j4fyHz9Q7XXQ
         +4O5ef1nnDvHLhb9yInJ/Bv1WSqF201kwgYV2SxPmtGEryg+3brd9IT2l5dQDiFZqpah
         +KGmX8zupKZw5T6fpKLYmwUiANZ/wvSJoBP1FK1Dw0zP2ZlKxsg5RyMEi1mVFWaTh51I
         vl5r6rOxsIeVp5JZsEjsUpoGH4FhmzXGYvSsq+XPjIYM0sT3eljl2pumwazdTXCPw8VE
         NXtQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=cVDMUf8AKgRoi7M7Ias8CElX5ZgIrrK+L8qpu6v9jG4=;
        b=mvhXkL4gkPlT4/w8PRyNsvTzZYrjYjSuMSJ/6uMAacNv22keZ3Hk9mhvhG0NEccFlI
         y71jLkEOySKnvElrGsJYLEtSnRbEC+RyPMLVLbMIG004fx9PfUdqEWD6y0RWES4rJcFM
         x3RGyTok3bfSwwgnUa9OXNNScUzg5Pe8DB7iiahsagsfLPELN3eZif/uAcOl2msR6xJR
         GVYZ7wFqjf5HNeb0tBO7aI5XgA4G7fQWMQfEeFioEg8dPzNmz+IPEIznIgiVS5uFu/nx
         C1zNH2z5U/O6gkzImMWVAjUGjaJGAf16Af1y21HAD3E9EYBdTcaRU467bKT2+7pa1+6M
         aO9w==
X-Gm-Message-State: AOAM532i/zzA9KA2wzHvX7WWw9bvve6IBZ4hc81+MF83joZlCfD8ZrE4
        KtU34Xrmaft1a5rhHPmE4KImi9eS3wFMTA==
X-Google-Smtp-Source: ABdhPJxWop5Mv+Z/T5iu6uG3ldnbUU/gTHk/4sDM4g0rb0i2PYGtRatuMTmIFrv9EjeztTLbwvsfkQ==
X-Received: by 2002:a17:902:bf03:b029:da:fcd1:b10 with SMTP id bi3-20020a170902bf03b02900dafcd10b10mr3867756plb.0.1607553848550;
        Wed, 09 Dec 2020 14:44:08 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id p8sm3336920pjf.11.2020.12.09.14.44.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 09 Dec 2020 14:44:07 -0800 (PST)
Message-ID: <5fd15337.1c69fb81.ce2cb.67a5@mx.google.com>
Date:   Wed, 09 Dec 2020 14:44:07 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: queue/4.14
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v4.14.211-21-g9f474502bc7fc
X-Kernelci-Report-Type: test
Subject: stable-rc/queue/4.14 baseline: 155 runs,
 8 regressions (v4.14.211-21-g9f474502bc7fc)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.14 baseline: 155 runs, 8 regressions (v4.14.211-21-g9f474=
502bc7fc)

Regressions Summary
-------------------

platform             | arch   | lab             | compiler | defconfig     =
      | regressions
---------------------+--------+-----------------+----------+---------------=
------+------------
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

qemu_x86_64-uefi     | x86_64 | lab-baylibre    | gcc-8    | x86_64_defconf=
ig    | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.14/ker=
nel/v4.14.211-21-g9f474502bc7fc/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.14
  Describe: v4.14.211-21-g9f474502bc7fc
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      9f474502bc7fc4459f2840cae3ad7ac5f7d8bc58 =



Test Regressions
---------------- =



platform             | arch   | lab             | compiler | defconfig     =
      | regressions
---------------------+--------+-----------------+----------+---------------=
------+------------
meson-gxm-q200       | arm64  | lab-baylibre    | gcc-8    | defconfig     =
      | 1          =


  Details:     https://kernelci.org/test/plan/id/5fd12fa96946218fe2c94cc3

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.211=
-21-g9f474502bc7fc/arm64/defconfig/gcc-8/lab-baylibre/baseline-meson-gxm-q2=
00.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.211=
-21-g9f474502bc7fc/arm64/defconfig/gcc-8/lab-baylibre/baseline-meson-gxm-q2=
00.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fd12fa96946218fe2c94=
cc4
        failing since 1 day (last pass: v4.14.210-20-gc32b9f7cbda7, first f=
ail: v4.14.210-20-g5ea7913395d3) =

 =



platform             | arch   | lab             | compiler | defconfig     =
      | regressions
---------------------+--------+-----------------+----------+---------------=
------+------------
qemu_arm-versatilepb | arm    | lab-baylibre    | gcc-8    | versatile_defc=
onfig | 1          =


  Details:     https://kernelci.org/test/plan/id/5fd11fb2413290e409c94cc5

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.211=
-21-g9f474502bc7fc/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu=
_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.211=
-21-g9f474502bc7fc/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu=
_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fd11fb2413290e409c94=
cc6
        failing since 25 days (last pass: v4.14.206-21-g787a7a3ca16c, first=
 fail: v4.14.206-22-ga949bf40fb01) =

 =



platform             | arch   | lab             | compiler | defconfig     =
      | regressions
---------------------+--------+-----------------+----------+---------------=
------+------------
qemu_arm-versatilepb | arm    | lab-broonie     | gcc-8    | versatile_defc=
onfig | 1          =


  Details:     https://kernelci.org/test/plan/id/5fd11fb5413290e409c94cc8

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.211=
-21-g9f474502bc7fc/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_=
arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.211=
-21-g9f474502bc7fc/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_=
arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fd11fb5413290e409c94=
cc9
        failing since 25 days (last pass: v4.14.206-21-g787a7a3ca16c, first=
 fail: v4.14.206-22-ga949bf40fb01) =

 =



platform             | arch   | lab             | compiler | defconfig     =
      | regressions
---------------------+--------+-----------------+----------+---------------=
------+------------
qemu_arm-versatilepb | arm    | lab-cip         | gcc-8    | versatile_defc=
onfig | 1          =


  Details:     https://kernelci.org/test/plan/id/5fd11fa23d3c5358cac94cda

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.211=
-21-g9f474502bc7fc/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-=
versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.211=
-21-g9f474502bc7fc/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-=
versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fd11fa23d3c5358cac94=
cdb
        failing since 25 days (last pass: v4.14.206-21-g787a7a3ca16c, first=
 fail: v4.14.206-22-ga949bf40fb01) =

 =



platform             | arch   | lab             | compiler | defconfig     =
      | regressions
---------------------+--------+-----------------+----------+---------------=
------+------------
qemu_arm-versatilepb | arm    | lab-collabora   | gcc-8    | versatile_defc=
onfig | 1          =


  Details:     https://kernelci.org/test/plan/id/5fd12079a0b5f3759cc94cd4

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.211=
-21-g9f474502bc7fc/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qem=
u_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.211=
-21-g9f474502bc7fc/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qem=
u_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fd12079a0b5f3759cc94=
cd5
        failing since 25 days (last pass: v4.14.206-21-g787a7a3ca16c, first=
 fail: v4.14.206-22-ga949bf40fb01) =

 =



platform             | arch   | lab             | compiler | defconfig     =
      | regressions
---------------------+--------+-----------------+----------+---------------=
------+------------
qemu_arm-versatilepb | arm    | lab-linaro-lkft | gcc-8    | versatile_defc=
onfig | 1          =


  Details:     https://kernelci.org/test/plan/id/5fd14b29aa137333a3c94cc2

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.211=
-21-g9f474502bc7fc/arm/versatile_defconfig/gcc-8/lab-linaro-lkft/baseline-q=
emu_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.211=
-21-g9f474502bc7fc/arm/versatile_defconfig/gcc-8/lab-linaro-lkft/baseline-q=
emu_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fd14b29aa137333a3c94=
cc3
        failing since 25 days (last pass: v4.14.206-21-g787a7a3ca16c, first=
 fail: v4.14.206-22-ga949bf40fb01) =

 =



platform             | arch   | lab             | compiler | defconfig     =
      | regressions
---------------------+--------+-----------------+----------+---------------=
------+------------
qemu_i386            | i386   | lab-baylibre    | gcc-8    | i386_defconfig=
      | 1          =


  Details:     https://kernelci.org/test/plan/id/5fd1205fc19ccbbec7c94ccb

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: i386_defconfig
  Compiler:    gcc-8 (gcc (Debian 8.3.0-6) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.211=
-21-g9f474502bc7fc/i386/i386_defconfig/gcc-8/lab-baylibre/baseline-qemu_i38=
6.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.211=
-21-g9f474502bc7fc/i386/i386_defconfig/gcc-8/lab-baylibre/baseline-qemu_i38=
6.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/x86/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fd1205fc19ccbbec7c94=
ccc
        new failure (last pass: v4.14.211-21-gc8ef797f5dae) =

 =



platform             | arch   | lab             | compiler | defconfig     =
      | regressions
---------------------+--------+-----------------+----------+---------------=
------+------------
qemu_x86_64-uefi     | x86_64 | lab-baylibre    | gcc-8    | x86_64_defconf=
ig    | 1          =


  Details:     https://kernelci.org/test/plan/id/5fd120c1134397ccdfc94cde

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig
  Compiler:    gcc-8 (gcc (Debian 8.3.0-6) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.211=
-21-g9f474502bc7fc/x86_64/x86_64_defconfig/gcc-8/lab-baylibre/baseline-qemu=
_x86_64-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.211=
-21-g9f474502bc7fc/x86_64/x86_64_defconfig/gcc-8/lab-baylibre/baseline-qemu=
_x86_64-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/x86/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fd120c1134397ccdfc94=
cdf
        new failure (last pass: v4.14.211-21-gc8ef797f5dae) =

 =20
