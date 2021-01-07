Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EEE442EE649
	for <lists+stable@lfdr.de>; Thu,  7 Jan 2021 20:40:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729272AbhAGTj7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 7 Jan 2021 14:39:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48390 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725903AbhAGTj7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 7 Jan 2021 14:39:59 -0500
Received: from mail-pl1-x629.google.com (mail-pl1-x629.google.com [IPv6:2607:f8b0:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7EF0EC0612F6
        for <stable@vger.kernel.org>; Thu,  7 Jan 2021 11:39:18 -0800 (PST)
Received: by mail-pl1-x629.google.com with SMTP id j1so4098385pld.3
        for <stable@vger.kernel.org>; Thu, 07 Jan 2021 11:39:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=Ct9ynqp/oBvQ2M1VFq0SPI+9pvQX2Wo0loTCpNLBAhg=;
        b=VVRCrsjlNnuuDtg8cTaeW2mFR2SlfbrRxJo1nU1mKxmDjq3Qg/DFH9UL9W+/4JPlSX
         d8lXaW01V3R7tUhPvwjnfnDn6MhhqTAnfPnJ5u5dw0SfFnSKnw8xC/U+OVpmShF/D3nm
         3XYQK57hatDTDf0cBuWUdtoc0aOVq0HNs3/H29/2Tc7wd+8saunS8nywtkW3UA/6kjTc
         6t7zZRQhsvsdzyajf2VB5dcYZVqmPNph4FYKxc/h5VSNi/0rxQGOep/RJ/C5bRqoB50F
         koSJNgS5g1ZX93W0OMFtvhrcIZFEg92csWMCNG4GMeohcN+xcVaOxIAZLh0XLUw/Nzxf
         3PyQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=Ct9ynqp/oBvQ2M1VFq0SPI+9pvQX2Wo0loTCpNLBAhg=;
        b=qUmeImQmPqHcF22du2vKrWQNJqBz3vRkyqE7xwAceKnV3z0RZRtFg0v4GCCtGjpeTA
         DKKkH5/jbVLbgHX0JB4HIgzAdD71IIm/IZDnci5YRFQYvz5w7Mwp7PJoEMttg9uHw9xO
         cy/G2t0W6jJTOuKYwfvmKqrja94q78vGPqehdGpYW9l8rPXoQYQklBL+xo2QZ7p8JRTL
         oxyXjtFpCIU+0oJHWZhVgq0qidvoXyNu1LkiinL1G7IUKDi7ltyyM9ozO1JKe/RxpXb0
         KPx+8E0j5Oksb2eItEQbBD+jUellqD2/23RPMoh8Er5jEfjVN6iPfz+gZBO2o4qCmbbQ
         LuOw==
X-Gm-Message-State: AOAM532ebJ5CeOZY3XST31k1u3jHiCPVmNZkZ6barDMz/gwrCR1Cb/MU
        xgONeAc+fVeFvc9kJfwTuAxqfayCrrMKZQ==
X-Google-Smtp-Source: ABdhPJySXCZo5HMVj+jdKFWEoqtKvQd/0wq5oefz1UMTFDsxR+nQLFd10wiazlbMGao/xUr2m2ST2A==
X-Received: by 2002:a17:90a:fa0c:: with SMTP id cm12mr50451pjb.87.1610048357675;
        Thu, 07 Jan 2021 11:39:17 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id y6sm6677359pfn.145.2021.01.07.11.39.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 07 Jan 2021 11:39:16 -0800 (PST)
Message-ID: <5ff76364.1c69fb81.7a50d.fc60@mx.google.com>
Date:   Thu, 07 Jan 2021 11:39:16 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: queue/4.19
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v4.19.165-8-g69c37921fb8c
X-Kernelci-Report-Type: test
Subject: stable-rc/queue/4.19 baseline: 157 runs,
 6 regressions (v4.19.165-8-g69c37921fb8c)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.19 baseline: 157 runs, 6 regressions (v4.19.165-8-g69c379=
21fb8c)

Regressions Summary
-------------------

platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
dove-cubox           | arm  | lab-pengutronix | gcc-8    | multi_v7_defconf=
ig  | 1          =

panda                | arm  | lab-collabora   | gcc-8    | omap2plus_defcon=
fig | 1          =

qemu_arm-versatilepb | arm  | lab-baylibre    | gcc-8    | versatile_defcon=
fig | 1          =

qemu_arm-versatilepb | arm  | lab-broonie     | gcc-8    | versatile_defcon=
fig | 1          =

qemu_arm-versatilepb | arm  | lab-cip         | gcc-8    | versatile_defcon=
fig | 1          =

qemu_arm-versatilepb | arm  | lab-collabora   | gcc-8    | versatile_defcon=
fig | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.19/ker=
nel/v4.19.165-8-g69c37921fb8c/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.19
  Describe: v4.19.165-8-g69c37921fb8c
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      69c37921fb8c601b4ab1afdf69511dcdd8bb1144 =



Test Regressions
---------------- =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
dove-cubox           | arm  | lab-pengutronix | gcc-8    | multi_v7_defconf=
ig  | 1          =


  Details:     https://kernelci.org/test/plan/id/5ff73142db539b8af7c94cdd

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.165=
-8-g69c37921fb8c/arm/multi_v7_defconfig/gcc-8/lab-pengutronix/baseline-dove=
-cubox.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.165=
-8-g69c37921fb8c/arm/multi_v7_defconfig/gcc-8/lab-pengutronix/baseline-dove=
-cubox.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5ff73142db539b8af7c94=
cde
        new failure (last pass: v4.19.165-7-g6cf7f7d976ba5) =

 =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
panda                | arm  | lab-collabora   | gcc-8    | omap2plus_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/5ff72edaf40b9e564dc94ce3

  Results:     4 PASS, 1 FAIL, 0 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.165=
-8-g69c37921fb8c/arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-panda=
.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.165=
-8-g69c37921fb8c/arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-panda=
.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/5ff72edaf40b9e5=
64dc94ce8
        failing since 0 day (last pass: v4.19.164-29-g4c0bb8a87fa6b, first =
fail: v4.19.165-7-g6cf7f7d976ba5)
        2 lines

    2021-01-07 15:55:01.551000+00:00  kern  :emerg :  lock: emif_lock+0x0/0=
xffffed34 [emif], .magic: dead4ead, .owner: <none>/-1, .owner_cpu: -1
    2021-01-07 15:55:01.567000+00:00  <8>[   22.966613] <LAVA_SIGNAL_TESTCA=
SE TEST_CASE_ID=3Demerg RESULT=3Dfail UNITS=3Dlines MEASUREMENT=3D2>   =

 =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-baylibre    | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/5ff72e92f4661e4778c94cc2

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.165=
-8-g69c37921fb8c/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_a=
rm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.165=
-8-g69c37921fb8c/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_a=
rm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5ff72e92f4661e4778c94=
cc3
        failing since 54 days (last pass: v4.19.157-26-gd59f3161b3a0, first=
 fail: v4.19.157-27-g5543cc2c41d55) =

 =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-broonie     | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/5ff72e935aaea68153c94ccf

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.165=
-8-g69c37921fb8c/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_ar=
m-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.165=
-8-g69c37921fb8c/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_ar=
m-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5ff72e935aaea68153c94=
cd0
        failing since 54 days (last pass: v4.19.157-26-gd59f3161b3a0, first=
 fail: v4.19.157-27-g5543cc2c41d55) =

 =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-cip         | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/5ff72e985aaea68153c94cd5

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.165=
-8-g69c37921fb8c/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-ve=
rsatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.165=
-8-g69c37921fb8c/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-ve=
rsatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5ff72e985aaea68153c94=
cd6
        failing since 54 days (last pass: v4.19.157-26-gd59f3161b3a0, first=
 fail: v4.19.157-27-g5543cc2c41d55) =

 =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-collabora   | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/5ff72e4bb91f3ca4b7c94ccd

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.165=
-8-g69c37921fb8c/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu_=
arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.165=
-8-g69c37921fb8c/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu_=
arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5ff72e4bb91f3ca4b7c94=
cce
        failing since 54 days (last pass: v4.19.157-26-gd59f3161b3a0, first=
 fail: v4.19.157-27-g5543cc2c41d55) =

 =20
