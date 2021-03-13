Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C1280339CEE
	for <lists+stable@lfdr.de>; Sat, 13 Mar 2021 09:32:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230114AbhCMIbj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 13 Mar 2021 03:31:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37844 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229968AbhCMIbL (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 13 Mar 2021 03:31:11 -0500
Received: from mail-pg1-x52f.google.com (mail-pg1-x52f.google.com [IPv6:2607:f8b0:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E8D60C061574
        for <stable@vger.kernel.org>; Sat, 13 Mar 2021 00:31:10 -0800 (PST)
Received: by mail-pg1-x52f.google.com with SMTP id p21so17377712pgl.12
        for <stable@vger.kernel.org>; Sat, 13 Mar 2021 00:31:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=SehD8jFg8k1ACUG39yNvzGiamoGVrNSG6tWWK/HPyls=;
        b=vI+JfAu5b4t18GtjHt6aCri8KUHQDLYZ3dO053sXrInvovafozLWiHKKSbYUo7s0h9
         IZAaHwMatkB4VLM2/rsHmSeY/oOFWpfa3R7w0Y1xsgLdvbvQS5mTYl9MH7bKwwyKxeJd
         KSTWtKfX4VhuvkQV3Xwx/aMT2vdOFT5hei/jMSqb3Jj4eivUJzbWWsQyifEObEE4L2sC
         X32gSknvuC9HE4agGiTMuek0T4sG/HFvmrTg/UbHQG5zobHRlmf72Hc+UgOyPthYR+Yu
         cGoFgZnUWYJvYlYvnRlsPkgcPl6ROl7o9hyyF1Mz4N0wzs/ICpIW7wauHJKZtKcEpLlE
         5Y5w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=SehD8jFg8k1ACUG39yNvzGiamoGVrNSG6tWWK/HPyls=;
        b=dRHukIih1dj5HHFI2MzZijs6aytYewTkN/ftzl6zXI5vmwxFkf1MhPggUxOoa5n1QC
         2G1bw521HEo39R/GrvC91jQFsQIKmzYwIbr0/FrXmd6saGsmEQ11K41HC8OwCh7vhM1D
         vUzNkxbPv5rah7801UVa4rz47rHQCUDx8rYlLjQtf+eaWyEdbW2U6qtNPuql93nsT4vJ
         hbdPjRjzjsMcfMBZaajFgi/C76mTE03oyvMG5FLo5FN3ijPmZyBAbTgTAznap8bZT9Bd
         v91e6l6PWDPqyndoLXXdwyVVvJ+9iey/l2i3rO1MFzNAcM80tbZHcVYpBvM7Q7jeCxe+
         tyqQ==
X-Gm-Message-State: AOAM531aBJ0E35JaewEL2gBVpC3Eq3B/kcwyBbcZ2Jk2q/FA9JdCErzR
        7eFPY1LJMGSCZ+qqBIZQdKRZvaQOgHzlBg==
X-Google-Smtp-Source: ABdhPJzpA9HDOYsMLq47sA8/KJtT5NGrH1cQagIoCycOv66Cd5UK4qLvTlohtAeYDBLkeQvDk3Kkpw==
X-Received: by 2002:a62:5c84:0:b029:1f2:a5f0:d12a with SMTP id q126-20020a625c840000b02901f2a5f0d12amr2049221pfb.36.1615624270122;
        Sat, 13 Mar 2021 00:31:10 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id o184sm2970728pfb.128.2021.03.13.00.31.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 13 Mar 2021 00:31:09 -0800 (PST)
Message-ID: <604c784d.1c69fb81.8544.74da@mx.google.com>
Date:   Sat, 13 Mar 2021 00:31:09 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.9.261-24-gc9deaed4c3062
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/4.9
Subject: stable-rc/queue/4.9 baseline: 118 runs,
 6 regressions (v4.9.261-24-gc9deaed4c3062)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.9 baseline: 118 runs, 6 regressions (v4.9.261-24-gc9deaed=
4c3062)

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


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.9/kern=
el/v4.9.261-24-gc9deaed4c3062/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.9
  Describe: v4.9.261-24-gc9deaed4c3062
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      c9deaed4c3062ce9f7300b4a22f666556b28d251 =



Test Regressions
---------------- =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
panda                | arm  | lab-collabora   | gcc-8    | omap2plus_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/604c46b5000b00a9fcaddcb1

  Results:     3 PASS, 1 FAIL, 1 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.261-2=
4-gc9deaed4c3062/arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-panda=
.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.261-2=
4-gc9deaed4c3062/arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-panda=
.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/604c46b5000b00a=
9fcaddcb6
        new failure (last pass: v4.9.261-17-g0640bd71e2fe1)
        2 lines

    2021-03-13 04:59:29.742000+00:00  kern  :emerg : BUG: spinlock bad magi=
c on CPU#0, udevd/122
    2021-03-13 04:59:29.763000+00:00  kern  :emerg :  lock: emif_lock+0x0/0=
xfffff24c [emif], .magic: dead4ead, .owner: <none>/-1, .owner_c[   20.38708=
4] smsc95xx 3-1.1:1.0 eth0: register 'smsc95xx' at usb-4a064c00.ehci-1.1, s=
msc95xx USB 2.0 Ethernet, e2:44:45:4c:85:68
    2021-03-13 04:59:29.764000+00:00  pu: -1
    2021-03-13 04:59:29.765000+00:00  + set +x
    2021-03-13 04:59:29.773000+00:00  [   20.396362] <LAVA_SIGNAL_TESTCASE =
TEST_CASE_ID=3Demerg RESULT=3Dfail UNITS=3Dlines MEASUREMENT=3D2>   =

 =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-baylibre    | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/604c4448dd4adcb85baddccc

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.261-2=
4-gc9deaed4c3062/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_a=
rm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.261-2=
4-gc9deaed4c3062/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_a=
rm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/604c4448dd4adcb85badd=
ccd
        failing since 119 days (last pass: v4.9.243-16-gd8d67e375b0a, first=
 fail: v4.9.243-25-ga01fe8e99a22) =

 =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-broonie     | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/604c444101ba0aad13addce8

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.261-2=
4-gc9deaed4c3062/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_ar=
m-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.261-2=
4-gc9deaed4c3062/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_ar=
m-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/604c444101ba0aad13add=
ce9
        failing since 119 days (last pass: v4.9.243-16-gd8d67e375b0a, first=
 fail: v4.9.243-25-ga01fe8e99a22) =

 =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-cip         | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/604c443901ba0aad13addcd2

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.261-2=
4-gc9deaed4c3062/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-ve=
rsatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.261-2=
4-gc9deaed4c3062/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-ve=
rsatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/604c443901ba0aad13add=
cd3
        failing since 119 days (last pass: v4.9.243-16-gd8d67e375b0a, first=
 fail: v4.9.243-25-ga01fe8e99a22) =

 =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-collabora   | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/604c43e125bda7a2f9addcb5

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.261-2=
4-gc9deaed4c3062/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu_=
arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.261-2=
4-gc9deaed4c3062/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu_=
arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/604c43e125bda7a2f9add=
cb6
        failing since 119 days (last pass: v4.9.243-16-gd8d67e375b0a, first=
 fail: v4.9.243-25-ga01fe8e99a22) =

 =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-linaro-lkft | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/604c43ea043ccdaf2daddcbb

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.261-2=
4-gc9deaed4c3062/arm/versatile_defconfig/gcc-8/lab-linaro-lkft/baseline-qem=
u_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.261-2=
4-gc9deaed4c3062/arm/versatile_defconfig/gcc-8/lab-linaro-lkft/baseline-qem=
u_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/604c43ea043ccdaf2dadd=
cbc
        failing since 119 days (last pass: v4.9.243-16-gd8d67e375b0a, first=
 fail: v4.9.243-25-ga01fe8e99a22) =

 =20
