Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4D9A92D3914
	for <lists+stable@lfdr.de>; Wed,  9 Dec 2020 04:04:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726435AbgLIDE2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Dec 2020 22:04:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43986 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725789AbgLIDEY (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 8 Dec 2020 22:04:24 -0500
Received: from mail-pl1-x629.google.com (mail-pl1-x629.google.com [IPv6:2607:f8b0:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 53B33C0613CF
        for <stable@vger.kernel.org>; Tue,  8 Dec 2020 19:03:44 -0800 (PST)
Received: by mail-pl1-x629.google.com with SMTP id y8so180789plp.8
        for <stable@vger.kernel.org>; Tue, 08 Dec 2020 19:03:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=Rsocz5BcODnWdiP+gxA8JE4/p7AhQ85oXwls1Fbl7tY=;
        b=CPYBgo/n/x+g6ruMr9XWr5kunyuhe5jiDDhWahJPOOt7N5bu6hy43dj21XHvC+ilyx
         C0Fy4PG/aFicoETMz3sFhEkRTb7jBor2Z8W52nweUaTagZVnR5tcjFju7PFoHm3+b5AY
         VbIkGcgcuBqla8a5jcYlchXDK/OPqXgIUu11PKS5ANnmMOK8KSLcQby2zzbguH9M8ogc
         1gEGR1MzdOc9XHBqRgzK30j+B714cF5FWMWgrPLaeIvcvE8/8PZZzSvAP578ob9INz1D
         zBPFKtsMOioerQKNQZ8NXD16HZ9FhLzJxPr6wF1eCtyCtcdTi+Q7TMAHPkYs2+UDedXM
         DbcA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=Rsocz5BcODnWdiP+gxA8JE4/p7AhQ85oXwls1Fbl7tY=;
        b=RrTyaX2GRfn3eFXxBFtGdbnnEfTZ9F3As0k3kdTRFEUnoLI8MAu4635kby0LjwXWak
         fLsM2FOs4eLLE7f8RnV/leYEAo7GVlUkfmD0jCogFurc+xkb9D65+Gw70WhLELCwalvn
         icQEcqSzpkOBiKIxkveAfmcGFR9ys+MYNtkdd/HskbmN7VS0VFGsHftS+JGzoIXHMEoS
         NEdXpDr5hmNiemXgYj06TxuKvuvI9GgCzLCwv7j9GmwRPzuNW0qwXtm5AdGlRHzmHLBs
         sAi0w2Df2bN9+KUJe+k3hWWmBFylFkkum9CZnOKitNle+w0Ra5k+14Cx6dx4exPArxKh
         Au7A==
X-Gm-Message-State: AOAM531xC/siuUvyMJIY70tF4YpZXiVwijaXjesqM8VRNks2vpVM5bWx
        Zpb6vhScFSt8N+ILaBZDPuqGgk/cYbA/sA==
X-Google-Smtp-Source: ABdhPJyddkv4uZyExy9msZfuZvW5WV7yrTL64kH1pIGVeLmCQTrtXZEIoIuOvx+ccIs6QCdO6vVmVQ==
X-Received: by 2002:a17:90a:f286:: with SMTP id fs6mr271760pjb.65.1607483023328;
        Tue, 08 Dec 2020 19:03:43 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id v17sm190428pga.58.2020.12.08.19.03.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 08 Dec 2020 19:03:42 -0800 (PST)
Message-ID: <5fd03e8e.1c69fb81.6d54e.0952@mx.google.com>
Date:   Tue, 08 Dec 2020 19:03:42 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: queue/4.4
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v4.4.247-15-ga32da6d21a77
X-Kernelci-Report-Type: test
Subject: stable-rc/queue/4.4 baseline: 103 runs,
 12 regressions (v4.4.247-15-ga32da6d21a77)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.4 baseline: 103 runs, 12 regressions (v4.4.247-15-ga32da6=
d21a77)

Regressions Summary
-------------------

platform            | arch   | lab           | compiler | defconfig        =
   | regressions
--------------------+--------+---------------+----------+------------------=
---+------------
panda               | arm    | lab-collabora | gcc-8    | omap2plus_defconf=
ig | 1          =

qemu_arm-virt-gicv2 | arm    | lab-baylibre  | gcc-8    | multi_v7_defconfi=
g  | 1          =

qemu_arm-virt-gicv2 | arm    | lab-broonie   | gcc-8    | multi_v7_defconfi=
g  | 1          =

qemu_arm-virt-gicv2 | arm    | lab-cip       | gcc-8    | multi_v7_defconfi=
g  | 1          =

qemu_arm-virt-gicv2 | arm    | lab-collabora | gcc-8    | multi_v7_defconfi=
g  | 1          =

qemu_arm-virt-gicv3 | arm    | lab-baylibre  | gcc-8    | multi_v7_defconfi=
g  | 1          =

qemu_arm-virt-gicv3 | arm    | lab-broonie   | gcc-8    | multi_v7_defconfi=
g  | 1          =

qemu_arm-virt-gicv3 | arm    | lab-cip       | gcc-8    | multi_v7_defconfi=
g  | 1          =

qemu_arm-virt-gicv3 | arm    | lab-collabora | gcc-8    | multi_v7_defconfi=
g  | 1          =

qemu_i386           | i386   | lab-baylibre  | gcc-8    | i386_defconfig   =
   | 1          =

qemu_i386-uefi      | i386   | lab-baylibre  | gcc-8    | i386_defconfig   =
   | 1          =

qemu_x86_64-uefi    | x86_64 | lab-baylibre  | gcc-8    | x86_64_defconfig =
   | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.4/kern=
el/v4.4.247-15-ga32da6d21a77/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.4
  Describe: v4.4.247-15-ga32da6d21a77
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      a32da6d21a77d6c191f8e3665772fd46ce03251f =



Test Regressions
---------------- =



platform            | arch   | lab           | compiler | defconfig        =
   | regressions
--------------------+--------+---------------+----------+------------------=
---+------------
panda               | arm    | lab-collabora | gcc-8    | omap2plus_defconf=
ig | 1          =


  Details:     https://kernelci.org/test/plan/id/5fd00bd9ef56633ac2c94cde

  Results:     3 PASS, 1 FAIL, 1 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.247-1=
5-ga32da6d21a77/arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-panda.=
txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.247-1=
5-ga32da6d21a77/arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-panda.=
html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/5fd00bd9ef56633=
ac2c94ce3
        failing since 5 days (last pass: v4.4.247-4-ga92d60286ae0, first fa=
il: v4.4.247-4-gef81364d5eda)
        2 lines =

 =



platform            | arch   | lab           | compiler | defconfig        =
   | regressions
--------------------+--------+---------------+----------+------------------=
---+------------
qemu_arm-virt-gicv2 | arm    | lab-baylibre  | gcc-8    | multi_v7_defconfi=
g  | 1          =


  Details:     https://kernelci.org/test/plan/id/5fd00db3f15caefe70c94cb9

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.247-1=
5-ga32da6d21a77/arm/multi_v7_defconfig/gcc-8/lab-baylibre/baseline-qemu_arm=
-virt-gicv2.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.247-1=
5-ga32da6d21a77/arm/multi_v7_defconfig/gcc-8/lab-baylibre/baseline-qemu_arm=
-virt-gicv2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fd00db3f15caefe70c94=
cba
        failing since 25 days (last pass: v4.4.243-18-gfc7e8c68369a, first =
fail: v4.4.243-19-g71b6c961c7fe) =

 =



platform            | arch   | lab           | compiler | defconfig        =
   | regressions
--------------------+--------+---------------+----------+------------------=
---+------------
qemu_arm-virt-gicv2 | arm    | lab-broonie   | gcc-8    | multi_v7_defconfi=
g  | 1          =


  Details:     https://kernelci.org/test/plan/id/5fd00d72a483e0582ec94cdc

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.247-1=
5-ga32da6d21a77/arm/multi_v7_defconfig/gcc-8/lab-broonie/baseline-qemu_arm-=
virt-gicv2.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.247-1=
5-ga32da6d21a77/arm/multi_v7_defconfig/gcc-8/lab-broonie/baseline-qemu_arm-=
virt-gicv2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fd00d72a483e0582ec94=
cdd
        failing since 25 days (last pass: v4.4.243-18-gfc7e8c68369a, first =
fail: v4.4.243-19-g71b6c961c7fe) =

 =



platform            | arch   | lab           | compiler | defconfig        =
   | regressions
--------------------+--------+---------------+----------+------------------=
---+------------
qemu_arm-virt-gicv2 | arm    | lab-cip       | gcc-8    | multi_v7_defconfi=
g  | 1          =


  Details:     https://kernelci.org/test/plan/id/5fd00cebdeea13ec15c94cbf

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.247-1=
5-ga32da6d21a77/arm/multi_v7_defconfig/gcc-8/lab-cip/baseline-qemu_arm-virt=
-gicv2.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.247-1=
5-ga32da6d21a77/arm/multi_v7_defconfig/gcc-8/lab-cip/baseline-qemu_arm-virt=
-gicv2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fd00cebdeea13ec15c94=
cc0
        failing since 25 days (last pass: v4.4.243-18-gfc7e8c68369a, first =
fail: v4.4.243-19-g71b6c961c7fe) =

 =



platform            | arch   | lab           | compiler | defconfig        =
   | regressions
--------------------+--------+---------------+----------+------------------=
---+------------
qemu_arm-virt-gicv2 | arm    | lab-collabora | gcc-8    | multi_v7_defconfi=
g  | 1          =


  Details:     https://kernelci.org/test/plan/id/5fd00d454d3c1a65eec94cc3

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.247-1=
5-ga32da6d21a77/arm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-qemu_ar=
m-virt-gicv2.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.247-1=
5-ga32da6d21a77/arm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-qemu_ar=
m-virt-gicv2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fd00d454d3c1a65eec94=
cc4
        failing since 25 days (last pass: v4.4.243-18-gfc7e8c68369a, first =
fail: v4.4.243-19-g71b6c961c7fe) =

 =



platform            | arch   | lab           | compiler | defconfig        =
   | regressions
--------------------+--------+---------------+----------+------------------=
---+------------
qemu_arm-virt-gicv3 | arm    | lab-baylibre  | gcc-8    | multi_v7_defconfi=
g  | 1          =


  Details:     https://kernelci.org/test/plan/id/5fd00d0e902f2ea6f4c94cca

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.247-1=
5-ga32da6d21a77/arm/multi_v7_defconfig/gcc-8/lab-baylibre/baseline-qemu_arm=
-virt-gicv3.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.247-1=
5-ga32da6d21a77/arm/multi_v7_defconfig/gcc-8/lab-baylibre/baseline-qemu_arm=
-virt-gicv3.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fd00d0e902f2ea6f4c94=
ccb
        failing since 25 days (last pass: v4.4.243-18-gfc7e8c68369a, first =
fail: v4.4.243-19-g71b6c961c7fe) =

 =



platform            | arch   | lab           | compiler | defconfig        =
   | regressions
--------------------+--------+---------------+----------+------------------=
---+------------
qemu_arm-virt-gicv3 | arm    | lab-broonie   | gcc-8    | multi_v7_defconfi=
g  | 1          =


  Details:     https://kernelci.org/test/plan/id/5fd00d3033d260ad51c94d0b

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.247-1=
5-ga32da6d21a77/arm/multi_v7_defconfig/gcc-8/lab-broonie/baseline-qemu_arm-=
virt-gicv3.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.247-1=
5-ga32da6d21a77/arm/multi_v7_defconfig/gcc-8/lab-broonie/baseline-qemu_arm-=
virt-gicv3.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fd00d3033d260ad51c94=
d0c
        failing since 25 days (last pass: v4.4.243-18-gfc7e8c68369a, first =
fail: v4.4.243-19-g71b6c961c7fe) =

 =



platform            | arch   | lab           | compiler | defconfig        =
   | regressions
--------------------+--------+---------------+----------+------------------=
---+------------
qemu_arm-virt-gicv3 | arm    | lab-cip       | gcc-8    | multi_v7_defconfi=
g  | 1          =


  Details:     https://kernelci.org/test/plan/id/5fd00cfb3303ec7867c94cf2

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.247-1=
5-ga32da6d21a77/arm/multi_v7_defconfig/gcc-8/lab-cip/baseline-qemu_arm-virt=
-gicv3.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.247-1=
5-ga32da6d21a77/arm/multi_v7_defconfig/gcc-8/lab-cip/baseline-qemu_arm-virt=
-gicv3.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fd00cfb3303ec7867c94=
cf3
        failing since 25 days (last pass: v4.4.243-18-gfc7e8c68369a, first =
fail: v4.4.243-19-g71b6c961c7fe) =

 =



platform            | arch   | lab           | compiler | defconfig        =
   | regressions
--------------------+--------+---------------+----------+------------------=
---+------------
qemu_arm-virt-gicv3 | arm    | lab-collabora | gcc-8    | multi_v7_defconfi=
g  | 1          =


  Details:     https://kernelci.org/test/plan/id/5fd00cfe3303ec7867c94cfe

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.247-1=
5-ga32da6d21a77/arm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-qemu_ar=
m-virt-gicv3.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.247-1=
5-ga32da6d21a77/arm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-qemu_ar=
m-virt-gicv3.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fd00cfe3303ec7867c94=
cff
        failing since 25 days (last pass: v4.4.243-18-gfc7e8c68369a, first =
fail: v4.4.243-19-g71b6c961c7fe) =

 =



platform            | arch   | lab           | compiler | defconfig        =
   | regressions
--------------------+--------+---------------+----------+------------------=
---+------------
qemu_i386           | i386   | lab-baylibre  | gcc-8    | i386_defconfig   =
   | 1          =


  Details:     https://kernelci.org/test/plan/id/5fd00d2833d260ad51c94cff

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: i386_defconfig
  Compiler:    gcc-8 (gcc (Debian 8.3.0-6) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.247-1=
5-ga32da6d21a77/i386/i386_defconfig/gcc-8/lab-baylibre/baseline-qemu_i386.t=
xt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.247-1=
5-ga32da6d21a77/i386/i386_defconfig/gcc-8/lab-baylibre/baseline-qemu_i386.h=
tml
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/x86/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fd00d2833d260ad51c94=
d00
        new failure (last pass: v4.4.247-15-gfdea2d6d53dac) =

 =



platform            | arch   | lab           | compiler | defconfig        =
   | regressions
--------------------+--------+---------------+----------+------------------=
---+------------
qemu_i386-uefi      | i386   | lab-baylibre  | gcc-8    | i386_defconfig   =
   | 1          =


  Details:     https://kernelci.org/test/plan/id/5fd00d42fe7c15def3c94cb9

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: i386_defconfig
  Compiler:    gcc-8 (gcc (Debian 8.3.0-6) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.247-1=
5-ga32da6d21a77/i386/i386_defconfig/gcc-8/lab-baylibre/baseline-qemu_i386-u=
efi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.247-1=
5-ga32da6d21a77/i386/i386_defconfig/gcc-8/lab-baylibre/baseline-qemu_i386-u=
efi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/x86/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fd00d42fe7c15def3c94=
cba
        new failure (last pass: v4.4.247-15-gfdea2d6d53dac) =

 =



platform            | arch   | lab           | compiler | defconfig        =
   | regressions
--------------------+--------+---------------+----------+------------------=
---+------------
qemu_x86_64-uefi    | x86_64 | lab-baylibre  | gcc-8    | x86_64_defconfig =
   | 1          =


  Details:     https://kernelci.org/test/plan/id/5fd00dff177defa815c94d4d

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig
  Compiler:    gcc-8 (gcc (Debian 8.3.0-6) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.247-1=
5-ga32da6d21a77/x86_64/x86_64_defconfig/gcc-8/lab-baylibre/baseline-qemu_x8=
6_64-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.247-1=
5-ga32da6d21a77/x86_64/x86_64_defconfig/gcc-8/lab-baylibre/baseline-qemu_x8=
6_64-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/x86/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fd00dff177defa815c94=
d4e
        new failure (last pass: v4.4.247-15-gfdea2d6d53dac) =

 =20
