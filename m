Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 981143574FB
	for <lists+stable@lfdr.de>; Wed,  7 Apr 2021 21:32:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345680AbhDGTcQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 7 Apr 2021 15:32:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58360 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345553AbhDGTcP (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 7 Apr 2021 15:32:15 -0400
Received: from mail-pg1-x52d.google.com (mail-pg1-x52d.google.com [IPv6:2607:f8b0:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 90B9DC06175F
        for <stable@vger.kernel.org>; Wed,  7 Apr 2021 12:32:05 -0700 (PDT)
Received: by mail-pg1-x52d.google.com with SMTP id g35so9063315pgg.9
        for <stable@vger.kernel.org>; Wed, 07 Apr 2021 12:32:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=ruJ9ULfWsdNKXrvOGl/UfFxbrYxOZGULHeZaK0LzjYg=;
        b=A5Eddem5up96hevo0ox32DpyBtlEvwVfz9HWdSwVxwkXJrUlgLhET/L/9vXhQei3qq
         jQqE8DHZ48vcDmitcUB7MtSwLFgq6BDzXIYByaMrBZ2zELYLzDbk5aRYmRraLCpG/3Ag
         NHOH3Udju50IUcrjwNTWLRgQqq4gRe08AMTJozALtw3F7+V2Uo/DS1zaCgczUQiW4JkG
         cznZktBJqJTGN2C+8PvkHIIdom+aacGQfsLfoZBfENUIysJ0kKVbRrst9SwOtLOAxt2a
         KQIYLdatlyysw3QYsENVMKS1ER80+nnU1K/gFO+lg3Cqb/NKQ/NJ5xthU7eK00/23iTV
         ixfw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=ruJ9ULfWsdNKXrvOGl/UfFxbrYxOZGULHeZaK0LzjYg=;
        b=aWDY55eQZ/W2rZcm3T9nIXWPPfWsO4iAZH/q8ZjthoCQYy/4i8Hr3HCVrY+VQuiPK7
         2VDMdcT1N1sBVDQSwHu3/la3s9umiBP34G0ewnzNxeO7IekuRxao1RWheALGGKI6BcVA
         kl4poJv298Mul0gGxHiVLx0L+W5Zu3Y9IltVx5xf802uNdbPS8HxVqX3QrmqucznyxOw
         0QaORhSyYENHwHhBnwg4qJX+eYe5uC+fU01XnRpRi4OhG9XClAF+GloYD7mnJmsyc9AI
         P5hlAxltG3UsnFQ8G0L7z/7Y5J/94DY1PJadlo/ahoNEzvCNDA3jb8qlbR+9AkD9syQS
         cZ4A==
X-Gm-Message-State: AOAM530pDgQNwRoDSOpaGMXSrN6O0prgKZEt8wHrsstEx+0QzB6U3rxY
        dIh0CKuvBRRF8YWTrnhZLVYx5ugYwDS1ACvi
X-Google-Smtp-Source: ABdhPJytYYdHOCghTh6o0leo6aZebrVm232J9mos3D3xEDRqDzVLEjJfz+4oe4/iqgBt9nEea7EF2g==
X-Received: by 2002:a63:c90c:: with SMTP id o12mr4887335pgg.210.1617823924786;
        Wed, 07 Apr 2021 12:32:04 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id r23sm6293754pje.38.2021.04.07.12.32.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 07 Apr 2021 12:32:04 -0700 (PDT)
Message-ID: <606e08b4.1c69fb81.3f120.0928@mx.google.com>
Date:   Wed, 07 Apr 2021 12:32:04 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v4.19.185
X-Kernelci-Branch: linux-4.19.y
X-Kernelci-Tree: stable
Subject: stable/linux-4.19.y baseline: 116 runs, 6 regressions (v4.19.185)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable/linux-4.19.y baseline: 116 runs, 6 regressions (v4.19.185)

Regressions Summary
-------------------

platform             | arch  | lab           | compiler | defconfig        =
   | regressions
---------------------+-------+---------------+----------+------------------=
---+------------
hip07-d05            | arm64 | lab-collabora | gcc-8    | defconfig        =
   | 1          =

panda                | arm   | lab-collabora | gcc-8    | omap2plus_defconf=
ig | 1          =

qemu_arm-versatilepb | arm   | lab-baylibre  | gcc-8    | versatile_defconf=
ig | 1          =

qemu_arm-versatilepb | arm   | lab-broonie   | gcc-8    | versatile_defconf=
ig | 1          =

qemu_arm-versatilepb | arm   | lab-cip       | gcc-8    | versatile_defconf=
ig | 1          =

qemu_arm-versatilepb | arm   | lab-collabora | gcc-8    | versatile_defconf=
ig | 1          =


  Details:  https://kernelci.org/test/job/stable/branch/linux-4.19.y/kernel=
/v4.19.185/plan/baseline/

  Test:     baseline
  Tree:     stable
  Branch:   linux-4.19.y
  Describe: v4.19.185
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able.git
  SHA:      b4454811f122c6a0a330ced6b854e6ef32c37857 =



Test Regressions
---------------- =



platform             | arch  | lab           | compiler | defconfig        =
   | regressions
---------------------+-------+---------------+----------+------------------=
---+------------
hip07-d05            | arm64 | lab-collabora | gcc-8    | defconfig        =
   | 1          =


  Details:     https://kernelci.org/test/plan/id/606dd440db8a4f62f5dac6bd

  Results:     4 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable/linux-4.19.y/v4.19.185/=
arm64/defconfig/gcc-8/lab-collabora/baseline-hip07-d05.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.19.y/v4.19.185/=
arm64/defconfig/gcc-8/lab-collabora/baseline-hip07-d05.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/606dd440db8a4f62f5dac=
6be
        new failure (last pass: v4.19.183) =

 =



platform             | arch  | lab           | compiler | defconfig        =
   | regressions
---------------------+-------+---------------+----------+------------------=
---+------------
panda                | arm   | lab-collabora | gcc-8    | omap2plus_defconf=
ig | 1          =


  Details:     https://kernelci.org/test/plan/id/606dccacda8a94e176dac6b2

  Results:     4 PASS, 1 FAIL, 0 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable/linux-4.19.y/v4.19.185/=
arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-panda.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.19.y/v4.19.185/=
arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-panda.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/606dccacda8a94e=
176dac6b9
        new failure (last pass: v4.19.184)
        2 lines

    2021-04-07 15:15:48.363000+00:00  kern  :emerg : BUG: spinlock bad magi=
c on CPU#0, udevd/109
    2021-04-07 15:15:48.373000+00:00  kern  :emerg :  lock: emif_lock+0x0/0=
xffffed34 [emif], .magic: dead4ead, .owner: <none>/-1, .owner_cpu: -1   =

 =



platform             | arch  | lab           | compiler | defconfig        =
   | regressions
---------------------+-------+---------------+----------+------------------=
---+------------
qemu_arm-versatilepb | arm   | lab-baylibre  | gcc-8    | versatile_defconf=
ig | 1          =


  Details:     https://kernelci.org/test/plan/id/606dceb269e6c2f33cdac6fb

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable/linux-4.19.y/v4.19.185/=
arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.19.y/v4.19.185/=
arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_arm-versatilepb.ht=
ml
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/606dceb269e6c2f33cdac=
6fc
        failing since 139 days (last pass: v4.19.157, first fail: v4.19.158=
) =

 =



platform             | arch  | lab           | compiler | defconfig        =
   | regressions
---------------------+-------+---------------+----------+------------------=
---+------------
qemu_arm-versatilepb | arm   | lab-broonie   | gcc-8    | versatile_defconf=
ig | 1          =


  Details:     https://kernelci.org/test/plan/id/606dce9dd7d2d4b2afdac6b1

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable/linux-4.19.y/v4.19.185/=
arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.19.y/v4.19.185/=
arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/606dce9dd7d2d4b2afdac=
6b2
        failing since 139 days (last pass: v4.19.157, first fail: v4.19.158=
) =

 =



platform             | arch  | lab           | compiler | defconfig        =
   | regressions
---------------------+-------+---------------+----------+------------------=
---+------------
qemu_arm-versatilepb | arm   | lab-cip       | gcc-8    | versatile_defconf=
ig | 1          =


  Details:     https://kernelci.org/test/plan/id/606dcfe3eacd2e32aadac6c5

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable/linux-4.19.y/v4.19.185/=
arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.19.y/v4.19.185/=
arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/606dcfe3eacd2e32aadac=
6c6
        failing since 139 days (last pass: v4.19.157, first fail: v4.19.158=
) =

 =



platform             | arch  | lab           | compiler | defconfig        =
   | regressions
---------------------+-------+---------------+----------+------------------=
---+------------
qemu_arm-versatilepb | arm   | lab-collabora | gcc-8    | versatile_defconf=
ig | 1          =


  Details:     https://kernelci.org/test/plan/id/606dcfd37e852c628cdac6d0

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable/linux-4.19.y/v4.19.185/=
arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu_arm-versatilepb.t=
xt
  HTML log:    https://storage.kernelci.org//stable/linux-4.19.y/v4.19.185/=
arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu_arm-versatilepb.h=
tml
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/606dcfd37e852c628cdac=
6d1
        failing since 139 days (last pass: v4.19.157, first fail: v4.19.158=
) =

 =20
