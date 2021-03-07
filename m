Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B1F68330348
	for <lists+stable@lfdr.de>; Sun,  7 Mar 2021 18:24:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232661AbhCGRYI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 7 Mar 2021 12:24:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39762 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232684AbhCGRXp (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 7 Mar 2021 12:23:45 -0500
Received: from mail-pj1-x1035.google.com (mail-pj1-x1035.google.com [IPv6:2607:f8b0:4864:20::1035])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 084BCC06175F
        for <stable@vger.kernel.org>; Sun,  7 Mar 2021 09:23:45 -0800 (PST)
Received: by mail-pj1-x1035.google.com with SMTP id q2-20020a17090a2e02b02900bee668844dso1695570pjd.3
        for <stable@vger.kernel.org>; Sun, 07 Mar 2021 09:23:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=Cy/c9YfZJwTVN4V77sVv+/C/+CUa5JzlnExXUotZOMM=;
        b=p1GN5AZCWHKjFIabmLYkGxhdfxkDmfpnqNaZ708+7A1hiADEygayVBqCt9/gZYNI10
         siBS1Zb9KOQRfKNz9nv08HuO1wnIC+6klKHspi9m9LTksowGwGMd2FWWw68/bz3hl9YI
         xE1dNiGmwrllIR99k1vGLKFSX7YxvlRc7rAw/6gmXvBxk54gPqSL9lrcYXcuqopsN/jm
         s06mJerAJefev6Pv2Jp5Hr1t4rLsiIMFXjnZ+zBx0K1qdq8/oq1V25FkqmC3zP4AGkTb
         IR4k2pKQC5/VDj6O1RLIXfPkpV7bVsJZ2Bw0yUe07olCSZ8RkPqp/rcirtMGjfeVcTSl
         hv6A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=Cy/c9YfZJwTVN4V77sVv+/C/+CUa5JzlnExXUotZOMM=;
        b=tw4/bMyMD1vhINVY7+twU33EKz2qoXYX5ysVGJKLl6YIteuIOeJ4xdnFLcFXyiBjXA
         XrfX46ZYwmNrUIKnk1bTmNIInJkv0IGEtm+niNZixF2f9a+vBnEVxDhUgF0E1P4UPqUR
         TNfjKcka+7bf6I6RAHBraLJmYpkG3gM5AJ33+rexOEFDISdtcaSzy2OOXMpXHBZN66My
         BG4Zz6KhspRj9sFbLcNue41BnlFjEeinLty8ybzVkOStJOAr/6B4v5fbGm3gMHdnOJH9
         iRZ+ANqQXR/KEkwJW5rL4Bl4aNok4pl7VqQbzE+vcmPSZTgZKbGF7ossBQ9sos0BJpOI
         lGxw==
X-Gm-Message-State: AOAM533+iHD3I2YkpGfaW4LGIT4e8cLmbicVshZyHXQWx5llUYnvjKtp
        EyXhzeLHwUJrQt2MWTfiihM3jdpcCk3rLg==
X-Google-Smtp-Source: ABdhPJxA8nP2CmWK06LY0MqveWNK0Q59RmaUa7qIqC/Gfl0qYNnV2/fAw3WynKYFmqcHykNM+vw8vw==
X-Received: by 2002:a17:90a:ab8b:: with SMTP id n11mr20224589pjq.85.1615137824350;
        Sun, 07 Mar 2021 09:23:44 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id c21sm8093454pgh.0.2021.03.07.09.23.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 07 Mar 2021 09:23:43 -0800 (PST)
Message-ID: <60450c1f.1c69fb81.f15ca.43ed@mx.google.com>
Date:   Sun, 07 Mar 2021 09:23:43 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.4.260
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable
X-Kernelci-Branch: linux-4.4.y
Subject: stable/linux-4.4.y baseline: 107 runs, 12 regressions (v4.4.260)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable/linux-4.4.y baseline: 107 runs, 12 regressions (v4.4.260)

Regressions Summary
-------------------

platform            | arch | lab             | compiler | defconfig        =
  | regressions
--------------------+------+-----------------+----------+------------------=
--+------------
qemu_arm-virt-gicv2 | arm  | lab-baylibre    | gcc-8    | multi_v7_defconfi=
g | 1          =

qemu_arm-virt-gicv2 | arm  | lab-broonie     | gcc-8    | multi_v7_defconfi=
g | 1          =

qemu_arm-virt-gicv2 | arm  | lab-cip         | gcc-8    | multi_v7_defconfi=
g | 1          =

qemu_arm-virt-gicv2 | arm  | lab-collabora   | gcc-8    | multi_v7_defconfi=
g | 1          =

qemu_arm-virt-gicv2 | arm  | lab-linaro-lkft | gcc-8    | multi_v7_defconfi=
g | 1          =

qemu_arm-virt-gicv3 | arm  | lab-baylibre    | gcc-8    | multi_v7_defconfi=
g | 1          =

qemu_arm-virt-gicv3 | arm  | lab-broonie     | gcc-8    | multi_v7_defconfi=
g | 1          =

qemu_arm-virt-gicv3 | arm  | lab-cip         | gcc-8    | multi_v7_defconfi=
g | 1          =

qemu_arm-virt-gicv3 | arm  | lab-collabora   | gcc-8    | multi_v7_defconfi=
g | 1          =

qemu_arm-virt-gicv3 | arm  | lab-linaro-lkft | gcc-8    | multi_v7_defconfi=
g | 1          =

qemu_i386           | i386 | lab-baylibre    | gcc-8    | i386_defconfig   =
  | 1          =

qemu_i386-uefi      | i386 | lab-baylibre    | gcc-8    | i386_defconfig   =
  | 1          =


  Details:  https://kernelci.org/test/job/stable/branch/linux-4.4.y/kernel/=
v4.4.260/plan/baseline/

  Test:     baseline
  Tree:     stable
  Branch:   linux-4.4.y
  Describe: v4.4.260
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able.git
  SHA:      319f66f08de1083c1fe271261665c209009dd65a =



Test Regressions
---------------- =



platform            | arch | lab             | compiler | defconfig        =
  | regressions
--------------------+------+-----------------+----------+------------------=
--+------------
qemu_arm-virt-gicv2 | arm  | lab-baylibre    | gcc-8    | multi_v7_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/6044dcc5b236700ccdaddccd

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable/linux-4.4.y/v4.4.260/ar=
m/multi_v7_defconfig/gcc-8/lab-baylibre/baseline-qemu_arm-virt-gicv2.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.4.y/v4.4.260/ar=
m/multi_v7_defconfig/gcc-8/lab-baylibre/baseline-qemu_arm-virt-gicv2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6044dcc5b236700ccdadd=
cce
        failing since 105 days (last pass: v4.4.243, first fail: v4.4.245) =

 =



platform            | arch | lab             | compiler | defconfig        =
  | regressions
--------------------+------+-----------------+----------+------------------=
--+------------
qemu_arm-virt-gicv2 | arm  | lab-broonie     | gcc-8    | multi_v7_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/6044f939c4a3d584b5addd07

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable/linux-4.4.y/v4.4.260/ar=
m/multi_v7_defconfig/gcc-8/lab-broonie/baseline-qemu_arm-virt-gicv2.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.4.y/v4.4.260/ar=
m/multi_v7_defconfig/gcc-8/lab-broonie/baseline-qemu_arm-virt-gicv2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6044f939c4a3d584b5add=
d08
        failing since 105 days (last pass: v4.4.243, first fail: v4.4.245) =

 =



platform            | arch | lab             | compiler | defconfig        =
  | regressions
--------------------+------+-----------------+----------+------------------=
--+------------
qemu_arm-virt-gicv2 | arm  | lab-cip         | gcc-8    | multi_v7_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/6044f79d494d64fed8addcc3

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable/linux-4.4.y/v4.4.260/ar=
m/multi_v7_defconfig/gcc-8/lab-cip/baseline-qemu_arm-virt-gicv2.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.4.y/v4.4.260/ar=
m/multi_v7_defconfig/gcc-8/lab-cip/baseline-qemu_arm-virt-gicv2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6044f79d494d64fed8add=
cc4
        failing since 105 days (last pass: v4.4.243, first fail: v4.4.245) =

 =



platform            | arch | lab             | compiler | defconfig        =
  | regressions
--------------------+------+-----------------+----------+------------------=
--+------------
qemu_arm-virt-gicv2 | arm  | lab-collabora   | gcc-8    | multi_v7_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/6044d9cb5b56860b21addcc6

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable/linux-4.4.y/v4.4.260/ar=
m/multi_v7_defconfig/gcc-8/lab-collabora/baseline-qemu_arm-virt-gicv2.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.4.y/v4.4.260/ar=
m/multi_v7_defconfig/gcc-8/lab-collabora/baseline-qemu_arm-virt-gicv2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6044d9cb5b56860b21add=
cc7
        failing since 105 days (last pass: v4.4.243, first fail: v4.4.245) =

 =



platform            | arch | lab             | compiler | defconfig        =
  | regressions
--------------------+------+-----------------+----------+------------------=
--+------------
qemu_arm-virt-gicv2 | arm  | lab-linaro-lkft | gcc-8    | multi_v7_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/6044d9cf5b56860b21addcd5

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable/linux-4.4.y/v4.4.260/ar=
m/multi_v7_defconfig/gcc-8/lab-linaro-lkft/baseline-qemu_arm-virt-gicv2.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.4.y/v4.4.260/ar=
m/multi_v7_defconfig/gcc-8/lab-linaro-lkft/baseline-qemu_arm-virt-gicv2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6044d9cf5b56860b21add=
cd6
        failing since 105 days (last pass: v4.4.243, first fail: v4.4.245) =

 =



platform            | arch | lab             | compiler | defconfig        =
  | regressions
--------------------+------+-----------------+----------+------------------=
--+------------
qemu_arm-virt-gicv3 | arm  | lab-baylibre    | gcc-8    | multi_v7_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/6044dccb33250614b3addccc

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable/linux-4.4.y/v4.4.260/ar=
m/multi_v7_defconfig/gcc-8/lab-baylibre/baseline-qemu_arm-virt-gicv3.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.4.y/v4.4.260/ar=
m/multi_v7_defconfig/gcc-8/lab-baylibre/baseline-qemu_arm-virt-gicv3.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6044dccb33250614b3add=
ccd
        failing since 105 days (last pass: v4.4.243, first fail: v4.4.245) =

 =



platform            | arch | lab             | compiler | defconfig        =
  | regressions
--------------------+------+-----------------+----------+------------------=
--+------------
qemu_arm-virt-gicv3 | arm  | lab-broonie     | gcc-8    | multi_v7_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/6044f94e2e9701cef0addcc3

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable/linux-4.4.y/v4.4.260/ar=
m/multi_v7_defconfig/gcc-8/lab-broonie/baseline-qemu_arm-virt-gicv3.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.4.y/v4.4.260/ar=
m/multi_v7_defconfig/gcc-8/lab-broonie/baseline-qemu_arm-virt-gicv3.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6044f94e2e9701cef0add=
cc4
        failing since 105 days (last pass: v4.4.243, first fail: v4.4.245) =

 =



platform            | arch | lab             | compiler | defconfig        =
  | regressions
--------------------+------+-----------------+----------+------------------=
--+------------
qemu_arm-virt-gicv3 | arm  | lab-cip         | gcc-8    | multi_v7_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/6044f8042f1acfa3ebaddcb1

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable/linux-4.4.y/v4.4.260/ar=
m/multi_v7_defconfig/gcc-8/lab-cip/baseline-qemu_arm-virt-gicv3.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.4.y/v4.4.260/ar=
m/multi_v7_defconfig/gcc-8/lab-cip/baseline-qemu_arm-virt-gicv3.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6044f8042f1acfa3ebadd=
cb2
        failing since 105 days (last pass: v4.4.243, first fail: v4.4.245) =

 =



platform            | arch | lab             | compiler | defconfig        =
  | regressions
--------------------+------+-----------------+----------+------------------=
--+------------
qemu_arm-virt-gicv3 | arm  | lab-collabora   | gcc-8    | multi_v7_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/6044d9c85b56860b21addcb7

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable/linux-4.4.y/v4.4.260/ar=
m/multi_v7_defconfig/gcc-8/lab-collabora/baseline-qemu_arm-virt-gicv3.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.4.y/v4.4.260/ar=
m/multi_v7_defconfig/gcc-8/lab-collabora/baseline-qemu_arm-virt-gicv3.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6044d9c85b56860b21add=
cb8
        failing since 105 days (last pass: v4.4.243, first fail: v4.4.245) =

 =



platform            | arch | lab             | compiler | defconfig        =
  | regressions
--------------------+------+-----------------+----------+------------------=
--+------------
qemu_arm-virt-gicv3 | arm  | lab-linaro-lkft | gcc-8    | multi_v7_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/6044d9d0767b9a2f02addcba

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable/linux-4.4.y/v4.4.260/ar=
m/multi_v7_defconfig/gcc-8/lab-linaro-lkft/baseline-qemu_arm-virt-gicv3.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.4.y/v4.4.260/ar=
m/multi_v7_defconfig/gcc-8/lab-linaro-lkft/baseline-qemu_arm-virt-gicv3.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6044d9d0767b9a2f02add=
cbb
        failing since 105 days (last pass: v4.4.243, first fail: v4.4.245) =

 =



platform            | arch | lab             | compiler | defconfig        =
  | regressions
--------------------+------+-----------------+----------+------------------=
--+------------
qemu_i386           | i386 | lab-baylibre    | gcc-8    | i386_defconfig   =
  | 1          =


  Details:     https://kernelci.org/test/plan/id/6044dc38ba54313a7aaddcb1

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: i386_defconfig
  Compiler:    gcc-8 (gcc (Debian 8.3.0-6) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable/linux-4.4.y/v4.4.260/i3=
86/i386_defconfig/gcc-8/lab-baylibre/baseline-qemu_i386.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.4.y/v4.4.260/i3=
86/i386_defconfig/gcc-8/lab-baylibre/baseline-qemu_i386.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/x86/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6044dc38ba54313a7aadd=
cb2
        new failure (last pass: v4.4.256) =

 =



platform            | arch | lab             | compiler | defconfig        =
  | regressions
--------------------+------+-----------------+----------+------------------=
--+------------
qemu_i386-uefi      | i386 | lab-baylibre    | gcc-8    | i386_defconfig   =
  | 1          =


  Details:     https://kernelci.org/test/plan/id/6044dc258e32705523addcc9

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: i386_defconfig
  Compiler:    gcc-8 (gcc (Debian 8.3.0-6) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable/linux-4.4.y/v4.4.260/i3=
86/i386_defconfig/gcc-8/lab-baylibre/baseline-qemu_i386-uefi.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.4.y/v4.4.260/i3=
86/i386_defconfig/gcc-8/lab-baylibre/baseline-qemu_i386-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/x86/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6044dc258e32705523add=
cca
        new failure (last pass: v4.4.256) =

 =20
