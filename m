Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C81AA372EEF
	for <lists+stable@lfdr.de>; Tue,  4 May 2021 19:29:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230400AbhEDRam (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 4 May 2021 13:30:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42404 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230379AbhEDRam (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 4 May 2021 13:30:42 -0400
Received: from mail-pf1-x42d.google.com (mail-pf1-x42d.google.com [IPv6:2607:f8b0:4864:20::42d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5332EC061574
        for <stable@vger.kernel.org>; Tue,  4 May 2021 10:29:47 -0700 (PDT)
Received: by mail-pf1-x42d.google.com with SMTP id q2so8420532pfh.13
        for <stable@vger.kernel.org>; Tue, 04 May 2021 10:29:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=Xj4AO2gPjAsNjmszoOdAasNWe1BIiP0Liw1OB14d9eQ=;
        b=bF8kkrwRDfns5yYnV8hsnOVp6rvextibY2eAzf0dgvri5rVdSIE5b/RIjubq4MO2xx
         0VwChenivPRKrgfuJGtHjDIGmWAku4UFWIax1wrVLj7bKIgh9cVFlZq1gzhxF33VzNqJ
         kVRkmZzX/a+jr6nU1oY9y7iIdm0FAK5Gq5hy5qLqCUdqMw+mne9vCIwBoA+QF2FnfPaZ
         2QwqRKcwPnMYW/kuHE0bkiGYSQ7p3bhCtFfrWU1x5hsEsRbLmwXVgg5rKZ889V4I3YwZ
         P986cpr0BeZH2JWDyjYv1+cFjq7+EoppNTyOMvWhq1HILfU5UOr9i30sVld3QoOeNxTb
         SmvQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=Xj4AO2gPjAsNjmszoOdAasNWe1BIiP0Liw1OB14d9eQ=;
        b=VW3/CZY6Ejx3xO14Ea6rRxUXmE4oNnD1gHIpQRTjcnruAua1ijauuD5N3+uDsmjoBc
         CQLBBoXt5rrMzkFP2KrBQmAZcu/24kQp//w1KRFTv92L/pG0+0Ki11N/Sv9ObQD7AH7O
         IFQotguLvf1MXbJGHJ5m8pDzEkizJWPkIOqu3QeespuzMcdfmNOPujAmRjKqq0aDiHWV
         ZnQl28HiyhX0GVu+Jpb8aogykv2vC+xidGR69yOg61Li+fQZD78mo3VGM46q9UuvJInN
         VIPBsGCIrZdq2mKoXlAVuzqOy2CAwt4DnYFv21/20Mfx2DF5YoxEyRELKhVB7Qk8R9dw
         Fg0g==
X-Gm-Message-State: AOAM532BMvR+rhE4iphg4Dt9sPL30nPSRvkhHV7EqB0SYExFusTpcM7d
        C9FafoKtqiUiKeGyhthpu+NyoEIi4z/eWTVd
X-Google-Smtp-Source: ABdhPJxKvMU2nv2y99MvdHtZ1aPjpBweKkMXfLDpXh8O/hjZLHf5tbIsQdCwZcYbcvbqfP1mWVc4KQ==
X-Received: by 2002:a17:90a:8d82:: with SMTP id d2mr28673033pjo.200.1620149386611;
        Tue, 04 May 2021 10:29:46 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id 144sm13543207pfc.101.2021.05.04.10.29.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 04 May 2021 10:29:46 -0700 (PDT)
Message-ID: <6091848a.1c69fb81.8c438.2d16@mx.google.com>
Date:   Tue, 04 May 2021 10:29:46 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.9.268-2-gd6ef008d25c07
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/4.9
Subject: stable-rc/queue/4.9 baseline: 83 runs,
 5 regressions (v4.9.268-2-gd6ef008d25c07)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.9 baseline: 83 runs, 5 regressions (v4.9.268-2-gd6ef008d2=
5c07)

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


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.9/kern=
el/v4.9.268-2-gd6ef008d25c07/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.9
  Describe: v4.9.268-2-gd6ef008d25c07
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      d6ef008d25c07a6b1ee8ef90d539629e49a067d1 =



Test Regressions
---------------- =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
panda                | arm  | lab-collabora   | gcc-8    | omap2plus_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/609153e3f40d912e63843f3f

  Results:     3 PASS, 1 FAIL, 1 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.268-2=
-gd6ef008d25c07/arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-panda.=
txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.268-2=
-gd6ef008d25c07/arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-panda.=
html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/609153e3f40d912=
e63843f44
        failing since 0 day (last pass: v4.9.268-1-gf945683b79529, first fa=
il: v4.9.268-1-gf967fc4704b0c)
        2 lines

    2021-05-04 14:02:08.312000+00:00  kern  :emerg : BUG: spinlock bad magi=
c on CPU#0, udevd/125
    2021-05-04 14:02:08.321000+00:00  kern  :emerg :  lock: emif_lock+0x0/0=
xfffff24c [emif], .magic: dead4ead, .owner: <none>/-1, .owner_cpu: -1
    2021-05-04 14:02:08.334000+00:00  [   20.406585] <LAVA_SIGNAL_TESTCASE =
TEST_CASE_ID=3Demerg RESULT=3Dfail UNITS=3Dlines MEASUREMENT=3D2>   =

 =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-baylibre    | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/609149a8cac0c68882843f27

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.268-2=
-gd6ef008d25c07/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_ar=
m-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.268-2=
-gd6ef008d25c07/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_ar=
m-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/609149a8cac0c68882843=
f28
        failing since 171 days (last pass: v4.9.243-16-gd8d67e375b0a, first=
 fail: v4.9.243-25-ga01fe8e99a22) =

 =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-broonie     | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/609149b3545b8dce85843f1d

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.268-2=
-gd6ef008d25c07/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_arm=
-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.268-2=
-gd6ef008d25c07/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_arm=
-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/609149b3545b8dce85843=
f1e
        failing since 171 days (last pass: v4.9.243-16-gd8d67e375b0a, first=
 fail: v4.9.243-25-ga01fe8e99a22) =

 =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-cip         | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/609149ab4e623bae83843f28

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.268-2=
-gd6ef008d25c07/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-ver=
satilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.268-2=
-gd6ef008d25c07/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-ver=
satilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/609149ab4e623bae83843=
f29
        failing since 171 days (last pass: v4.9.243-16-gd8d67e375b0a, first=
 fail: v4.9.243-25-ga01fe8e99a22) =

 =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-linaro-lkft | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/6091494d311cc848ba843f17

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.268-2=
-gd6ef008d25c07/arm/versatile_defconfig/gcc-8/lab-linaro-lkft/baseline-qemu=
_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.268-2=
-gd6ef008d25c07/arm/versatile_defconfig/gcc-8/lab-linaro-lkft/baseline-qemu=
_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6091494d311cc848ba843=
f18
        failing since 171 days (last pass: v4.9.243-16-gd8d67e375b0a, first=
 fail: v4.9.243-25-ga01fe8e99a22) =

 =20
