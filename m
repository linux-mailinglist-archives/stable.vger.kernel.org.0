Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3222D3651D1
	for <lists+stable@lfdr.de>; Tue, 20 Apr 2021 07:26:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229563AbhDTF1N (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 20 Apr 2021 01:27:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44754 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229523AbhDTF1N (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 20 Apr 2021 01:27:13 -0400
Received: from mail-pj1-x1033.google.com (mail-pj1-x1033.google.com [IPv6:2607:f8b0:4864:20::1033])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 97F21C06174A
        for <stable@vger.kernel.org>; Mon, 19 Apr 2021 22:26:40 -0700 (PDT)
Received: by mail-pj1-x1033.google.com with SMTP id k23-20020a17090a5917b02901043e35ad4aso21690040pji.3
        for <stable@vger.kernel.org>; Mon, 19 Apr 2021 22:26:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=qHaniV9k3vTZLSrCXUmfjHn/P3vCUZqYSDVOMthbKr8=;
        b=ztaWgDWWSa/D5qQUhGIbYYPtkF3bGCdp2xpV/Z3PR6AmIYAJ6I9/st/p1bWwEzG5pP
         2ndoEE09fOpaggsR8mAHNFqvt7to4g/RUtZfjCr59vS7s4xNeafXhYbszGC3kGO7Sjst
         TsqpHxfoc0lWi+Lz9NISKDBqXxjcA5kZFcGsioJNPsY/WboYN1/qf8eAWPTVeNy2CGvo
         2ZSKRhjOuO7Reo/ulP8712Z7O50pw4/k+HIW1xuAWbGFxJIVodQQGv+QMFUuViAfxAM+
         HKzMDqH1aj54YPbEFW2I7K+rBNkO/3MLvL8Nf5xqtuA4sYSpbjEisJWKrVeYDnRNTlun
         9jSA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=qHaniV9k3vTZLSrCXUmfjHn/P3vCUZqYSDVOMthbKr8=;
        b=Jz9TL6AdMpXfa3A8bV9JdptTdwa9L2nGxsY8V6rf1o9bHkjTAwm1c8JWwklsiWozw8
         2FEUy45QhC2FKLm0mB47XMZQZyV8f155xTNU/7QcS36ZU8awHWCneGgpHXb7etIxMSFp
         mCRHaB3VzU6c623yenLxJ6gwMTxSt/mf0WrPhRoCQKOdppzzJP/HVUBBdbSARiAhvfhJ
         V+Eru3gLEi+WKV7xKTDxC2qjrCHu/Zxd/B5o39+6hcgf3M8fakb509nUxS5JHT2qWQdF
         S+LRmgS1Lvc0KQzI988dlrsIuag9aExgJOOUa0VBf9VHuvgsr8n8uBxS7kA9eynCKnpI
         oM9g==
X-Gm-Message-State: AOAM532QQp6ub30QAdSk3YXXz6YNVDTOcBVx47ywXLNJKZilEFnFnz6V
        RvBfHrGMQFSaZrCVHf8P2nxr1lKkapeaVlIj
X-Google-Smtp-Source: ABdhPJzBfQEgF2K3AFznJctCvyUHWoG6aX8G+uvxoP1NKfxN8yQ1JLH4mVjLxQkiWALdpF9ogQvehg==
X-Received: by 2002:a17:90a:9b18:: with SMTP id f24mr2888386pjp.96.1618896399631;
        Mon, 19 Apr 2021 22:26:39 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id w25sm1670441pfg.206.2021.04.19.22.26.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 19 Apr 2021 22:26:39 -0700 (PDT)
Message-ID: <607e660f.1c69fb81.529af.5c09@mx.google.com>
Date:   Mon, 19 Apr 2021 22:26:39 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.19.188-45-gb0e11de9a5168
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-4.19.y
Subject: stable-rc/linux-4.19.y baseline: 134 runs,
 6 regressions (v4.19.188-45-gb0e11de9a5168)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.19.y baseline: 134 runs, 6 regressions (v4.19.188-45-gb0e=
11de9a5168)

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


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-4.19.y/ker=
nel/v4.19.188-45-gb0e11de9a5168/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-4.19.y
  Describe: v4.19.188-45-gb0e11de9a5168
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      b0e11de9a51682fa903639eb7250f7623cf8636b =



Test Regressions
---------------- =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
panda                | arm  | lab-collabora   | gcc-8    | omap2plus_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/607e32778447791ff29b779b

  Results:     4 PASS, 1 FAIL, 0 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.1=
88-45-gb0e11de9a5168/arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-p=
anda.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.1=
88-45-gb0e11de9a5168/arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-p=
anda.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/607e32778447791=
ff29b77a2
        new failure (last pass: v4.19.188-42-gda54c8927dbd4)
        2 lines

    2021-04-20 01:46:26.668000+00:00  kern  :emerg : BUG: spinlock bad magi=
c on CPU#0, udevd/108
    2021-04-20 01:46:26.678000+00:00  kern  :emerg :  lock: emif_lock+0x0/0=
xffffed34 [emif], .magic: 00000000, .owner: <none>/-1, .owner_cpu: 0
    2021-04-20 01:46:26.699000+00:00  <8>[   22.882873] <LAVA_SIGNAL_TESTCA=
SE TEST_CASE_ID=3Demerg RESULT=3Dfail UNITS=3Dlines MEASUREMENT=3D2>   =

 =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-baylibre    | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/607e31ed3da674e0399b77ab

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.1=
88-45-gb0e11de9a5168/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qe=
mu_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.1=
88-45-gb0e11de9a5168/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qe=
mu_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/607e31ed3da674e0399b7=
7ac
        failing since 152 days (last pass: v4.19.157-26-ga8e7fec1fea1, firs=
t fail: v4.19.157-102-g1d674327c1b7) =

 =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-broonie     | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/607e31d4e05ec0bf079b77b6

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.1=
88-45-gb0e11de9a5168/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qem=
u_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.1=
88-45-gb0e11de9a5168/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qem=
u_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/607e31d4e05ec0bf079b7=
7b7
        failing since 152 days (last pass: v4.19.157-26-ga8e7fec1fea1, firs=
t fail: v4.19.157-102-g1d674327c1b7) =

 =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-cip         | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/607e32026c83e61de59b77ad

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.1=
88-45-gb0e11de9a5168/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_ar=
m-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.1=
88-45-gb0e11de9a5168/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_ar=
m-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/607e32026c83e61de59b7=
7ae
        failing since 152 days (last pass: v4.19.157-26-ga8e7fec1fea1, firs=
t fail: v4.19.157-102-g1d674327c1b7) =

 =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-collabora   | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/607e31740935cb6d159b77bd

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.1=
88-45-gb0e11de9a5168/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-q=
emu_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.1=
88-45-gb0e11de9a5168/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-q=
emu_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/607e31740935cb6d159b7=
7be
        failing since 152 days (last pass: v4.19.157-26-ga8e7fec1fea1, firs=
t fail: v4.19.157-102-g1d674327c1b7) =

 =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-linaro-lkft | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/607e318e6553ed2c549b77a1

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.1=
88-45-gb0e11de9a5168/arm/versatile_defconfig/gcc-8/lab-linaro-lkft/baseline=
-qemu_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.1=
88-45-gb0e11de9a5168/arm/versatile_defconfig/gcc-8/lab-linaro-lkft/baseline=
-qemu_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/607e318e6553ed2c549b7=
7a2
        failing since 152 days (last pass: v4.19.157-26-ga8e7fec1fea1, firs=
t fail: v4.19.157-102-g1d674327c1b7) =

 =20
