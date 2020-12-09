Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7208F2D476A
	for <lists+stable@lfdr.de>; Wed,  9 Dec 2020 18:06:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731117AbgLIRFN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 9 Dec 2020 12:05:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60522 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731105AbgLIRFN (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 9 Dec 2020 12:05:13 -0500
Received: from mail-pf1-x42a.google.com (mail-pf1-x42a.google.com [IPv6:2607:f8b0:4864:20::42a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C73C0C061793
        for <stable@vger.kernel.org>; Wed,  9 Dec 2020 09:04:32 -0800 (PST)
Received: by mail-pf1-x42a.google.com with SMTP id b26so1416017pfi.3
        for <stable@vger.kernel.org>; Wed, 09 Dec 2020 09:04:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=eLydimx3TBKbhZ5PbgHrLeWQVGcMKJQgJrCzItKUwjI=;
        b=WBYwU/uD61z2W7XiRdm7PPYbMNM8ziKQpEh5q95kHiLSTUrY40Hh/UVnP9oESmZm9a
         Kd3CZq3tyKV8MNd34jHS/jcgxMbncFFGHq/N6S/ARV7PHragJzob0I/cCYsxbNwIXYvj
         tHZNpHT4qj7QDE4uwYr3iIffiuAAwBWRfRUSA0cDHkM6PSt/N2le28oAehdhrni0sFhj
         Z6gR4x1lm0u5Nj7e4XluCtavL6JQ7FxvSvYDyZtEV0+Kp0gt2fA5VYo4waooxW9v/wqc
         RMUUCtgGCMTDwhy+qTu8mlMLAgmfodRgdY+qfFTGqcASuJ/5oAVHBB2XZY2Xe6GAC/g1
         cMJA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=eLydimx3TBKbhZ5PbgHrLeWQVGcMKJQgJrCzItKUwjI=;
        b=OmyUEPAF5k3/6cOuWYFcWFcwJCF/J27gVZKvjcMTsfthGnPCVtOoC4nGGupv0YXtaH
         qv1Uf2I0REEcl8RVTM9wJzC35HFtvOfPzl/yzA88v2mZTworXvksTMFL0drKDmbeQdjI
         +tx3efgnZSyuG006utQAKWBkbay/enQcMopmjgzLzVYUXOHaUxNvsUuxMUXTZn6tFxW1
         ibQbWkFyH3OELsObTqAB8q+BLd5DYrlZFe5X53aOWewZ8CVdJzkHShcOZ9+TnYdVSEYR
         X52Vumfy9gm0GfHESV/2esWUG6e3wk/ZXK3M9CV/pITCfTosajI6vYedBpRhsWSMLAT9
         XVxg==
X-Gm-Message-State: AOAM531qWVQWkjUpRe10TUDy1XKaYO9VrTnaBcOi/iLuwoeQPIrunPvh
        0EXzghINJw7KR+lAQ1LvQsfmWT95lDkTbA==
X-Google-Smtp-Source: ABdhPJy2urRGZgyDghINcnp0gRSeCcI8y0qBX4fkGsGC7l8cJQYI2ru5d3hNhG+5D5M74m4preHJgQ==
X-Received: by 2002:a63:1e11:: with SMTP id e17mr2796706pge.156.1607533471285;
        Wed, 09 Dec 2020 09:04:31 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id l3sm2595580pju.44.2020.12.09.09.04.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 09 Dec 2020 09:04:30 -0800 (PST)
Message-ID: <5fd1039e.1c69fb81.109d5.4b90@mx.google.com>
Date:   Wed, 09 Dec 2020 09:04:30 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: queue/4.9
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v4.9.247-35-g5e0c9eb873819
X-Kernelci-Report-Type: test
Subject: stable-rc/queue/4.9 baseline: 124 runs,
 8 regressions (v4.9.247-35-g5e0c9eb873819)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.9 baseline: 124 runs, 8 regressions (v4.9.247-35-g5e0c9eb=
873819)

Regressions Summary
-------------------

platform              | arch  | lab           | compiler | defconfig       =
    | regressions
----------------------+-------+---------------+----------+-----------------=
----+------------
at91-sama5d4_xplained | arm   | lab-baylibre  | gcc-8    | sama5_defconfig =
    | 1          =

meson-gxbb-p200       | arm64 | lab-baylibre  | gcc-8    | defconfig       =
    | 1          =

panda                 | arm   | lab-collabora | gcc-8    | omap2plus_defcon=
fig | 1          =

qemu_arm-versatilepb  | arm   | lab-baylibre  | gcc-8    | versatile_defcon=
fig | 1          =

qemu_arm-versatilepb  | arm   | lab-broonie   | gcc-8    | versatile_defcon=
fig | 1          =

qemu_arm-versatilepb  | arm   | lab-cip       | gcc-8    | versatile_defcon=
fig | 1          =

qemu_arm-versatilepb  | arm   | lab-collabora | gcc-8    | versatile_defcon=
fig | 1          =

r8a7795-salvator-x    | arm64 | lab-baylibre  | gcc-8    | defconfig       =
    | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.9/kern=
el/v4.9.247-35-g5e0c9eb873819/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.9
  Describe: v4.9.247-35-g5e0c9eb873819
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      5e0c9eb873819aa968091aaa21ba9b2c6078cf3d =



Test Regressions
---------------- =



platform              | arch  | lab           | compiler | defconfig       =
    | regressions
----------------------+-------+---------------+----------+-----------------=
----+------------
at91-sama5d4_xplained | arm   | lab-baylibre  | gcc-8    | sama5_defconfig =
    | 1          =


  Details:     https://kernelci.org/test/plan/id/5fd0d038abfed28f23c94cd1

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: sama5_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.247-3=
5-g5e0c9eb873819/arm/sama5_defconfig/gcc-8/lab-baylibre/baseline-at91-sama5=
d4_xplained.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.247-3=
5-g5e0c9eb873819/arm/sama5_defconfig/gcc-8/lab-baylibre/baseline-at91-sama5=
d4_xplained.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fd0d038abfed28f23c94=
cd2
        failing since 41 days (last pass: v4.9.240-139-gd719c4ad8056, first=
 fail: v4.9.240-139-g65bd9a74252c) =

 =



platform              | arch  | lab           | compiler | defconfig       =
    | regressions
----------------------+-------+---------------+----------+-----------------=
----+------------
meson-gxbb-p200       | arm64 | lab-baylibre  | gcc-8    | defconfig       =
    | 1          =


  Details:     https://kernelci.org/test/plan/id/5fd0cec6da9c78f0d7c94cb9

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.247-3=
5-g5e0c9eb873819/arm64/defconfig/gcc-8/lab-baylibre/baseline-meson-gxbb-p20=
0.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.247-3=
5-g5e0c9eb873819/arm64/defconfig/gcc-8/lab-baylibre/baseline-meson-gxbb-p20=
0.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fd0cec6da9c78f0d7c94=
cba
        new failure (last pass: v4.9.247-33-ge34980fc14c5e) =

 =



platform              | arch  | lab           | compiler | defconfig       =
    | regressions
----------------------+-------+---------------+----------+-----------------=
----+------------
panda                 | arm   | lab-collabora | gcc-8    | omap2plus_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/5fd0d3010d39401c82c94cc8

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.247-3=
5-g5e0c9eb873819/arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-panda=
.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.247-3=
5-g5e0c9eb873819/arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-panda=
.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fd0d3010d39401c82c94=
cc9
        new failure (last pass: v4.9.247-34-ge5b55f8b0d86c) =

 =



platform              | arch  | lab           | compiler | defconfig       =
    | regressions
----------------------+-------+---------------+----------+-----------------=
----+------------
qemu_arm-versatilepb  | arm   | lab-baylibre  | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/5fd0d13618d913a0e7c94cd8

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.247-3=
5-g5e0c9eb873819/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_a=
rm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.247-3=
5-g5e0c9eb873819/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_a=
rm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fd0d13618d913a0e7c94=
cd9
        failing since 25 days (last pass: v4.9.243-16-gd8d67e375b0a, first =
fail: v4.9.243-25-ga01fe8e99a22) =

 =



platform              | arch  | lab           | compiler | defconfig       =
    | regressions
----------------------+-------+---------------+----------+-----------------=
----+------------
qemu_arm-versatilepb  | arm   | lab-broonie   | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/5fd0d76d6d9c2ce936c94cef

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.247-3=
5-g5e0c9eb873819/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_ar=
m-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.247-3=
5-g5e0c9eb873819/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_ar=
m-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fd0d76d6d9c2ce936c94=
cf0
        failing since 25 days (last pass: v4.9.243-16-gd8d67e375b0a, first =
fail: v4.9.243-25-ga01fe8e99a22) =

 =



platform              | arch  | lab           | compiler | defconfig       =
    | regressions
----------------------+-------+---------------+----------+-----------------=
----+------------
qemu_arm-versatilepb  | arm   | lab-cip       | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/5fd0d29be770b1acccc94cba

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.247-3=
5-g5e0c9eb873819/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-ve=
rsatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.247-3=
5-g5e0c9eb873819/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-ve=
rsatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fd0d29be770b1acccc94=
cbb
        failing since 25 days (last pass: v4.9.243-16-gd8d67e375b0a, first =
fail: v4.9.243-25-ga01fe8e99a22) =

 =



platform              | arch  | lab           | compiler | defconfig       =
    | regressions
----------------------+-------+---------------+----------+-----------------=
----+------------
qemu_arm-versatilepb  | arm   | lab-collabora | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/5fd0d22a77b9618fc4c94ce3

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.247-3=
5-g5e0c9eb873819/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu_=
arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.247-3=
5-g5e0c9eb873819/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu_=
arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fd0d22a77b9618fc4c94=
ce4
        failing since 25 days (last pass: v4.9.243-16-gd8d67e375b0a, first =
fail: v4.9.243-25-ga01fe8e99a22) =

 =



platform              | arch  | lab           | compiler | defconfig       =
    | regressions
----------------------+-------+---------------+----------+-----------------=
----+------------
r8a7795-salvator-x    | arm64 | lab-baylibre  | gcc-8    | defconfig       =
    | 1          =


  Details:     https://kernelci.org/test/plan/id/5fd0ce62cafb1c3609c94ce1

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.247-3=
5-g5e0c9eb873819/arm64/defconfig/gcc-8/lab-baylibre/baseline-r8a7795-salvat=
or-x.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.247-3=
5-g5e0c9eb873819/arm64/defconfig/gcc-8/lab-baylibre/baseline-r8a7795-salvat=
or-x.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fd0ce62cafb1c3609c94=
ce2
        failing since 21 days (last pass: v4.9.243-24-ga8ede488cf7a, first =
fail: v4.9.243-77-g36ec779d6aa89) =

 =20
