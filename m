Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B714F3F9355
	for <lists+stable@lfdr.de>; Fri, 27 Aug 2021 06:10:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244175AbhH0D56 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 26 Aug 2021 23:57:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46458 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232207AbhH0D55 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 26 Aug 2021 23:57:57 -0400
Received: from mail-pg1-x532.google.com (mail-pg1-x532.google.com [IPv6:2607:f8b0:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 853EAC061757
        for <stable@vger.kernel.org>; Thu, 26 Aug 2021 20:57:09 -0700 (PDT)
Received: by mail-pg1-x532.google.com with SMTP id x4so4943412pgh.1
        for <stable@vger.kernel.org>; Thu, 26 Aug 2021 20:57:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=F03TSbUrRBvqzauIK+ScRm7msCPwsLPkge7J0gI999Q=;
        b=OFs5zjaeejufrdh3jl/xwawBXifOQZuMCjeEbZ+ORe4tVc2arTKGO9GO/17K9uQw3p
         WRbrBdAppcOKLl4gXCUzTOBFs8r0Wk2Yw1OkTAVmCZNdJA1Gw3wfS+fP3AJr5NKN/Sff
         1Ymw5W2nTyRNsqAvcskEiVrmUEiXq29+ifLJMrsSPnpKZnfD48wMl/MIq4uFPPmVzebG
         jBHZDAkKghOW/U6JHNzxQ/Kn1XL2ib2NqRBVzTAGuxJVMgVRmt2uaFML/7mZnGdpHkkx
         7PYxDU2o/pCczSnKKYfLSMTnKcqMCxVn8vaJIW07CSDkLbZ1JSl4pTzpeH6EpJpKjpf+
         ECXA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=F03TSbUrRBvqzauIK+ScRm7msCPwsLPkge7J0gI999Q=;
        b=DZTzfabtTX1jUrPr9IeLB87A++V9xtG6KtFhIBGPfScdmtegvU8YsA7NsVB0CEm3nK
         qUqfoSggts0t43+78q8ZtSlzOHEuehG6K6CPhthiCEqC7E1qfYdoGch1ktc68rAhYeeW
         QBWVOzLC76pcq7+k9sBEGMJ8BKtmE1Nfbez1+odot09UbZeDBKQO2Lhmv6Kg2fOLgxbQ
         109HFMw52OIdqghVFpy2K3Lk4UaR135GvE6/jZaBmEubBU00L77ZRXN2ypeNYzaR2ruA
         pTIQrBbG6ajWBDNhm6mbt4oURR9Khjiip09fRrSSBwWO3dwfIgXEOX8GWWYbezGP2S2k
         BVFg==
X-Gm-Message-State: AOAM5335jd/4UquAYJ5lE+5XblxpixjN1aPSQ+gdFB0e1SYiiUUhwCbv
        J36XNa+zwBMPmDaZ1wp8CsTkoD9Ogd0zDbBs
X-Google-Smtp-Source: ABdhPJx4Gvg9zCVOdZL9j6KCrzpfWR0DPFG9WWypKYSkIpIjBL4aBmnBAIq5CnUAFu/s4e2ybgtN6g==
X-Received: by 2002:a05:6a00:10d3:b029:3c8:d7c4:973f with SMTP id d19-20020a056a0010d3b02903c8d7c4973fmr6877703pfu.16.1630036628743;
        Thu, 26 Aug 2021 20:57:08 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id o10sm4272422pfk.212.2021.08.26.20.57.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 26 Aug 2021 20:57:08 -0700 (PDT)
Message-ID: <61286294.1c69fb81.8924f.c53a@mx.google.com>
Date:   Thu, 26 Aug 2021 20:57:08 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: linux-4.4.y
X-Kernelci-Kernel: v4.4.282
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable
Subject: stable/linux-4.4.y baseline: 76 runs, 7 regressions (v4.4.282)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable/linux-4.4.y baseline: 76 runs, 7 regressions (v4.4.282)

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

qemu_arm-virt-gicv2 | arm  | lab-cip      | gcc-8    | multi_v7_defconfig  =
| 1          =

qemu_arm-virt-gicv3 | arm  | lab-baylibre | gcc-8    | multi_v7_defconfig  =
| 1          =

qemu_arm-virt-gicv3 | arm  | lab-cip      | gcc-8    | multi_v7_defconfig  =
| 1          =

qemu_i386           | i386 | lab-broonie  | gcc-8    | i386_defconfig      =
| 1          =


  Details:  https://kernelci.org/test/job/stable/branch/linux-4.4.y/kernel/=
v4.4.282/plan/baseline/

  Test:     baseline
  Tree:     stable
  Branch:   linux-4.4.y
  Describe: v4.4.282
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able.git
  SHA:      0f5b96f6814376fe061a02604064b702ccf4bc6a =



Test Regressions
---------------- =



platform            | arch | lab          | compiler | defconfig           =
| regressions
--------------------+------+--------------+----------+---------------------=
+------------
beagle-xm           | arm  | lab-baylibre | gcc-8    | omap2plus_defconfig =
| 2          =


  Details:     https://kernelci.org/test/plan/id/612830eab468270c958e2ca7

  Results:     3 PASS, 2 FAIL, 1 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable/linux-4.4.y/v4.4.282/ar=
m/omap2plus_defconfig/gcc-8/lab-baylibre/baseline-beagle-xm.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.4.y/v4.4.282/ar=
m/omap2plus_defconfig/gcc-8/lab-baylibre/baseline-beagle-xm.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.dmesg.crit: https://kernelci.org/test/case/id/612830eab468270c=
958e2cad
        new failure (last pass: v4.4.277)
        1 lines

    2021-08-27T00:24:55.670297  / # #
    2021-08-27T00:24:55.671121  =

    2021-08-27T00:24:55.774266  / # #
    2021-08-27T00:24:55.774905  =

    2021-08-27T00:24:55.876224  / # #export SHELL=3D/bin/sh
    2021-08-27T00:24:55.876657  =

    2021-08-27T00:24:55.977805  / # export SHELL=3D/bin/sh. /lava-743064/en=
vironment
    2021-08-27T00:24:55.978196  =

    2021-08-27T00:24:56.079131  / # . /lava-743064/environment/lava-743064/=
bin/lava-test-runner /lava-743064/0
    2021-08-27T00:24:56.080311   =

    ... (9 line(s) more)  =


  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/612830eab468270=
c958e2caf
        new failure (last pass: v4.4.277)
        28 lines

    2021-08-27T00:24:56.543365  [   50.020874] <LAVA_SIGNAL_TESTCASE TEST_C=
ASE_ID=3Dalert RESULT=3Dpass UNITS=3Dlines MEASUREMENT=3D0>
    2021-08-27T00:24:56.595746  kern  :emerg : Internal error: Oops - BUG: =
0 [#1] SMP ARM
    2021-08-27T00:24:56.602167  kern  :emerg : Process udevd (pid: 111, sta=
ck limit =3D 0xcb97e218)
    2021-08-27T00:24:56.605815  kern  :emerg : Stack: (0xcb97fd10 to 0xcb98=
0000)
    2021-08-27T00:24:56.615415  kern  :emerg : fd00:                       =
              bf02b83c bf010b84 cb968810 bf02b8c8
    2021-08-27T00:24:56.627041  kern  :emerg : fd20: cb968810 bf2440a8 0000=
0002 cb[   50.101654] <LAVA_SIGNAL_TESTCASE TEST_CASE_ID=3Demerg RESULT=3Df=
ail UNITS=3Dlines MEASUREMENT=3D28>   =

 =



platform            | arch | lab          | compiler | defconfig           =
| regressions
--------------------+------+--------------+----------+---------------------=
+------------
qemu_arm-virt-gicv2 | arm  | lab-baylibre | gcc-8    | multi_v7_defconfig  =
| 1          =


  Details:     https://kernelci.org/test/plan/id/612831af8cd1b5728e8e2c7f

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable/linux-4.4.y/v4.4.282/ar=
m/multi_v7_defconfig/gcc-8/lab-baylibre/baseline-qemu_arm-virt-gicv2.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.4.y/v4.4.282/ar=
m/multi_v7_defconfig/gcc-8/lab-baylibre/baseline-qemu_arm-virt-gicv2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/612831af8cd1b5728e8e2=
c80
        failing since 277 days (last pass: v4.4.243, first fail: v4.4.245) =

 =



platform            | arch | lab          | compiler | defconfig           =
| regressions
--------------------+------+--------------+----------+---------------------=
+------------
qemu_arm-virt-gicv2 | arm  | lab-cip      | gcc-8    | multi_v7_defconfig  =
| 1          =


  Details:     https://kernelci.org/test/plan/id/61283164291e88c5f18e2ca0

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable/linux-4.4.y/v4.4.282/ar=
m/multi_v7_defconfig/gcc-8/lab-cip/baseline-qemu_arm-virt-gicv2.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.4.y/v4.4.282/ar=
m/multi_v7_defconfig/gcc-8/lab-cip/baseline-qemu_arm-virt-gicv2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61283164291e88c5f18e2=
ca1
        failing since 277 days (last pass: v4.4.243, first fail: v4.4.245) =

 =



platform            | arch | lab          | compiler | defconfig           =
| regressions
--------------------+------+--------------+----------+---------------------=
+------------
qemu_arm-virt-gicv3 | arm  | lab-baylibre | gcc-8    | multi_v7_defconfig  =
| 1          =


  Details:     https://kernelci.org/test/plan/id/61283224337cd50e178e2ca5

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable/linux-4.4.y/v4.4.282/ar=
m/multi_v7_defconfig/gcc-8/lab-baylibre/baseline-qemu_arm-virt-gicv3.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.4.y/v4.4.282/ar=
m/multi_v7_defconfig/gcc-8/lab-baylibre/baseline-qemu_arm-virt-gicv3.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61283224337cd50e178e2=
ca6
        failing since 277 days (last pass: v4.4.243, first fail: v4.4.245) =

 =



platform            | arch | lab          | compiler | defconfig           =
| regressions
--------------------+------+--------------+----------+---------------------=
+------------
qemu_arm-virt-gicv3 | arm  | lab-cip      | gcc-8    | multi_v7_defconfig  =
| 1          =


  Details:     https://kernelci.org/test/plan/id/6128316397f2ea18648e2c8f

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable/linux-4.4.y/v4.4.282/ar=
m/multi_v7_defconfig/gcc-8/lab-cip/baseline-qemu_arm-virt-gicv3.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.4.y/v4.4.282/ar=
m/multi_v7_defconfig/gcc-8/lab-cip/baseline-qemu_arm-virt-gicv3.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6128316397f2ea18648e2=
c90
        failing since 277 days (last pass: v4.4.243, first fail: v4.4.245) =

 =



platform            | arch | lab          | compiler | defconfig           =
| regressions
--------------------+------+--------------+----------+---------------------=
+------------
qemu_i386           | i386 | lab-broonie  | gcc-8    | i386_defconfig      =
| 1          =


  Details:     https://kernelci.org/test/plan/id/612861368b0ce82a738e2c81

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: i386_defconfig
  Compiler:    gcc-8 (gcc (Debian 8.3.0-6) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable/linux-4.4.y/v4.4.282/i3=
86/i386_defconfig/gcc-8/lab-broonie/baseline-qemu_i386.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.4.y/v4.4.282/i3=
86/i386_defconfig/gcc-8/lab-broonie/baseline-qemu_i386.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/x86/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/612861368b0ce82a738e2=
c82
        new failure (last pass: v4.4.281) =

 =20
