Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D4CCD35F5A6
	for <lists+stable@lfdr.de>; Wed, 14 Apr 2021 16:04:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351712AbhDNNwI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 14 Apr 2021 09:52:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54168 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351718AbhDNNwD (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 14 Apr 2021 09:52:03 -0400
Received: from mail-pg1-x531.google.com (mail-pg1-x531.google.com [IPv6:2607:f8b0:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 90473C061344
        for <stable@vger.kernel.org>; Wed, 14 Apr 2021 06:51:38 -0700 (PDT)
Received: by mail-pg1-x531.google.com with SMTP id q10so14448944pgj.2
        for <stable@vger.kernel.org>; Wed, 14 Apr 2021 06:51:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=Or+9yHvWuXDf7nOItEdNiVIgwgX3jcvGRSrolP20fxg=;
        b=IDW0bq/7p72i1/vSys8fVFQoO26KxKXr9rhrt99hQ/9pJi0NnzXpN9McHz5hjsOjAB
         KdKfIkyifDN9BJaaVXix3DBJY4XnJ+Gh6Q7rbRpWVQmuLtndmYUhqlEbMoZZYWHOJtX+
         kzZm/8YtH8SWJOWDVu0w/KS+fsDU/jdYJ0tTkr2ohIFkD0UU+iErmoaSC/danTaT78GP
         etZne3CeQCOiisUwMxKFqo4CX1wjxRskGMu2swQqrlJglaRoJA/a/XHCxaeeaY9A3N0B
         UrzL12EXVpN3NJ0/xj8Y0EKXSU886So3NOp0IXKCov2wUvfeMjTXF2ydGBNg0Utb5tQI
         o22Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=Or+9yHvWuXDf7nOItEdNiVIgwgX3jcvGRSrolP20fxg=;
        b=nmKkk2WADJlX8RP/DoAQfOIls7nzi4OULqXbF6/UxS0mQ00HzuQ+iU39zYGJroxzcv
         y2UFF4Boic+CZ3yL4qrBgteuTRKyAva5RgbnB01l/1+mUZl4JAvbi9nPFo9dew82cIO5
         0urL33PXALn5I2kk3DxT/wfpDPIVDgL0rDGV2H/HgOSFNrO2a3HQl/93Jtw+rwMn87op
         RLZ94BcWqCXlf6s3WbvbeLiwuaJs2wxpipgaM3WAD65AcR80dDkyMKnnubCOA/mX0/Sa
         2VT1HVkBRDH4Re9iVupPFXgnaCExtoF1znI748Hty2AaP9BhWlwMghvNFvCBXEyE3I7c
         wMiw==
X-Gm-Message-State: AOAM532EH0r8wYEy6ziOmQTMcXvURn4gMVWSIFPxSCRwQzBzNhOGJSkf
        8iZ61/IPvQ4nAmBEtmqJAI/EFYsfR372qg==
X-Google-Smtp-Source: ABdhPJyHhbpki/aOpB10HCSNOOmbsVArZvUL2FybdLM6gmBww+vFjFtSPNOLLeoCSjSiVCkK5Vf50w==
X-Received: by 2002:a63:d54a:: with SMTP id v10mr37189318pgi.83.1618408297919;
        Wed, 14 Apr 2021 06:51:37 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id mv13sm5074631pjb.29.2021.04.14.06.51.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 14 Apr 2021 06:51:37 -0700 (PDT)
Message-ID: <6076f369.1c69fb81.5174f.e75f@mx.google.com>
Date:   Wed, 14 Apr 2021 06:51:37 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v4.14.230-59-ga6483ab2e47a2
X-Kernelci-Branch: queue/4.14
X-Kernelci-Tree: stable-rc
Subject: stable-rc/queue/4.14 baseline: 126 runs,
 5 regressions (v4.14.230-59-ga6483ab2e47a2)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.14 baseline: 126 runs, 5 regressions (v4.14.230-59-ga6483=
ab2e47a2)

Regressions Summary
-------------------

platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
panda                | arm  | lab-collabora   | gcc-8    | omap2plus_defcon=
fig | 1          =

qemu_arm-versatilepb | arm  | lab-baylibre    | gcc-8    | versatile_defcon=
fig | 1          =

qemu_arm-versatilepb | arm  | lab-cip         | gcc-8    | versatile_defcon=
fig | 1          =

qemu_arm-versatilepb | arm  | lab-collabora   | gcc-8    | versatile_defcon=
fig | 1          =

qemu_arm-versatilepb | arm  | lab-linaro-lkft | gcc-8    | versatile_defcon=
fig | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.14/ker=
nel/v4.14.230-59-ga6483ab2e47a2/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.14
  Describe: v4.14.230-59-ga6483ab2e47a2
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      a6483ab2e47a25126d98aa099c3cc90f2d2113cb =



Test Regressions
---------------- =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
panda                | arm  | lab-collabora   | gcc-8    | omap2plus_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/6076c02b42d6511ec3dac724

  Results:     3 PASS, 1 FAIL, 1 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.230=
-59-ga6483ab2e47a2/arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-pan=
da.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.230=
-59-ga6483ab2e47a2/arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-pan=
da.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/6076c02b42d6511=
ec3dac729
        failing since 1 day (last pass: v4.14.230-58-g25bd7e2a3beb4, first =
fail: v4.14.230-59-g8186e9dd7149)
        2 lines

    2021-04-14 10:12:56.164000+00:00  kern  :emerg :  lock: emif_lock+0x0/0=
xffffed34 [emif], .magic: 00000000, .owner: <none>/-1, .owner_cpu: 0
    2021-04-14 10:12:56.179000+00:00  [   20.727996] <LAVA_SIGNAL_TESTCASE =
TEST_CASE_ID=3Demerg RESULT=3Dfail UNITS=3Dlines MEASUREMENT=3D2>   =

 =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-baylibre    | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/6076bfce8775d30504dac6b1

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.230=
-59-ga6483ab2e47a2/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu=
_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.230=
-59-ga6483ab2e47a2/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu=
_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6076bfce8775d30504dac=
6b2
        failing since 151 days (last pass: v4.14.206-21-g787a7a3ca16c, firs=
t fail: v4.14.206-22-ga949bf40fb01) =

 =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-cip         | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/6076bfc4aac379507fdac6c3

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.230=
-59-ga6483ab2e47a2/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-=
versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.230=
-59-ga6483ab2e47a2/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-=
versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6076bfc4aac379507fdac=
6c4
        failing since 151 days (last pass: v4.14.206-21-g787a7a3ca16c, firs=
t fail: v4.14.206-22-ga949bf40fb01) =

 =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-collabora   | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/6076bf5e5f8e6d682cdac6c6

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.230=
-59-ga6483ab2e47a2/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qem=
u_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.230=
-59-ga6483ab2e47a2/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qem=
u_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6076bf5e5f8e6d682cdac=
6c7
        failing since 151 days (last pass: v4.14.206-21-g787a7a3ca16c, firs=
t fail: v4.14.206-22-ga949bf40fb01) =

 =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-linaro-lkft | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/6076bf665f8e6d682cdac6cc

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.230=
-59-ga6483ab2e47a2/arm/versatile_defconfig/gcc-8/lab-linaro-lkft/baseline-q=
emu_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.230=
-59-ga6483ab2e47a2/arm/versatile_defconfig/gcc-8/lab-linaro-lkft/baseline-q=
emu_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6076bf665f8e6d682cdac=
6cd
        failing since 151 days (last pass: v4.14.206-21-g787a7a3ca16c, firs=
t fail: v4.14.206-22-ga949bf40fb01) =

 =20
