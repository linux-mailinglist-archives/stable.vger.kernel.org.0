Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AF5E32F9A53
	for <lists+stable@lfdr.de>; Mon, 18 Jan 2021 08:03:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731180AbhARHDm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 Jan 2021 02:03:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42920 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725868AbhARHDl (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 18 Jan 2021 02:03:41 -0500
Received: from mail-pj1-x1031.google.com (mail-pj1-x1031.google.com [IPv6:2607:f8b0:4864:20::1031])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2943BC061573
        for <stable@vger.kernel.org>; Sun, 17 Jan 2021 23:03:01 -0800 (PST)
Received: by mail-pj1-x1031.google.com with SMTP id m5so9153526pjv.5
        for <stable@vger.kernel.org>; Sun, 17 Jan 2021 23:03:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=Y5HDzhiRVNWqUHW9YYPzqGtYSBol7d/OHwv1kwVo8qk=;
        b=ho7qHd+kTg3qhZP2t93syajIN6gIXCtBqOIumc5pWFPn3CcqmGssSQAVgcUhuCWJhU
         3S1GAXXPCoUhizX0/SdoIRa4cPZBYzX5ToSmbimEAjrCqLKgVBL5R15l+2nwNncJb685
         D4xO/LDpTODId/WmsAH1StJp1xkW2NRqBFa9UFaLpEsu70cV2LF+P3LJGFnccwVzMuL/
         Zy/7gAvBqMLRbG500wleKBwdsWtLX+JEnG1DE+iJJcN6xQ8v+k7BiX59AZdGBGw0simd
         keE7pwG/+KIpKQhV+fSGz6Q+MKmsgJ+amoeLAV6oEDstoVxMrJXJIwVaUv57wxbUhrZH
         EeeA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=Y5HDzhiRVNWqUHW9YYPzqGtYSBol7d/OHwv1kwVo8qk=;
        b=R8Rc7ww5tnSe937SOI3HVbMJC1G9MFhIqs4mud6w0jGq/GFO0PqglqFPOdFPUNEyA0
         2sWl2BQJnamqq6Tjht4YkMGXykqgBreYUZpM2mqRAdm2idlXAVUZMvIT5gv28QEjxKtX
         YAxjHqjiKhbaosYuCdJ3L5dRRMJMydXkVr1DykbNcF8n5lzUdWVr2s0OumKCbAM4RBIW
         OH1yog+fC8onnMh2Ktn54Qj2+PuIEZbeoKNqrR+krMB28vjBOjx9uKI0HVfCkrOvSmLP
         AO8B6QVRM0mXSfmr8W6xT9Ak0iAD7nI4mvIBUuQW7C6G17ilyBtuvHKOLvAcnomIFm+R
         2jvA==
X-Gm-Message-State: AOAM532avGx3VPiNUR4/7aHobjH4j1fOV8ugpeHJA7/lnz9L8C+XRCm1
        CWl7N7cT8NvNrHz8hScwqa7neqjBbU9/ng==
X-Google-Smtp-Source: ABdhPJzbcTWFoLRVUp82uhCkn2HZmncF/AWo6P9PAwFy+1QL0WMLJFK7j+Kts7O3hFoF6QJlRIMpeg==
X-Received: by 2002:a17:902:c115:b029:de:8961:47e5 with SMTP id 21-20020a170902c115b02900de896147e5mr11616748pli.46.1610953380129;
        Sun, 17 Jan 2021 23:03:00 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id h12sm15070012pgs.7.2021.01.17.23.02.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 17 Jan 2021 23:02:59 -0800 (PST)
Message-ID: <600532a3.1c69fb81.6f584.5dc6@mx.google.com>
Date:   Sun, 17 Jan 2021 23:02:59 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: queue/4.4
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v4.4.252-11-g5e0a4488a3bb5
X-Kernelci-Report-Type: test
Subject: stable-rc/queue/4.4 baseline: 113 runs,
 15 regressions (v4.4.252-11-g5e0a4488a3bb5)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.4 baseline: 113 runs, 15 regressions (v4.4.252-11-g5e0a44=
88a3bb5)

Regressions Summary
-------------------

platform            | arch   | lab             | compiler | defconfig      =
     | regressions
--------------------+--------+-----------------+----------+----------------=
-----+------------
panda               | arm    | lab-collabora   | gcc-8    | omap2plus_defco=
nfig | 1          =

qemu_arm-virt-gicv2 | arm    | lab-baylibre    | gcc-8    | multi_v7_defcon=
fig  | 1          =

qemu_arm-virt-gicv2 | arm    | lab-broonie     | gcc-8    | multi_v7_defcon=
fig  | 1          =

qemu_arm-virt-gicv2 | arm    | lab-cip         | gcc-8    | multi_v7_defcon=
fig  | 1          =

qemu_arm-virt-gicv2 | arm    | lab-collabora   | gcc-8    | multi_v7_defcon=
fig  | 1          =

qemu_arm-virt-gicv2 | arm    | lab-linaro-lkft | gcc-8    | multi_v7_defcon=
fig  | 1          =

qemu_arm-virt-gicv3 | arm    | lab-baylibre    | gcc-8    | multi_v7_defcon=
fig  | 1          =

qemu_arm-virt-gicv3 | arm    | lab-broonie     | gcc-8    | multi_v7_defcon=
fig  | 1          =

qemu_arm-virt-gicv3 | arm    | lab-cip         | gcc-8    | multi_v7_defcon=
fig  | 1          =

qemu_arm-virt-gicv3 | arm    | lab-collabora   | gcc-8    | multi_v7_defcon=
fig  | 1          =

qemu_arm-virt-gicv3 | arm    | lab-linaro-lkft | gcc-8    | multi_v7_defcon=
fig  | 1          =

qemu_i386           | i386   | lab-baylibre    | gcc-8    | i386_defconfig =
     | 1          =

qemu_i386-uefi      | i386   | lab-baylibre    | gcc-8    | i386_defconfig =
     | 1          =

qemu_i386-uefi      | i386   | lab-broonie     | gcc-8    | i386_defconfig =
     | 1          =

qemu_x86_64         | x86_64 | lab-broonie     | gcc-8    | x86_64_defconfi=
g    | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.4/kern=
el/v4.4.252-11-g5e0a4488a3bb5/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.4
  Describe: v4.4.252-11-g5e0a4488a3bb5
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      5e0a4488a3bb58a42099cfae2bde13942ac47c33 =



Test Regressions
---------------- =



platform            | arch   | lab             | compiler | defconfig      =
     | regressions
--------------------+--------+-----------------+----------+----------------=
-----+------------
panda               | arm    | lab-collabora   | gcc-8    | omap2plus_defco=
nfig | 1          =


  Details:     https://kernelci.org/test/plan/id/6004f9f6c0ae944a51c94cc7

  Results:     3 PASS, 1 FAIL, 1 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.252-1=
1-g5e0a4488a3bb5/arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-panda=
.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.252-1=
1-g5e0a4488a3bb5/arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-panda=
.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/6004f9f7c0ae944=
a51c94ccc
        failing since 0 day (last pass: v4.4.252-4-g8f1315d1b1ec, first fai=
l: v4.4.252-11-g5890028bd2b67)
        2 lines

    2021-01-18 03:01:07.097000+00:00  kern  :emerg :  lock: emif_lock+0x0/0=
xfffff26c [emif], .magic: dead4ead, .owner: <none>/-1, .owner_cpu: -1   =

 =



platform            | arch   | lab             | compiler | defconfig      =
     | regressions
--------------------+--------+-----------------+----------+----------------=
-----+------------
qemu_arm-virt-gicv2 | arm    | lab-baylibre    | gcc-8    | multi_v7_defcon=
fig  | 1          =


  Details:     https://kernelci.org/test/plan/id/6004f98e9e2c85d2b5c94dc7

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.252-1=
1-g5e0a4488a3bb5/arm/multi_v7_defconfig/gcc-8/lab-baylibre/baseline-qemu_ar=
m-virt-gicv2.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.252-1=
1-g5e0a4488a3bb5/arm/multi_v7_defconfig/gcc-8/lab-baylibre/baseline-qemu_ar=
m-virt-gicv2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6004f98e9e2c85d2b5c94=
dc8
        failing since 65 days (last pass: v4.4.243-18-gfc7e8c68369a, first =
fail: v4.4.243-19-g71b6c961c7fe) =

 =



platform            | arch   | lab             | compiler | defconfig      =
     | regressions
--------------------+--------+-----------------+----------+----------------=
-----+------------
qemu_arm-virt-gicv2 | arm    | lab-broonie     | gcc-8    | multi_v7_defcon=
fig  | 1          =


  Details:     https://kernelci.org/test/plan/id/6004f9efd7329a10f4c94cbe

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.252-1=
1-g5e0a4488a3bb5/arm/multi_v7_defconfig/gcc-8/lab-broonie/baseline-qemu_arm=
-virt-gicv2.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.252-1=
1-g5e0a4488a3bb5/arm/multi_v7_defconfig/gcc-8/lab-broonie/baseline-qemu_arm=
-virt-gicv2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6004f9efd7329a10f4c94=
cbf
        failing since 65 days (last pass: v4.4.243-18-gfc7e8c68369a, first =
fail: v4.4.243-19-g71b6c961c7fe) =

 =



platform            | arch   | lab             | compiler | defconfig      =
     | regressions
--------------------+--------+-----------------+----------+----------------=
-----+------------
qemu_arm-virt-gicv2 | arm    | lab-cip         | gcc-8    | multi_v7_defcon=
fig  | 1          =


  Details:     https://kernelci.org/test/plan/id/6004f9a29e2c85d2b5c94e00

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.252-1=
1-g5e0a4488a3bb5/arm/multi_v7_defconfig/gcc-8/lab-cip/baseline-qemu_arm-vir=
t-gicv2.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.252-1=
1-g5e0a4488a3bb5/arm/multi_v7_defconfig/gcc-8/lab-cip/baseline-qemu_arm-vir=
t-gicv2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6004f9a29e2c85d2b5c94=
e01
        failing since 65 days (last pass: v4.4.243-18-gfc7e8c68369a, first =
fail: v4.4.243-19-g71b6c961c7fe) =

 =



platform            | arch   | lab             | compiler | defconfig      =
     | regressions
--------------------+--------+-----------------+----------+----------------=
-----+------------
qemu_arm-virt-gicv2 | arm    | lab-collabora   | gcc-8    | multi_v7_defcon=
fig  | 1          =


  Details:     https://kernelci.org/test/plan/id/6004fd2e8619f262aac94cca

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.252-1=
1-g5e0a4488a3bb5/arm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-qemu_a=
rm-virt-gicv2.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.252-1=
1-g5e0a4488a3bb5/arm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-qemu_a=
rm-virt-gicv2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6004fd2e8619f262aac94=
ccb
        failing since 65 days (last pass: v4.4.243-18-gfc7e8c68369a, first =
fail: v4.4.243-19-g71b6c961c7fe) =

 =



platform            | arch   | lab             | compiler | defconfig      =
     | regressions
--------------------+--------+-----------------+----------+----------------=
-----+------------
qemu_arm-virt-gicv2 | arm    | lab-linaro-lkft | gcc-8    | multi_v7_defcon=
fig  | 1          =


  Details:     https://kernelci.org/test/plan/id/6004fa23eb9004dae6c94cd5

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.252-1=
1-g5e0a4488a3bb5/arm/multi_v7_defconfig/gcc-8/lab-linaro-lkft/baseline-qemu=
_arm-virt-gicv2.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.252-1=
1-g5e0a4488a3bb5/arm/multi_v7_defconfig/gcc-8/lab-linaro-lkft/baseline-qemu=
_arm-virt-gicv2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6004fa23eb9004dae6c94=
cd6
        failing since 65 days (last pass: v4.4.243-18-gfc7e8c68369a, first =
fail: v4.4.243-19-g71b6c961c7fe) =

 =



platform            | arch   | lab             | compiler | defconfig      =
     | regressions
--------------------+--------+-----------------+----------+----------------=
-----+------------
qemu_arm-virt-gicv3 | arm    | lab-baylibre    | gcc-8    | multi_v7_defcon=
fig  | 1          =


  Details:     https://kernelci.org/test/plan/id/6004f98d9e2c85d2b5c94dc4

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.252-1=
1-g5e0a4488a3bb5/arm/multi_v7_defconfig/gcc-8/lab-baylibre/baseline-qemu_ar=
m-virt-gicv3.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.252-1=
1-g5e0a4488a3bb5/arm/multi_v7_defconfig/gcc-8/lab-baylibre/baseline-qemu_ar=
m-virt-gicv3.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6004f98d9e2c85d2b5c94=
dc5
        failing since 65 days (last pass: v4.4.243-18-gfc7e8c68369a, first =
fail: v4.4.243-19-g71b6c961c7fe) =

 =



platform            | arch   | lab             | compiler | defconfig      =
     | regressions
--------------------+--------+-----------------+----------+----------------=
-----+------------
qemu_arm-virt-gicv3 | arm    | lab-broonie     | gcc-8    | multi_v7_defcon=
fig  | 1          =


  Details:     https://kernelci.org/test/plan/id/6004f98f9e2c85d2b5c94dca

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.252-1=
1-g5e0a4488a3bb5/arm/multi_v7_defconfig/gcc-8/lab-broonie/baseline-qemu_arm=
-virt-gicv3.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.252-1=
1-g5e0a4488a3bb5/arm/multi_v7_defconfig/gcc-8/lab-broonie/baseline-qemu_arm=
-virt-gicv3.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6004f98f9e2c85d2b5c94=
dcb
        failing since 65 days (last pass: v4.4.243-18-gfc7e8c68369a, first =
fail: v4.4.243-19-g71b6c961c7fe) =

 =



platform            | arch   | lab             | compiler | defconfig      =
     | regressions
--------------------+--------+-----------------+----------+----------------=
-----+------------
qemu_arm-virt-gicv3 | arm    | lab-cip         | gcc-8    | multi_v7_defcon=
fig  | 1          =


  Details:     https://kernelci.org/test/plan/id/6004f96532abcb082ac94cd1

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.252-1=
1-g5e0a4488a3bb5/arm/multi_v7_defconfig/gcc-8/lab-cip/baseline-qemu_arm-vir=
t-gicv3.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.252-1=
1-g5e0a4488a3bb5/arm/multi_v7_defconfig/gcc-8/lab-cip/baseline-qemu_arm-vir=
t-gicv3.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6004f96532abcb082ac94=
cd2
        failing since 65 days (last pass: v4.4.243-18-gfc7e8c68369a, first =
fail: v4.4.243-19-g71b6c961c7fe) =

 =



platform            | arch   | lab             | compiler | defconfig      =
     | regressions
--------------------+--------+-----------------+----------+----------------=
-----+------------
qemu_arm-virt-gicv3 | arm    | lab-collabora   | gcc-8    | multi_v7_defcon=
fig  | 1          =


  Details:     https://kernelci.org/test/plan/id/6004fb75120631d957c94cc7

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.252-1=
1-g5e0a4488a3bb5/arm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-qemu_a=
rm-virt-gicv3.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.252-1=
1-g5e0a4488a3bb5/arm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-qemu_a=
rm-virt-gicv3.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6004fb75120631d957c94=
cc8
        failing since 65 days (last pass: v4.4.243-18-gfc7e8c68369a, first =
fail: v4.4.243-19-g71b6c961c7fe) =

 =



platform            | arch   | lab             | compiler | defconfig      =
     | regressions
--------------------+--------+-----------------+----------+----------------=
-----+------------
qemu_arm-virt-gicv3 | arm    | lab-linaro-lkft | gcc-8    | multi_v7_defcon=
fig  | 1          =


  Details:     https://kernelci.org/test/plan/id/6004f9fbc0ae944a51c94cd0

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.252-1=
1-g5e0a4488a3bb5/arm/multi_v7_defconfig/gcc-8/lab-linaro-lkft/baseline-qemu=
_arm-virt-gicv3.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.252-1=
1-g5e0a4488a3bb5/arm/multi_v7_defconfig/gcc-8/lab-linaro-lkft/baseline-qemu=
_arm-virt-gicv3.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6004f9fbc0ae944a51c94=
cd1
        failing since 65 days (last pass: v4.4.243-18-gfc7e8c68369a, first =
fail: v4.4.243-19-g71b6c961c7fe) =

 =



platform            | arch   | lab             | compiler | defconfig      =
     | regressions
--------------------+--------+-----------------+----------+----------------=
-----+------------
qemu_i386           | i386   | lab-baylibre    | gcc-8    | i386_defconfig =
     | 1          =


  Details:     https://kernelci.org/test/plan/id/6004f96b32abcb082ac94cda

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: i386_defconfig
  Compiler:    gcc-8 (gcc (Debian 8.3.0-6) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.252-1=
1-g5e0a4488a3bb5/i386/i386_defconfig/gcc-8/lab-baylibre/baseline-qemu_i386.=
txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.252-1=
1-g5e0a4488a3bb5/i386/i386_defconfig/gcc-8/lab-baylibre/baseline-qemu_i386.=
html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/x86/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6004f96b32abcb082ac94=
cdb
        new failure (last pass: v4.4.252-11-g5890028bd2b67) =

 =



platform            | arch   | lab             | compiler | defconfig      =
     | regressions
--------------------+--------+-----------------+----------+----------------=
-----+------------
qemu_i386-uefi      | i386   | lab-baylibre    | gcc-8    | i386_defconfig =
     | 1          =


  Details:     https://kernelci.org/test/plan/id/6004f9979e2c85d2b5c94deb

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: i386_defconfig
  Compiler:    gcc-8 (gcc (Debian 8.3.0-6) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.252-1=
1-g5e0a4488a3bb5/i386/i386_defconfig/gcc-8/lab-baylibre/baseline-qemu_i386-=
uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.252-1=
1-g5e0a4488a3bb5/i386/i386_defconfig/gcc-8/lab-baylibre/baseline-qemu_i386-=
uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/x86/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6004f9989e2c85d2b5c94=
dec
        new failure (last pass: v4.4.252-11-g5890028bd2b67) =

 =



platform            | arch   | lab             | compiler | defconfig      =
     | regressions
--------------------+--------+-----------------+----------+----------------=
-----+------------
qemu_i386-uefi      | i386   | lab-broonie     | gcc-8    | i386_defconfig =
     | 1          =


  Details:     https://kernelci.org/test/plan/id/6004f9e4d7329a10f4c94cb9

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: i386_defconfig
  Compiler:    gcc-8 (gcc (Debian 8.3.0-6) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.252-1=
1-g5e0a4488a3bb5/i386/i386_defconfig/gcc-8/lab-broonie/baseline-qemu_i386-u=
efi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.252-1=
1-g5e0a4488a3bb5/i386/i386_defconfig/gcc-8/lab-broonie/baseline-qemu_i386-u=
efi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/x86/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6004f9e4d7329a10f4c94=
cba
        new failure (last pass: v4.4.252-11-g5890028bd2b67) =

 =



platform            | arch   | lab             | compiler | defconfig      =
     | regressions
--------------------+--------+-----------------+----------+----------------=
-----+------------
qemu_x86_64         | x86_64 | lab-broonie     | gcc-8    | x86_64_defconfi=
g    | 1          =


  Details:     https://kernelci.org/test/plan/id/6004f9355c52b285fac94cb9

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig
  Compiler:    gcc-8 (gcc (Debian 8.3.0-6) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.252-1=
1-g5e0a4488a3bb5/x86_64/x86_64_defconfig/gcc-8/lab-broonie/baseline-qemu_x8=
6_64.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.252-1=
1-g5e0a4488a3bb5/x86_64/x86_64_defconfig/gcc-8/lab-broonie/baseline-qemu_x8=
6_64.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/x86/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6004f9355c52b285fac94=
cba
        new failure (last pass: v4.4.252-11-g5890028bd2b67) =

 =20
