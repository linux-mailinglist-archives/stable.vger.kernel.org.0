Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EC0372C8490
	for <lists+stable@lfdr.de>; Mon, 30 Nov 2020 14:00:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726283AbgK3M70 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 30 Nov 2020 07:59:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33316 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726275AbgK3M70 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 30 Nov 2020 07:59:26 -0500
Received: from mail-pj1-x102c.google.com (mail-pj1-x102c.google.com [IPv6:2607:f8b0:4864:20::102c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4ABC7C0613CF
        for <stable@vger.kernel.org>; Mon, 30 Nov 2020 04:58:46 -0800 (PST)
Received: by mail-pj1-x102c.google.com with SMTP id hk16so1315958pjb.4
        for <stable@vger.kernel.org>; Mon, 30 Nov 2020 04:58:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=1PaQnj1beslDHGnxYVO1hfT+mt0MoeG3QeAslLmmy9E=;
        b=1JjmRssgd1mO449qUMfpdWPXGImrEegAdhyCtL0qjVQ2acIvnih4I89re3bSvx4U/u
         a8bYuHhTKEKK8IP6Ins97mktW3N0RaxUe+HctVRpRTUgAVY6XCEtrYP2Tl31xtuNYVu3
         gALz345wp+2CnSgk3+z5jfupuNTHq75dXHDc907G4fDPATsToRHFPrXtjrXpluIdgw1t
         NC2FZYX+QwxMbv1JPve3bPNifg1sdRx6/UT4/ayRCsu/Iwa9vcizffHO6gFQXp0nxCGm
         1s/w9WmMTEGuTjU+ar9ytvUjVxs1VHZQvtCqP5GIHwX08RZQ0haEaUAWgsGvGSmBxVN2
         xoCQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=1PaQnj1beslDHGnxYVO1hfT+mt0MoeG3QeAslLmmy9E=;
        b=GuhCTEglvKqdunhgxEc2Zap1mZ8dmOZ9QkCjnRC2qXekxRPzehCVwz9e4fj3I/EYX1
         084SYun8xSdt2I5qiKmUSBuiZNsm0kdWszJE1Tv4XCwfDG/agly2EybskORdPFSejJbV
         2WIyJvhYrlfBj+APPlawREe7/r0TOdHkaweYq4mJCUB0+zbF3smv4ce+Z/3kxDNmeEqi
         irS0QM7+lekzCTALaHvkd8NPtOja3EYpQrFjzaWqD2OZ1TxT81CUa1fj85CiLJlZl7UV
         C5b5W1l5jz6bNCm+lDlfkie1mqO/s+pqgq2KaN+xoLTd8SxazsAETA4TgVP/5pQjtPGv
         M7MA==
X-Gm-Message-State: AOAM5312DqzXsI/lMC77B3dh45/Hu8EsG86/bHz+PzYDORWJGE+8NDyW
        H9OKK7KCKaYL2zhdLZZ5ky+5o7izC/7ebw==
X-Google-Smtp-Source: ABdhPJxa0cF35ZmfFkiYxgwc7zdvV3biWXZlyWo18+a2J4v8QhmhMNFoK5kyi8FUVfg3KVdbtzlFZg==
X-Received: by 2002:a17:90a:d790:: with SMTP id z16mr26024078pju.88.1606741125195;
        Mon, 30 Nov 2020 04:58:45 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id b17sm17117774pfi.61.2020.11.30.04.58.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 30 Nov 2020 04:58:44 -0800 (PST)
Message-ID: <5fc4ec84.1c69fb81.f945b.668a@mx.google.com>
Date:   Mon, 30 Nov 2020 04:58:44 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: queue/4.19
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v4.19.160-55-g2c2d029d8d60
X-Kernelci-Report-Type: test
Subject: stable-rc/queue/4.19 baseline: 151 runs,
 4 regressions (v4.19.160-55-g2c2d029d8d60)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.19 baseline: 151 runs, 4 regressions (v4.19.160-55-g2c2d0=
29d8d60)

Regressions Summary
-------------------

platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-baylibre    | gcc-8    | versatile_defcon=
fig | 1          =

qemu_arm-versatilepb | arm  | lab-broonie     | gcc-8    | versatile_defcon=
fig | 1          =

qemu_arm-versatilepb | arm  | lab-cip         | gcc-8    | versatile_defcon=
fig | 1          =

qemu_arm-versatilepb | arm  | lab-linaro-lkft | gcc-8    | versatile_defcon=
fig | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.19/ker=
nel/v4.19.160-55-g2c2d029d8d60/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.19
  Describe: v4.19.160-55-g2c2d029d8d60
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      2c2d029d8d604b6dafb1003b11b34a053835bff4 =



Test Regressions
---------------- =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-baylibre    | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/5fc4ba184deb6bb36cc94d0d

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.160=
-55-g2c2d029d8d60/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_=
arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.160=
-55-g2c2d029d8d60/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_=
arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fc4ba184deb6bb36cc94=
d0e
        failing since 16 days (last pass: v4.19.157-26-gd59f3161b3a0, first=
 fail: v4.19.157-27-g5543cc2c41d55) =

 =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-broonie     | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/5fc4bab3accff7d398c94cdd

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.160=
-55-g2c2d029d8d60/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_a=
rm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.160=
-55-g2c2d029d8d60/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_a=
rm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fc4bab3accff7d398c94=
cde
        failing since 16 days (last pass: v4.19.157-26-gd59f3161b3a0, first=
 fail: v4.19.157-27-g5543cc2c41d55) =

 =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-cip         | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/5fc4b97c756db16fe3c94cce

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.160=
-55-g2c2d029d8d60/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-v=
ersatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.160=
-55-g2c2d029d8d60/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-v=
ersatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fc4b97c756db16fe3c94=
ccf
        failing since 16 days (last pass: v4.19.157-26-gd59f3161b3a0, first=
 fail: v4.19.157-27-g5543cc2c41d55) =

 =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-linaro-lkft | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/5fc4d7b25a98175f66c94cb9

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.160=
-55-g2c2d029d8d60/arm/versatile_defconfig/gcc-8/lab-linaro-lkft/baseline-qe=
mu_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.160=
-55-g2c2d029d8d60/arm/versatile_defconfig/gcc-8/lab-linaro-lkft/baseline-qe=
mu_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fc4d7b25a98175f66c94=
cba
        failing since 16 days (last pass: v4.19.157-26-gd59f3161b3a0, first=
 fail: v4.19.157-27-g5543cc2c41d55) =

 =20
