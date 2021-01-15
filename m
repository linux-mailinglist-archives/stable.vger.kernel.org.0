Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C72442F833E
	for <lists+stable@lfdr.de>; Fri, 15 Jan 2021 19:04:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726355AbhAOSEC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 15 Jan 2021 13:04:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54232 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725923AbhAOSEC (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 15 Jan 2021 13:04:02 -0500
Received: from mail-pl1-x631.google.com (mail-pl1-x631.google.com [IPv6:2607:f8b0:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E3884C061757
        for <stable@vger.kernel.org>; Fri, 15 Jan 2021 10:03:21 -0800 (PST)
Received: by mail-pl1-x631.google.com with SMTP id x12so5084224plr.10
        for <stable@vger.kernel.org>; Fri, 15 Jan 2021 10:03:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=zQFRlwJ8gtgtpqsDg+37+7MWfELXyIBVqyFr/MAgHWk=;
        b=uXX8hriiOszfiQtjLRmCLcMmQQmNayx04+m6tFdo1vMBZj8+zka3BVQx16I6XQ4xYe
         dMWjPgtYqeKmTeRta+DmF4fQvBibvikuQxklYiD7lyYyCv6+qNKfbyMEMhmee8KcB+sI
         oWELLIMG/Q+QXfbHvWDaQj7YtvgClBw8sNL71BOIDEZ/N2Iq2V58qAbZS8DhCGG1bYWu
         2lfrGVJ8I32RR0iC5izysgd8Se2UN/fR1F6TSvkxetXIZ4+8bd0Ds0zT+GE0GM6qSQR9
         vVHK6sZ2nuZUlcR5JIp+oeqyLqRDz77yOMIlWHNaMk6xSDSN/pB2cSxMcddQkjQfEsnR
         ZBww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=zQFRlwJ8gtgtpqsDg+37+7MWfELXyIBVqyFr/MAgHWk=;
        b=K1tP3KXvRe2UqoIXz4DtyeocEOmCkitWMf3F4NZaNd2qSNKWnRK0JX1PuBSWtkZ+yl
         a/OFJbSWpkndjUeAs9Z03Nm92+Fu8fbd1Dh2siy4iUHavf73hS0oa4fsvp3Pv98DsKF2
         BoTT1BZxtgfBMfnoC7rGyuNZn4O1IrMXdrhRgj5tAFtFGhsAG742hhIdgiERLsmi69qb
         E+MurdJpxrGxUjxxHexqd7277SlHITgjprggojkhQHvWEI6c9GYLk+/cf5/BsN47BJ7n
         Pm3mN3dVQgc1FpRJYikkS0ul92KibBnqG1r/7FJDlt0Mpw9hcDZulDuHzoYXiDMq7XRj
         unmQ==
X-Gm-Message-State: AOAM532s1mb9d2gs8GTJJgKISgUctMOEt4CFQrUKG/nYnvAUH56ruNXQ
        aPemyy0J7bxjz19LsDkHAXd9qg/Ym0as8w==
X-Google-Smtp-Source: ABdhPJzmSVEFBstZmm2gfFpZji55jYlTdaTdA3q2c8pBDBsBCwlZbdyyWqPGvu7onHgoLcBZh5zlag==
X-Received: by 2002:a17:902:d4d1:b029:de:30a4:360f with SMTP id o17-20020a170902d4d1b02900de30a4360fmr13734547plg.83.1610733800777;
        Fri, 15 Jan 2021 10:03:20 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id 5sm8642456pff.125.2021.01.15.10.03.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 15 Jan 2021 10:03:20 -0800 (PST)
Message-ID: <6001d8e8.1c69fb81.8cb2c.6137@mx.google.com>
Date:   Fri, 15 Jan 2021 10:03:20 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: queue/4.14
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v4.14.215-28-g44cb20ad2e61
X-Kernelci-Report-Type: test
Subject: stable-rc/queue/4.14 baseline: 130 runs,
 6 regressions (v4.14.215-28-g44cb20ad2e61)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.14 baseline: 130 runs, 6 regressions (v4.14.215-28-g44cb2=
0ad2e61)

Regressions Summary
-------------------

platform             | arch  | lab           | compiler | defconfig        =
   | regressions
---------------------+-------+---------------+----------+------------------=
---+------------
meson-gxm-q200       | arm64 | lab-baylibre  | gcc-8    | defconfig        =
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


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.14/ker=
nel/v4.14.215-28-g44cb20ad2e61/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.14
  Describe: v4.14.215-28-g44cb20ad2e61
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      44cb20ad2e612920bf4faa6109481c27b0d5fcbb =



Test Regressions
---------------- =



platform             | arch  | lab           | compiler | defconfig        =
   | regressions
---------------------+-------+---------------+----------+------------------=
---+------------
meson-gxm-q200       | arm64 | lab-baylibre  | gcc-8    | defconfig        =
   | 1          =


  Details:     https://kernelci.org/test/plan/id/6001af5a945de656dfc94ce4

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.215=
-28-g44cb20ad2e61/arm64/defconfig/gcc-8/lab-baylibre/baseline-meson-gxm-q20=
0.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.215=
-28-g44cb20ad2e61/arm64/defconfig/gcc-8/lab-baylibre/baseline-meson-gxm-q20=
0.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6001af5a945de656dfc94=
ce5
        failing since 38 days (last pass: v4.14.210-20-gc32b9f7cbda7, first=
 fail: v4.14.210-20-g5ea7913395d3) =

 =



platform             | arch  | lab           | compiler | defconfig        =
   | regressions
---------------------+-------+---------------+----------+------------------=
---+------------
panda                | arm   | lab-collabora | gcc-8    | omap2plus_defconf=
ig | 1          =


  Details:     https://kernelci.org/test/plan/id/6001a510c1b6c822f5c94d01

  Results:     3 PASS, 1 FAIL, 1 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.215=
-28-g44cb20ad2e61/arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-pand=
a.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.215=
-28-g44cb20ad2e61/arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-pand=
a.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/6001a510c1b6c82=
2f5c94d06
        new failure (last pass: v4.14.215-28-g698dbcc987be)
        2 lines

    2021-01-15 14:22:03.775000+00:00  kern  :emerg :  lock: emif_lock+0x0/0=
xffffed34 [emif], .magic: 00000000, .owner: <none>/-1, .owner_cpu: 0   =

 =



platform             | arch  | lab           | compiler | defconfig        =
   | regressions
---------------------+-------+---------------+----------+------------------=
---+------------
qemu_arm-versatilepb | arm   | lab-baylibre  | gcc-8    | versatile_defconf=
ig | 1          =


  Details:     https://kernelci.org/test/plan/id/6001a48f8d00c46214c94ce1

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.215=
-28-g44cb20ad2e61/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_=
arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.215=
-28-g44cb20ad2e61/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_=
arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6001a48f8d00c46214c94=
ce2
        failing since 62 days (last pass: v4.14.206-21-g787a7a3ca16c, first=
 fail: v4.14.206-22-ga949bf40fb01) =

 =



platform             | arch  | lab           | compiler | defconfig        =
   | regressions
---------------------+-------+---------------+----------+------------------=
---+------------
qemu_arm-versatilepb | arm   | lab-broonie   | gcc-8    | versatile_defconf=
ig | 1          =


  Details:     https://kernelci.org/test/plan/id/6001a4bc3d759c37d2c94ce3

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.215=
-28-g44cb20ad2e61/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_a=
rm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.215=
-28-g44cb20ad2e61/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_a=
rm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6001a4bc3d759c37d2c94=
ce4
        failing since 62 days (last pass: v4.14.206-21-g787a7a3ca16c, first=
 fail: v4.14.206-22-ga949bf40fb01) =

 =



platform             | arch  | lab           | compiler | defconfig        =
   | regressions
---------------------+-------+---------------+----------+------------------=
---+------------
qemu_arm-versatilepb | arm   | lab-cip       | gcc-8    | versatile_defconf=
ig | 1          =


  Details:     https://kernelci.org/test/plan/id/6001a491f53103a294c94cd1

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.215=
-28-g44cb20ad2e61/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-v=
ersatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.215=
-28-g44cb20ad2e61/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-v=
ersatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6001a491f53103a294c94=
cd2
        failing since 62 days (last pass: v4.14.206-21-g787a7a3ca16c, first=
 fail: v4.14.206-22-ga949bf40fb01) =

 =



platform             | arch  | lab           | compiler | defconfig        =
   | regressions
---------------------+-------+---------------+----------+------------------=
---+------------
qemu_arm-versatilepb | arm   | lab-collabora | gcc-8    | versatile_defconf=
ig | 1          =


  Details:     https://kernelci.org/test/plan/id/6001b506194821d1e4c94cc0

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.215=
-28-g44cb20ad2e61/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu=
_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.215=
-28-g44cb20ad2e61/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu=
_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6001b506194821d1e4c94=
cc1
        failing since 62 days (last pass: v4.14.206-21-g787a7a3ca16c, first=
 fail: v4.14.206-22-ga949bf40fb01) =

 =20
