Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 46DCA381227
	for <lists+stable@lfdr.de>; Fri, 14 May 2021 22:58:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229932AbhENU74 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 14 May 2021 16:59:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55158 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229681AbhENU7z (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 14 May 2021 16:59:55 -0400
Received: from mail-pf1-x431.google.com (mail-pf1-x431.google.com [IPv6:2607:f8b0:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0229EC061574
        for <stable@vger.kernel.org>; Fri, 14 May 2021 13:58:42 -0700 (PDT)
Received: by mail-pf1-x431.google.com with SMTP id h127so586272pfe.9
        for <stable@vger.kernel.org>; Fri, 14 May 2021 13:58:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=nITSLYFdoqEOsLPw9oqd3XNnis0sEOTajKWiB6G+DNY=;
        b=ott76KdEdXPtTCADS0GS/sL6uUC1A9WnVQZpyzQHV+0cKVya5GiwFasmuYMtm5uCIE
         2EOlzWAmyVP5b8mfMMn8r9s/auZEolVfn9itkcMyVFSxjk9aNyCUjePvvRXX6zY5AJoK
         iMpInjimRCEn6lZFP4FMkPgIxJF3YVaqFobW+/EL33S2sRen9IxcLkfl9Q9cvITC4Sz6
         9Ql4DQylAkCinW2rWUSkakCrr2KUy4P6efPCkDcqkBt8ZuHAm8NcCwtxg3ktrwSZuqOk
         3hL7aBsINxlPw+mxP2Gh9WmD3cG0xWYahaiI95ZRQmmOAk13uGvjN/M9etf4O9dbVaBD
         5V3w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=nITSLYFdoqEOsLPw9oqd3XNnis0sEOTajKWiB6G+DNY=;
        b=NEQ2lqkDMumE2EIgkqDioX6nSJz3ptmLRBabNV5yUrgjTY2CsxxoezZGKu169oRk3A
         dCFpJLAEAxhIcp5A4oMF26J4RqICpKNKDXHsCt8cuanrdfD8XwheOfkPtFd4Kjo8OmSR
         U5pqzMg4vKnEGXsfwijjbGMdw+2fynotxgTjKU5wZt1IjCr9fllY4ScKc7WRNeGSex1s
         Y5Cj7F/ncMpPBmNK0but/v66WoKh9ame5tuqCk5J+O3tWJxGUu4j8S5Lk9Lgyyq7GuIS
         LiW4u9smlZdqGjum+46s0JM9IZnPiPCNosgi6ro9Jlv+TteI37PUgK5yt1Ogyhdy99q5
         xZ6Q==
X-Gm-Message-State: AOAM532nv6nwamAobIDGt1YZTCW1yu5+WR0UwRFgjXxfnQl1t9YoylqF
        Fh0p/UcUhvRsNAkfl7Ie/EUKL34/m4hqHl0Y
X-Google-Smtp-Source: ABdhPJw0QAl0W10qJO0AhyXM3Ehsoq7xR1oTjWeYnE2OmJsZdKJ/r9HG/azphVOYYNgQZT8L9fsdVg==
X-Received: by 2002:a63:a19:: with SMTP id 25mr48751459pgk.177.1621025922117;
        Fri, 14 May 2021 13:58:42 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id k7sm4782427pfc.16.2021.05.14.13.58.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 14 May 2021 13:58:41 -0700 (PDT)
Message-ID: <609ee481.1c69fb81.6156b.0be8@mx.google.com>
Date:   Fri, 14 May 2021 13:58:41 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v4.19.190-302-g31651124a48a
X-Kernelci-Branch: queue/4.19
X-Kernelci-Report-Type: test
Subject: stable-rc/queue/4.19 baseline: 82 runs,
 4 regressions (v4.19.190-302-g31651124a48a)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.19 baseline: 82 runs, 4 regressions (v4.19.190-302-g31651=
124a48a)

Regressions Summary
-------------------

platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-baylibre    | gcc-8    | versatile_defcon=
fig | 1          =

qemu_arm-versatilepb | arm  | lab-broonie     | gcc-8    | versatile_defcon=
fig | 1          =

qemu_arm-versatilepb | arm  | lab-cip         | gcc-8    | versatile_defcon=
fig | 1          =

qemu_arm-versatilepb | arm  | lab-linaro-lkft | gcc-8    | versatile_defcon=
fig | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.19/ker=
nel/v4.19.190-302-g31651124a48a/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.19
  Describe: v4.19.190-302-g31651124a48a
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      31651124a48a8f115ed1a3de6454d52356faf7af =



Test Regressions
---------------- =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-baylibre    | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/609eb167069fc07b48b3af99

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.190=
-302-g31651124a48a/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu=
_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.190=
-302-g31651124a48a/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu=
_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/609eb167069fc07b48b3a=
f9a
        failing since 181 days (last pass: v4.19.157-26-gd59f3161b3a0, firs=
t fail: v4.19.157-27-g5543cc2c41d55) =

 =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-broonie     | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/609eb17148b5d58b0cb3afac

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.190=
-302-g31651124a48a/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_=
arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.190=
-302-g31651124a48a/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_=
arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/609eb17148b5d58b0cb3a=
fad
        failing since 181 days (last pass: v4.19.157-26-gd59f3161b3a0, firs=
t fail: v4.19.157-27-g5543cc2c41d55) =

 =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-cip         | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/609eb16710e5ea7c27b3af9f

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.190=
-302-g31651124a48a/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-=
versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.190=
-302-g31651124a48a/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-=
versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/609eb16710e5ea7c27b3a=
fa0
        failing since 181 days (last pass: v4.19.157-26-gd59f3161b3a0, firs=
t fail: v4.19.157-27-g5543cc2c41d55) =

 =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-linaro-lkft | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/609ecfe1b1440b6925b3af97

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.190=
-302-g31651124a48a/arm/versatile_defconfig/gcc-8/lab-linaro-lkft/baseline-q=
emu_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.190=
-302-g31651124a48a/arm/versatile_defconfig/gcc-8/lab-linaro-lkft/baseline-q=
emu_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/609ecfe1b1440b6925b3a=
f98
        failing since 181 days (last pass: v4.19.157-26-gd59f3161b3a0, firs=
t fail: v4.19.157-27-g5543cc2c41d55) =

 =20
