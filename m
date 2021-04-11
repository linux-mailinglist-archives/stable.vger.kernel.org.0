Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5965535B6E6
	for <lists+stable@lfdr.de>; Sun, 11 Apr 2021 22:45:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236562AbhDKUpo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 11 Apr 2021 16:45:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49458 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233822AbhDKUpn (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 11 Apr 2021 16:45:43 -0400
Received: from mail-pg1-x52c.google.com (mail-pg1-x52c.google.com [IPv6:2607:f8b0:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F2FF8C061574
        for <stable@vger.kernel.org>; Sun, 11 Apr 2021 13:45:26 -0700 (PDT)
Received: by mail-pg1-x52c.google.com with SMTP id f29so7777658pgm.8
        for <stable@vger.kernel.org>; Sun, 11 Apr 2021 13:45:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=rO1+jgNPIhtald/6A5uj0ZCcJBgQeIIM5uWFKHzm2NY=;
        b=X+IkBsSroHphm1w10KnqHmUoRzZHC1VsVZNHhloZCFEtRTC1MKl1MZp2Br3YpnGePy
         NOCrIrRQmz/7zZNlY+DQNTpKTYscejL/W/ixRO21CSHh8MoA2SY7dYMWzSvne0/01uwB
         ZP1ruQbj26qBvrJQ+kVIQINW/S99+laVgPU/GQVGLtmgegvMdhtHTcWsIiP2pqQR63+G
         XnyXYw7+/5J0LoXJq4w3Uqe+CtqnJ5hAcLCpT7JSB/RfvJZmoJ77Z5m+qxCwnenqtAjW
         kQeqvuWVvo6CB066LbAyXc377/QiBozYIOl7GgGIA0Odd+qoSyVIDxk36rX/BpJZpGRV
         WOZg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=rO1+jgNPIhtald/6A5uj0ZCcJBgQeIIM5uWFKHzm2NY=;
        b=XeDd0/ENEnZnuA2Oh9hXpmDLDv9Taok9uUu04TzaifVMYTCx4G8jchnC8dVLcgnAIw
         tvwIH6NlZo4N4M18Dfoxl8cfWtlP7IMQlJLj/MkJXPetpJuVauZLpBaYCOSgByC8Lwst
         26pq5SNjU5zbASU+CgyFOWYLTBCxNZLf5ppMkqA/5xmvpS1dA0R2n4sEvoJk+Z1DW+dk
         x8qcMD2hzX/h213+uvQ4ZUERahjWRicuDNeYa7a/lxmawO0BZouDmgZaFHnuV4soiTLW
         dbzIpVqkzN1udccn9Fv6srbc4gAEirvuR+A7eg+oaTSPJXQHtWgxkDdwDvKL1gliAOi1
         Bh3Q==
X-Gm-Message-State: AOAM533bHi2ILSCGT5rZerYqr4fuZiE6HNliDlOQsh6OKcJKRiXGiAIL
        EvnRVzMH5+LrrwdxSpGpb0ws1J5m7hUu8A==
X-Google-Smtp-Source: ABdhPJzRPI+FeoefBE+rrWgseDlBJB7OCyTtSbS8uSttFQ0oT4Rm3VcAIOryjM4L3oDu8fX+1rq/nQ==
X-Received: by 2002:aa7:8493:0:b029:1ee:75b2:2865 with SMTP id u19-20020aa784930000b02901ee75b22865mr21414718pfn.61.1618173926362;
        Sun, 11 Apr 2021 13:45:26 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id m195sm8363177pfd.99.2021.04.11.13.45.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 11 Apr 2021 13:45:26 -0700 (PDT)
Message-ID: <60735fe6.1c69fb81.cec8b.496c@mx.google.com>
Date:   Sun, 11 Apr 2021 13:45:26 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v4.19.186-26-gdcd8d7907af5c
X-Kernelci-Branch: queue/4.19
X-Kernelci-Tree: stable-rc
Subject: stable-rc/queue/4.19 baseline: 152 runs,
 5 regressions (v4.19.186-26-gdcd8d7907af5c)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.19 baseline: 152 runs, 5 regressions (v4.19.186-26-gdcd8d=
7907af5c)

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

qemu_arm-versatilepb | arm  | lab-collabora   | gcc-8    | versatile_defcon=
fig | 1          =

qemu_arm-versatilepb | arm  | lab-linaro-lkft | gcc-8    | versatile_defcon=
fig | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.19/ker=
nel/v4.19.186-26-gdcd8d7907af5c/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.19
  Describe: v4.19.186-26-gdcd8d7907af5c
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      dcd8d7907af5ce017f20ace8af779c28b7e024e1 =



Test Regressions
---------------- =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-baylibre    | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/607327594daaeb13a3dac6ba

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.186=
-26-gdcd8d7907af5c/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu=
_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.186=
-26-gdcd8d7907af5c/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu=
_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/607327594daaeb13a3dac=
6bb
        failing since 148 days (last pass: v4.19.157-26-gd59f3161b3a0, firs=
t fail: v4.19.157-27-g5543cc2c41d55) =

 =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-broonie     | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/607327559916f599dbdac6b1

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.186=
-26-gdcd8d7907af5c/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_=
arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.186=
-26-gdcd8d7907af5c/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_=
arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/607327559916f599dbdac=
6b2
        failing since 148 days (last pass: v4.19.157-26-gd59f3161b3a0, firs=
t fail: v4.19.157-27-g5543cc2c41d55) =

 =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-cip         | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/6073275c4daaeb13a3dac6c0

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.186=
-26-gdcd8d7907af5c/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-=
versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.186=
-26-gdcd8d7907af5c/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-=
versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6073275c4daaeb13a3dac=
6c1
        failing since 148 days (last pass: v4.19.157-26-gd59f3161b3a0, firs=
t fail: v4.19.157-27-g5543cc2c41d55) =

 =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-collabora   | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/607326e62504fdf7a0dac6df

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.186=
-26-gdcd8d7907af5c/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qem=
u_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.186=
-26-gdcd8d7907af5c/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qem=
u_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/607326e62504fdf7a0dac=
6e0
        failing since 148 days (last pass: v4.19.157-26-gd59f3161b3a0, firs=
t fail: v4.19.157-27-g5543cc2c41d55) =

 =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-linaro-lkft | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/607327022d7086f720dac70f

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.186=
-26-gdcd8d7907af5c/arm/versatile_defconfig/gcc-8/lab-linaro-lkft/baseline-q=
emu_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.186=
-26-gdcd8d7907af5c/arm/versatile_defconfig/gcc-8/lab-linaro-lkft/baseline-q=
emu_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/607327022d7086f720dac=
710
        failing since 148 days (last pass: v4.19.157-26-gd59f3161b3a0, firs=
t fail: v4.19.157-27-g5543cc2c41d55) =

 =20
