Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E2CB933A730
	for <lists+stable@lfdr.de>; Sun, 14 Mar 2021 18:50:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232431AbhCNRtd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 14 Mar 2021 13:49:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39656 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231205AbhCNRtQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 14 Mar 2021 13:49:16 -0400
Received: from mail-pj1-x1030.google.com (mail-pj1-x1030.google.com [IPv6:2607:f8b0:4864:20::1030])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 878EAC061574
        for <stable@vger.kernel.org>; Sun, 14 Mar 2021 10:49:16 -0700 (PDT)
Received: by mail-pj1-x1030.google.com with SMTP id x7-20020a17090a2b07b02900c0ea793940so13141595pjc.2
        for <stable@vger.kernel.org>; Sun, 14 Mar 2021 10:49:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=kJH7D/N5AmBFAo0sVlP7T1BDNRZlWfzk7DBVYrGWOyA=;
        b=b/c2x2hUDbhdcjj/kHyvFWJjWjSL95vM5nOYUjVXWNB4LIDSI1ZKSATMeXohDryubo
         /N8tvMfl0+XYoPUUpHlM3Hib/F0P40c62lWksbXzBeyzr6qlSQP6Fp3eVP82K1CrMTiI
         n/nK9rz1L0LgjvubT2X5xTKM8fsYPbinLk6dKD0cmKmI9PuQhu9nMTz5IBKJY+kCEHMz
         4aHJern1IFNnD72c43GKmcOhIwKUHkpSvt1sLI5a3ML2D4A+kVoKseoCOTrNvFuTL8Z6
         IQrG6aK7sqGVclSrHvHVc0qrCLMKx0MRqvnDepLOFXoTUBanCrTDi108fej6qG+rRztQ
         8yoA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=kJH7D/N5AmBFAo0sVlP7T1BDNRZlWfzk7DBVYrGWOyA=;
        b=MFh+qmVjJgggqI4Iq+gNmLK46OPg7GtkulhU9GPtk2b7ZUibJOND9koMWFjh96/zQi
         X2PB6bjoRjWPsZ7STn7YNEBbdRG4sfZeuXoDcd69BUD5lpVA6SKEhA0XJPSTJ1ERk8XB
         h5dQh+YX2Mb1nlK3+xPcbtMIDUlD6JOx5bV8WVX3j+Wt4mgmCqz9ZVhttLsjGzlZUlY8
         tugur2uNeDE3Ccq2H63ttIWJumXRPGE1uLaS65retbNEmE3GnDKLJXsVbyI2j7KyYz9u
         UpL0gZEX3t0cxpDu6+5QYgr/+p0ZDjyKpIEW14nxuTfSw9lllPZokeT1MxOtyHRSoa+X
         1waQ==
X-Gm-Message-State: AOAM532sCV529/LkBEeW0t3qu0+HRA8IlMW3aPJxocz/LLhdZ6m7AO+f
        hTFIbhzIWWkQpumbnPDUyO1ZUfEDAyLY6w==
X-Google-Smtp-Source: ABdhPJwS1/e7q13Km1AHaTkzQn/uM5WjdlLb+YUug1BA/js0jAiaGYoXx93D0fTX3V1+YeHfxVko3w==
X-Received: by 2002:a17:90a:66c2:: with SMTP id z2mr9113896pjl.139.1615744155732;
        Sun, 14 Mar 2021 10:49:15 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id cp22sm8205317pjb.15.2021.03.14.10.49.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 14 Mar 2021 10:49:15 -0700 (PDT)
Message-ID: <604e4c9b.1c69fb81.67cde.37ac@mx.google.com>
Date:   Sun, 14 Mar 2021 10:49:15 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.9.261-59-g0e1a91b52ecbc
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/4.9
Subject: stable-rc/queue/4.9 baseline: 92 runs,
 5 regressions (v4.9.261-59-g0e1a91b52ecbc)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.9 baseline: 92 runs, 5 regressions (v4.9.261-59-g0e1a91b5=
2ecbc)

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


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.9/kern=
el/v4.9.261-59-g0e1a91b52ecbc/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.9
  Describe: v4.9.261-59-g0e1a91b52ecbc
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      0e1a91b52ecbcab85d1aeb6409738820c145a623 =



Test Regressions
---------------- =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
panda                | arm  | lab-collabora   | gcc-8    | omap2plus_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/604e17beabdac74414addcb7

  Results:     3 PASS, 1 FAIL, 1 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.261-5=
9-g0e1a91b52ecbc/arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-panda=
.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.261-5=
9-g0e1a91b52ecbc/arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-panda=
.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/604e17beabdac74=
414addcbc
        failing since 1 day (last pass: v4.9.261-17-g0640bd71e2fe1, first f=
ail: v4.9.261-24-gc9deaed4c3062)
        2 lines

    2021-03-14 14:03:38.046000+00:00  kern  :emerg : BUG: spinlock bad magi=
c on CPU#0, udevd/124
    2021-03-14 14:03:38.055000+00:00  kern  :emerg :  lock: emif_lock+0x0/0=
xfffff24c [emif], .magic: dead4ead, .owner: <none>/-1, .owner_cpu: -1   =

 =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-broonie     | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/604e165ea4c0fdf906addcb1

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.261-5=
9-g0e1a91b52ecbc/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_ar=
m-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.261-5=
9-g0e1a91b52ecbc/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_ar=
m-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/604e165ea4c0fdf906add=
cb2
        failing since 120 days (last pass: v4.9.243-16-gd8d67e375b0a, first=
 fail: v4.9.243-25-ga01fe8e99a22) =

 =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-cip         | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/604e196dfafeb5bda9addcb4

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.261-5=
9-g0e1a91b52ecbc/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-ve=
rsatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.261-5=
9-g0e1a91b52ecbc/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-ve=
rsatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/604e196dfafeb5bda9add=
cb5
        failing since 120 days (last pass: v4.9.243-16-gd8d67e375b0a, first=
 fail: v4.9.243-25-ga01fe8e99a22) =

 =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-collabora   | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/604e15fd318e3efe47addcdb

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.261-5=
9-g0e1a91b52ecbc/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu_=
arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.261-5=
9-g0e1a91b52ecbc/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu_=
arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/604e15fd318e3efe47add=
cdc
        failing since 120 days (last pass: v4.9.243-16-gd8d67e375b0a, first=
 fail: v4.9.243-25-ga01fe8e99a22) =

 =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-linaro-lkft | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/604e1609318e3efe47addcf0

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.261-5=
9-g0e1a91b52ecbc/arm/versatile_defconfig/gcc-8/lab-linaro-lkft/baseline-qem=
u_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.261-5=
9-g0e1a91b52ecbc/arm/versatile_defconfig/gcc-8/lab-linaro-lkft/baseline-qem=
u_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/604e1609318e3efe47add=
cf1
        failing since 120 days (last pass: v4.9.243-16-gd8d67e375b0a, first=
 fail: v4.9.243-25-ga01fe8e99a22) =

 =20
