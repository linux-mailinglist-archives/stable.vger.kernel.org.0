Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A06CE32F06E
	for <lists+stable@lfdr.de>; Fri,  5 Mar 2021 17:55:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229719AbhCEQyz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 5 Mar 2021 11:54:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37358 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229573AbhCEQyu (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 5 Mar 2021 11:54:50 -0500
Received: from mail-pf1-x436.google.com (mail-pf1-x436.google.com [IPv6:2607:f8b0:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2DAF7C061574
        for <stable@vger.kernel.org>; Fri,  5 Mar 2021 08:54:50 -0800 (PST)
Received: by mail-pf1-x436.google.com with SMTP id 16so1036827pfn.5
        for <stable@vger.kernel.org>; Fri, 05 Mar 2021 08:54:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=TAKA/4wNgc/cwNtYmcJtEA2d2p4c2N9qswUSq/xJzsQ=;
        b=eXJj3/sRl8bU7WAD4DO93LKIbev7dzL5XtRfZQkJpwpmnd0tg/eO1lyCNUvb0a9aCA
         Y4bJrntwXNV1So3YIlfhVgkSC1+t4My7LCOXT1/N197yiMm7/b0x4hXMge151NaWrw+o
         JX3jpa7W3G/+HqnLTLKzqnD2oPVSldExcGo5e79+bIQAKasZXNVbldGo5hnWJn3hkMwK
         FvbYdy0eDbivr9B7wsAyhPFMWILaU34+uWMqpYOIjNRNhWB21csQfjtf18OkmLhk5Jss
         f6+cPd4+2Ow4KpziAN8/I1zUOZkHI7hY/BcgUsUj4gzNIRCMi5k4z0AB1OaNVZ2FsOO4
         xYtQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=TAKA/4wNgc/cwNtYmcJtEA2d2p4c2N9qswUSq/xJzsQ=;
        b=afvrkYdy2wKUKhzPcQ9HX/lzc2rJeyD0/lni1u4kEfXpxyIS+jCCz2stn/mdo33H8x
         pfyM/c8N7JyyrBYaLFlwkiPhwCwQcWWmAA5yh1WScKbKAfr1wuUTyrY5UJSXft/h5qxH
         ID0i7WCGIM4KwUEsB61YfQbE6Tbt0RcFasWzScmEn7u5i7eONnSx8jCYia9Z9ZamaAKr
         L2qpRvzCug4d1/OdZsS1xrrwHZi4ri86QsFXP02CJmY0YCsmWXlAUCGgh2TpvASQaIdw
         tDyNhmWw+pTDcdnqrpgYZc+PJ0gf7i2bnuYXX/UtgOgbNata9yCB+wK8D7ON6rKRLSIA
         su7A==
X-Gm-Message-State: AOAM533XD8uUewnJfMgUKi8Qe+1cPObw6RmuYpI8z1wx2LHPf3CBw5zA
        1KA/RzhNtRpyV+bfRUTGXVkvXKNbPq7KptTV
X-Google-Smtp-Source: ABdhPJwsp2WIXcR+qgN30V33jyEpmPu0hVxR799QlVS9JFUYEomNquUakcelzM6ZtdDtwgSKgRX10w==
X-Received: by 2002:a65:6290:: with SMTP id f16mr9548638pgv.69.1614963289435;
        Fri, 05 Mar 2021 08:54:49 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id r20sm2963557pgb.3.2021.03.05.08.54.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 05 Mar 2021 08:54:49 -0800 (PST)
Message-ID: <60426259.1c69fb81.cf4b2.795a@mx.google.com>
Date:   Fri, 05 Mar 2021 08:54:49 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.4.259-31-g22ce103533f98
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-4.4.y
Subject: stable-rc/linux-4.4.y baseline: 68 runs,
 7 regressions (v4.4.259-31-g22ce103533f98)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.4.y baseline: 68 runs, 7 regressions (v4.4.259-31-g22ce10=
3533f98)

Regressions Summary
-------------------

platform            | arch | lab             | compiler | defconfig        =
  | regressions
--------------------+------+-----------------+----------+------------------=
--+------------
dove-cubox          | arm  | lab-pengutronix | gcc-8    | mvebu_v7_defconfi=
g | 1          =

qemu_arm-virt-gicv2 | arm  | lab-broonie     | gcc-8    | multi_v7_defconfi=
g | 1          =

qemu_arm-virt-gicv2 | arm  | lab-cip         | gcc-8    | multi_v7_defconfi=
g | 1          =

qemu_arm-virt-gicv2 | arm  | lab-collabora   | gcc-8    | multi_v7_defconfi=
g | 1          =

qemu_arm-virt-gicv3 | arm  | lab-broonie     | gcc-8    | multi_v7_defconfi=
g | 1          =

qemu_arm-virt-gicv3 | arm  | lab-cip         | gcc-8    | multi_v7_defconfi=
g | 1          =

qemu_arm-virt-gicv3 | arm  | lab-collabora   | gcc-8    | multi_v7_defconfi=
g | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-4.4.y/kern=
el/v4.4.259-31-g22ce103533f98/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-4.4.y
  Describe: v4.4.259-31-g22ce103533f98
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      22ce103533f98c3a483b24b6e18069e581f58f16 =



Test Regressions
---------------- =



platform            | arch | lab             | compiler | defconfig        =
  | regressions
--------------------+------+-----------------+----------+------------------=
--+------------
dove-cubox          | arm  | lab-pengutronix | gcc-8    | mvebu_v7_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/60422eb91af5bed8a0addcb1

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: mvebu_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.4.y/v4.4.259=
-31-g22ce103533f98/arm/mvebu_v7_defconfig/gcc-8/lab-pengutronix/baseline-do=
ve-cubox.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.4.y/v4.4.259=
-31-g22ce103533f98/arm/mvebu_v7_defconfig/gcc-8/lab-pengutronix/baseline-do=
ve-cubox.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60422eb91af5bed8a0add=
cb2
        new failure (last pass: v4.4.259) =

 =



platform            | arch | lab             | compiler | defconfig        =
  | regressions
--------------------+------+-----------------+----------+------------------=
--+------------
qemu_arm-virt-gicv2 | arm  | lab-broonie     | gcc-8    | multi_v7_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/60424c8ce8e687a7b5addcb1

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.4.y/v4.4.259=
-31-g22ce103533f98/arm/multi_v7_defconfig/gcc-8/lab-broonie/baseline-qemu_a=
rm-virt-gicv2.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.4.y/v4.4.259=
-31-g22ce103533f98/arm/multi_v7_defconfig/gcc-8/lab-broonie/baseline-qemu_a=
rm-virt-gicv2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60424c8ce8e687a7b5add=
cb2
        failing since 110 days (last pass: v4.4.243-14-gcb8e837cb602, first=
 fail: v4.4.243-20-g3c35b64319c2) =

 =



platform            | arch | lab             | compiler | defconfig        =
  | regressions
--------------------+------+-----------------+----------+------------------=
--+------------
qemu_arm-virt-gicv2 | arm  | lab-cip         | gcc-8    | multi_v7_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/60424b53904da1e576addcd5

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.4.y/v4.4.259=
-31-g22ce103533f98/arm/multi_v7_defconfig/gcc-8/lab-cip/baseline-qemu_arm-v=
irt-gicv2.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.4.y/v4.4.259=
-31-g22ce103533f98/arm/multi_v7_defconfig/gcc-8/lab-cip/baseline-qemu_arm-v=
irt-gicv2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60424b53904da1e576add=
cd6
        failing since 110 days (last pass: v4.4.243-14-gcb8e837cb602, first=
 fail: v4.4.243-20-g3c35b64319c2) =

 =



platform            | arch | lab             | compiler | defconfig        =
  | regressions
--------------------+------+-----------------+----------+------------------=
--+------------
qemu_arm-virt-gicv2 | arm  | lab-collabora   | gcc-8    | multi_v7_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/60422fabf7c15af5ebaddd09

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.4.y/v4.4.259=
-31-g22ce103533f98/arm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-qemu=
_arm-virt-gicv2.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.4.y/v4.4.259=
-31-g22ce103533f98/arm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-qemu=
_arm-virt-gicv2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60422fabf7c15af5ebadd=
d0a
        failing since 110 days (last pass: v4.4.243-14-gcb8e837cb602, first=
 fail: v4.4.243-20-g3c35b64319c2) =

 =



platform            | arch | lab             | compiler | defconfig        =
  | regressions
--------------------+------+-----------------+----------+------------------=
--+------------
qemu_arm-virt-gicv3 | arm  | lab-broonie     | gcc-8    | multi_v7_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/60424c13189600e18faddce7

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.4.y/v4.4.259=
-31-g22ce103533f98/arm/multi_v7_defconfig/gcc-8/lab-broonie/baseline-qemu_a=
rm-virt-gicv3.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.4.y/v4.4.259=
-31-g22ce103533f98/arm/multi_v7_defconfig/gcc-8/lab-broonie/baseline-qemu_a=
rm-virt-gicv3.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60424c13189600e18fadd=
ce8
        failing since 110 days (last pass: v4.4.243-14-gcb8e837cb602, first=
 fail: v4.4.243-20-g3c35b64319c2) =

 =



platform            | arch | lab             | compiler | defconfig        =
  | regressions
--------------------+------+-----------------+----------+------------------=
--+------------
qemu_arm-virt-gicv3 | arm  | lab-cip         | gcc-8    | multi_v7_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/60424afebba29a6311addcd0

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.4.y/v4.4.259=
-31-g22ce103533f98/arm/multi_v7_defconfig/gcc-8/lab-cip/baseline-qemu_arm-v=
irt-gicv3.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.4.y/v4.4.259=
-31-g22ce103533f98/arm/multi_v7_defconfig/gcc-8/lab-cip/baseline-qemu_arm-v=
irt-gicv3.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60424afebba29a6311add=
cd1
        failing since 110 days (last pass: v4.4.243-14-gcb8e837cb602, first=
 fail: v4.4.243-20-g3c35b64319c2) =

 =



platform            | arch | lab             | compiler | defconfig        =
  | regressions
--------------------+------+-----------------+----------+------------------=
--+------------
qemu_arm-virt-gicv3 | arm  | lab-collabora   | gcc-8    | multi_v7_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/60422f97bc27bfab6faddcb8

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.4.y/v4.4.259=
-31-g22ce103533f98/arm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-qemu=
_arm-virt-gicv3.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.4.y/v4.4.259=
-31-g22ce103533f98/arm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-qemu=
_arm-virt-gicv3.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60422f97bc27bfab6fadd=
cb9
        failing since 110 days (last pass: v4.4.243-14-gcb8e837cb602, first=
 fail: v4.4.243-20-g3c35b64319c2) =

 =20
