Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3C24138B764
	for <lists+stable@lfdr.de>; Thu, 20 May 2021 21:21:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238132AbhETTXN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 May 2021 15:23:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37970 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237698AbhETTXN (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 20 May 2021 15:23:13 -0400
Received: from mail-pg1-x52a.google.com (mail-pg1-x52a.google.com [IPv6:2607:f8b0:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D52E2C061574
        for <stable@vger.kernel.org>; Thu, 20 May 2021 12:21:51 -0700 (PDT)
Received: by mail-pg1-x52a.google.com with SMTP id f22so11607168pgb.9
        for <stable@vger.kernel.org>; Thu, 20 May 2021 12:21:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=B0iKPuzog6Bf2HauqdzLOCZJIkE2Ms0s0x+RaRaqrXU=;
        b=QWds9QSGYg8wNCUcc8V5rMgTkUUNP+nGPymOVvTyZFRvtuorwLsraQG/cN/FKIHA02
         SrbVHGCeSBYjLhK8qX72TiiOtQz4v43qRwxxgOTbr+6K2dx9SAhO6dZiPwSteZ8iWEZY
         KUgdy9bn+DqNB4X159EQhIG9s6sFUg/08dpxpFJsu3qlocd/bv2oVK1p5hFeiPq1J/Cx
         PT32HQK8Yn+kg0Jphb6aspcjyihAGRVNHTy/GBsMyFIpBQ+VMx/7AI7JLDsgZ04hiE+4
         U9aL5msg8ng4N0h64ege7dLFjKa0rJG1fUreZk04gnUi8rq3T79Ze06om/OmPlqY/2bd
         nOUg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=B0iKPuzog6Bf2HauqdzLOCZJIkE2Ms0s0x+RaRaqrXU=;
        b=QFM0Gp1HRWPFMOlmbFxJ09ACfxIFWYzEYDqjx+dMqb62fdtEGpEp2/4gSr+NZq76Gg
         6lSyK9ZVJG8Dg1QLKBGHoasnhwbI5uCyRQ/vHUlSHcgugUWtQuDCwX9ba32iilSnyH9+
         4038H+ejFd5RVSz0/7nf6nL3p1dCwN6DbOlQg2kft3r8DRbhaaBgLlbihYbXJ5LyRO87
         W7xlt27NuMcVYj5184mBjREjWDVTXS7KAlBYCZlC3pcN0xZnlSXQUUxM7cOhzaDYh9ZF
         iJgiuXMfJMHCK0bCn8mK8BlZpbjq2mFVtGqLucGCvybSKeUc9BGLjI0lVfD4lXwCkrAR
         38/w==
X-Gm-Message-State: AOAM5338DZRKHMaFmioaQa1h/Nrk0JwCJfEZbjK/io8KLLzkBCsgTGvI
        Qo+m65eVv+r+2ZBppjMHoT8OiZMqRG2v2A0X
X-Google-Smtp-Source: ABdhPJwP6FIrxs0qcVJrTIGo4XbjlMyRRN30fZ9gzpOuJZsWvWZ2CcWb1SMnQFLk9OlsgvokqfHTAQ==
X-Received: by 2002:a05:6a00:1384:b029:2c7:fcda:8d83 with SMTP id t4-20020a056a001384b02902c7fcda8d83mr6050824pfg.0.1621538511212;
        Thu, 20 May 2021 12:21:51 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id m14sm2572735pff.17.2021.05.20.12.21.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 20 May 2021 12:21:50 -0700 (PDT)
Message-ID: <60a6b6ce.1c69fb81.acc01.9293@mx.google.com>
Date:   Thu, 20 May 2021 12:21:50 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v4.19.190-424-gbb62732c6c52
X-Kernelci-Branch: queue/4.19
X-Kernelci-Report-Type: test
Subject: stable-rc/queue/4.19 baseline: 137 runs,
 4 regressions (v4.19.190-424-gbb62732c6c52)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.19 baseline: 137 runs, 4 regressions (v4.19.190-424-gbb62=
732c6c52)

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


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.19/ker=
nel/v4.19.190-424-gbb62732c6c52/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.19
  Describe: v4.19.190-424-gbb62732c6c52
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      bb62732c6c526f16fc2227ec40a7f00542a4d224 =



Test Regressions
---------------- =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-baylibre  | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/60a670bba64287f3dab3afc6

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.190=
-424-gbb62732c6c52/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu=
_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.190=
-424-gbb62732c6c52/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu=
_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60a670bba64287f3dab3a=
fc7
        failing since 187 days (last pass: v4.19.157-26-gd59f3161b3a0, firs=
t fail: v4.19.157-27-g5543cc2c41d55) =

 =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-broonie   | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/60a670c03ef2ddc35eb3afb1

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.190=
-424-gbb62732c6c52/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_=
arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.190=
-424-gbb62732c6c52/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_=
arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60a670c03ef2ddc35eb3a=
fb2
        failing since 187 days (last pass: v4.19.157-26-gd59f3161b3a0, firs=
t fail: v4.19.157-27-g5543cc2c41d55) =

 =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-cip       | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/60a670c33ef2ddc35eb3afb5

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.190=
-424-gbb62732c6c52/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-=
versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.190=
-424-gbb62732c6c52/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-=
versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60a670c33ef2ddc35eb3a=
fb6
        failing since 187 days (last pass: v4.19.157-26-gd59f3161b3a0, firs=
t fail: v4.19.157-27-g5543cc2c41d55) =

 =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-collabora | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/60a6705cb6014b51a1b3afca

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.190=
-424-gbb62732c6c52/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qem=
u_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.190=
-424-gbb62732c6c52/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qem=
u_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60a6705cb6014b51a1b3a=
fcb
        failing since 187 days (last pass: v4.19.157-26-gd59f3161b3a0, firs=
t fail: v4.19.157-27-g5543cc2c41d55) =

 =20
