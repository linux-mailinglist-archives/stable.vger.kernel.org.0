Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6A8C32CC654
	for <lists+stable@lfdr.de>; Wed,  2 Dec 2020 20:13:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389758AbgLBTMl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 2 Dec 2020 14:12:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58674 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389614AbgLBTMk (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 2 Dec 2020 14:12:40 -0500
Received: from mail-pf1-x436.google.com (mail-pf1-x436.google.com [IPv6:2607:f8b0:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D79D0C0613D6
        for <stable@vger.kernel.org>; Wed,  2 Dec 2020 11:12:00 -0800 (PST)
Received: by mail-pf1-x436.google.com with SMTP id q22so1833659pfk.12
        for <stable@vger.kernel.org>; Wed, 02 Dec 2020 11:12:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=b8R/hiLZB8XQ4qRolq+vW2rIRUwrTLw1k95xrO3i3v8=;
        b=bgWVkgWdkfVrbDZwmpQerz01c2f4+/pXk+pQwmN/jpPK60rFI25vlW0c15i9AlrWpl
         zhLdTy6/wOns8tyEa6NK/FguTkoJdXLZyFiYCxzvYkadTHF+1QUoHLJpZsmUW51Ze4NL
         GaaNNf+mLLzYeKvunXFYTTwVvnRGl0BZ6dnWS2K/JnbeHcQtqUtBP4g+7aWaoxTjteZ5
         QjzpcwNqbor5jPtf4T5r8t2ibnyNhMx3ODNcTLzmhaqyCnUVDSrUzFgIs1qh7SRp3+FA
         uc9E9fgu9KFeLf2rIDyrJCzuLIliADK4Vmm9XkPCu8ZU4kbheRQVKi5q90SC05KZUkyr
         2CYQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=b8R/hiLZB8XQ4qRolq+vW2rIRUwrTLw1k95xrO3i3v8=;
        b=gxRf4zZLXcAdFQtpX0gfPzM+pXMoTfAEMwsCo8o18NyMl2gPRnsgfcLXjmdwfQ6wiX
         aFBTmXherg9DAoocAcuNrnup9EGoiCQZjPzNqWVXE+rFeFNE361wYWV67r28WhEibGv4
         PSXmcbTAw9geo59O0KBCRjtpaKgol82fNU1YLMHRynZZWWb9BYVPT6SVjZF7K9GBE7rg
         coxqzjUBhpPKqpAjebm7Bl+nr9YhED/pdJMBTL/Ts2oI+2/krfyf7TvNyMA5I4It2qvD
         FdPTTGLA6ZAlCbeJEkAvtLYwDnHPTJJOBnxErLcQz5nXBRynAnJLGklhcSlbOIZia++h
         Wkiw==
X-Gm-Message-State: AOAM531jtScJI5+vDwSRQ3wJmKFFzAzzTDAKdCFCNdyKM/ikWqTdkh5X
        IJe0h0IqGierWAm0vttMYsBFzXZU1oY80g==
X-Google-Smtp-Source: ABdhPJx3lEmtB5Fdc9+Ne6k6mSN4XG/lpCIdTjfRw1dItyTK+uJPnv9Fzry+CbAV052ZYrl7pWdIOw==
X-Received: by 2002:a63:ea01:: with SMTP id c1mr1165424pgi.375.1606936320084;
        Wed, 02 Dec 2020 11:12:00 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id 22sm360204pjb.40.2020.12.02.11.11.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 02 Dec 2020 11:11:59 -0800 (PST)
Message-ID: <5fc7e6ff.1c69fb81.97dfb.1112@mx.google.com>
Date:   Wed, 02 Dec 2020 11:11:59 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: queue/4.14
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v4.14.210-7-gc5d4ef27476b9
X-Kernelci-Report-Type: test
Subject: stable-rc/queue/4.14 baseline: 154 runs,
 7 regressions (v4.14.210-7-gc5d4ef27476b9)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.14 baseline: 154 runs, 7 regressions (v4.14.210-7-gc5d4ef=
27476b9)

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

sun8i-h3-orangepi-pc | arm  | lab-clabbe      | gcc-8    | sunxi_defconfig =
    | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.14/ker=
nel/v4.14.210-7-gc5d4ef27476b9/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.14
  Describe: v4.14.210-7-gc5d4ef27476b9
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      c5d4ef27476b92a22f4704cef2d7b038f02d7736 =



Test Regressions
---------------- =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
panda                | arm  | lab-collabora   | gcc-8    | omap2plus_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/5fc7b414d39bd19dcfc94cfb

  Results:     3 PASS, 1 FAIL, 1 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.210=
-7-gc5d4ef27476b9/arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-pand=
a.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.210=
-7-gc5d4ef27476b9/arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-pand=
a.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/5fc7b414d39bd19=
dcfc94d00
        failing since 3 days (last pass: v4.14.209-11-ge2326a479d95, first =
fail: v4.14.209-14-gefcf305b1a7e8)
        2 lines =

 =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-baylibre    | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/5fc7b18862d6e7dd32c94cc8

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.210=
-7-gc5d4ef27476b9/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_=
arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.210=
-7-gc5d4ef27476b9/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_=
arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fc7b18862d6e7dd32c94=
cc9
        failing since 18 days (last pass: v4.14.206-21-g787a7a3ca16c, first=
 fail: v4.14.206-22-ga949bf40fb01) =

 =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-broonie     | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/5fc7ba0e7eb61e3d84c94cde

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.210=
-7-gc5d4ef27476b9/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_a=
rm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.210=
-7-gc5d4ef27476b9/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_a=
rm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fc7ba0e7eb61e3d84c94=
cdf
        failing since 18 days (last pass: v4.14.206-21-g787a7a3ca16c, first=
 fail: v4.14.206-22-ga949bf40fb01) =

 =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-cip         | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/5fc7b19b419831f723c94cce

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.210=
-7-gc5d4ef27476b9/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-v=
ersatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.210=
-7-gc5d4ef27476b9/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-v=
ersatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fc7b19b419831f723c94=
ccf
        failing since 18 days (last pass: v4.14.206-21-g787a7a3ca16c, first=
 fail: v4.14.206-22-ga949bf40fb01) =

 =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-collabora   | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/5fc7b2382e22dcfda5c94cc2

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.210=
-7-gc5d4ef27476b9/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu=
_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.210=
-7-gc5d4ef27476b9/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu=
_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fc7b2382e22dcfda5c94=
cc3
        failing since 18 days (last pass: v4.14.206-21-g787a7a3ca16c, first=
 fail: v4.14.206-22-ga949bf40fb01) =

 =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-linaro-lkft | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/5fc7b70e3f3b54a73fc94cd8

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.210=
-7-gc5d4ef27476b9/arm/versatile_defconfig/gcc-8/lab-linaro-lkft/baseline-qe=
mu_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.210=
-7-gc5d4ef27476b9/arm/versatile_defconfig/gcc-8/lab-linaro-lkft/baseline-qe=
mu_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fc7b70e3f3b54a73fc94=
cd9
        failing since 18 days (last pass: v4.14.206-21-g787a7a3ca16c, first=
 fail: v4.14.206-22-ga949bf40fb01) =

 =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
sun8i-h3-orangepi-pc | arm  | lab-clabbe      | gcc-8    | sunxi_defconfig =
    | 1          =


  Details:     https://kernelci.org/test/plan/id/5fc7b201b177a2ffecc94cd9

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: sunxi_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.210=
-7-gc5d4ef27476b9/arm/sunxi_defconfig/gcc-8/lab-clabbe/baseline-sun8i-h3-or=
angepi-pc.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.210=
-7-gc5d4ef27476b9/arm/sunxi_defconfig/gcc-8/lab-clabbe/baseline-sun8i-h3-or=
angepi-pc.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fc7b201b177a2ffecc94=
cda
        new failure (last pass: v4.14.209-49-gc89b5763ada4) =

 =20
