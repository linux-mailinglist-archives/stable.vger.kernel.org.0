Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 88E87372F94
	for <lists+stable@lfdr.de>; Tue,  4 May 2021 20:12:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232065AbhEDSNF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 4 May 2021 14:13:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51938 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231635AbhEDSNE (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 4 May 2021 14:13:04 -0400
Received: from mail-pf1-x42f.google.com (mail-pf1-x42f.google.com [IPv6:2607:f8b0:4864:20::42f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B3CF2C061574
        for <stable@vger.kernel.org>; Tue,  4 May 2021 11:12:09 -0700 (PDT)
Received: by mail-pf1-x42f.google.com with SMTP id q2so8648568pfh.13
        for <stable@vger.kernel.org>; Tue, 04 May 2021 11:12:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=0GcPw8ZoRzHBNdcJ2RYTpyyem06ZdrcS137qPp8aBik=;
        b=QsjKR/q/QRHvVbzcsVrCXd1FEb/pqM07lO9qfpvcuINFpOX2G4OyBdRAtvr3d6sfXC
         /ussg7tIeNqUJRKX2ZqiCdOz5Z0TMHEGtd4pplXfZlCrttbB/Z++w5aj7B5v17ref5k0
         96zHyNHSYwJvVVzANzToybg+tiNvwysm+wE4pK/MdNLfK47roHOE2Xo+mmFo79RdjhX4
         UyjptKQQH+yK2uWWAlqUQpS47MIk2XP0fl8bk0XaXiGIsiF7YoHn23hB3t+INeoAzxoR
         E7ZMJZl63G08ylWO/TTT3cTD1Fe8KabLwjDuhd/i7WIKG86fDGcXFLjLjYtxlqfPxQHH
         s/Xg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=0GcPw8ZoRzHBNdcJ2RYTpyyem06ZdrcS137qPp8aBik=;
        b=ENlXzkXnpK33ibc+ICfP6Awu301PW6QyOtlJ7PxPfMGe23xaYiHRUuRLeLJ7NzDXLn
         UP7bNQwohln2xRTojMenh8+gjnVuIacgJQynLGE9pRIN52sUIpMEySInfirdrZCS4aHG
         7ZqFzFWObfMsm5g0fROKUuNDXb+iNaDyYI/B1SuB5g72mIAxfIN+vo+u73ZBXWUnSOgT
         e7dg6YD0SGqNXn1T8y/ZOrZcTgH0WhaAmeu/fjnq+kafGyRPP8rLFWFsK79bJACj4TiO
         vXxRievyKt/0fQsLtuRzP4yEEl6rHVdAtS0/fNu1Wy/+m9TT6mxZJox+khSAuTez1Klk
         STKA==
X-Gm-Message-State: AOAM532yN+Vm1EvfZVfIam1zTB+Inef4HvKuwn4iEvr2kaaI2IxTvGla
        wN8MAioaJxgciiEvEf7YHa9fOVasa5ywI/hx
X-Google-Smtp-Source: ABdhPJy41A0ZmOyluEhwmEHO2XUL7dhNmQevi2/JJC7HxHVKMoOSIqrqTTTL3I578CN/OJ9+NHO5XQ==
X-Received: by 2002:a17:90b:347:: with SMTP id fh7mr6572418pjb.183.1620151929024;
        Tue, 04 May 2021 11:12:09 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id p22sm4893426pjg.39.2021.05.04.11.12.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 04 May 2021 11:12:08 -0700 (PDT)
Message-ID: <60918e78.1c69fb81.6271c.a13a@mx.google.com>
Date:   Tue, 04 May 2021 11:12:08 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.19.189-7-gb2a67041e4ea9
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/4.19
Subject: stable-rc/queue/4.19 baseline: 98 runs,
 5 regressions (v4.19.189-7-gb2a67041e4ea9)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.19 baseline: 98 runs, 5 regressions (v4.19.189-7-gb2a6704=
1e4ea9)

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

qemu_arm-versatilepb | arm  | lab-linaro-lkft | gcc-8    | versatile_defcon=
fig | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.19/ker=
nel/v4.19.189-7-gb2a67041e4ea9/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.19
  Describe: v4.19.189-7-gb2a67041e4ea9
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      b2a67041e4ea97acc1252ea60a729bbbb280c510 =



Test Regressions
---------------- =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
panda                | arm  | lab-collabora   | gcc-8    | omap2plus_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/60916474ca68a02aeb843f1e

  Results:     4 PASS, 1 FAIL, 0 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.189=
-7-gb2a67041e4ea9/arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-pand=
a.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.189=
-7-gb2a67041e4ea9/arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-pand=
a.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/60916474ca68a02=
aeb843f23
        failing since 0 day (last pass: v4.19.189-1-gbab36f93665a6, first f=
ail: v4.19.189-4-g87f39fb5050ad)
        2 lines

    2021-05-04 15:12:47.805000+00:00  kern  :emerg : BUG: spinlock bad magi=
c on CPU#0, udevd/109
    2021-05-04 15:12:47.814000+00:00  kern  :emerg :  lock: emif_lock+0x0/0=
xffffed34 [emif], .magic: dead4ead, .owner: <none>/-1, .owner_cpu: -1
    2021-05-04 15:12:47.830000+00:00  <8>[   22.844940] <LAVA_SIGNAL_TESTCA=
SE TEST_CASE_ID=3Demerg RESULT=3Dfail UNITS=3Dlines MEASUREMENT=3D2>   =

 =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-baylibre    | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/609153e6f40d912e63843f49

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.189=
-7-gb2a67041e4ea9/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_=
arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.189=
-7-gb2a67041e4ea9/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_=
arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/609153e6f40d912e63843=
f4a
        failing since 171 days (last pass: v4.19.157-26-gd59f3161b3a0, firs=
t fail: v4.19.157-27-g5543cc2c41d55) =

 =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-broonie     | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/609153ddcc4b52bfec843f1b

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.189=
-7-gb2a67041e4ea9/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_a=
rm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.189=
-7-gb2a67041e4ea9/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_a=
rm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/609153ddcc4b52bfec843=
f1c
        failing since 171 days (last pass: v4.19.157-26-gd59f3161b3a0, firs=
t fail: v4.19.157-27-g5543cc2c41d55) =

 =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-cip         | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/6091540fa8f48dc6e4843f20

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.189=
-7-gb2a67041e4ea9/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-v=
ersatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.189=
-7-gb2a67041e4ea9/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-v=
ersatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6091540fa8f48dc6e4843=
f21
        failing since 171 days (last pass: v4.19.157-26-gd59f3161b3a0, firs=
t fail: v4.19.157-27-g5543cc2c41d55) =

 =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-linaro-lkft | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/609153795e5bab6d47843f23

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.189=
-7-gb2a67041e4ea9/arm/versatile_defconfig/gcc-8/lab-linaro-lkft/baseline-qe=
mu_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.189=
-7-gb2a67041e4ea9/arm/versatile_defconfig/gcc-8/lab-linaro-lkft/baseline-qe=
mu_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/609153795e5bab6d47843=
f24
        failing since 171 days (last pass: v4.19.157-26-gd59f3161b3a0, firs=
t fail: v4.19.157-27-g5543cc2c41d55) =

 =20
