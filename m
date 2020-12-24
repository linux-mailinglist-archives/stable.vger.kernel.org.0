Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1D5762E2904
	for <lists+stable@lfdr.de>; Thu, 24 Dec 2020 23:17:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728941AbgLXWQm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 24 Dec 2020 17:16:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44398 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729094AbgLXWQm (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 24 Dec 2020 17:16:42 -0500
Received: from mail-pf1-x42d.google.com (mail-pf1-x42d.google.com [IPv6:2607:f8b0:4864:20::42d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 23ECFC061573
        for <stable@vger.kernel.org>; Thu, 24 Dec 2020 14:16:02 -0800 (PST)
Received: by mail-pf1-x42d.google.com with SMTP id t8so1781041pfg.8
        for <stable@vger.kernel.org>; Thu, 24 Dec 2020 14:16:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=ShpQ3EJG4BfYj89ySk+uqMjHPN1jHVZpR6xFsabmcWQ=;
        b=msiq20rPoeL0Hn1DzLr7dIgFi6ObLhrbuJntRoImjX+J00ApHhQIeC/hyjJOCBSEVH
         K1ysZFVIUNXdIHxr7h6rNHl2eTavj1BIY9n10VuCwm2AYACeBW0q8ET91uRM5DfP9/31
         7anHoepdR/tyPuaEcICbirIqGOek1byx/ApGfi//iK963C9UGqK6Bso6XbapWGK9nb2S
         vLwfn/JnZCEyAcP2WW5CQKuL6IOPQQU2yUgWnI+1+uXTszY7cSpxKl/yQFanKgYESZpq
         VXYsoDTiIKn+/bdaG/dBpMVvdbG2VIReGV+wnmI5faLmA96T5DyjeYTmkPe3jlkhI9lg
         T6/Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=ShpQ3EJG4BfYj89ySk+uqMjHPN1jHVZpR6xFsabmcWQ=;
        b=jzZ/tfeO/8kcsyIQetrIJIV+L1D6bPHMuE2fXyGrrgP8gyBrPLkCXF+bGb4f5uU2zj
         m+2A9vqD3AuxXIejt6a1Ms6icCiexUeH5S+qPkvKR1LSaia64yxFSNGHvaAvXDXBQrCH
         zuJpDnmznNo0qOth/kMBOFXMLC8foaaQIBd2sP+NAG9xaVU4YV559PY49z4wtyfFsf2J
         2+anPRbkyKilDp8YRTG8bYQ54sjda7rkExWxdXXvQwzgGC36TqWDNSHzdpPqC+x8Ajh7
         j/5wPuI2iWzuLJkaTpX+WNHCLd7if3cbQ9tIxJPwjYSp76p6kYiug4Z5hRjx3+oW2IJy
         4boQ==
X-Gm-Message-State: AOAM532H18oQ5XaBaIR24pUX22txxiFYPLnOWnbdlXPq/HHzlOEwo9E/
        LpJDVlNNK/ajGL/ESDlQljvVY8DDF09dDw==
X-Google-Smtp-Source: ABdhPJyNty+9E/RCKj/WSuwhiiSw11eRRaAkPpAbcIDEJAFy5UCCXVDfYImpWTu+NIHMcPvZzVwetw==
X-Received: by 2002:a63:4346:: with SMTP id q67mr7090825pga.223.1608848161143;
        Thu, 24 Dec 2020 14:16:01 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id y16sm19106071pgg.20.2020.12.24.14.16.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 24 Dec 2020 14:16:00 -0800 (PST)
Message-ID: <5fe51320.1c69fb81.5a6ed.40ce@mx.google.com>
Date:   Thu, 24 Dec 2020 14:16:00 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: queue/4.14
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v4.14.212-64-gcedad771847f
X-Kernelci-Report-Type: test
Subject: stable-rc/queue/4.14 baseline: 162 runs,
 8 regressions (v4.14.212-64-gcedad771847f)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.14 baseline: 162 runs, 8 regressions (v4.14.212-64-gcedad=
771847f)

Regressions Summary
-------------------

platform             | arch  | lab             | compiler | defconfig      =
     | regressions
---------------------+-------+-----------------+----------+----------------=
-----+------------
meson-gxm-q200       | arm64 | lab-baylibre    | gcc-8    | defconfig      =
     | 1          =

odroid-xu3           | arm   | lab-collabora   | gcc-8    | multi_v7_defcon=
fig  | 1          =

panda                | arm   | lab-collabora   | gcc-8    | omap2plus_defco=
nfig | 1          =

qemu_arm-versatilepb | arm   | lab-baylibre    | gcc-8    | versatile_defco=
nfig | 1          =

qemu_arm-versatilepb | arm   | lab-broonie     | gcc-8    | versatile_defco=
nfig | 1          =

qemu_arm-versatilepb | arm   | lab-cip         | gcc-8    | versatile_defco=
nfig | 1          =

qemu_arm-versatilepb | arm   | lab-collabora   | gcc-8    | versatile_defco=
nfig | 1          =

qemu_arm-versatilepb | arm   | lab-linaro-lkft | gcc-8    | versatile_defco=
nfig | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.14/ker=
nel/v4.14.212-64-gcedad771847f/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.14
  Describe: v4.14.212-64-gcedad771847f
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      cedad771847fd768f6232c31e7d746b488f882cf =



Test Regressions
---------------- =



platform             | arch  | lab             | compiler | defconfig      =
     | regressions
---------------------+-------+-----------------+----------+----------------=
-----+------------
meson-gxm-q200       | arm64 | lab-baylibre    | gcc-8    | defconfig      =
     | 1          =


  Details:     https://kernelci.org/test/plan/id/5fe4e36e76cd391e16c94cba

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.212=
-64-gcedad771847f/arm64/defconfig/gcc-8/lab-baylibre/baseline-meson-gxm-q20=
0.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.212=
-64-gcedad771847f/arm64/defconfig/gcc-8/lab-baylibre/baseline-meson-gxm-q20=
0.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fe4e36e76cd391e16c94=
cbb
        failing since 16 days (last pass: v4.14.210-20-gc32b9f7cbda7, first=
 fail: v4.14.210-20-g5ea7913395d3) =

 =



platform             | arch  | lab             | compiler | defconfig      =
     | regressions
---------------------+-------+-----------------+----------+----------------=
-----+------------
odroid-xu3           | arm   | lab-collabora   | gcc-8    | multi_v7_defcon=
fig  | 1          =


  Details:     https://kernelci.org/test/plan/id/5fe4fa61900e25a5dbc94cbd

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.212=
-64-gcedad771847f/arm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-odroi=
d-xu3.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.212=
-64-gcedad771847f/arm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-odroi=
d-xu3.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fe4fa61900e25a5dbc94=
cbe
        new failure (last pass: v4.14.212-64-g95f3ecbc0c1f) =

 =



platform             | arch  | lab             | compiler | defconfig      =
     | regressions
---------------------+-------+-----------------+----------+----------------=
-----+------------
panda                | arm   | lab-collabora   | gcc-8    | omap2plus_defco=
nfig | 1          =


  Details:     https://kernelci.org/test/plan/id/5fe4e1c69bceecd61ec94d02

  Results:     3 PASS, 1 FAIL, 1 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.212=
-64-gcedad771847f/arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-pand=
a.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.212=
-64-gcedad771847f/arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-pand=
a.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/5fe4e1c69bceecd=
61ec94d07
        failing since 0 day (last pass: v4.14.212-63-g127b6f13142d, first f=
ail: v4.14.212-64-g95f3ecbc0c1f)
        2 lines

    2020-12-24 18:45:22.692000+00:00  kern  :emerg :  lock: emif_lock+0x0/0=
xffffed34 [emif], .magic: 00000000, .owner: <none>/-1, .owner_cpu: 0   =

 =



platform             | arch  | lab             | compiler | defconfig      =
     | regressions
---------------------+-------+-----------------+----------+----------------=
-----+------------
qemu_arm-versatilepb | arm   | lab-baylibre    | gcc-8    | versatile_defco=
nfig | 1          =


  Details:     https://kernelci.org/test/plan/id/5fe4e0cb2abdf435b5c94cdf

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.212=
-64-gcedad771847f/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_=
arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.212=
-64-gcedad771847f/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_=
arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fe4e0cb2abdf435b5c94=
ce0
        failing since 40 days (last pass: v4.14.206-21-g787a7a3ca16c, first=
 fail: v4.14.206-22-ga949bf40fb01) =

 =



platform             | arch  | lab             | compiler | defconfig      =
     | regressions
---------------------+-------+-----------------+----------+----------------=
-----+------------
qemu_arm-versatilepb | arm   | lab-broonie     | gcc-8    | versatile_defco=
nfig | 1          =


  Details:     https://kernelci.org/test/plan/id/5fe4e0c72abdf435b5c94cda

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.212=
-64-gcedad771847f/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_a=
rm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.212=
-64-gcedad771847f/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_a=
rm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fe4e0c72abdf435b5c94=
cdb
        failing since 40 days (last pass: v4.14.206-21-g787a7a3ca16c, first=
 fail: v4.14.206-22-ga949bf40fb01) =

 =



platform             | arch  | lab             | compiler | defconfig      =
     | regressions
---------------------+-------+-----------------+----------+----------------=
-----+------------
qemu_arm-versatilepb | arm   | lab-cip         | gcc-8    | versatile_defco=
nfig | 1          =


  Details:     https://kernelci.org/test/plan/id/5fe4e0d8558646c514c94cc0

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.212=
-64-gcedad771847f/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-v=
ersatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.212=
-64-gcedad771847f/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-v=
ersatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fe4e0d8558646c514c94=
cc1
        failing since 40 days (last pass: v4.14.206-21-g787a7a3ca16c, first=
 fail: v4.14.206-22-ga949bf40fb01) =

 =



platform             | arch  | lab             | compiler | defconfig      =
     | regressions
---------------------+-------+-----------------+----------+----------------=
-----+------------
qemu_arm-versatilepb | arm   | lab-collabora   | gcc-8    | versatile_defco=
nfig | 1          =


  Details:     https://kernelci.org/test/plan/id/5fe4e0777bad2abc8ec94cce

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.212=
-64-gcedad771847f/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu=
_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.212=
-64-gcedad771847f/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu=
_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fe4e0777bad2abc8ec94=
ccf
        failing since 40 days (last pass: v4.14.206-21-g787a7a3ca16c, first=
 fail: v4.14.206-22-ga949bf40fb01) =

 =



platform             | arch  | lab             | compiler | defconfig      =
     | regressions
---------------------+-------+-----------------+----------+----------------=
-----+------------
qemu_arm-versatilepb | arm   | lab-linaro-lkft | gcc-8    | versatile_defco=
nfig | 1          =


  Details:     https://kernelci.org/test/plan/id/5fe4e0867bad2abc8ec94cd2

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.212=
-64-gcedad771847f/arm/versatile_defconfig/gcc-8/lab-linaro-lkft/baseline-qe=
mu_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.212=
-64-gcedad771847f/arm/versatile_defconfig/gcc-8/lab-linaro-lkft/baseline-qe=
mu_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fe4e0867bad2abc8ec94=
cd3
        failing since 40 days (last pass: v4.14.206-21-g787a7a3ca16c, first=
 fail: v4.14.206-22-ga949bf40fb01) =

 =20
