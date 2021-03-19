Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 957873428CB
	for <lists+stable@lfdr.de>; Fri, 19 Mar 2021 23:41:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230285AbhCSWku (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Mar 2021 18:40:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48556 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230218AbhCSWkS (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 19 Mar 2021 18:40:18 -0400
Received: from mail-pf1-x436.google.com (mail-pf1-x436.google.com [IPv6:2607:f8b0:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 377E6C061760
        for <stable@vger.kernel.org>; Fri, 19 Mar 2021 15:39:40 -0700 (PDT)
Received: by mail-pf1-x436.google.com with SMTP id 11so6877943pfn.9
        for <stable@vger.kernel.org>; Fri, 19 Mar 2021 15:39:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=EqRA+jZXHjmzsb2SwMsx7awOZhtvkSR3eDLp/2gyIps=;
        b=ePVEPEZxaK3pyltOh0UgATK62+GcnQgN2PZlvnylWlioANC6APuBdjhniydNSK/Pfq
         HPrRQOTnkaVdFUDdSWWVgGIjajdegMsu8EfyzDYKTf8bxYxJTLAH77mFRGpg4vjIdoVC
         dzYczNM2QWgEdy4QX1YvXE/H3ax5Og4Qjq+UAPPKQ9m4PRyECrJ/O83O7lIK2upToiEn
         zhUrasgOXY1jsfi280D6I3M+b1duvzOVzixasNPhqEcwGOCE0E/K8sP92poFx2xH+klA
         KPpKtEswcuruMHJursoDA+JgAU0BbzFcRymK+fllTlByW9y5cECgDdcij4Mzn7f/So/C
         GSZg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=EqRA+jZXHjmzsb2SwMsx7awOZhtvkSR3eDLp/2gyIps=;
        b=QP0KwjPWtoDiOKCkoCNLTCnR+iEI7E1p4VuCyYsQhR9DVHiA5Ls858GCNnR1aA0PfT
         SpFH+gjA6qr/5om5AG19lItu/pnLauW6QPfCqA9kkWeZ/6asyCtOulhIDZHWYTnKNQkN
         Y1Cck4n0fB6zaKIY4N+/+dTt79+o3Cj5PNxecHgI4b5Au3R+5GVcVwziFPXuV7PlLc0f
         O/8a+r1ain12v5BatTVFaTd+EkFPjmFpXP+XbV1x96/5gMpt0p2d51zCZB9dkHtNIBb2
         rRfrztB2dmp6SkMvv4hWEs+C9VRsAPzlnxPzUUWCj6ulJItdsmcCS4aEudfnl8mjOzQG
         rk6A==
X-Gm-Message-State: AOAM531HFat7Oz1m5zjB2pRqSDMj6VEv/JHwGotanuzX8DwgfRhQUQRN
        ZBe+2mdtLCvre1f360mtz+Lzl7k+16Kqng==
X-Google-Smtp-Source: ABdhPJw+WYDlmjMS/8YheLK9jVGiK5c4x5E428hsz8O2P6GykAbo3Gnw//W0FBspUKadCq5/iBQvgQ==
X-Received: by 2002:a62:7556:0:b029:1ff:5bf8:72b3 with SMTP id q83-20020a6275560000b02901ff5bf872b3mr11340690pfc.33.1616193579291;
        Fri, 19 Mar 2021 15:39:39 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id f20sm6615208pfa.10.2021.03.19.15.39.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 19 Mar 2021 15:39:38 -0700 (PDT)
Message-ID: <6055282a.1c69fb81.b5b5d.07a4@mx.google.com>
Date:   Fri, 19 Mar 2021 15:39:38 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.14.226-7-ga1e26b369d05
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/4.14
Subject: stable-rc/queue/4.14 baseline: 126 runs,
 4 regressions (v4.14.226-7-ga1e26b369d05)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.14 baseline: 126 runs, 4 regressions (v4.14.226-7-ga1e26b=
369d05)

Regressions Summary
-------------------

platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-baylibre  | gcc-8    | versatile_defconfi=
g | 1          =

qemu_arm-versatilepb | arm  | lab-broonie   | gcc-8    | versatile_defconfi=
g | 1          =

qemu_arm-versatilepb | arm  | lab-cip       | gcc-8    | versatile_defconfi=
g | 1          =

qemu_arm-versatilepb | arm  | lab-collabora | gcc-8    | versatile_defconfi=
g | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.14/ker=
nel/v4.14.226-7-ga1e26b369d05/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.14
  Describe: v4.14.226-7-ga1e26b369d05
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      a1e26b369d05f0e3d91ee63139ce4bd004709ffb =



Test Regressions
---------------- =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-baylibre  | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/6054efee3bfeb33de0addcbd

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.226=
-7-ga1e26b369d05/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_a=
rm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.226=
-7-ga1e26b369d05/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_a=
rm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6054efee3bfeb33de0add=
cbe
        failing since 125 days (last pass: v4.14.206-21-g787a7a3ca16c, firs=
t fail: v4.14.206-22-ga949bf40fb01) =

 =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-broonie   | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/6054eff43bfeb33de0addcd4

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.226=
-7-ga1e26b369d05/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_ar=
m-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.226=
-7-ga1e26b369d05/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_ar=
m-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6054eff43bfeb33de0add=
cd5
        failing since 125 days (last pass: v4.14.206-21-g787a7a3ca16c, firs=
t fail: v4.14.206-22-ga949bf40fb01) =

 =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-cip       | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/6054f007d557f34fcdaddcb1

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.226=
-7-ga1e26b369d05/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-ve=
rsatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.226=
-7-ga1e26b369d05/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-ve=
rsatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6054f007d557f34fcdadd=
cb2
        failing since 125 days (last pass: v4.14.206-21-g787a7a3ca16c, firs=
t fail: v4.14.206-22-ga949bf40fb01) =

 =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-collabora | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/6054ef98c666add8d1addcbc

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.226=
-7-ga1e26b369d05/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu_=
arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.226=
-7-ga1e26b369d05/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu_=
arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6054ef98c666add8d1add=
cbd
        failing since 125 days (last pass: v4.14.206-21-g787a7a3ca16c, firs=
t fail: v4.14.206-22-ga949bf40fb01) =

 =20
