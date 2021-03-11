Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6B71D3380C5
	for <lists+stable@lfdr.de>; Thu, 11 Mar 2021 23:45:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229674AbhCKWpS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 11 Mar 2021 17:45:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53482 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229441AbhCKWoy (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 11 Mar 2021 17:44:54 -0500
Received: from mail-pf1-x42f.google.com (mail-pf1-x42f.google.com [IPv6:2607:f8b0:4864:20::42f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 58C98C061574
        for <stable@vger.kernel.org>; Thu, 11 Mar 2021 14:44:54 -0800 (PST)
Received: by mail-pf1-x42f.google.com with SMTP id q204so523385pfq.10
        for <stable@vger.kernel.org>; Thu, 11 Mar 2021 14:44:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=L+BHV53d0pDDvWJIY3ttgMNaukYqE1ZeimYLb8N+4Q8=;
        b=m3QUGrV1DsEoaAMLJi+Lqc2WQ/Spi01sAhavcV0hn/LJGo95PaFiKegIOYNscTfL5e
         MPU7Z/oWr0NV02v2enWJWg4FLRVShaUcXTkD7KoLupvZ7JLF3fNNVNwLHWtnMDGmr5oL
         BM9fJ5jaRZErWOh0+b0hkkCBPovo1L+PkXZnzE8jU8USPb2oRP765N5+yX9oarb6Y2X+
         Mf+G01bB78OqvJftmrLS4qg/wjnL2crcg4lEQN93ypo6DyHStiTl/a99DSMMzc/TnAAu
         e7fgizOMl/FHFNPXh4rZIgM44ag41Cc21u2vJ7zT0RcPbPCudKzC7v6tVRNWCxzeyts1
         Wo9g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=L+BHV53d0pDDvWJIY3ttgMNaukYqE1ZeimYLb8N+4Q8=;
        b=iz7PIZnQz+b/3RisEz67qneUG3puxTjyp2QhQg2ER4AGXSEZ34fRqJJW+e2QJFDI/S
         E4vAlgXtKcHCIlm/Jfm9DOYnlQQXyqE9N2H+ua5ktPCWO3RF1snCmLhya2gurUPo7r3O
         kIZ4eD6gYyw4IkA7GBR29yaGZcoIp+xfYJ7joWrB4UwG2UU6XGNgM0xpmgQm8QNx1RnO
         3KU7M6IbuEl0EhSipc8c7xpbhoW/ed/i7v6UdS8Lbq/pT7LeSZRYjae1LRpMX6CpZcaY
         NDN1UwtwKgkZjoMxO3U7BIY6FiPjz/IqpXQSzh3r1juDkze8XxfXEAqxl2/O6NHN0Dkj
         UtKw==
X-Gm-Message-State: AOAM532smOodgVEHzo5yx2p6X/03WSy3ZxTzMW9H00apxqX+8blB0V4g
        8VoDlhHfbiY3qvhhFh0BndQ3KYPZS7FbaKJq
X-Google-Smtp-Source: ABdhPJy5mfUEjb7uukYuNrjOMtF3x0+Wyau4Kjq8G6VdmboHa2Zn4na/iS9J7HT/S0UkuP2qSJ5FBg==
X-Received: by 2002:a63:3d0b:: with SMTP id k11mr8979463pga.390.1615502693644;
        Thu, 11 Mar 2021 14:44:53 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id a19sm118947pjh.39.2021.03.11.14.44.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 11 Mar 2021 14:44:53 -0800 (PST)
Message-ID: <604a9d65.1c69fb81.90ea2.0919@mx.google.com>
Date:   Thu, 11 Mar 2021 14:44:53 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.9.261-10-g5874599a8f305
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-4.9.y
Subject: stable-rc/linux-4.9.y baseline: 71 runs,
 4 regressions (v4.9.261-10-g5874599a8f305)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.9.y baseline: 71 runs, 4 regressions (v4.9.261-10-g587459=
9a8f305)

Regressions Summary
-------------------

platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
panda                | arm  | lab-collabora | gcc-8    | omap2plus_defconfi=
g | 1          =

qemu_arm-versatilepb | arm  | lab-broonie   | gcc-8    | versatile_defconfi=
g | 1          =

qemu_arm-versatilepb | arm  | lab-cip       | gcc-8    | versatile_defconfi=
g | 1          =

qemu_arm-versatilepb | arm  | lab-collabora | gcc-8    | versatile_defconfi=
g | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-4.9.y/kern=
el/v4.9.261-10-g5874599a8f305/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-4.9.y
  Describe: v4.9.261-10-g5874599a8f305
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      5874599a8f305dc1bcf7fa76e84a813624d0f095 =



Test Regressions
---------------- =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
panda                | arm  | lab-collabora | gcc-8    | omap2plus_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/604a6c846966ac11bcaddcc3

  Results:     3 PASS, 1 FAIL, 1 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.261=
-10-g5874599a8f305/arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-pan=
da.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.261=
-10-g5874599a8f305/arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-pan=
da.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/604a6c846966ac1=
1bcaddcc8
        new failure (last pass: v4.9.260-12-g8bf14e5a6c5c)
        2 lines

    2021-03-11 19:16:17.082000+00:00  kern  :emerg :  lock: emif_lock+0x0/0=
xfffff24c [emif], .magic: 00000000, .owner: <none>/-1, .owner_cpu: 0   =

 =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-broonie   | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/604a6b9af8e93a2f6daddcc1

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.261=
-10-g5874599a8f305/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_=
arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.261=
-10-g5874599a8f305/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_=
arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/604a6b9af8e93a2f6dadd=
cc2
        failing since 117 days (last pass: v4.9.243-17-g9c24315b745a0, firs=
t fail: v4.9.243-26-g7b603f689c1c) =

 =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-cip       | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/604a6c04c48cafffcbaddcc4

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.261=
-10-g5874599a8f305/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-=
versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.261=
-10-g5874599a8f305/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-=
versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/604a6c04c48cafffcbadd=
cc5
        failing since 117 days (last pass: v4.9.243-17-g9c24315b745a0, firs=
t fail: v4.9.243-26-g7b603f689c1c) =

 =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-collabora | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/604a6af7eb12992499addcc3

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.261=
-10-g5874599a8f305/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qem=
u_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.261=
-10-g5874599a8f305/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qem=
u_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/604a6af7eb12992499add=
cc4
        failing since 117 days (last pass: v4.9.243-17-g9c24315b745a0, firs=
t fail: v4.9.243-26-g7b603f689c1c) =

 =20
