Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 067422FE45D
	for <lists+stable@lfdr.de>; Thu, 21 Jan 2021 08:51:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727874AbhAUHt5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 21 Jan 2021 02:49:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50638 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727857AbhAUHtV (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 21 Jan 2021 02:49:21 -0500
Received: from mail-pg1-x52a.google.com (mail-pg1-x52a.google.com [IPv6:2607:f8b0:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6B770C0613C1
        for <stable@vger.kernel.org>; Wed, 20 Jan 2021 23:48:41 -0800 (PST)
Received: by mail-pg1-x52a.google.com with SMTP id i5so862530pgo.1
        for <stable@vger.kernel.org>; Wed, 20 Jan 2021 23:48:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=iCEX8mkYZLFPZ7icv067rVRr7xJ3D7b86IlRGFAZJlc=;
        b=sEhlTLMHNPBxr/OUzr2fSDwvxf16gEE3Kk2eeyk24Y6AA46ZXEm5D023+jEl4gt+ce
         8Fgww+Q7WmKqOPduOgvWsU0q0cthQuJFdJXl3Kzjaac/aaD/9DG7G0dljkHsbz4R1vie
         msoMWK1VYynL79Tp0qxBVT4upTyeyE3ROnCcR4GJ+7lwMshbKE+F2wYSSpW9frk6kGW0
         G3iKkP/P3OHM8UW3wOI9tPIy8YGEHK/y29M5+9NzHYO2h1vgRHu8+hy/uLJLxTziDCI+
         i6/kEm44QyW7onzxx7ncGJ4v09LiGNU+fF9npdkCFBIBDo1oxrLIgLbB+Hz3Q9d6Xl8J
         RTvw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=iCEX8mkYZLFPZ7icv067rVRr7xJ3D7b86IlRGFAZJlc=;
        b=PSYDYLWJR0IvVoX21XZTMYwdcuu50ctWwT54dvH/jpWj4nUtMnReHiv+JxEPb4sqxl
         SZpwbCoKFinHlpZb5IMJCr+CatpdHiMtojOpr7DIf0zGX2cmMJ/h43lZx9TV0O/+FZZz
         yLTajq3t6Mr3+K8G9ATbbH5H5zr3ZuL6jYH2jLJt5OPXC4zFFKB/LcKSYy1YjubNxIAI
         ImLCTSxHpXH64sBXQJ1tTDWTF1BSp1IXNsNA90rm+0Iz+9gJgOxYTcEnv7mTxnaOIwJE
         3cESRDn+HVCMmHDwq6rdkvewub/PUuzABvrP+vv0tIHA0N3gRoIkO+Vx+F6909n+hgyH
         1H/w==
X-Gm-Message-State: AOAM531TacPWb2QKaIuFlZrktPmYK0uZtzHUWtZBvSXWRMsS/FOtCqAj
        LSVriZtWXpHZ7uzBnesMg4KvHdO8k8krsJe4
X-Google-Smtp-Source: ABdhPJxaC4vslXQ6vbFUSdLNi2hz9GMkc9bMflBe9oAFixs+MZXl3MZTuNXa/qxK/QHiwuOviKpuPQ==
X-Received: by 2002:a63:e50:: with SMTP id 16mr13175439pgo.74.1611215320562;
        Wed, 20 Jan 2021 23:48:40 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id k128sm4643171pfd.137.2021.01.20.23.48.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 20 Jan 2021 23:48:39 -0800 (PST)
Message-ID: <600931d7.1c69fb81.b1a41.bd39@mx.google.com>
Date:   Wed, 20 Jan 2021 23:48:39 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: queue/4.14
X-Kernelci-Tree: stable-rc
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v4.14.216-34-g7e223c1966702
Subject: stable-rc/queue/4.14 baseline: 137 runs,
 10 regressions (v4.14.216-34-g7e223c1966702)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.14 baseline: 137 runs, 10 regressions (v4.14.216-34-g7e22=
3c1966702)

Regressions Summary
-------------------

platform             | arch   | lab             | compiler | defconfig     =
      | regressions
---------------------+--------+-----------------+----------+---------------=
------+------------
fsl-ls2088a-rdb      | arm64  | lab-nxp         | gcc-8    | defconfig     =
      | 1          =

meson-gxm-q200       | arm64  | lab-baylibre    | gcc-8    | defconfig     =
      | 1          =

panda                | arm    | lab-collabora   | gcc-8    | omap2plus_defc=
onfig | 1          =

qemu_arm-versatilepb | arm    | lab-baylibre    | gcc-8    | versatile_defc=
onfig | 1          =

qemu_arm-versatilepb | arm    | lab-broonie     | gcc-8    | versatile_defc=
onfig | 1          =

qemu_arm-versatilepb | arm    | lab-cip         | gcc-8    | versatile_defc=
onfig | 1          =

qemu_arm-versatilepb | arm    | lab-collabora   | gcc-8    | versatile_defc=
onfig | 1          =

qemu_arm-versatilepb | arm    | lab-linaro-lkft | gcc-8    | versatile_defc=
onfig | 1          =

qemu_x86_64          | x86_64 | lab-baylibre    | gcc-8    | x86_64_defconf=
ig    | 1          =

qemu_x86_64-uefi     | x86_64 | lab-baylibre    | gcc-8    | x86_64_defconf=
ig    | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.14/ker=
nel/v4.14.216-34-g7e223c1966702/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.14
  Describe: v4.14.216-34-g7e223c1966702
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      7e223c19667029a94b161d4a4257cd559f9bc61f =



Test Regressions
---------------- =



platform             | arch   | lab             | compiler | defconfig     =
      | regressions
---------------------+--------+-----------------+----------+---------------=
------+------------
fsl-ls2088a-rdb      | arm64  | lab-nxp         | gcc-8    | defconfig     =
      | 1          =


  Details:     https://kernelci.org/test/plan/id/6008ffcbcc85c3555bbb5d2e

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.216=
-34-g7e223c1966702/arm64/defconfig/gcc-8/lab-nxp/baseline-fsl-ls2088a-rdb.t=
xt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.216=
-34-g7e223c1966702/arm64/defconfig/gcc-8/lab-nxp/baseline-fsl-ls2088a-rdb.h=
tml
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6008ffcbcc85c3555bbb5=
d2f
        new failure (last pass: v4.14.216-34-ge1afddaa7824) =

 =



platform             | arch   | lab             | compiler | defconfig     =
      | regressions
---------------------+--------+-----------------+----------+---------------=
------+------------
meson-gxm-q200       | arm64  | lab-baylibre    | gcc-8    | defconfig     =
      | 1          =


  Details:     https://kernelci.org/test/plan/id/600923bc17e169d29bbb5d1e

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.216=
-34-g7e223c1966702/arm64/defconfig/gcc-8/lab-baylibre/baseline-meson-gxm-q2=
00.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.216=
-34-g7e223c1966702/arm64/defconfig/gcc-8/lab-baylibre/baseline-meson-gxm-q2=
00.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/600923bc17e169d29bbb5=
d1f
        failing since 43 days (last pass: v4.14.210-20-gc32b9f7cbda7, first=
 fail: v4.14.210-20-g5ea7913395d3) =

 =



platform             | arch   | lab             | compiler | defconfig     =
      | regressions
---------------------+--------+-----------------+----------+---------------=
------+------------
panda                | arm    | lab-collabora   | gcc-8    | omap2plus_defc=
onfig | 1          =


  Details:     https://kernelci.org/test/plan/id/60090105541d786cbcbb5d28

  Results:     3 PASS, 1 FAIL, 1 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.216=
-34-g7e223c1966702/arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-pan=
da.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.216=
-34-g7e223c1966702/arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-pan=
da.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/60090105541d786=
cbcbb5d2d
        failing since 1 day (last pass: v4.14.216-19-g6b67a3fc25644, first =
fail: v4.14.216-33-gafaeeec3a32b)
        2 lines

    2021-01-21 04:20:17.780000+00:00  kern  :emerg : BUG: spinlock bad magi=
c on CPU#0, udevd/101
    2021-01-21 04:20:17.788000+00:00  kern  :emerg :  lock: emif_lock+0x0/0=
xffffed34 [emif], .magic: 00000000, .owner: <none>/-1, .owner_cpu: 0
    2021-01-21 04:20:17.807000+00:00  [   20.308624] smsc95xx 3-1.1:1.0 eth=
0: register 'smsc95xx' at usb-4a064c00.ehci-1.1, smsc95xx USB 2.0 Ethernet,=
 da:c3:ca:77:de:c9
    2021-01-21 04:20:17.814000+00:00  [   20.322143] usbcore: registered ne=
w interface driver smsc95xx   =

 =



platform             | arch   | lab             | compiler | defconfig     =
      | regressions
---------------------+--------+-----------------+----------+---------------=
------+------------
qemu_arm-versatilepb | arm    | lab-baylibre    | gcc-8    | versatile_defc=
onfig | 1          =


  Details:     https://kernelci.org/test/plan/id/6008fcb1c65fd2447ebb5d1c

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.216=
-34-g7e223c1966702/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu=
_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.216=
-34-g7e223c1966702/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu=
_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6008fcb1c65fd2447ebb5=
d1d
        failing since 68 days (last pass: v4.14.206-21-g787a7a3ca16c, first=
 fail: v4.14.206-22-ga949bf40fb01) =

 =



platform             | arch   | lab             | compiler | defconfig     =
      | regressions
---------------------+--------+-----------------+----------+---------------=
------+------------
qemu_arm-versatilepb | arm    | lab-broonie     | gcc-8    | versatile_defc=
onfig | 1          =


  Details:     https://kernelci.org/test/plan/id/6008fcc1796eae20dcbb5d1c

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.216=
-34-g7e223c1966702/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_=
arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.216=
-34-g7e223c1966702/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_=
arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6008fcc1796eae20dcbb5=
d1d
        failing since 68 days (last pass: v4.14.206-21-g787a7a3ca16c, first=
 fail: v4.14.206-22-ga949bf40fb01) =

 =



platform             | arch   | lab             | compiler | defconfig     =
      | regressions
---------------------+--------+-----------------+----------+---------------=
------+------------
qemu_arm-versatilepb | arm    | lab-cip         | gcc-8    | versatile_defc=
onfig | 1          =


  Details:     https://kernelci.org/test/plan/id/6008fcb3b7158a3413bb5d2c

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.216=
-34-g7e223c1966702/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-=
versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.216=
-34-g7e223c1966702/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-=
versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6008fcb3b7158a3413bb5=
d2d
        failing since 68 days (last pass: v4.14.206-21-g787a7a3ca16c, first=
 fail: v4.14.206-22-ga949bf40fb01) =

 =



platform             | arch   | lab             | compiler | defconfig     =
      | regressions
---------------------+--------+-----------------+----------+---------------=
------+------------
qemu_arm-versatilepb | arm    | lab-collabora   | gcc-8    | versatile_defc=
onfig | 1          =


  Details:     https://kernelci.org/test/plan/id/6008fc778357d9100fbb5d3c

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.216=
-34-g7e223c1966702/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qem=
u_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.216=
-34-g7e223c1966702/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qem=
u_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6008fc778357d9100fbb5=
d3d
        failing since 68 days (last pass: v4.14.206-21-g787a7a3ca16c, first=
 fail: v4.14.206-22-ga949bf40fb01) =

 =



platform             | arch   | lab             | compiler | defconfig     =
      | regressions
---------------------+--------+-----------------+----------+---------------=
------+------------
qemu_arm-versatilepb | arm    | lab-linaro-lkft | gcc-8    | versatile_defc=
onfig | 1          =


  Details:     https://kernelci.org/test/plan/id/6008fc7421f098249ebb5d1a

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.216=
-34-g7e223c1966702/arm/versatile_defconfig/gcc-8/lab-linaro-lkft/baseline-q=
emu_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.216=
-34-g7e223c1966702/arm/versatile_defconfig/gcc-8/lab-linaro-lkft/baseline-q=
emu_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6008fc7421f098249ebb5=
d1b
        failing since 68 days (last pass: v4.14.206-21-g787a7a3ca16c, first=
 fail: v4.14.206-22-ga949bf40fb01) =

 =



platform             | arch   | lab             | compiler | defconfig     =
      | regressions
---------------------+--------+-----------------+----------+---------------=
------+------------
qemu_x86_64          | x86_64 | lab-baylibre    | gcc-8    | x86_64_defconf=
ig    | 1          =


  Details:     https://kernelci.org/test/plan/id/6008fd875fff2272a2bb5d2b

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig
  Compiler:    gcc-8 (gcc (Debian 8.3.0-6) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.216=
-34-g7e223c1966702/x86_64/x86_64_defconfig/gcc-8/lab-baylibre/baseline-qemu=
_x86_64.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.216=
-34-g7e223c1966702/x86_64/x86_64_defconfig/gcc-8/lab-baylibre/baseline-qemu=
_x86_64.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/x86/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6008fd875fff2272a2bb5=
d2c
        new failure (last pass: v4.14.216-34-ge1afddaa7824) =

 =



platform             | arch   | lab             | compiler | defconfig     =
      | regressions
---------------------+--------+-----------------+----------+---------------=
------+------------
qemu_x86_64-uefi     | x86_64 | lab-baylibre    | gcc-8    | x86_64_defconf=
ig    | 1          =


  Details:     https://kernelci.org/test/plan/id/6008fd88c04de92501bb5d29

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig
  Compiler:    gcc-8 (gcc (Debian 8.3.0-6) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.216=
-34-g7e223c1966702/x86_64/x86_64_defconfig/gcc-8/lab-baylibre/baseline-qemu=
_x86_64-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.216=
-34-g7e223c1966702/x86_64/x86_64_defconfig/gcc-8/lab-baylibre/baseline-qemu=
_x86_64-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/x86/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6008fd88c04de92501bb5=
d2a
        new failure (last pass: v4.14.216-34-ge1afddaa7824) =

 =20
