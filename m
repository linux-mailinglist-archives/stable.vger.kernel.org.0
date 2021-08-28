Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 17B123FA286
	for <lists+stable@lfdr.de>; Sat, 28 Aug 2021 02:42:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232798AbhH1AmG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 27 Aug 2021 20:42:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47532 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232616AbhH1AmG (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 27 Aug 2021 20:42:06 -0400
Received: from mail-pl1-x636.google.com (mail-pl1-x636.google.com [IPv6:2607:f8b0:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8357BC0613D9
        for <stable@vger.kernel.org>; Fri, 27 Aug 2021 17:41:16 -0700 (PDT)
Received: by mail-pl1-x636.google.com with SMTP id m17so5013747plc.6
        for <stable@vger.kernel.org>; Fri, 27 Aug 2021 17:41:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=UWvDn7758/2cHBvUOZ3RBhRYiAKm4EYqlTDuLl+UV+k=;
        b=d81RqQ2Mnqnrv5/ElD2yUsfwmDgtxBVpSLnybqdYVVdxC43mTbMK8u0ALjpz8sLeg+
         aGJR1rcKbkgfxlCSuQjaDyieeqFj3xkBUF1L9MR81vi50RnUyP3TSY2ddJh+FbeC5Ea7
         c4wyKNA5JUgjMsTB9l/8lYBjY3eFsZbMmZPOulj2//DVfF2JNFoA0WkdT8S2mjG2aSem
         coGp2YF9XoOLYr4JF2p+b8jFD0X1FUbcnwGcb8EMD0Mt6i75hasnpXPGY7x4SVYQIPWI
         zZeBxyoDf/ykGsr0NCLxxLBTb63mrSlUHBHOXE8xgJvnYmTK13BE4m3/Meaf5FKal7Ao
         R1gQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=UWvDn7758/2cHBvUOZ3RBhRYiAKm4EYqlTDuLl+UV+k=;
        b=TyKEGftMnZOQnkyTpRCO0qFS2Qj7ePH2CuRd5GJjyCG4rgI8ghwCCf7b7/xMhCBmOw
         tr9jfavozFlgloI8KOD/wv+TcUJoLSjYSYLqYfc8ASi5kvCz0Ip1Uhu4+RoQMYrAH7+F
         3QNMtOUiiwAUMQavA32HQTwdzqK8BWUztfkQFkHlkbiEZIXLjJtf+TSx+2WSf8KIwhIp
         7aznVmy4LhiCCh82kcq7JSb+TBaW+P0XdI+1nMEyhwXpVT14WiBoCcBacX1Zf1Xa9/QF
         Iwa5QFyoOGrFW/Er2eJ3n5oU/t3SzhG+gYfZ65vpxns1MNIcqhczsd/xoXjNPlUrDONx
         Hkeg==
X-Gm-Message-State: AOAM5334PAQZwpReVzMikO/Kv0MhyNOqVElwCuA50RfaD6p6CtIWnk80
        G7X53ZHzzjH0fPRVc7A3c6vZcodNexU4w4vV
X-Google-Smtp-Source: ABdhPJwBZhCB135yf/wmc84uHi5HwFXUMvhHJeJhb0IFENyucO08Uqk0UM1M9rFs46Ia6EBCnhdMGA==
X-Received: by 2002:a17:903:2349:b029:12d:4a06:1c56 with SMTP id c9-20020a1709032349b029012d4a061c56mr11192392plh.64.1630111275812;
        Fri, 27 Aug 2021 17:41:15 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id k12sm13672763pjg.6.2021.08.27.17.41.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 27 Aug 2021 17:41:15 -0700 (PDT)
Message-ID: <6129862b.1c69fb81.59ce6.3e9b@mx.google.com>
Date:   Fri, 27 Aug 2021 17:41:15 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: queue/4.19
X-Kernelci-Kernel: v4.19.205-7-g0cfdba431276
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
Subject: stable-rc/queue/4.19 baseline: 138 runs,
 3 regressions (v4.19.205-7-g0cfdba431276)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.19 baseline: 138 runs, 3 regressions (v4.19.205-7-g0cfdba=
431276)

Regressions Summary
-------------------

platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-baylibre    | gcc-8    | versatile_defcon=
fig | 1          =

qemu_arm-versatilepb | arm  | lab-cip         | gcc-8    | versatile_defcon=
fig | 1          =

qemu_arm-versatilepb | arm  | lab-linaro-lkft | gcc-8    | versatile_defcon=
fig | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.19/ker=
nel/v4.19.205-7-g0cfdba431276/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.19
  Describe: v4.19.205-7-g0cfdba431276
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      0cfdba431276b857d52dc1d03eb35c6590488b6c =



Test Regressions
---------------- =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-baylibre    | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/61296267316461af8d8e2ccc

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.205=
-7-g0cfdba431276/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_a=
rm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.205=
-7-g0cfdba431276/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_a=
rm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61296267316461af8d8e2=
ccd
        failing since 287 days (last pass: v4.19.157-26-gd59f3161b3a0, firs=
t fail: v4.19.157-27-g5543cc2c41d55) =

 =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-cip         | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/61294bea3b4acfa6888e2c90

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.205=
-7-g0cfdba431276/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-ve=
rsatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.205=
-7-g0cfdba431276/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-ve=
rsatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61294bea3b4acfa6888e2=
c91
        failing since 287 days (last pass: v4.19.157-26-gd59f3161b3a0, firs=
t fail: v4.19.157-27-g5543cc2c41d55) =

 =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-linaro-lkft | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/61294b8079bface8868e2c8b

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.205=
-7-g0cfdba431276/arm/versatile_defconfig/gcc-8/lab-linaro-lkft/baseline-qem=
u_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.205=
-7-g0cfdba431276/arm/versatile_defconfig/gcc-8/lab-linaro-lkft/baseline-qem=
u_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61294b8079bface8868e2=
c8c
        failing since 287 days (last pass: v4.19.157-26-gd59f3161b3a0, firs=
t fail: v4.19.157-27-g5543cc2c41d55) =

 =20
