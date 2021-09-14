Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E340540A2D2
	for <lists+stable@lfdr.de>; Tue, 14 Sep 2021 03:49:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236326AbhINBuZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Sep 2021 21:50:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60210 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234034AbhINBuS (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Sep 2021 21:50:18 -0400
Received: from mail-pf1-x430.google.com (mail-pf1-x430.google.com [IPv6:2607:f8b0:4864:20::430])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DCAB5C061766
        for <stable@vger.kernel.org>; Mon, 13 Sep 2021 18:49:01 -0700 (PDT)
Received: by mail-pf1-x430.google.com with SMTP id y17so10615437pfl.13
        for <stable@vger.kernel.org>; Mon, 13 Sep 2021 18:49:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=J6MSVWyJuyhZ8yap9z8a7BokyLYCnhACSnfSfppBNME=;
        b=GHqjNNB/adzrzeNtMQp8cLeOurrbvSrPq2UPCy2BupylSsBDtQiYSv5ozPNuhh60Qh
         Ac0dVoISPdBXxN0zfwCllvtGQVIFqXOj37UQN79TMuFQo9ql4GnydEM4v7g3oapH2CMZ
         /wZymAwFaADK3eOtU1IvEFW/eA4ECXvEHoOoGSAMiUPvL0oK3HezBOIwfr2ledXG7UF3
         +5wSRou3JSEvPt4M+PDTQK16sGgsKxAUATLXCuyHiui48kjkw0H6bgkXWDvHjpBkXjmR
         nKTr4FKv1IChFb88eZIoBI1gcWdWns3C+tMbbL4ZVWPAc3KBIZs6XMZEpuDilKvZe3Nn
         vnrw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=J6MSVWyJuyhZ8yap9z8a7BokyLYCnhACSnfSfppBNME=;
        b=QQf8AI/fuxnwSkd7qTxrdZi7TOqQjevcExqJLCR32i5VNnI575JjS8wC4g7f9Ukt79
         6HIYEz2JeKJ9if30YgBpWCWKr0mp3XIaaLI3KrqquSLnIGVRz7P5L81vQc416IqPH4U6
         cRF6aVs3Hg8szzLmVyZJaII9ZbGLxSi6AYzWtZmOTG/1E0deWc4fYQORaCq3CKIOPugh
         CxHPicOVNtSke/kjcFGMrd06Z4o+xpJqkR0+Cv/Nus6LfxJGrRbCS8LKccyd3wk9CYGZ
         CwvPG/SnqQYFMa5GNO+PqUqKi0/lXnDeBc2OtyAtpmtXthrgvBZvMioe0GwqbsKdKssc
         NeVg==
X-Gm-Message-State: AOAM530S28/7rCoyqS6pXZZSGwZ92HY6QXEFvyWoPp9Zo1GwCo3iC2vD
        2DahyjxjhkLXsW11F+FkSJhaS/WCB0xmPB8J
X-Google-Smtp-Source: ABdhPJztAKcUDEUgZ1qIRmk1qixEpmAQbP6n2C/gKzWJlAs/DxlX7Qluv3Q0AYVm+XvKw6Swheewpg==
X-Received: by 2002:a62:28c:0:b0:405:397f:5c9e with SMTP id 134-20020a62028c000000b00405397f5c9emr2293641pfc.74.1631584141091;
        Mon, 13 Sep 2021 18:49:01 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id e11sm717240pfm.79.2021.09.13.18.49.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 Sep 2021 18:49:00 -0700 (PDT)
Message-ID: <613fff8c.1c69fb81.3bca9.3813@mx.google.com>
Date:   Mon, 13 Sep 2021 18:49:00 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.4.283-73-g04e131be02cf
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-4.4.y
Subject: stable-rc/linux-4.4.y baseline: 92 runs,
 8 regressions (v4.4.283-73-g04e131be02cf)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.4.y baseline: 92 runs, 8 regressions (v4.4.283-73-g04e131=
be02cf)

Regressions Summary
-------------------

platform            | arch | lab           | compiler | defconfig          =
 | regressions
--------------------+------+---------------+----------+--------------------=
-+------------
beagle-xm           | arm  | lab-baylibre  | gcc-8    | omap2plus_defconfig=
 | 2          =

qemu_arm-virt-gicv2 | arm  | lab-baylibre  | gcc-8    | multi_v7_defconfig =
 | 1          =

qemu_arm-virt-gicv2 | arm  | lab-cip       | gcc-8    | multi_v7_defconfig =
 | 1          =

qemu_arm-virt-gicv2 | arm  | lab-collabora | gcc-8    | multi_v7_defconfig =
 | 1          =

qemu_arm-virt-gicv3 | arm  | lab-baylibre  | gcc-8    | multi_v7_defconfig =
 | 1          =

qemu_arm-virt-gicv3 | arm  | lab-cip       | gcc-8    | multi_v7_defconfig =
 | 1          =

qemu_arm-virt-gicv3 | arm  | lab-collabora | gcc-8    | multi_v7_defconfig =
 | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-4.4.y/kern=
el/v4.4.283-73-g04e131be02cf/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-4.4.y
  Describe: v4.4.283-73-g04e131be02cf
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      04e131be02cf0b19beabcbadfd5acd482a16e6fd =



Test Regressions
---------------- =



platform            | arch | lab           | compiler | defconfig          =
 | regressions
--------------------+------+---------------+----------+--------------------=
-+------------
beagle-xm           | arm  | lab-baylibre  | gcc-8    | omap2plus_defconfig=
 | 2          =


  Details:     https://kernelci.org/test/plan/id/613fceb2d9dbd2abee99a314

  Results:     3 PASS, 2 FAIL, 1 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.4.y/v4.4.283=
-73-g04e131be02cf/arm/omap2plus_defconfig/gcc-8/lab-baylibre/baseline-beagl=
e-xm.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.4.y/v4.4.283=
-73-g04e131be02cf/arm/omap2plus_defconfig/gcc-8/lab-baylibre/baseline-beagl=
e-xm.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.dmesg.crit: https://kernelci.org/test/case/id/613fceb2d9dbd2ab=
ee99a31a
        new failure (last pass: v4.4.283-68-g373b6d2c441d)
        1 lines

    2021-09-13T22:20:16.716849  / # =

    2021-09-13T22:20:16.717586  #
    2021-09-13T22:20:16.820796  / # #
    2021-09-13T22:20:16.821369  =

    2021-09-13T22:20:16.922702  / # #export SHELL=3D/bin/sh
    2021-09-13T22:20:16.923136  =

    2021-09-13T22:20:17.024303  / # export SHELL=3D/bin/sh. /lava-841651/en=
vironment
    2021-09-13T22:20:17.024738  =

    2021-09-13T22:20:17.125882  / # . /lava-841651/environment/lava-841651/=
bin/lava-test-runner /lava-841651/0
    2021-09-13T22:20:17.126946   =

    ... (9 line(s) more)  =


  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/613fceb2d9dbd2a=
bee99a31c
        new failure (last pass: v4.4.283-68-g373b6d2c441d)
        28 lines

    2021-09-13T22:20:17.639853  kern  :emerg : Internal error: Oops - BUG: =
0 [#1] SMP ARM
    2021-09-13T22:20:17.645781  kern  :emerg : Process udevd (pid: 110, sta=
ck limit =3D 0xcb956218)
    2021-09-13T22:20:17.650112  kern  :emerg : Stack: (0xcb957d10 to 0xcb95=
8000)
    2021-09-13T22:20:17.658120  kern  :emerg : 7d00:                       =
              bf02b83c bf010b84 cba51610 bf02b8c8
    2021-09-13T22:20:17.671328  kern  :emerg : 7d20: cba51610 bf2190a8 0000=
0002 cb[   50.085632] <LAVA_SIGNAL_TESTCASE TEST_CASE_ID=3Demerg RESULT=3Df=
ail UNITS=3Dlines MEASUREMENT=3D28>   =

 =



platform            | arch | lab           | compiler | defconfig          =
 | regressions
--------------------+------+---------------+----------+--------------------=
-+------------
qemu_arm-virt-gicv2 | arm  | lab-baylibre  | gcc-8    | multi_v7_defconfig =
 | 1          =


  Details:     https://kernelci.org/test/plan/id/613fce224239cfb55799a2db

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.4.y/v4.4.283=
-73-g04e131be02cf/arm/multi_v7_defconfig/gcc-8/lab-baylibre/baseline-qemu_a=
rm-virt-gicv2.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.4.y/v4.4.283=
-73-g04e131be02cf/arm/multi_v7_defconfig/gcc-8/lab-baylibre/baseline-qemu_a=
rm-virt-gicv2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/613fce224239cfb55799a=
2dc
        failing since 303 days (last pass: v4.4.243-14-gcb8e837cb602, first=
 fail: v4.4.243-20-g3c35b64319c2) =

 =



platform            | arch | lab           | compiler | defconfig          =
 | regressions
--------------------+------+---------------+----------+--------------------=
-+------------
qemu_arm-virt-gicv2 | arm  | lab-cip       | gcc-8    | multi_v7_defconfig =
 | 1          =


  Details:     https://kernelci.org/test/plan/id/613fce464f53905a4599a2dd

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.4.y/v4.4.283=
-73-g04e131be02cf/arm/multi_v7_defconfig/gcc-8/lab-cip/baseline-qemu_arm-vi=
rt-gicv2.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.4.y/v4.4.283=
-73-g04e131be02cf/arm/multi_v7_defconfig/gcc-8/lab-cip/baseline-qemu_arm-vi=
rt-gicv2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/613fce464f53905a4599a=
2de
        failing since 303 days (last pass: v4.4.243-14-gcb8e837cb602, first=
 fail: v4.4.243-20-g3c35b64319c2) =

 =



platform            | arch | lab           | compiler | defconfig          =
 | regressions
--------------------+------+---------------+----------+--------------------=
-+------------
qemu_arm-virt-gicv2 | arm  | lab-collabora | gcc-8    | multi_v7_defconfig =
 | 1          =


  Details:     https://kernelci.org/test/plan/id/613fcef0d0437d323199a2ed

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.4.y/v4.4.283=
-73-g04e131be02cf/arm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-qemu_=
arm-virt-gicv2.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.4.y/v4.4.283=
-73-g04e131be02cf/arm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-qemu_=
arm-virt-gicv2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/613fcef0d0437d323199a=
2ee
        failing since 303 days (last pass: v4.4.243-14-gcb8e837cb602, first=
 fail: v4.4.243-20-g3c35b64319c2) =

 =



platform            | arch | lab           | compiler | defconfig          =
 | regressions
--------------------+------+---------------+----------+--------------------=
-+------------
qemu_arm-virt-gicv3 | arm  | lab-baylibre  | gcc-8    | multi_v7_defconfig =
 | 1          =


  Details:     https://kernelci.org/test/plan/id/613fce234239cfb55799a2de

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.4.y/v4.4.283=
-73-g04e131be02cf/arm/multi_v7_defconfig/gcc-8/lab-baylibre/baseline-qemu_a=
rm-virt-gicv3.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.4.y/v4.4.283=
-73-g04e131be02cf/arm/multi_v7_defconfig/gcc-8/lab-baylibre/baseline-qemu_a=
rm-virt-gicv3.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/613fce234239cfb55799a=
2df
        failing since 303 days (last pass: v4.4.243-14-gcb8e837cb602, first=
 fail: v4.4.243-20-g3c35b64319c2) =

 =



platform            | arch | lab           | compiler | defconfig          =
 | regressions
--------------------+------+---------------+----------+--------------------=
-+------------
qemu_arm-virt-gicv3 | arm  | lab-cip       | gcc-8    | multi_v7_defconfig =
 | 1          =


  Details:     https://kernelci.org/test/plan/id/613fce89d9dbd2abee99a2e0

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.4.y/v4.4.283=
-73-g04e131be02cf/arm/multi_v7_defconfig/gcc-8/lab-cip/baseline-qemu_arm-vi=
rt-gicv3.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.4.y/v4.4.283=
-73-g04e131be02cf/arm/multi_v7_defconfig/gcc-8/lab-cip/baseline-qemu_arm-vi=
rt-gicv3.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/613fce89d9dbd2abee99a=
2e1
        failing since 303 days (last pass: v4.4.243-14-gcb8e837cb602, first=
 fail: v4.4.243-20-g3c35b64319c2) =

 =



platform            | arch | lab           | compiler | defconfig          =
 | regressions
--------------------+------+---------------+----------+--------------------=
-+------------
qemu_arm-virt-gicv3 | arm  | lab-collabora | gcc-8    | multi_v7_defconfig =
 | 1          =


  Details:     https://kernelci.org/test/plan/id/613fcf3fd03a15b63599a2e7

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.4.y/v4.4.283=
-73-g04e131be02cf/arm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-qemu_=
arm-virt-gicv3.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.4.y/v4.4.283=
-73-g04e131be02cf/arm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-qemu_=
arm-virt-gicv3.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/613fcf3fd03a15b63599a=
2e8
        failing since 303 days (last pass: v4.4.243-14-gcb8e837cb602, first=
 fail: v4.4.243-20-g3c35b64319c2) =

 =20
