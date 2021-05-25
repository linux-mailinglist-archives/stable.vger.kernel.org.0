Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B14BE3906FE
	for <lists+stable@lfdr.de>; Tue, 25 May 2021 18:57:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232739AbhEYQ7W (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 25 May 2021 12:59:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52834 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231262AbhEYQ7V (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 25 May 2021 12:59:21 -0400
Received: from mail-pj1-x1029.google.com (mail-pj1-x1029.google.com [IPv6:2607:f8b0:4864:20::1029])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E8E92C061574
        for <stable@vger.kernel.org>; Tue, 25 May 2021 09:57:51 -0700 (PDT)
Received: by mail-pj1-x1029.google.com with SMTP id j6-20020a17090adc86b02900cbfe6f2c96so13533152pjv.1
        for <stable@vger.kernel.org>; Tue, 25 May 2021 09:57:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=eLNvAqjuzsNJiWay6Q0HHXsDCXZFzSLrzl9DGm1lDFE=;
        b=x4YREB/JAmeiNnM1VMRbw+hmyNFp2mAPOt3sXwST+h5nXliZAWZ6dbmeCjv/lTM5PD
         RpqKOHCbPskzc512XE9YI9pZwpcgS0TMW4qny0WwPLwu2h6L+evcgbkUHrMK+IZWxjTZ
         4Uft5rpbKoXWorW9aIxFo7j19N6KWksOFX0okGncyux5m9c4QgGzjrHUx5ENLqGKdfOf
         qLtvfOvy85L2I1yFFH9hI+7A2DYvjQlHolU4dxMOwNnuUcjVTJ3umgasAp+xGh/JsHsm
         TYMJ2hGx0bMpUjXS4Id4FDu015MBJnLdJckj7Rcxd36K/RZfrQhIWe50aphIR3pftFJS
         ErZw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=eLNvAqjuzsNJiWay6Q0HHXsDCXZFzSLrzl9DGm1lDFE=;
        b=JHkiF2u++RPD3lrylzYbMxmS32EYL7C2bUo5hCpPgxx63UYrvRnEWZzr+1Pj0Y1Y8N
         rSdzxFMly/Ixwm5sqf5ArvJa0NUeeWiXtyRIzAyBlXGh4OvyyncJktYArOxJ2HUHAwNM
         S7h3259gabbF6UBfllbc6y8O4nyRRxcH54n9psAmLWe9OwzKl4r4K7rZCuStABIajAQm
         NyL8078VD8+trEF73y763tBB8pnby10+9uDFF7i6HnnvR9Ymhoeqp7dUbxQ5LM5nUxBB
         0+hkL0l4bVpGioG2ZzeZUGNwqFeRpCLJ4+k+4ywn4WysX2VM+42EeLoIMj36rAftxCg8
         reKA==
X-Gm-Message-State: AOAM531I7UMAN8E6+3LtHDiJNyBOLi0EWBiScyYIhO0DWnrWJuzqoBGZ
        6ThG6z5SaFQh0/Q3Y+JjXbBriur7vZ3uTdMd
X-Google-Smtp-Source: ABdhPJytW+TFMH5jWV/BW6QU0JRDHcv2q06IoxJ9z5NH+Iv7KQZd4k6K9Uf6nrTHtkRqBN9UerQtKA==
X-Received: by 2002:a17:90a:f0d2:: with SMTP id fa18mr5806956pjb.126.1621961871244;
        Tue, 25 May 2021 09:57:51 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id w197sm13705825pfc.5.2021.05.25.09.57.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 25 May 2021 09:57:48 -0700 (PDT)
Message-ID: <60ad2c8c.1c69fb81.e821d.c866@mx.google.com>
Date:   Tue, 25 May 2021 09:57:48 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v4.14.233-36-g430fdf2aba8d
X-Kernelci-Branch: queue/4.14
X-Kernelci-Report-Type: test
Subject: stable-rc/queue/4.14 baseline: 105 runs,
 4 regressions (v4.14.233-36-g430fdf2aba8d)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.14 baseline: 105 runs, 4 regressions (v4.14.233-36-g430fd=
f2aba8d)

Regressions Summary
-------------------

platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-broonie     | gcc-8    | versatile_defcon=
fig | 1          =

qemu_arm-versatilepb | arm  | lab-cip         | gcc-8    | versatile_defcon=
fig | 1          =

qemu_arm-versatilepb | arm  | lab-collabora   | gcc-8    | versatile_defcon=
fig | 1          =

qemu_arm-versatilepb | arm  | lab-linaro-lkft | gcc-8    | versatile_defcon=
fig | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.14/ker=
nel/v4.14.233-36-g430fdf2aba8d/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.14
  Describe: v4.14.233-36-g430fdf2aba8d
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      430fdf2aba8d343815b3b9c9b47882c939939a6d =



Test Regressions
---------------- =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-broonie     | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/60acf603e72707c733b3afa2

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.233=
-36-g430fdf2aba8d/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_a=
rm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.233=
-36-g430fdf2aba8d/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_a=
rm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60acf603e72707c733b3a=
fa3
        failing since 192 days (last pass: v4.14.206-21-g787a7a3ca16c, firs=
t fail: v4.14.206-22-ga949bf40fb01) =

 =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-cip         | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/60acf6060200b11dceb3afc1

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.233=
-36-g430fdf2aba8d/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-v=
ersatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.233=
-36-g430fdf2aba8d/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-v=
ersatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60acf6060200b11dceb3a=
fc2
        failing since 192 days (last pass: v4.14.206-21-g787a7a3ca16c, firs=
t fail: v4.14.206-22-ga949bf40fb01) =

 =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-collabora   | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/60acf6030200b11dceb3afad

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.233=
-36-g430fdf2aba8d/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu=
_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.233=
-36-g430fdf2aba8d/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu=
_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60acf6030200b11dceb3a=
fae
        failing since 192 days (last pass: v4.14.206-21-g787a7a3ca16c, firs=
t fail: v4.14.206-22-ga949bf40fb01) =

 =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-linaro-lkft | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/60acf5c6a608f58924b3afb7

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.233=
-36-g430fdf2aba8d/arm/versatile_defconfig/gcc-8/lab-linaro-lkft/baseline-qe=
mu_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.233=
-36-g430fdf2aba8d/arm/versatile_defconfig/gcc-8/lab-linaro-lkft/baseline-qe=
mu_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60acf5c6a608f58924b3a=
fb8
        failing since 192 days (last pass: v4.14.206-21-g787a7a3ca16c, firs=
t fail: v4.14.206-22-ga949bf40fb01) =

 =20
