Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 93B15339C3A
	for <lists+stable@lfdr.de>; Sat, 13 Mar 2021 06:48:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232223AbhCMFr0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 13 Mar 2021 00:47:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58822 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230470AbhCMFrN (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 13 Mar 2021 00:47:13 -0500
Received: from mail-pl1-x635.google.com (mail-pl1-x635.google.com [IPv6:2607:f8b0:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 46458C061574
        for <stable@vger.kernel.org>; Fri, 12 Mar 2021 21:47:13 -0800 (PST)
Received: by mail-pl1-x635.google.com with SMTP id q12so2426293plr.1
        for <stable@vger.kernel.org>; Fri, 12 Mar 2021 21:47:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=PWfYsUklhaseuj3k5MVU4nyINObNtwZv9EWhvGrO0ho=;
        b=jeo8qS1PxbUd5OHo4j9snFGQ0IYXJx4admWqMMimLlKYeitoW9GC3/KBEdFHbBOP1h
         TZWrEvLnBcjOqjyxYefP/fiXkWeaYTr9RZdNRKejNrWFgerajC1e2m3HfGweoEmcrdkC
         jwvACekpzzerNpCfP++0lwyNvUNCRLreZQXZSVbhphqi/uHdPR9FA9PJ1uONzFpmrMKT
         njXn1dM72WF9jru+67oQgDC+ljj8/DWUC2wkHdbl3jC/v1gHdaeCeYCSFYvnSOEIe0HE
         u8V1w0Veu9DZQKFX/W8Yopn4/SVLRDSeiRosz5/FjHC5L0s4OpBktTkPdpXKu56afy29
         Gt7A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=PWfYsUklhaseuj3k5MVU4nyINObNtwZv9EWhvGrO0ho=;
        b=kWsnqo5SAK82gbcXFdmhY9ESvUPfOUS09xKVcIJ8N0BMoxcmzD3RhmIXWzx8s1Btnd
         pEQ91673D5U8HnL69hbwRhkB+bK6wNClLDAcA8TCKuXil1knpWrEwecP6lEEhYx/nj1h
         ms1hVIZEnYtqbOtyO9vOIE/EMbgjjv6aMVGaWArAgNEvRZRWotVY9yo0A8be3ZhwHuro
         VQ5YW8tCn04A8BY334pSU1xtnEUWvdAl3PeFAmlKjBZfb7fg1h0cFh+5Uq8jQ5g4lzHI
         jKiebxpqGKUxYycseF3BOynaO/0HLX7JCjBHSm+zvWy95K+KtdM3ROXTHzVlRC9OZ4LO
         eYmA==
X-Gm-Message-State: AOAM531SeNnHJ+u3f+7/xOiiTqfrCyKsd8CHpPI3faRxAX1B+TAAw4oO
        fQkhAuxZ6/UGJls4/gFZBd2W09WbhHptUg==
X-Google-Smtp-Source: ABdhPJzbsFcwMsbMkthwCqWWZxR2jaFo5ylSTTr/nrPl7VNazmlUjQxDx0wOGQ9QXlOBR2z4f5xiBA==
X-Received: by 2002:a17:90b:b0d:: with SMTP id bf13mr1915204pjb.7.1615614432529;
        Fri, 12 Mar 2021 21:47:12 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id c25sm6683596pfo.101.2021.03.12.21.47.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 12 Mar 2021 21:47:12 -0800 (PST)
Message-ID: <604c51e0.1c69fb81.b2e98.2603@mx.google.com>
Date:   Fri, 12 Mar 2021 21:47:12 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.14.225-31-g6faec443ce130
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/4.14
Subject: stable-rc/queue/4.14 baseline: 99 runs,
 5 regressions (v4.14.225-31-g6faec443ce130)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.14 baseline: 99 runs, 5 regressions (v4.14.225-31-g6faec4=
43ce130)

Regressions Summary
-------------------

platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
panda                | arm  | lab-collabora   | gcc-8    | omap2plus_defcon=
fig | 1          =

qemu_arm-versatilepb | arm  | lab-broonie     | gcc-8    | versatile_defcon=
fig | 1          =

qemu_arm-versatilepb | arm  | lab-cip         | gcc-8    | versatile_defcon=
fig | 1          =

qemu_arm-versatilepb | arm  | lab-collabora   | gcc-8    | versatile_defcon=
fig | 1          =

qemu_arm-versatilepb | arm  | lab-linaro-lkft | gcc-8    | versatile_defcon=
fig | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.14/ker=
nel/v4.14.225-31-g6faec443ce130/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.14
  Describe: v4.14.225-31-g6faec443ce130
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      6faec443ce13005be95f8d671eb0a38baeae7212 =



Test Regressions
---------------- =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
panda                | arm  | lab-collabora   | gcc-8    | omap2plus_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/604c20df02cec03337addccf

  Results:     3 PASS, 1 FAIL, 1 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.225=
-31-g6faec443ce130/arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-pan=
da.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.225=
-31-g6faec443ce130/arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-pan=
da.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/604c20df02cec03=
337addcd4
        failing since 0 day (last pass: v4.14.224-20-g7af575ced3e9a, first =
fail: v4.14.225-11-ga5cc03880a07b)
        2 lines

    2021-03-13 02:18:03.926000+00:00  [   20.398529] usb 3-1.1: New USB dev=
ice found, idVendor=3D0424, idProduct=3Dec00
    2021-03-13 02:18:03.928000+00:00  [   20.404571] usb 3-1.1: New USB dev=
ice strings: Mfr=3D0, Product=3D0, SerialNumber=3D0
    2021-03-13 02:18:03.963000+00:00  [   20.445190] smsc95xx v1.0.6
    2021-03-13 02:18:03.986000+00:00  kern  :emerg : BUG: spinlock bad magi=
c on CPU#0, udevd/106
    2021-03-13 02:18:03.995000+00:00  kern  :emerg :  lock: emif_lock+0x0/0=
xffffed34 [emif], .magic: 00000000, .owner: <none>/-1, .owner_cpu: 0   =

 =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-broonie     | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/604c1f81cd5a07440baddcf8

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.225=
-31-g6faec443ce130/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_=
arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.225=
-31-g6faec443ce130/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_=
arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/604c1f81cd5a07440badd=
cf9
        failing since 119 days (last pass: v4.14.206-21-g787a7a3ca16c, firs=
t fail: v4.14.206-22-ga949bf40fb01) =

 =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-cip         | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/604c1face45ea45229addcb4

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.225=
-31-g6faec443ce130/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-=
versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.225=
-31-g6faec443ce130/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-=
versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/604c1face45ea45229add=
cb5
        failing since 119 days (last pass: v4.14.206-21-g787a7a3ca16c, firs=
t fail: v4.14.206-22-ga949bf40fb01) =

 =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-collabora   | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/604c1f1ca90ae661e1addcc3

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.225=
-31-g6faec443ce130/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qem=
u_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.225=
-31-g6faec443ce130/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qem=
u_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/604c1f1ca90ae661e1add=
cc4
        failing since 119 days (last pass: v4.14.206-21-g787a7a3ca16c, firs=
t fail: v4.14.206-22-ga949bf40fb01) =

 =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-linaro-lkft | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/604c1f30a90ae661e1addcca

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.225=
-31-g6faec443ce130/arm/versatile_defconfig/gcc-8/lab-linaro-lkft/baseline-q=
emu_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.225=
-31-g6faec443ce130/arm/versatile_defconfig/gcc-8/lab-linaro-lkft/baseline-q=
emu_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/604c1f30a90ae661e1add=
ccb
        failing since 119 days (last pass: v4.14.206-21-g787a7a3ca16c, firs=
t fail: v4.14.206-22-ga949bf40fb01) =

 =20
