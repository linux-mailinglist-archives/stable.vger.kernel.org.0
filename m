Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3A31D37ED98
	for <lists+stable@lfdr.de>; Thu, 13 May 2021 00:42:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1387797AbhELUkF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 May 2021 16:40:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39258 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1377986AbhELTKC (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 12 May 2021 15:10:02 -0400
Received: from mail-pf1-x42f.google.com (mail-pf1-x42f.google.com [IPv6:2607:f8b0:4864:20::42f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 164E9C061760
        for <stable@vger.kernel.org>; Wed, 12 May 2021 12:08:53 -0700 (PDT)
Received: by mail-pf1-x42f.google.com with SMTP id 10so19453542pfl.1
        for <stable@vger.kernel.org>; Wed, 12 May 2021 12:08:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=DU/GXXnEj8t9bLrF9zeZnV3HfSJiLDw5nQr4DFMjO4E=;
        b=X7LNfXdjWLNreDLelVDC/DC5duvlHW8TYuf8hBhVwx33M4ElI8t/lrQ9XoylNJdmZM
         Fp31H6qJoerw5IioWJ1D8ofNgrEN9mgeFAXt37vzQYNm66lLPlX4804BGu6EY6YrBsnJ
         xRY6Yob5dOe9kpPJGvvfQCYNX1Q56MRbVAFyvH6pnNn4K3NSytYQc4yhE8i7bbD6eGFf
         +qBwlSN/zB1ZMIt+3Sr39uNowb3fYR3CtlsgyIsm96MtebM/40sfuvIkVtn/S6KvPZA4
         tNH4TKWRP2kC+KD899IElFSv5rvCjf8JQukUjbq/OpQbG6LEX6l1nAxKA6pDq6DEIViK
         +vMg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=DU/GXXnEj8t9bLrF9zeZnV3HfSJiLDw5nQr4DFMjO4E=;
        b=cCkba6Y/9b70dtzGieNTCgfpS8FPsV1ed4KErMgEGud0MQ8dBUKCKJcDIPKYrnNXFb
         NeISu0e9o0Duas0A/jY6V+H6XhZgczjvwHJQ0rkciGsws1HA9xzLRCzR+6tHvKN8fh6h
         apwpx1cKYB6v60m1gtardmTTm6wP4O0K8F+CHtkcstOlLNeg70q/XNwgYVJzrD0MBjGy
         j294B/y22cb0jxSJvqRyeqrimAWzGI8X+1fVzDGzVY1a7Y4kbFqtP3mdv0mi4D+Zgkax
         Bnsf6W/naWl8FputELKVPXv5FbiU5aReDWIpRz8QiLn24Vm/BQFCjvrSzbmJCNVrPNPn
         pSfw==
X-Gm-Message-State: AOAM531+7SDuuuEpxKNj+K68vqdi05gI+kJd6a4FuwzTskKH2GpzzSj9
        dt1HObTkiYY8NrHo18+AaXVyVFFdEYmuxHvZ
X-Google-Smtp-Source: ABdhPJwS98nhUIfSXD+cGOZfC4qOvOVXOarW0DJU7BteYs7TesowqDzyvPqE810sWkte3a/eYHfKkw==
X-Received: by 2002:a65:48c2:: with SMTP id o2mr36754282pgs.376.1620846533363;
        Wed, 12 May 2021 12:08:53 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id 23sm487668pfz.91.2021.05.12.12.08.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 12 May 2021 12:08:53 -0700 (PDT)
Message-ID: <609c27c5.1c69fb81.2f0d2.2016@mx.google.com>
Date:   Wed, 12 May 2021 12:08:53 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v4.19.190-302-gc1569a843d627
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/4.19
Subject: stable-rc/queue/4.19 baseline: 144 runs,
 4 regressions (v4.19.190-302-gc1569a843d627)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.19 baseline: 144 runs, 4 regressions (v4.19.190-302-gc156=
9a843d627)

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
nel/v4.19.190-302-gc1569a843d627/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.19
  Describe: v4.19.190-302-gc1569a843d627
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      c1569a843d627f4e832be80738d3ce6bc16dc87f =



Test Regressions
---------------- =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-baylibre  | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/609bee81a1ffc3fe6c19929a

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.190=
-302-gc1569a843d627/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qem=
u_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.190=
-302-gc1569a843d627/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qem=
u_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/609bee81a1ffc3fe6c199=
29b
        failing since 179 days (last pass: v4.19.157-26-gd59f3161b3a0, firs=
t fail: v4.19.157-27-g5543cc2c41d55) =

 =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-broonie   | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/609bee7df7ec8ff0af199280

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.190=
-302-gc1569a843d627/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu=
_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.190=
-302-gc1569a843d627/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu=
_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/609bee7df7ec8ff0af199=
281
        failing since 179 days (last pass: v4.19.157-26-gd59f3161b3a0, firs=
t fail: v4.19.157-27-g5543cc2c41d55) =

 =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-cip       | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/609bee9a0738063b0519928c

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.190=
-302-gc1569a843d627/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm=
-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.190=
-302-gc1569a843d627/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm=
-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/609bee9a0738063b05199=
28d
        failing since 179 days (last pass: v4.19.157-26-gd59f3161b3a0, firs=
t fail: v4.19.157-27-g5543cc2c41d55) =

 =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-collabora | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/609bee36d60e50ad65199286

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.190=
-302-gc1569a843d627/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qe=
mu_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.190=
-302-gc1569a843d627/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qe=
mu_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/609bee36d60e50ad65199=
287
        failing since 179 days (last pass: v4.19.157-26-gd59f3161b3a0, firs=
t fail: v4.19.157-27-g5543cc2c41d55) =

 =20
