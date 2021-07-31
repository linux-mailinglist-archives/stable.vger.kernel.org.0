Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BD8453DC4B3
	for <lists+stable@lfdr.de>; Sat, 31 Jul 2021 09:58:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229703AbhGaH6J (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 31 Jul 2021 03:58:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43524 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232258AbhGaH6I (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 31 Jul 2021 03:58:08 -0400
Received: from mail-pj1-x1034.google.com (mail-pj1-x1034.google.com [IPv6:2607:f8b0:4864:20::1034])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 483EFC0613CF
        for <stable@vger.kernel.org>; Sat, 31 Jul 2021 00:58:02 -0700 (PDT)
Received: by mail-pj1-x1034.google.com with SMTP id o44-20020a17090a0a2fb0290176ca3e5a2fso17708232pjo.1
        for <stable@vger.kernel.org>; Sat, 31 Jul 2021 00:58:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=SAp3mBUJRHVb10/r50cSS/w69eoN/3TDaptKstWL+kY=;
        b=bFIUN5Wyq023QihAQy5sKJE+69eb8xaYp7a+ujgWFD4UXGn/VQnFn1GN/ytfHkxm2j
         FeSm5W1Y7YsyGpmJWEF3g/eusSzqkIUwd5ZISWaC/PMepbA/C6ajLyO/27LQvQ4SMgGh
         SkxvVcn5L0p7sLrTopnLn41d97DzoKZ81YFmhvJDvL96XwhjEgXSLAVff3hCr6QHb8Gx
         jc0djWz0XYkyqKNy/ZRwuWeStr2BHgs9fmknSlfe0FCknr8GB6ZuonMSIscph9FJwImz
         282hAuWR9TCtcxALoUz8f9lJl4IcA9/xc9SzsKj1UWx/EQ036dJGpGVMlL2mmy5b/9+Y
         MXnQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=SAp3mBUJRHVb10/r50cSS/w69eoN/3TDaptKstWL+kY=;
        b=ZcHwHvFCg9LsqFsFPNSz73PXtf4E7Lj6NtGWPovIF37C7NMH2zM8o211ZQf0/JdRYs
         KsAnwBMGktyGDXPGBRaDzowpaa1o8z+xvuZgmDfB50kRLs3dWr86gt251YYg0Odo5xY3
         8Gj8kHac0LpUoOtRLzAyLkMYVY1XJcV7nyWgTMkRv8vm0rnJX98ZPXNAupxhMqWj70P+
         aqQp3MOYMnxOdXh0WlEFQ320dq41tb+epMSX7E35/YuPhFR00wNCr2OXFb4lsXLEajVN
         X2wFTI45Zf1B3n4zMhdsJraALd5lFmwdr62Vx2uTFUG25ciM+gZPVowX+89kI5fhNlur
         VcxA==
X-Gm-Message-State: AOAM530WGVFQwPT1NpjL8VC8TqG7s5+fkvowomPNdzAMH1pGKbHW1TcQ
        w8dsa+bIDofh7/Wxmhvro4Bnrvei0ftEPJ47
X-Google-Smtp-Source: ABdhPJyUtHsxh3T9kHuO3xldmFOXShk43AyU6JXc6Hu20EQDJsKir0f77gWlZuqELQ5Bih17LikbqA==
X-Received: by 2002:a17:90b:4b8d:: with SMTP id lr13mr7326534pjb.141.1627718281516;
        Sat, 31 Jul 2021 00:58:01 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id 129sm4808465pfw.35.2021.07.31.00.58.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 31 Jul 2021 00:58:01 -0700 (PDT)
Message-ID: <61050289.1c69fb81.c0552.d8f8@mx.google.com>
Date:   Sat, 31 Jul 2021 00:58:01 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: queue/4.4
X-Kernelci-Kernel: v4.4.277-13-g8198d1a482ec
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
Subject: stable-rc/queue/4.4 baseline: 102 runs,
 9 regressions (v4.4.277-13-g8198d1a482ec)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.4 baseline: 102 runs, 9 regressions (v4.4.277-13-g8198d1a=
482ec)

Regressions Summary
-------------------

platform            | arch   | lab             | compiler | defconfig      =
              | regressions
--------------------+--------+-----------------+----------+----------------=
--------------+------------
qemu_arm-virt-gicv2 | arm    | lab-baylibre    | gcc-8    | multi_v7_defcon=
fig           | 1          =

qemu_arm-virt-gicv2 | arm    | lab-cip         | gcc-8    | multi_v7_defcon=
fig           | 1          =

qemu_arm-virt-gicv2 | arm    | lab-collabora   | gcc-8    | multi_v7_defcon=
fig           | 1          =

qemu_arm-virt-gicv2 | arm    | lab-linaro-lkft | gcc-8    | multi_v7_defcon=
fig           | 1          =

qemu_arm-virt-gicv3 | arm    | lab-baylibre    | gcc-8    | multi_v7_defcon=
fig           | 1          =

qemu_arm-virt-gicv3 | arm    | lab-cip         | gcc-8    | multi_v7_defcon=
fig           | 1          =

qemu_arm-virt-gicv3 | arm    | lab-collabora   | gcc-8    | multi_v7_defcon=
fig           | 1          =

qemu_arm-virt-gicv3 | arm    | lab-linaro-lkft | gcc-8    | multi_v7_defcon=
fig           | 1          =

qemu_x86_64         | x86_64 | lab-collabora   | gcc-8    | x86_64_defcon..=
.6-chromebook | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.4/kern=
el/v4.4.277-13-g8198d1a482ec/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.4
  Describe: v4.4.277-13-g8198d1a482ec
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      8198d1a482ec01d7798941ca438a902f11d73686 =



Test Regressions
---------------- =



platform            | arch   | lab             | compiler | defconfig      =
              | regressions
--------------------+--------+-----------------+----------+----------------=
--------------+------------
qemu_arm-virt-gicv2 | arm    | lab-baylibre    | gcc-8    | multi_v7_defcon=
fig           | 1          =


  Details:     https://kernelci.org/test/plan/id/6104cd5616d7dce6e885f496

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.277-1=
3-g8198d1a482ec/arm/multi_v7_defconfig/gcc-8/lab-baylibre/baseline-qemu_arm=
-virt-gicv2.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.277-1=
3-g8198d1a482ec/arm/multi_v7_defconfig/gcc-8/lab-baylibre/baseline-qemu_arm=
-virt-gicv2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6104cd5616d7dce6e885f=
497
        failing since 259 days (last pass: v4.4.243-18-gfc7e8c68369a, first=
 fail: v4.4.243-19-g71b6c961c7fe) =

 =



platform            | arch   | lab             | compiler | defconfig      =
              | regressions
--------------------+--------+-----------------+----------+----------------=
--------------+------------
qemu_arm-virt-gicv2 | arm    | lab-cip         | gcc-8    | multi_v7_defcon=
fig           | 1          =


  Details:     https://kernelci.org/test/plan/id/6104cd5846d617aa6785f46b

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.277-1=
3-g8198d1a482ec/arm/multi_v7_defconfig/gcc-8/lab-cip/baseline-qemu_arm-virt=
-gicv2.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.277-1=
3-g8198d1a482ec/arm/multi_v7_defconfig/gcc-8/lab-cip/baseline-qemu_arm-virt=
-gicv2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6104cd5846d617aa6785f=
46c
        failing since 259 days (last pass: v4.4.243-18-gfc7e8c68369a, first=
 fail: v4.4.243-19-g71b6c961c7fe) =

 =



platform            | arch   | lab             | compiler | defconfig      =
              | regressions
--------------------+--------+-----------------+----------+----------------=
--------------+------------
qemu_arm-virt-gicv2 | arm    | lab-collabora   | gcc-8    | multi_v7_defcon=
fig           | 1          =


  Details:     https://kernelci.org/test/plan/id/6104de70730f71283685f467

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.277-1=
3-g8198d1a482ec/arm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-qemu_ar=
m-virt-gicv2.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.277-1=
3-g8198d1a482ec/arm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-qemu_ar=
m-virt-gicv2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6104de70730f71283685f=
468
        failing since 259 days (last pass: v4.4.243-18-gfc7e8c68369a, first=
 fail: v4.4.243-19-g71b6c961c7fe) =

 =



platform            | arch   | lab             | compiler | defconfig      =
              | regressions
--------------------+--------+-----------------+----------+----------------=
--------------+------------
qemu_arm-virt-gicv2 | arm    | lab-linaro-lkft | gcc-8    | multi_v7_defcon=
fig           | 1          =


  Details:     https://kernelci.org/test/plan/id/6104cd5a46d617aa6785f471

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.277-1=
3-g8198d1a482ec/arm/multi_v7_defconfig/gcc-8/lab-linaro-lkft/baseline-qemu_=
arm-virt-gicv2.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.277-1=
3-g8198d1a482ec/arm/multi_v7_defconfig/gcc-8/lab-linaro-lkft/baseline-qemu_=
arm-virt-gicv2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6104cd5a46d617aa6785f=
472
        failing since 259 days (last pass: v4.4.243-18-gfc7e8c68369a, first=
 fail: v4.4.243-19-g71b6c961c7fe) =

 =



platform            | arch   | lab             | compiler | defconfig      =
              | regressions
--------------------+--------+-----------------+----------+----------------=
--------------+------------
qemu_arm-virt-gicv3 | arm    | lab-baylibre    | gcc-8    | multi_v7_defcon=
fig           | 1          =


  Details:     https://kernelci.org/test/plan/id/6104cd5716d7dce6e885f49c

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.277-1=
3-g8198d1a482ec/arm/multi_v7_defconfig/gcc-8/lab-baylibre/baseline-qemu_arm=
-virt-gicv3.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.277-1=
3-g8198d1a482ec/arm/multi_v7_defconfig/gcc-8/lab-baylibre/baseline-qemu_arm=
-virt-gicv3.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6104cd5716d7dce6e885f=
49d
        failing since 259 days (last pass: v4.4.243-18-gfc7e8c68369a, first=
 fail: v4.4.243-19-g71b6c961c7fe) =

 =



platform            | arch   | lab             | compiler | defconfig      =
              | regressions
--------------------+--------+-----------------+----------+----------------=
--------------+------------
qemu_arm-virt-gicv3 | arm    | lab-cip         | gcc-8    | multi_v7_defcon=
fig           | 1          =


  Details:     https://kernelci.org/test/plan/id/6104cd7a7011301d2085f47a

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.277-1=
3-g8198d1a482ec/arm/multi_v7_defconfig/gcc-8/lab-cip/baseline-qemu_arm-virt=
-gicv3.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.277-1=
3-g8198d1a482ec/arm/multi_v7_defconfig/gcc-8/lab-cip/baseline-qemu_arm-virt=
-gicv3.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6104cd7a7011301d2085f=
47b
        failing since 259 days (last pass: v4.4.243-18-gfc7e8c68369a, first=
 fail: v4.4.243-19-g71b6c961c7fe) =

 =



platform            | arch   | lab             | compiler | defconfig      =
              | regressions
--------------------+--------+-----------------+----------+----------------=
--------------+------------
qemu_arm-virt-gicv3 | arm    | lab-collabora   | gcc-8    | multi_v7_defcon=
fig           | 1          =


  Details:     https://kernelci.org/test/plan/id/6104dede4cf1a4311d85f45a

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.277-1=
3-g8198d1a482ec/arm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-qemu_ar=
m-virt-gicv3.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.277-1=
3-g8198d1a482ec/arm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-qemu_ar=
m-virt-gicv3.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6104dede4cf1a4311d85f=
45b
        failing since 259 days (last pass: v4.4.243-18-gfc7e8c68369a, first=
 fail: v4.4.243-19-g71b6c961c7fe) =

 =



platform            | arch   | lab             | compiler | defconfig      =
              | regressions
--------------------+--------+-----------------+----------+----------------=
--------------+------------
qemu_arm-virt-gicv3 | arm    | lab-linaro-lkft | gcc-8    | multi_v7_defcon=
fig           | 1          =


  Details:     https://kernelci.org/test/plan/id/6104cd5c24da00de7285f45a

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.277-1=
3-g8198d1a482ec/arm/multi_v7_defconfig/gcc-8/lab-linaro-lkft/baseline-qemu_=
arm-virt-gicv3.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.277-1=
3-g8198d1a482ec/arm/multi_v7_defconfig/gcc-8/lab-linaro-lkft/baseline-qemu_=
arm-virt-gicv3.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6104cd5c24da00de7285f=
45b
        failing since 259 days (last pass: v4.4.243-18-gfc7e8c68369a, first=
 fail: v4.4.243-19-g71b6c961c7fe) =

 =



platform            | arch   | lab             | compiler | defconfig      =
              | regressions
--------------------+--------+-----------------+----------+----------------=
--------------+------------
qemu_x86_64         | x86_64 | lab-collabora   | gcc-8    | x86_64_defcon..=
.6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/6104e12530bafdadd385f47f

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-8 (gcc (Debian 8.3.0-6) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.277-1=
3-g8198d1a482ec/x86_64/x86_64_defconfig+x86-chromebook/gcc-8/lab-collabora/=
baseline-qemu_x86_64.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.277-1=
3-g8198d1a482ec/x86_64/x86_64_defconfig+x86-chromebook/gcc-8/lab-collabora/=
baseline-qemu_x86_64.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/x86/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6104e12530bafdadd385f=
480
        new failure (last pass: v4.4.277-12-g0bcb837a06e1) =

 =20
