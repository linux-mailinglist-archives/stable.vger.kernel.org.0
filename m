Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4906C2CC00B
	for <lists+stable@lfdr.de>; Wed,  2 Dec 2020 15:49:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728974AbgLBOsP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 2 Dec 2020 09:48:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45492 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728165AbgLBOsP (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 2 Dec 2020 09:48:15 -0500
Received: from mail-pj1-x1033.google.com (mail-pj1-x1033.google.com [IPv6:2607:f8b0:4864:20::1033])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 93583C0613CF
        for <stable@vger.kernel.org>; Wed,  2 Dec 2020 06:47:29 -0800 (PST)
Received: by mail-pj1-x1033.google.com with SMTP id v1so1138169pjr.2
        for <stable@vger.kernel.org>; Wed, 02 Dec 2020 06:47:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=k8xhZQ/cpfE8nHImeEMpz+7f7HTkq1iMqGQaCcV3srg=;
        b=as5pC/uBeO71dqlkDeP4yH+ff+FRtEjEtuXGNYbZAaRkMn1wIfmuOewM1FiCGrU/Ut
         JSaOAbr7tpOm0XpYXQqn0Xsp3vUdYCTx9GMKkx9OOZiEjdxsLAp2H4YZbWeywA8/40oP
         bbadipvntTKmJprytpJDiQc9jNleosMHuS9twJeQHUQNqj3Vpv1eMOO+xkDP9cPuAXaJ
         BibSyUb0qZQ1RkDOUr7K2soYm5b4fxUTi59gBpHUaSXV3LX9k0uEavB3259LqTHwaHNg
         vspccWdq68VOIsGujY5XUdoW9rzQFmFgqyzdTJOI07aHDtE8a5ifBvKNso3gGZdLVKJ0
         rVtg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=k8xhZQ/cpfE8nHImeEMpz+7f7HTkq1iMqGQaCcV3srg=;
        b=EKkYUK8NyTCj6MgHAkjlys/bH+tpfEwbhZxPU1ig6jiEm6O2ZDQbp9aQl8o1MCrs2A
         o7TrUQIpv9okICn/DRGu9NULmSNU4If4p/lYOKbo1mKUnP9dX3PZ4CMaoEqN55yw42Bk
         kTpby4h75Qk4d3NBVxPNYHatl1GuGI09kmX8m3wG/w2Twk6cAG0vSYffR1OB+o348x+S
         p08e+Pan0e4b7mR/bGlzHlCsz6GUZIVmkJTfFk/4BObOg1mZQMeTTcaIMBocY69iNyn8
         IknWbTjqqs4/phFcoxkMIA/2F0BNd+Hg3sa9sWcCA/LNJIOcVF2wbAZST44yXoWVhz4Q
         x4rg==
X-Gm-Message-State: AOAM53276IhNcwmWRjiQ1w+iFnjc61wOybabgdv4sDIbxDamcHZI4YI1
        mFq6T6dkk00lN5RsccKk86MIr0xVHqi3DQ==
X-Google-Smtp-Source: ABdhPJzljMnVOigoqQNFsX0PAlDSUlaQDWm6fUe39fvYn3Q3+sxJYBYbAFNKg47UVn7DqfZtok3GlQ==
X-Received: by 2002:a17:90a:f3c3:: with SMTP id ha3mr206311pjb.202.1606920448672;
        Wed, 02 Dec 2020 06:47:28 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id x7sm111811pfb.96.2020.12.02.06.47.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 02 Dec 2020 06:47:27 -0800 (PST)
Message-ID: <5fc7a8ff.1c69fb81.e4b26.0421@mx.google.com>
Date:   Wed, 02 Dec 2020 06:47:27 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: queue/4.19
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v4.19.161-13-g30b360cf1996
X-Kernelci-Report-Type: test
Subject: stable-rc/queue/4.19 baseline: 152 runs,
 5 regressions (v4.19.161-13-g30b360cf1996)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.19 baseline: 152 runs, 5 regressions (v4.19.161-13-g30b36=
0cf1996)

Regressions Summary
-------------------

platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
panda                | arm  | lab-collabora | gcc-8    | omap2plus_defconfi=
g | 1          =

qemu_arm-versatilepb | arm  | lab-baylibre  | gcc-8    | versatile_defconfi=
g | 1          =

qemu_arm-versatilepb | arm  | lab-broonie   | gcc-8    | versatile_defconfi=
g | 1          =

qemu_arm-versatilepb | arm  | lab-cip       | gcc-8    | versatile_defconfi=
g | 1          =

qemu_arm-versatilepb | arm  | lab-collabora | gcc-8    | versatile_defconfi=
g | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.19/ker=
nel/v4.19.161-13-g30b360cf1996/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.19
  Describe: v4.19.161-13-g30b360cf1996
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      30b360cf1996c2064f12614b732cab8b8f9104d4 =



Test Regressions
---------------- =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
panda                | arm  | lab-collabora | gcc-8    | omap2plus_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/5fc7764f31ebf42862c94d24

  Results:     4 PASS, 1 FAIL, 0 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.161=
-13-g30b360cf1996/arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-pand=
a.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.161=
-13-g30b360cf1996/arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-pand=
a.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/5fc7764f31ebf42=
862c94d29
        failing since 2 days (last pass: v4.19.160-13-g8733751e476a, first =
fail: v4.19.160-50-ge829433bf8e6)
        2 lines =

 =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-baylibre  | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/5fc775d2688fc460f3c94cea

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.161=
-13-g30b360cf1996/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_=
arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.161=
-13-g30b360cf1996/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_=
arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fc775d2688fc460f3c94=
ceb
        failing since 18 days (last pass: v4.19.157-26-gd59f3161b3a0, first=
 fail: v4.19.157-27-g5543cc2c41d55) =

 =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-broonie   | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/5fc775ce688fc460f3c94ce7

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.161=
-13-g30b360cf1996/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_a=
rm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.161=
-13-g30b360cf1996/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_a=
rm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fc775ce688fc460f3c94=
ce8
        failing since 18 days (last pass: v4.19.157-26-gd59f3161b3a0, first=
 fail: v4.19.157-27-g5543cc2c41d55) =

 =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-cip       | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/5fc77661dce33ec294c94d62

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.161=
-13-g30b360cf1996/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-v=
ersatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.161=
-13-g30b360cf1996/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-v=
ersatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fc77661dce33ec294c94=
d63
        failing since 18 days (last pass: v4.19.157-26-gd59f3161b3a0, first=
 fail: v4.19.157-27-g5543cc2c41d55) =

 =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-collabora | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/5fc78e93e011fe037ac94cd4

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.161=
-13-g30b360cf1996/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu=
_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.161=
-13-g30b360cf1996/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu=
_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fc78e93e011fe037ac94=
cd5
        failing since 18 days (last pass: v4.19.157-26-gd59f3161b3a0, first=
 fail: v4.19.157-27-g5543cc2c41d55) =

 =20
