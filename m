Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5C3A24001A4
	for <lists+stable@lfdr.de>; Fri,  3 Sep 2021 17:01:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235434AbhICPCJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 3 Sep 2021 11:02:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45564 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349576AbhICPCJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 3 Sep 2021 11:02:09 -0400
Received: from mail-pl1-x62d.google.com (mail-pl1-x62d.google.com [IPv6:2607:f8b0:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 47606C061764
        for <stable@vger.kernel.org>; Fri,  3 Sep 2021 08:01:09 -0700 (PDT)
Received: by mail-pl1-x62d.google.com with SMTP id j2so3470794pll.1
        for <stable@vger.kernel.org>; Fri, 03 Sep 2021 08:01:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=cVCf2BTpp+PuZhQOj5MCviDI4VckBUZvpKx3rYJm2Bo=;
        b=nonlQZeZJq54jY+5FjJyoEf5plR5pSpwT5yJxLJkQGMnsBHCbrWq7N3UQpxGc6i0Pj
         JzZE5HHDcv5lki1dW7uAWRtTaNWUOJzf3xo2oxazawd5W9O5g8ZRhaBRVTwgIkfNNHAk
         Ey+LaFjZP/Y5RGwdXr9q8PgB4FKLcuc8THyEETuPtrH2o3YoJwRbmGLRA1TJinQZTE5I
         A03Ql5yfEH4XzKsz2nnK24nbmn/T/B8GRbfqrWdOoDZevzhAKFLgBjX5QrJfCT+piOrX
         LHmPMokyCUzPqSOnHj/oFURscQmiM+KTMT3rWvrxTmvnu74SkPT1AovpuKx0dMGnmm3B
         8yjA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=cVCf2BTpp+PuZhQOj5MCviDI4VckBUZvpKx3rYJm2Bo=;
        b=kz1oJcFo1R0ZeQoSbno7jIDsrOahDphl7fSQYO5n9LxxQWR8yzvSqPjTNBWthHnHrn
         6RmLpkPIjyZppqP9B3scRf6PXwcc5nqASESbwuUtA/OpXAY+lUfgfj0wv/azvXrXxgme
         EBvYAzyb3bMWDw5Dv3Ys3HUHXJHD4ic0Q98x0/mAD57fyS+XPozHUL/nZDLex/+But4k
         6F75AhtLhReAD956GJs6AubgiIb7mCFDParrbQeg+D+avXB0vhGQZRYV9ypewtjg7mFm
         rH/9ARr76AfYrWgpRlpJPv3umEFmGARGpC/LNTUj6e+DFd8I/1juh9KYjWaa+JJh29/o
         flZQ==
X-Gm-Message-State: AOAM5306/coZDuJinorz2K1Ltk5xGvazWXVF34RadlVGxmbNlJNdPCRR
        T8kC+C/hN5RCDw1UJ1sfSoTdcgOvq9/OYncJ
X-Google-Smtp-Source: ABdhPJw3BW7nnud9HcRU97Sure5t22v6B6SEWS24T4ItR210hmIPSrKVnvlP+V9mRauLp0c4xFAI5Q==
X-Received: by 2002:a17:90b:103:: with SMTP id p3mr10351519pjz.157.1630681268523;
        Fri, 03 Sep 2021 08:01:08 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id e16sm5301930pfc.214.2021.09.03.08.01.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 03 Sep 2021 08:01:08 -0700 (PDT)
Message-ID: <613238b4.1c69fb81.8f951.deca@mx.google.com>
Date:   Fri, 03 Sep 2021 08:01:08 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v4.4.283
X-Kernelci-Tree: stable
X-Kernelci-Branch: linux-4.4.y
Subject: stable/linux-4.4.y baseline: 100 runs, 8 regressions (v4.4.283)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable/linux-4.4.y baseline: 100 runs, 8 regressions (v4.4.283)

Regressions Summary
-------------------

platform            | arch | lab          | compiler | defconfig           =
| regressions
--------------------+------+--------------+----------+---------------------=
+------------
beagle-xm           | arm  | lab-baylibre | gcc-8    | omap2plus_defconfig =
| 2          =

qemu_arm-virt-gicv2 | arm  | lab-baylibre | gcc-8    | multi_v7_defconfig  =
| 1          =

qemu_arm-virt-gicv2 | arm  | lab-broonie  | gcc-8    | multi_v7_defconfig  =
| 1          =

qemu_arm-virt-gicv2 | arm  | lab-cip      | gcc-8    | multi_v7_defconfig  =
| 1          =

qemu_arm-virt-gicv3 | arm  | lab-baylibre | gcc-8    | multi_v7_defconfig  =
| 1          =

qemu_arm-virt-gicv3 | arm  | lab-broonie  | gcc-8    | multi_v7_defconfig  =
| 1          =

qemu_arm-virt-gicv3 | arm  | lab-cip      | gcc-8    | multi_v7_defconfig  =
| 1          =


  Details:  https://kernelci.org/test/job/stable/branch/linux-4.4.y/kernel/=
v4.4.283/plan/baseline/

  Test:     baseline
  Tree:     stable
  Branch:   linux-4.4.y
  Describe: v4.4.283
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able.git
  SHA:      cbc3014d0d917ba60a8ca3938316ef022ef11f8a =



Test Regressions
---------------- =



platform            | arch | lab          | compiler | defconfig           =
| regressions
--------------------+------+--------------+----------+---------------------=
+------------
beagle-xm           | arm  | lab-baylibre | gcc-8    | omap2plus_defconfig =
| 2          =


  Details:     https://kernelci.org/test/plan/id/6131ff08948209292dd5968f

  Results:     3 PASS, 2 FAIL, 1 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable/linux-4.4.y/v4.4.283/ar=
m/omap2plus_defconfig/gcc-8/lab-baylibre/baseline-beagle-xm.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.4.y/v4.4.283/ar=
m/omap2plus_defconfig/gcc-8/lab-baylibre/baseline-beagle-xm.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.dmesg.crit: https://kernelci.org/test/case/id/6131ff0894820929=
2dd59695
        failing since 7 days (last pass: v4.4.277, first fail: v4.4.282)
        1 lines

    2021-09-03T10:54:47.886636  / # #
    2021-09-03T10:54:47.887366  =

    2021-09-03T10:54:47.990691  / # #
    2021-09-03T10:54:47.991384  =

    2021-09-03T10:54:48.092699  / # #export SHELL=3D/bin/sh
    2021-09-03T10:54:48.093100  =

    2021-09-03T10:54:48.194226  / # export SHELL=3D/bin/sh. /lava-790441/en=
vironment
    2021-09-03T10:54:48.194554  =

    2021-09-03T10:54:48.295705  / # . /lava-790441/environment/lava-790441/=
bin/lava-test-runner /lava-790441/0
    2021-09-03T10:54:48.296774   =

    ... (9 line(s) more)  =


  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/6131ff089482092=
92dd59697
        failing since 7 days (last pass: v4.4.277, first fail: v4.4.282)
        28 lines

    2021-09-03T10:54:48.757688  [   49.982025] <LAVA_SIGNAL_TESTCASE TEST_C=
ASE_ID=3Dalert RESULT=3Dpass UNITS=3Dlines MEASUREMENT=3D0>
    2021-09-03T10:54:48.809281  kern  :emerg : Internal error: Oops - BUG: =
0 [#1] SMP ARM
    2021-09-03T10:54:48.815141  kern  :emerg : Process udevd (pid: 108, sta=
ck limit =3D 0xcb90a218)
    2021-09-03T10:54:48.819357  kern  :emerg : Stack: (0xcb90bd10 to 0xcb90=
c000)
    2021-09-03T10:54:48.827446  kern  :emerg : bd00:                       =
              bf02b83c bf010b84 cb9a7e10 bf02b8c8
    2021-09-03T10:54:48.840808  kern  :emerg : bd20: cb9a7e10 bf2020a8 0000=
0002 cb[   50.061584] <LAVA_SIGNAL_TESTCASE TEST_CASE_ID=3Demerg RESULT=3Df=
ail UNITS=3Dlines MEASUREMENT=3D28>   =

 =



platform            | arch | lab          | compiler | defconfig           =
| regressions
--------------------+------+--------------+----------+---------------------=
+------------
qemu_arm-virt-gicv2 | arm  | lab-baylibre | gcc-8    | multi_v7_defconfig  =
| 1          =


  Details:     https://kernelci.org/test/plan/id/613207edb28d423f58d5966a

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable/linux-4.4.y/v4.4.283/ar=
m/multi_v7_defconfig/gcc-8/lab-baylibre/baseline-qemu_arm-virt-gicv2.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.4.y/v4.4.283/ar=
m/multi_v7_defconfig/gcc-8/lab-baylibre/baseline-qemu_arm-virt-gicv2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/613207edb28d423f58d59=
66b
        failing since 285 days (last pass: v4.4.243, first fail: v4.4.245) =

 =



platform            | arch | lab          | compiler | defconfig           =
| regressions
--------------------+------+--------------+----------+---------------------=
+------------
qemu_arm-virt-gicv2 | arm  | lab-broonie  | gcc-8    | multi_v7_defconfig  =
| 1          =


  Details:     https://kernelci.org/test/plan/id/6132113be29eff7d0dd59677

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable/linux-4.4.y/v4.4.283/ar=
m/multi_v7_defconfig/gcc-8/lab-broonie/baseline-qemu_arm-virt-gicv2.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.4.y/v4.4.283/ar=
m/multi_v7_defconfig/gcc-8/lab-broonie/baseline-qemu_arm-virt-gicv2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6132113be29eff7d0dd59=
678
        failing since 285 days (last pass: v4.4.243, first fail: v4.4.245) =

 =



platform            | arch | lab          | compiler | defconfig           =
| regressions
--------------------+------+--------------+----------+---------------------=
+------------
qemu_arm-virt-gicv2 | arm  | lab-cip      | gcc-8    | multi_v7_defconfig  =
| 1          =


  Details:     https://kernelci.org/test/plan/id/6131ffa8039db4cfc5d596c4

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable/linux-4.4.y/v4.4.283/ar=
m/multi_v7_defconfig/gcc-8/lab-cip/baseline-qemu_arm-virt-gicv2.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.4.y/v4.4.283/ar=
m/multi_v7_defconfig/gcc-8/lab-cip/baseline-qemu_arm-virt-gicv2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6131ffa8039db4cfc5d59=
6c5
        failing since 285 days (last pass: v4.4.243, first fail: v4.4.245) =

 =



platform            | arch | lab          | compiler | defconfig           =
| regressions
--------------------+------+--------------+----------+---------------------=
+------------
qemu_arm-virt-gicv3 | arm  | lab-baylibre | gcc-8    | multi_v7_defconfig  =
| 1          =


  Details:     https://kernelci.org/test/plan/id/6132083bffa5706e0ed5968c

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable/linux-4.4.y/v4.4.283/ar=
m/multi_v7_defconfig/gcc-8/lab-baylibre/baseline-qemu_arm-virt-gicv3.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.4.y/v4.4.283/ar=
m/multi_v7_defconfig/gcc-8/lab-baylibre/baseline-qemu_arm-virt-gicv3.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6132083bffa5706e0ed59=
68d
        failing since 285 days (last pass: v4.4.243, first fail: v4.4.245) =

 =



platform            | arch | lab          | compiler | defconfig           =
| regressions
--------------------+------+--------------+----------+---------------------=
+------------
qemu_arm-virt-gicv3 | arm  | lab-broonie  | gcc-8    | multi_v7_defconfig  =
| 1          =


  Details:     https://kernelci.org/test/plan/id/613211c7cdfa0536bdd59683

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable/linux-4.4.y/v4.4.283/ar=
m/multi_v7_defconfig/gcc-8/lab-broonie/baseline-qemu_arm-virt-gicv3.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.4.y/v4.4.283/ar=
m/multi_v7_defconfig/gcc-8/lab-broonie/baseline-qemu_arm-virt-gicv3.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/613211c7cdfa0536bdd59=
684
        failing since 285 days (last pass: v4.4.243, first fail: v4.4.245) =

 =



platform            | arch | lab          | compiler | defconfig           =
| regressions
--------------------+------+--------------+----------+---------------------=
+------------
qemu_arm-virt-gicv3 | arm  | lab-cip      | gcc-8    | multi_v7_defconfig  =
| 1          =


  Details:     https://kernelci.org/test/plan/id/6131ffff768695469fd5966e

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable/linux-4.4.y/v4.4.283/ar=
m/multi_v7_defconfig/gcc-8/lab-cip/baseline-qemu_arm-virt-gicv3.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.4.y/v4.4.283/ar=
m/multi_v7_defconfig/gcc-8/lab-cip/baseline-qemu_arm-virt-gicv3.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6131ffff768695469fd59=
66f
        failing since 285 days (last pass: v4.4.243, first fail: v4.4.245) =

 =20
