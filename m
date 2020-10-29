Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 684CB29E440
	for <lists+stable@lfdr.de>; Thu, 29 Oct 2020 08:37:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729090AbgJ2HfU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 29 Oct 2020 03:35:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55394 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728057AbgJ2HY4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 29 Oct 2020 03:24:56 -0400
Received: from mail-pf1-x42d.google.com (mail-pf1-x42d.google.com [IPv6:2607:f8b0:4864:20::42d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AD057C0613B4
        for <stable@vger.kernel.org>; Wed, 28 Oct 2020 22:06:31 -0700 (PDT)
Received: by mail-pf1-x42d.google.com with SMTP id y14so1338783pfp.13
        for <stable@vger.kernel.org>; Wed, 28 Oct 2020 22:06:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=7NpJ32PiP00eTbxqfmLSW1vpcRo9FbfGn7PUS3fL1qI=;
        b=qI9me5YfZNycnu0qrQeMXoDGprcLymHyETmn6S6dl7iitLr/8i19bLhdQ/VJscNuxD
         TkWqmKydtGnqP0fA8u25NQe9G0YPxUUEVk1KXfl7c7RayafT2uvXZzB8B4yZB5B9kvyh
         9veexx1QllCnkB1sxX1ARdrJf+KoBwktsQLFugWYppiKv2JkhCTNTPVxFMrE7DdSRU6U
         ySL7afmP/dvs+FPmqX6/TeDMFSLhSbE22Y0faFU4HEF9GtJBJHRQtqrYvofgj89tilcb
         UezojUUT0m7VQO/EweJ1eKNSllgXMRpFW0Wux1uiZHpfjsnLVRcS4P8th+2em4onwTQ2
         PVPA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=7NpJ32PiP00eTbxqfmLSW1vpcRo9FbfGn7PUS3fL1qI=;
        b=ckwXlrs1saD65NlY/1VRdEMagZaY9rT8TNPd6m8/f5tb2HsrUAEYzfnHWW9+cYSbSC
         ok9fYmjPWZbQishlHuPHXhM99RERZ/pBJx3MHwbQxQLHhEDBSIBBM1fGDFYHoCpbQDQb
         dHvu0KqaQz/JbMahP/tlidtyy0KkIvv2Peves/1QROmhnHGGa4rPXzyXGRgsurKzsJsF
         zD6rSjD3bz2d/7aQJVfc2ffLHHLdhOdtpQqMc3upZnKCVXhbTVPteWf+DqB1am2bsx+L
         +JmK5nMCCBQHWgqHfDoO2KiSmAGFQAhyEyei+fuYlifkB4Z17vIaBR9OG65ES5+HhwnB
         PxiA==
X-Gm-Message-State: AOAM531kGG6TAWdm1ec9FRBkU6HSBsPU7XxiU2QRWXYYPZqGzHodXPks
        DYvElji+HKNmCGXKWFOJkU8Lb8WYaTjyUg==
X-Google-Smtp-Source: ABdhPJz2HaMA2LlaFDueTm1x3baIg2HYEfnnV8qooTEUBljCXxIvOZDWIrDtJCIy4xHiDNN0FMlH7g==
X-Received: by 2002:a63:1119:: with SMTP id g25mr2484435pgl.385.1603947990803;
        Wed, 28 Oct 2020 22:06:30 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id n12sm1140044pjt.16.2020.10.28.22.06.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 28 Oct 2020 22:06:30 -0700 (PDT)
Message-ID: <5f9a4dd6.1c69fb81.d74b4.3b9e@mx.google.com>
Date:   Wed, 28 Oct 2020 22:06:30 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.14.202-192-g666a284dfa13
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/4.14
Subject: stable-rc/queue/4.14 baseline: 167 runs,
 5 regressions (v4.14.202-192-g666a284dfa13)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.14 baseline: 167 runs, 5 regressions (v4.14.202-192-g666a=
284dfa13)

Regressions Summary
-------------------

platform         | arch   | lab           | compiler | defconfig           =
| regressions
-----------------+--------+---------------+----------+---------------------=
+------------
jetson-tk1       | arm    | lab-collabora | gcc-8    | tegra_defconfig     =
| 1          =

panda            | arm    | lab-collabora | gcc-8    | omap2plus_defconfig =
| 1          =

qemu_i386        | i386   | lab-baylibre  | gcc-8    | i386_defconfig      =
| 1          =

qemu_i386-uefi   | i386   | lab-baylibre  | gcc-8    | i386_defconfig      =
| 1          =

qemu_x86_64-uefi | x86_64 | lab-baylibre  | gcc-8    | x86_64_defconfig    =
| 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.14/ker=
nel/v4.14.202-192-g666a284dfa13/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.14
  Describe: v4.14.202-192-g666a284dfa13
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      666a284dfa133abcc7f5e6c14f9a522988779cb1 =



Test Regressions
---------------- =



platform         | arch   | lab           | compiler | defconfig           =
| regressions
-----------------+--------+---------------+----------+---------------------=
+------------
jetson-tk1       | arm    | lab-collabora | gcc-8    | tegra_defconfig     =
| 1          =


  Details:     https://kernelci.org/test/plan/id/5f9a1a92b85f6fbc14381029

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: tegra_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.202=
-192-g666a284dfa13/arm/tegra_defconfig/gcc-8/lab-collabora/baseline-jetson-=
tk1.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.202=
-192-g666a284dfa13/arm/tegra_defconfig/gcc-8/lab-collabora/baseline-jetson-=
tk1.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5f9a1a92b85f6fbc14381=
02a
        new failure (last pass: v4.14.202-191-ga749788345ca) =

 =



platform         | arch   | lab           | compiler | defconfig           =
| regressions
-----------------+--------+---------------+----------+---------------------=
+------------
panda            | arm    | lab-collabora | gcc-8    | omap2plus_defconfig =
| 1          =


  Details:     https://kernelci.org/test/plan/id/5f9a1bb43fb61df0ef381026

  Results:     3 PASS, 1 FAIL, 1 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.202=
-192-g666a284dfa13/arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-pan=
da.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.202=
-192-g666a284dfa13/arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-pan=
da.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/5f9a1bb43fb61df=
0ef38102d
        failing since 1 day (last pass: v4.14.202-187-gb76e374d6454, first =
fail: v4.14.202-191-ga749788345ca)
        2 lines

    2020-10-29 01:32:33.268000+00:00  kern  :emerg :  lock: emif_lock+0x0/0=
xffffed34 [emif], .magic: dead4ead, .owner: <none>/-1, .owner_cpu: -1   =

 =



platform         | arch   | lab           | compiler | defconfig           =
| regressions
-----------------+--------+---------------+----------+---------------------=
+------------
qemu_i386        | i386   | lab-baylibre  | gcc-8    | i386_defconfig      =
| 1          =


  Details:     https://kernelci.org/test/plan/id/5f9a1a53b8edab90b838102c

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: i386_defconfig
  Compiler:    gcc-8 (gcc (Debian 8.3.0-6) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.202=
-192-g666a284dfa13/i386/i386_defconfig/gcc-8/lab-baylibre/baseline-qemu_i38=
6.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.202=
-192-g666a284dfa13/i386/i386_defconfig/gcc-8/lab-baylibre/baseline-qemu_i38=
6.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/x86/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5f9a1a53b8edab90b8381=
02d
        new failure (last pass: v4.14.202-191-ga749788345ca) =

 =



platform         | arch   | lab           | compiler | defconfig           =
| regressions
-----------------+--------+---------------+----------+---------------------=
+------------
qemu_i386-uefi   | i386   | lab-baylibre  | gcc-8    | i386_defconfig      =
| 1          =


  Details:     https://kernelci.org/test/plan/id/5f9a1a27b6599338b0381022

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: i386_defconfig
  Compiler:    gcc-8 (gcc (Debian 8.3.0-6) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.202=
-192-g666a284dfa13/i386/i386_defconfig/gcc-8/lab-baylibre/baseline-qemu_i38=
6-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.202=
-192-g666a284dfa13/i386/i386_defconfig/gcc-8/lab-baylibre/baseline-qemu_i38=
6-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/x86/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5f9a1a27b6599338b0381=
023
        new failure (last pass: v4.14.202-191-ga749788345ca) =

 =



platform         | arch   | lab           | compiler | defconfig           =
| regressions
-----------------+--------+---------------+----------+---------------------=
+------------
qemu_x86_64-uefi | x86_64 | lab-baylibre  | gcc-8    | x86_64_defconfig    =
| 1          =


  Details:     https://kernelci.org/test/plan/id/5f9a1a2ab6599338b038102e

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig
  Compiler:    gcc-8 (gcc (Debian 8.3.0-6) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.202=
-192-g666a284dfa13/x86_64/x86_64_defconfig/gcc-8/lab-baylibre/baseline-qemu=
_x86_64-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.202=
-192-g666a284dfa13/x86_64/x86_64_defconfig/gcc-8/lab-baylibre/baseline-qemu=
_x86_64-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/x86/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5f9a1a2ab6599338b0381=
02f
        new failure (last pass: v4.14.202-191-ga749788345ca) =

 =20
