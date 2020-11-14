Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 954F62B2C9E
	for <lists+stable@lfdr.de>; Sat, 14 Nov 2020 11:11:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726654AbgKNKKM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 14 Nov 2020 05:10:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44674 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726495AbgKNKKM (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 14 Nov 2020 05:10:12 -0500
Received: from mail-pg1-x52c.google.com (mail-pg1-x52c.google.com [IPv6:2607:f8b0:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B0F00C0613D1
        for <stable@vger.kernel.org>; Sat, 14 Nov 2020 02:10:10 -0800 (PST)
Received: by mail-pg1-x52c.google.com with SMTP id e21so8958468pgr.11
        for <stable@vger.kernel.org>; Sat, 14 Nov 2020 02:10:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=pJOpIppSxn1IgjC3L9ZUaajuyqQ1Lel7gmmmAeUqWew=;
        b=sRSrgWERWbTIheq2OJoXdhxI3jpHLoKl4sPf+X38Eudw5CG2EyayC6w09GZG3LgMnW
         2crvR+XUw1MjuMMB4mIG33NeeILQM3MIwGOdwg9bfOBYOyP9O1j2BJwE6hJr16ovXJf7
         Us0hySkEs4Av6onw3sTpcaZ9R7BKiwk79sGH2cw2Jv88DYzXKde/+TvxnH8HCz59cn1W
         377+X2BqQCEvKi6yiGdEq/zuYvEfxpo0nGJA98ziSS5vVo9qX4R4pngjQt3Ma+Wy6aLt
         VSgbI+RAtAW/WZ499R2pSEVuQ21+Cei9l1Eo+i/3f6noiapmzszBxbwUreariIiNur+S
         nIXQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=pJOpIppSxn1IgjC3L9ZUaajuyqQ1Lel7gmmmAeUqWew=;
        b=p+QdKNYCbmVmHgXggIuw3Fc+/6IR9VZ56vh9puixgRQIbGpFAcukVW75avjp1VKd1Z
         cztXJi6nkx47E1Dg4KOef8houB+HQIpcERqg4kHBvxJ9T5UhYR0IFo2if4Q1GtbcOA3w
         zAwgDi7TdOckPESbWFQ3MXTboSLCpZgfRZ+384Rsi4EfXChAy0T00YOp5vAprzFHP4Dy
         NMqmXpW+1kR5QNcrZig+53WpynmqtcTJwt5OZLjZTXO/d8yKPrHIsyuScuyNT2/LO+D8
         sDeUMnJKD0zRl8TrJZEuDF85j3/vaWBnzS2EalzvWWvPzgm56RnU1dNso1lYrazomyG5
         MgDg==
X-Gm-Message-State: AOAM530l+fvaAchlwy3olJfVIFCQBoeUgqR6upJtkUFwg178V36impAW
        n+0KuM3BxKIo2qTgVm7AAJw2TlFN6pU0jg==
X-Google-Smtp-Source: ABdhPJy131f85FKnf4C3bjniHrzFSsAl/XmMglEqA46xOCe034rejOYryrigk67QMMIRXwwS61o10A==
X-Received: by 2002:aa7:938f:0:b029:18b:48fa:a426 with SMTP id t15-20020aa7938f0000b029018b48faa426mr5611401pfe.6.1605348609726;
        Sat, 14 Nov 2020 02:10:09 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id j1sm12123918pfa.96.2020.11.14.02.10.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 14 Nov 2020 02:10:09 -0800 (PST)
Message-ID: <5fafad01.1c69fb81.36f3f.a7a0@mx.google.com>
Date:   Sat, 14 Nov 2020 02:10:09 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: queue/4.14
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v4.14.206-22-g25c371607d29c
X-Kernelci-Report-Type: test
Subject: stable-rc/queue/4.14 baseline: 125 runs,
 6 regressions (v4.14.206-22-g25c371607d29c)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.14 baseline: 125 runs, 6 regressions (v4.14.206-22-g25c37=
1607d29c)

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

qemu_arm-versatilepb | arm  | lab-cip         | gcc-8    | versatile_defcon=
fig | 1          =

qemu_arm-versatilepb | arm  | lab-collabora   | gcc-8    | versatile_defcon=
fig | 1          =

qemu_arm-versatilepb | arm  | lab-linaro-lkft | gcc-8    | versatile_defcon=
fig | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.14/ker=
nel/v4.14.206-22-g25c371607d29c/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.14
  Describe: v4.14.206-22-g25c371607d29c
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      25c371607d29c563cdaf56b168b1642247f1b6d0 =



Test Regressions
---------------- =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
panda                | arm  | lab-collabora   | gcc-8    | omap2plus_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/5faf6f2562b3f74dd679b8a2

  Results:     3 PASS, 1 FAIL, 1 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.206=
-22-g25c371607d29c/arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-pan=
da.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.206=
-22-g25c371607d29c/arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-pan=
da.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/5faf6f2562b3f74=
dd679b8a9
        failing since 0 day (last pass: v4.14.206-21-g787a7a3ca16c, first f=
ail: v4.14.206-22-ga949bf40fb01)
        2 lines

    2020-11-14 05:46:09.166000+00:00  kern  :emerg :  lock: emif_lock+0x0/0=
xffffed34 [emif], .magic: 00000000, .owner: <none>/-1, .owner_cpu: 0   =

 =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-baylibre    | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/5faf7181c0dc41946a79b8cb

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.206=
-22-g25c371607d29c/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu=
_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.206=
-22-g25c371607d29c/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu=
_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5faf7181c0dc41946a79b=
8cc
        failing since 0 day (last pass: v4.14.206-21-g787a7a3ca16c, first f=
ail: v4.14.206-22-ga949bf40fb01) =

 =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-broonie     | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/5faf718bf1bcff946a79b8b2

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.206=
-22-g25c371607d29c/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_=
arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.206=
-22-g25c371607d29c/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_=
arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5faf718bf1bcff946a79b=
8b3
        failing since 0 day (last pass: v4.14.206-21-g787a7a3ca16c, first f=
ail: v4.14.206-22-ga949bf40fb01) =

 =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-cip         | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/5faf717af1bcff946a79b8ad

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.206=
-22-g25c371607d29c/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-=
versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.206=
-22-g25c371607d29c/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-=
versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5faf717af1bcff946a79b=
8ae
        failing since 0 day (last pass: v4.14.206-21-g787a7a3ca16c, first f=
ail: v4.14.206-22-ga949bf40fb01) =

 =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-collabora   | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/5faf714135743501e579b8a9

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.206=
-22-g25c371607d29c/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qem=
u_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.206=
-22-g25c371607d29c/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qem=
u_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5faf714135743501e579b=
8aa
        failing since 0 day (last pass: v4.14.206-21-g787a7a3ca16c, first f=
ail: v4.14.206-22-ga949bf40fb01) =

 =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-linaro-lkft | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/5faf7141c0dc41946a79b8af

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.206=
-22-g25c371607d29c/arm/versatile_defconfig/gcc-8/lab-linaro-lkft/baseline-q=
emu_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.206=
-22-g25c371607d29c/arm/versatile_defconfig/gcc-8/lab-linaro-lkft/baseline-q=
emu_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5faf7141c0dc41946a79b=
8b0
        failing since 0 day (last pass: v4.14.206-21-g787a7a3ca16c, first f=
ail: v4.14.206-22-ga949bf40fb01) =

 =20
