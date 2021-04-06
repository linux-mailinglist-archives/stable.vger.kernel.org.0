Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DF432355DE4
	for <lists+stable@lfdr.de>; Tue,  6 Apr 2021 23:27:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234268AbhDFV17 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 6 Apr 2021 17:27:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50538 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234191AbhDFV16 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 6 Apr 2021 17:27:58 -0400
Received: from mail-pj1-x102e.google.com (mail-pj1-x102e.google.com [IPv6:2607:f8b0:4864:20::102e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B548CC06174A
        for <stable@vger.kernel.org>; Tue,  6 Apr 2021 14:27:48 -0700 (PDT)
Received: by mail-pj1-x102e.google.com with SMTP id lr1-20020a17090b4b81b02900ea0a3f38c1so1954495pjb.0
        for <stable@vger.kernel.org>; Tue, 06 Apr 2021 14:27:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=iagwur0uFyxnT4UNaieR+mfexfdrEU6s87OmfxmJfiw=;
        b=SGc1B4/WdvB72vTxKRGUb7XwDWcLMK4cVRaRQ2M7HzFdPU39CK6gxx8IlJXF/9T29G
         Pge7W6o/F1/WcEqKWqxX1IYyOTXUwv9urn2yR1+j8nv7HE6YcfuT/6qvVWB6Fmp+orMU
         6gWH019+e6UZuLhaSUaNRaFJSHuBeMxNIDpT7zKBA/KtmI0aQGXt5Awni/F0J1apHrC3
         ZaQc86fJunz6OwOsZwrpzT5hxWPVs8/6eT7Uct3fUdaBiMxOE5ld8eWNiG+znss5srsE
         X71U+CoDtCRIny6E1OX/AKdRtV+xFo6XlgR/LQj7+AleC+T2356SZMeC4WCKZW1pZ4B8
         iAxA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=iagwur0uFyxnT4UNaieR+mfexfdrEU6s87OmfxmJfiw=;
        b=L4FP9qu0g1n5+Q2QDAVZH2MS0QzYmP6GZsQA+GYxIKiN+Q+PD4t3yJyAWFH0+admzf
         L5oxj3Yrmudp9oyeNUfwXm60/qn8RnU/2FPHUp41HhiIN4Sb5UA1IapEir8sqbw5FTqG
         icZ3dZG06nq+4En/nNHCxE26V2B82NKxBvoHBU6QGecHzluSON0T0z3OpL7q6U5Kh23s
         kMC6oMp8pEUwCx2QKLLUcGu5zCVcMzsgna6xCbBQRix38rgBVgw3cIZZ62b245eFBq5J
         uR3L2PwTghfXAwnM863OvNTuBP6e7/+WOpg4/WnyFDlRJgZFSjmTVBo+Wn9CgvT/ZtJH
         2u9w==
X-Gm-Message-State: AOAM530ngGUpn6VWgiGG+AJyEpiXZrV+/BXLFYEfnQOFI7wKHPJa4FOM
        YpGWwiI2NDFrxQqTbVSA7fX0BPT/iClfEYkx
X-Google-Smtp-Source: ABdhPJxW/EceUdfgXglXyKUbLlRcJGjOL0yDx7aC2ojgkOqKLFJgCeKoG3zyPzIVxksbn3GBcciJmg==
X-Received: by 2002:a17:90a:de89:: with SMTP id n9mr157139pjv.180.1617744468173;
        Tue, 06 Apr 2021 14:27:48 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id k21sm19471761pfi.28.2021.04.06.14.27.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 06 Apr 2021 14:27:47 -0700 (PDT)
Message-ID: <606cd253.1c69fb81.7ab4f.0fd1@mx.google.com>
Date:   Tue, 06 Apr 2021 14:27:47 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v4.14.228-52-g7d681588fac8f
X-Kernelci-Branch: queue/4.14
X-Kernelci-Tree: stable-rc
Subject: stable-rc/queue/4.14 baseline: 72 runs,
 5 regressions (v4.14.228-52-g7d681588fac8f)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.14 baseline: 72 runs, 5 regressions (v4.14.228-52-g7d6815=
88fac8f)

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

qemu_arm-versatilepb | arm  | lab-broonie     | gcc-8    | versatile_defcon=
fig | 1          =

qemu_arm-versatilepb | arm  | lab-collabora   | gcc-8    | versatile_defcon=
fig | 1          =

qemu_arm-versatilepb | arm  | lab-linaro-lkft | gcc-8    | versatile_defcon=
fig | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.14/ker=
nel/v4.14.228-52-g7d681588fac8f/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.14
  Describe: v4.14.228-52-g7d681588fac8f
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      7d681588fac8f2f6d4376ae5dec76d25905d96df =



Test Regressions
---------------- =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
panda                | arm  | lab-collabora   | gcc-8    | omap2plus_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/606c987ad4224b229cdac6ba

  Results:     3 PASS, 1 FAIL, 1 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.228=
-52-g7d681588fac8f/arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-pan=
da.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.228=
-52-g7d681588fac8f/arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-pan=
da.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/606c987ad4224b2=
29cdac6c1
        failing since 3 days (last pass: v4.14.228-36-g9f3ce13352b5e, first=
 fail: v4.14.228-37-gf3371b16da688)
        2 lines

    2021-04-06 17:20:54.287000+00:00  kern  :emerg : BUG: spinlock bad magi=
c on CPU#0, udevd/106
    2021-04-06 17:20:54.302000+00:00  kern  :emerg :  lock: emif_lock+0x0/[=
   20.447662] smsc95xx 3-1.1:1.0 eth0: register 'smsc95xx' at usb-4a064c00.=
ehci-1.1, smsc95xx USB 2.0 Ethernet, de:78:de:d3:e6:86
    2021-04-06 17:20:54.312000+00:00  0xffffed34 [emif], .magic: 00000000, =
.owner: <no[   20.463867] usbcore: registered new interface driver smsc95xx=
   =

 =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-baylibre    | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/606c98728b8ef2f11bdac6b6

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.228=
-52-g7d681588fac8f/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu=
_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.228=
-52-g7d681588fac8f/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu=
_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/606c98728b8ef2f11bdac=
6b7
        failing since 143 days (last pass: v4.14.206-21-g787a7a3ca16c, firs=
t fail: v4.14.206-22-ga949bf40fb01) =

 =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-broonie     | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/606c973b34f84fbac2dac6c4

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.228=
-52-g7d681588fac8f/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_=
arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.228=
-52-g7d681588fac8f/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_=
arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/606c973b34f84fbac2dac=
6c5
        failing since 143 days (last pass: v4.14.206-21-g787a7a3ca16c, firs=
t fail: v4.14.206-22-ga949bf40fb01) =

 =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-collabora   | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/606c9b21114a6292addac6b3

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.228=
-52-g7d681588fac8f/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qem=
u_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.228=
-52-g7d681588fac8f/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qem=
u_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/606c9b21114a6292addac=
6b4
        failing since 143 days (last pass: v4.14.206-21-g787a7a3ca16c, firs=
t fail: v4.14.206-22-ga949bf40fb01) =

 =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-linaro-lkft | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/606c962d01eb59ff0bdac6c6

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.228=
-52-g7d681588fac8f/arm/versatile_defconfig/gcc-8/lab-linaro-lkft/baseline-q=
emu_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.228=
-52-g7d681588fac8f/arm/versatile_defconfig/gcc-8/lab-linaro-lkft/baseline-q=
emu_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/606c962d01eb59ff0bdac=
6c7
        failing since 143 days (last pass: v4.14.206-21-g787a7a3ca16c, firs=
t fail: v4.14.206-22-ga949bf40fb01) =

 =20
