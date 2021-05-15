Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C210438196F
	for <lists+stable@lfdr.de>; Sat, 15 May 2021 16:53:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231795AbhEOOy4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 15 May 2021 10:54:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35262 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231386AbhEOOyy (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 15 May 2021 10:54:54 -0400
Received: from mail-pg1-x529.google.com (mail-pg1-x529.google.com [IPv6:2607:f8b0:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 101F3C061573
        for <stable@vger.kernel.org>; Sat, 15 May 2021 07:53:40 -0700 (PDT)
Received: by mail-pg1-x529.google.com with SMTP id y32so1385698pga.11
        for <stable@vger.kernel.org>; Sat, 15 May 2021 07:53:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=JxSDtOJaDd2tpjHDURtHI8UXfV+YMthluHZukhrxkQc=;
        b=a4oRkPJe0gv2nbnnhhVS8qXkIN9p0iiEitkGZlDx+b0QhzrQ3AseGvP03vnTRUuyz4
         oxE8M2zzTp9JfsNfMZ0EOiBhpEyav4ruryChuowSFRJY/Ow4gGjwG/Gq4oKnd88IcXPi
         tityN6JM4mt9YYRcm+GfeqSvadkRcbRmodxr8a4XQ+ervjDzQ4x74z318oXjpwepndZG
         N42B5F1EKJ0nPEtIbKlbEVOakcfbciABWHlyaNSLAABQ96bk9oOH+PUdB+dTHQ/iHBPT
         srEYN22+cC/nOcaWkshow8I3FvvR5ZjJfEjFVcCmWLwxV+p887NioAYugZrPG3SLks0M
         w2ig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=JxSDtOJaDd2tpjHDURtHI8UXfV+YMthluHZukhrxkQc=;
        b=by4HKDPU2+gSDs4AEb2MJmZzw3VJE4emB1Un6JWnBu1GxdaGd00Ny4zgr0xFcCGLwy
         b7AKcf9MC2kmLIS8477BXtMohjXxvE4VJ68ubLj6ZlAbmse6gfvK4KtTKQst8WSxSq92
         JcZ/cOmniaaeyLUwA8hKq5STJux4lX3dDn++6uBGP91d7/TVq1J9XIi7+/2mKEKLf5AR
         IAIs/jP1ZGJEeu8VuAuCGtzFX4RQ5bqgq3UzEnwNz17yQsMA1tWOY7kGgKa2nzY3put+
         tj1eY1cIPSOOSYKRtSe7TFqu1VM/Q/SO4CHqS0zx5A3/dGGHbjyCA+Kwm9TJ8vI/rcf5
         tU7w==
X-Gm-Message-State: AOAM532QxuDTbl2WuF+Lu3dvo+iwLiPkawwodv5J54IGNpoXilD0yD27
        6F8kPyJys4UF9V4wIvJbKVKrb6cncI9X5Z70
X-Google-Smtp-Source: ABdhPJze4Rw4i7FwXNeIWwAFrI5hx4h+WureKVTPJ5QXLY3if597M5M3k93ReTA7q7A/bIqClg5s9A==
X-Received: by 2002:a62:2fc6:0:b029:28e:854b:20b3 with SMTP id v189-20020a622fc60000b029028e854b20b3mr51442566pfv.0.1621090419427;
        Sat, 15 May 2021 07:53:39 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id x133sm6440692pfc.19.2021.05.15.07.53.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 15 May 2021 07:53:39 -0700 (PDT)
Message-ID: <609fe073.1c69fb81.f274f.6176@mx.google.com>
Date:   Sat, 15 May 2021 07:53:39 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v4.9.268-205-g878b0a588fca
X-Kernelci-Branch: linux-4.9.y
X-Kernelci-Report-Type: test
Subject: stable-rc/linux-4.9.y baseline: 72 runs,
 4 regressions (v4.9.268-205-g878b0a588fca)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.9.y baseline: 72 runs, 4 regressions (v4.9.268-205-g878b0=
a588fca)

Regressions Summary
-------------------

platform             | arch  | lab          | compiler | defconfig         =
  | regressions
---------------------+-------+--------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm   | lab-baylibre | gcc-8    | versatile_defconfi=
g | 1          =

qemu_arm-versatilepb | arm   | lab-broonie  | gcc-8    | versatile_defconfi=
g | 1          =

qemu_arm-versatilepb | arm   | lab-cip      | gcc-8    | versatile_defconfi=
g | 1          =

r8a7795-salvator-x   | arm64 | lab-baylibre | gcc-8    | defconfig         =
  | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-4.9.y/kern=
el/v4.9.268-205-g878b0a588fca/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-4.9.y
  Describe: v4.9.268-205-g878b0a588fca
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      878b0a588fca1ff151ac805a94e7a3725d8c8800 =



Test Regressions
---------------- =



platform             | arch  | lab          | compiler | defconfig         =
  | regressions
---------------------+-------+--------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm   | lab-baylibre | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/609fab69974a371532b3afc3

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.268=
-205-g878b0a588fca/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu=
_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.268=
-205-g878b0a588fca/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu=
_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/609fab69974a371532b3a=
fc4
        failing since 181 days (last pass: v4.9.243-17-g9c24315b745a0, firs=
t fail: v4.9.243-26-g7b603f689c1c) =

 =



platform             | arch  | lab          | compiler | defconfig         =
  | regressions
---------------------+-------+--------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm   | lab-broonie  | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/609fab6d313d81c3f0b3afb1

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.268=
-205-g878b0a588fca/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_=
arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.268=
-205-g878b0a588fca/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_=
arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/609fab6d313d81c3f0b3a=
fb2
        failing since 181 days (last pass: v4.9.243-17-g9c24315b745a0, firs=
t fail: v4.9.243-26-g7b603f689c1c) =

 =



platform             | arch  | lab          | compiler | defconfig         =
  | regressions
---------------------+-------+--------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm   | lab-cip      | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/609fab5d313d81c3f0b3afa8

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.268=
-205-g878b0a588fca/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-=
versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.268=
-205-g878b0a588fca/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-=
versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/609fab5d313d81c3f0b3a=
fa9
        failing since 181 days (last pass: v4.9.243-17-g9c24315b745a0, firs=
t fail: v4.9.243-26-g7b603f689c1c) =

 =



platform             | arch  | lab          | compiler | defconfig         =
  | regressions
---------------------+-------+--------------+----------+-------------------=
--+------------
r8a7795-salvator-x   | arm64 | lab-baylibre | gcc-8    | defconfig         =
  | 1          =


  Details:     https://kernelci.org/test/plan/id/609facf9863a390fc3b3af9c

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.268=
-205-g878b0a588fca/arm64/defconfig/gcc-8/lab-baylibre/baseline-r8a7795-salv=
ator-x.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.268=
-205-g878b0a588fca/arm64/defconfig/gcc-8/lab-baylibre/baseline-r8a7795-salv=
ator-x.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/609facf9863a390fc3b3a=
f9d
        failing since 178 days (last pass: v4.9.243-17-g9c24315b745a0, firs=
t fail: v4.9.243-79-gd3e70b39d31a) =

 =20
