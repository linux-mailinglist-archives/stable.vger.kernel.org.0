Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1834836A9F1
	for <lists+stable@lfdr.de>; Mon, 26 Apr 2021 01:54:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231331AbhDYXzO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 25 Apr 2021 19:55:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52100 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231330AbhDYXzO (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 25 Apr 2021 19:55:14 -0400
Received: from mail-pj1-x1032.google.com (mail-pj1-x1032.google.com [IPv6:2607:f8b0:4864:20::1032])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3EFE3C061574
        for <stable@vger.kernel.org>; Sun, 25 Apr 2021 16:54:30 -0700 (PDT)
Received: by mail-pj1-x1032.google.com with SMTP id u14-20020a17090a1f0eb029014e38011b09so4205590pja.5
        for <stable@vger.kernel.org>; Sun, 25 Apr 2021 16:54:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=TH6HcJ33Nn6h2chzSTNDa2jet5x9Jq2McS/wmLmV4oo=;
        b=apd8YQRSP7FPxYffVnXNnkwXHX1bezLyK2lmcEq1+Bd7n2eKd0HFUhhukWI8xqFs4n
         7NxgPycprPe3dinWlS3Zpi01fLthm6wsv52MbP2qnXDFq3Uv63bfmkft4SgUaBhu31ZH
         UxNdUE62gHUB00bq4PFgpxpxQf891vyOV8QhmtEXqdq3sMASF75JdFEQojDSkhYFhlVg
         WHuQNcYScwfh6ql7zJ/b4WXohX/mk2VubhXGx1xPT6wzYGyKyIwRGTlXmfshfY3+9Fxd
         gPni+piA9b8RZNyKLHI89h/+2XcwTfkWtBE+YjWuCQdHtEH3BmIdBG4yfHz/CB4Z/jSQ
         RkyQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=TH6HcJ33Nn6h2chzSTNDa2jet5x9Jq2McS/wmLmV4oo=;
        b=UIp4/kmmi0BZ59MV8A7RRy2qroH8a2MrLTP1mUCn4YsSxYRpCvaZzPhkApg1k5Xsu3
         XIU0GQtIIy2+Knzv58y88fTs0MmxTle69JmDrQpX1gUg+AT41lhHOFCyIidHH6kEnbFt
         owOxowPNeDAO35wM2/oCUX99voUJ/WK0fhqsf/GuzYWNLuu3AsaemtpVYq8834i1Gu0Z
         L+wNima+pWwtYkBLphKvPP1IwXb+f2yth/7dfQGcJlVB6a7FT8Jn45EO1/8u64KRC7Aw
         lY6Z9WH4LJnSYV1VTqkY25BUIxDkTEIUUIUSoFkJ+rktIT3AvkCE3gWTSYcjAPIWOce4
         V+HA==
X-Gm-Message-State: AOAM531vlae42eZIV1x8YveSGBGh+lqZos1H+xsyWKKoc1n0Zldt82HH
        Z1wOg7b0GBzn2vvnehCxEq4aP2koqXIabKDM
X-Google-Smtp-Source: ABdhPJx/lTM+75Jvey9Xx9ZzSviE94TotTqbLAqVrQL2ej0oLVzNtTTcS8dpUipODyWUMXJ3whRPnQ==
X-Received: by 2002:a17:902:788b:b029:ec:c151:b5e with SMTP id q11-20020a170902788bb02900ecc1510b5emr15544185pll.75.1619394869583;
        Sun, 25 Apr 2021 16:54:29 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id n85sm9955333pfd.170.2021.04.25.16.54.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 25 Apr 2021 16:54:29 -0700 (PDT)
Message-ID: <60860135.1c69fb81.3b558.e197@mx.google.com>
Date:   Sun, 25 Apr 2021 16:54:29 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.14.231-39-ga9b6ba4783dcd
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/4.14
Subject: stable-rc/queue/4.14 baseline: 127 runs,
 5 regressions (v4.14.231-39-ga9b6ba4783dcd)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.14 baseline: 127 runs, 5 regressions (v4.14.231-39-ga9b6b=
a4783dcd)

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

qemu_arm-versatilepb | arm  | lab-collabora   | gcc-8    | versatile_defcon=
fig | 1          =

qemu_arm-versatilepb | arm  | lab-linaro-lkft | gcc-8    | versatile_defcon=
fig | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.14/ker=
nel/v4.14.231-39-ga9b6ba4783dcd/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.14
  Describe: v4.14.231-39-ga9b6ba4783dcd
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      a9b6ba4783dcdc0a38d1fb3c25e2e32115104754 =



Test Regressions
---------------- =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-baylibre    | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/6085cb7da3e39031e39b77a6

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.231=
-39-ga9b6ba4783dcd/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu=
_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.231=
-39-ga9b6ba4783dcd/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu=
_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6085cb7da3e39031e39b7=
7a7
        failing since 163 days (last pass: v4.14.206-21-g787a7a3ca16c, firs=
t fail: v4.14.206-22-ga949bf40fb01) =

 =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-broonie     | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/6085cb70a57d85c27c9b77c2

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.231=
-39-ga9b6ba4783dcd/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_=
arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.231=
-39-ga9b6ba4783dcd/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_=
arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6085cb70a57d85c27c9b7=
7c3
        failing since 163 days (last pass: v4.14.206-21-g787a7a3ca16c, firs=
t fail: v4.14.206-22-ga949bf40fb01) =

 =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-cip         | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/6085cb8575efb1cb4d9b779a

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.231=
-39-ga9b6ba4783dcd/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-=
versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.231=
-39-ga9b6ba4783dcd/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-=
versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6085cb8575efb1cb4d9b7=
79b
        failing since 163 days (last pass: v4.14.206-21-g787a7a3ca16c, firs=
t fail: v4.14.206-22-ga949bf40fb01) =

 =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-collabora   | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/6085cb0fc78584a34b9b7795

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.231=
-39-ga9b6ba4783dcd/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qem=
u_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.231=
-39-ga9b6ba4783dcd/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qem=
u_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6085cb0fc78584a34b9b7=
796
        failing since 163 days (last pass: v4.14.206-21-g787a7a3ca16c, firs=
t fail: v4.14.206-22-ga949bf40fb01) =

 =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-linaro-lkft | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/6085cb1f10156909399b7795

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.231=
-39-ga9b6ba4783dcd/arm/versatile_defconfig/gcc-8/lab-linaro-lkft/baseline-q=
emu_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.231=
-39-ga9b6ba4783dcd/arm/versatile_defconfig/gcc-8/lab-linaro-lkft/baseline-q=
emu_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6085cb1f10156909399b7=
796
        failing since 163 days (last pass: v4.14.206-21-g787a7a3ca16c, firs=
t fail: v4.14.206-22-ga949bf40fb01) =

 =20
