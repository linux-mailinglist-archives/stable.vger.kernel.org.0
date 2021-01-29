Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0A023308D86
	for <lists+stable@lfdr.de>; Fri, 29 Jan 2021 20:41:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233044AbhA2Ti5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 29 Jan 2021 14:38:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50838 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233042AbhA2Ti4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 29 Jan 2021 14:38:56 -0500
Received: from mail-pg1-x52b.google.com (mail-pg1-x52b.google.com [IPv6:2607:f8b0:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4FD9FC061574
        for <stable@vger.kernel.org>; Fri, 29 Jan 2021 11:38:16 -0800 (PST)
Received: by mail-pg1-x52b.google.com with SMTP id j2so5705127pgl.0
        for <stable@vger.kernel.org>; Fri, 29 Jan 2021 11:38:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=jZhtloGUj4+39JnEk8vv0xEWl8qy020bChBonmLKtxw=;
        b=sLU4v8rqLhWAwGD0ZCJOlvWut+WaPBz3+T0HEPWX+5x7uMdGyTuo0Vfd4GXbDyYYdw
         i8W8fTGlGDGhv39Mh4OsTJti0llS1ph9CWYM2RDH9DHqdSVKH8Eco3OxtlXf6mI9UKWI
         k8JD2ywu88coFSxpUvtko9BkSZsEoRVRYi46P220JRYk0FzMWYflh5yRVEb6Lr2BZVid
         KVDGDwTzH8m9WLxX9pcw0oZoZXnvQQqXa0MflZ0IpfSqba1hKY647SHDXS9Pu3v7mfgz
         aoxzYu2jiqVBht5OIC8czevLRsS2yfod7Z3LXQ6VOXuwICdu5UJAIMQcPpVx48tJyijA
         EIIg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=jZhtloGUj4+39JnEk8vv0xEWl8qy020bChBonmLKtxw=;
        b=c+zC39HB/doVA9ovZVHk1QquOBn4lrkMQ+FuNaQrsw8r0cJyMAKiMxZjRiXVP2BHuy
         wfGzNZMLccp9Ggd0nQXmfwRIqVQkjVca6yMUPw8epm48l3jiow7alFuWGkdxqXi9xArJ
         KrH+bhclhqUB2qS6vyG5o+RikQPSE9UqigPuOKfuf05V8tlNEovFF6JCVYIDWay+oPL7
         Z8fxR75gl5WHZpNUx9PTPP9oT7YenI/qfMXMyGm09kSUKtHHEuuYXEB+sdwAV5cQJmAi
         iBDtBSC7Aa+t/Rjjb0xJXrYxSn7yBq3SlxUWl4Mo8wfQe2pGrFfuGLUX3Zv3fa0GThWF
         WFLA==
X-Gm-Message-State: AOAM533XH36ViHk4d2R1ATUbvpPYqVsn/qrhf+ecUF4kike/xbfhd+69
        NA1e+OFPYMk/d6Z/D6xde1OnebPrlSYNpQ==
X-Google-Smtp-Source: ABdhPJwBHZI0NWn97J4EVY4iiEoywUBwV86mg7DLex3YPfemuTdAodNV6pLTyF0qlnY4jEGVlOar+g==
X-Received: by 2002:a62:1b47:0:b029:1ba:7a85:cdff with SMTP id b68-20020a621b470000b02901ba7a85cdffmr6001532pfb.22.1611949095491;
        Fri, 29 Jan 2021 11:38:15 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id c204sm9298892pfc.152.2021.01.29.11.38.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 29 Jan 2021 11:38:14 -0800 (PST)
Message-ID: <60146426.1c69fb81.b7c91.6b6b@mx.google.com>
Date:   Fri, 29 Jan 2021 11:38:14 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.19.171-27-gd36f1541af5a
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-4.19.y
Subject: stable-rc/linux-4.19.y baseline: 155 runs,
 5 regressions (v4.19.171-27-gd36f1541af5a)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.19.y baseline: 155 runs, 5 regressions (v4.19.171-27-gd36=
f1541af5a)

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


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-4.19.y/ker=
nel/v4.19.171-27-gd36f1541af5a/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-4.19.y
  Describe: v4.19.171-27-gd36f1541af5a
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      d36f1541af5ac2e86ea3548b7da2e962e4ef5266 =



Test Regressions
---------------- =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
panda                | arm  | lab-collabora | gcc-8    | omap2plus_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/60143355b05931199ad3dfdd

  Results:     4 PASS, 1 FAIL, 0 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.1=
71-27-gd36f1541af5a/arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-pa=
nda.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.1=
71-27-gd36f1541af5a/arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-pa=
nda.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/60143355b059311=
99ad3dfe2
        failing since 11 days (last pass: v4.19.167-44-g710affe26b436, firs=
t fail: v4.19.168-13-g245da3579887f)
        2 lines

    2021-01-29 16:09:51.454000+00:00  kern  :emerg :  lock: emif_lock+0x0/0=
xffffed34 [emif], .magic: dead4ead, .owner: <none>/-1, .owner_cpu: -1
    2021-01-29 16:09:51.470000+00:00  <8>[   22.722320] <LAVA_SIGNAL_TESTCA=
SE TEST_CASE_ID=3Demerg RESULT=3Dfail UNITS=3Dlines MEASUREMENT=3D2>   =

 =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-baylibre  | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/60142f5c8ba980eedcd3dfd9

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.1=
71-27-gd36f1541af5a/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qem=
u_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.1=
71-27-gd36f1541af5a/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qem=
u_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60142f5c8ba980eedcd3d=
fda
        failing since 72 days (last pass: v4.19.157-26-ga8e7fec1fea1, first=
 fail: v4.19.157-102-g1d674327c1b7) =

 =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-broonie   | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/60142f5a8ba980eedcd3dfd6

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.1=
71-27-gd36f1541af5a/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu=
_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.1=
71-27-gd36f1541af5a/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu=
_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60142f5a8ba980eedcd3d=
fd7
        failing since 72 days (last pass: v4.19.157-26-ga8e7fec1fea1, first=
 fail: v4.19.157-102-g1d674327c1b7) =

 =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-cip       | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/60142f4708d94a7feed3e075

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.1=
71-27-gd36f1541af5a/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm=
-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.1=
71-27-gd36f1541af5a/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm=
-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60142f4708d94a7feed3e=
076
        failing since 72 days (last pass: v4.19.157-26-ga8e7fec1fea1, first=
 fail: v4.19.157-102-g1d674327c1b7) =

 =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-collabora | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/60142ef746706fe987d3dfc9

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.1=
71-27-gd36f1541af5a/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qe=
mu_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.1=
71-27-gd36f1541af5a/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qe=
mu_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60142ef746706fe987d3d=
fca
        failing since 72 days (last pass: v4.19.157-26-ga8e7fec1fea1, first=
 fail: v4.19.157-102-g1d674327c1b7) =

 =20
