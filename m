Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3645A339FB1
	for <lists+stable@lfdr.de>; Sat, 13 Mar 2021 19:01:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234010AbhCMSAi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 13 Mar 2021 13:00:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46104 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233951AbhCMSAM (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 13 Mar 2021 13:00:12 -0500
Received: from mail-pj1-x1036.google.com (mail-pj1-x1036.google.com [IPv6:2607:f8b0:4864:20::1036])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F38E0C061574
        for <stable@vger.kernel.org>; Sat, 13 Mar 2021 10:00:11 -0800 (PST)
Received: by mail-pj1-x1036.google.com with SMTP id kk2-20020a17090b4a02b02900c777aa746fso12658251pjb.3
        for <stable@vger.kernel.org>; Sat, 13 Mar 2021 10:00:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=HJvDZn3BkFyMQhVevBi3GRU1+0HLtMmrONHphB6DVPY=;
        b=dTU6Tv5dCGWTt8KyL5cs5ZfiwJGMML1a0/CxJpvMajNb8HlywhwHI6up8DK2tiOJrv
         aANNC3lStX8Gc4UZNn7BctyN9iYAbdZPPyoLvfJn/1plRuIu9J3dO5HjSLYcYM0Q5no4
         rRFKl2bsDaHI2LWeojuIdu1Yq2/6CRU6z0MW8knFw+2o1Oa3vXirMhDyAQJQWsar7w9+
         r1gjF+vAg8oyZ/01CvqvaBtWWyWP/7QgZ128BcRTcJBgixjyYsgBPYG+VQ43UUCUaP8x
         RSac+6bI6MJUIvR28AXe/TANY86bbIpQYkN65dbCQVWwifAO/KBupicyf02DTVa68wB0
         n12Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=HJvDZn3BkFyMQhVevBi3GRU1+0HLtMmrONHphB6DVPY=;
        b=uAsxMSXzrxIMErxlje8CtZ01W76k7TSoFILyh6DwNB/geFuv0VDsCd8Fy/ly8w97rZ
         PKyakRSLrk4XwMU2qGMez9QVGVG2UZIE7aKkFmUspYslUOQgc/oUnqB1jW/l0eNpMRdR
         qdPQmuklYzHURzPBJNe/a/FotxyL+fXQyuiQ+UGJ0CUpjoM1LIPFXQX20hQgLkAXyDAd
         D5XI4jGAlwb5z4KIJA/zi7E+x60rWIVF7jpn+vcGUbIXCR0O0hdKXrepT511mitGdJiy
         NUA/V2ZZGh+LpzoJYjJDMFIQtHQnGMLcQhK9bPRYcgjkJmorslRo0wdajzXjABQk+9Kf
         FXxA==
X-Gm-Message-State: AOAM532jJcT9aqWid/gtiQUzqf1dY0ViNV50XqO/VtoBxdKYqQ3cDrr4
        ySxZ4m8OYInrRqQhdriXh6zb8ndFPZj3MA==
X-Google-Smtp-Source: ABdhPJzL7yMwrX7Pyt/BSS99nf6LKdFBxVDPorQArYT9rA6d2dsB+pICZ+4KpPw9T/M3qkCAH/2ijg==
X-Received: by 2002:a17:90b:4017:: with SMTP id ie23mr4764387pjb.118.1615658411408;
        Sat, 13 Mar 2021 10:00:11 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id 132sm8873860pfu.158.2021.03.13.10.00.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 13 Mar 2021 10:00:11 -0800 (PST)
Message-ID: <604cfdab.1c69fb81.e9479.6780@mx.google.com>
Date:   Sat, 13 Mar 2021 10:00:11 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.14.225-41-g7a2b42eb1464b
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-4.14.y
Subject: stable-rc/linux-4.14.y baseline: 101 runs,
 5 regressions (v4.14.225-41-g7a2b42eb1464b)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.14.y baseline: 101 runs, 5 regressions (v4.14.225-41-g7a2=
b42eb1464b)

Regressions Summary
-------------------

platform             | arch  | lab             | compiler | defconfig      =
     | regressions
---------------------+-------+-----------------+----------+----------------=
-----+------------
fsl-ls2088a-rdb      | arm64 | lab-nxp         | gcc-8    | defconfig      =
     | 1          =

qemu_arm-versatilepb | arm   | lab-broonie     | gcc-8    | versatile_defco=
nfig | 1          =

qemu_arm-versatilepb | arm   | lab-cip         | gcc-8    | versatile_defco=
nfig | 1          =

qemu_arm-versatilepb | arm   | lab-collabora   | gcc-8    | versatile_defco=
nfig | 1          =

qemu_arm-versatilepb | arm   | lab-linaro-lkft | gcc-8    | versatile_defco=
nfig | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-4.14.y/ker=
nel/v4.14.225-41-g7a2b42eb1464b/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-4.14.y
  Describe: v4.14.225-41-g7a2b42eb1464b
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      7a2b42eb1464b1afefcc74381f4bb2b85d168cf7 =



Test Regressions
---------------- =



platform             | arch  | lab             | compiler | defconfig      =
     | regressions
---------------------+-------+-----------------+----------+----------------=
-----+------------
fsl-ls2088a-rdb      | arm64 | lab-nxp         | gcc-8    | defconfig      =
     | 1          =


  Details:     https://kernelci.org/test/plan/id/604ccba5246e8d241daddcb5

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
25-41-g7a2b42eb1464b/arm64/defconfig/gcc-8/lab-nxp/baseline-fsl-ls2088a-rdb=
.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
25-41-g7a2b42eb1464b/arm64/defconfig/gcc-8/lab-nxp/baseline-fsl-ls2088a-rdb=
.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/604ccba5246e8d241dadd=
cb6
        failing since 0 day (last pass: v4.14.225-12-gac6e3f484ce66, first =
fail: v4.14.225-31-g1541031bfb0ff) =

 =



platform             | arch  | lab             | compiler | defconfig      =
     | regressions
---------------------+-------+-----------------+----------+----------------=
-----+------------
qemu_arm-versatilepb | arm   | lab-broonie     | gcc-8    | versatile_defco=
nfig | 1          =


  Details:     https://kernelci.org/test/plan/id/604cc8cb70d98ea01caddcdb

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
25-41-g7a2b42eb1464b/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qem=
u_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
25-41-g7a2b42eb1464b/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qem=
u_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/604cc8cb70d98ea01cadd=
cdc
        failing since 118 days (last pass: v4.14.206-21-gf1262f26e4d0, firs=
t fail: v4.14.206-23-g520c3568920c8) =

 =



platform             | arch  | lab             | compiler | defconfig      =
     | regressions
---------------------+-------+-----------------+----------+----------------=
-----+------------
qemu_arm-versatilepb | arm   | lab-cip         | gcc-8    | versatile_defco=
nfig | 1          =


  Details:     https://kernelci.org/test/plan/id/604cc931cdda7afbe0addccd

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
25-41-g7a2b42eb1464b/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_ar=
m-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
25-41-g7a2b42eb1464b/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_ar=
m-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/604cc931cdda7afbe0add=
cce
        failing since 118 days (last pass: v4.14.206-21-gf1262f26e4d0, firs=
t fail: v4.14.206-23-g520c3568920c8) =

 =



platform             | arch  | lab             | compiler | defconfig      =
     | regressions
---------------------+-------+-----------------+----------+----------------=
-----+------------
qemu_arm-versatilepb | arm   | lab-collabora   | gcc-8    | versatile_defco=
nfig | 1          =


  Details:     https://kernelci.org/test/plan/id/604cc84c628d32700baddcce

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
25-41-g7a2b42eb1464b/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-q=
emu_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
25-41-g7a2b42eb1464b/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-q=
emu_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/604cc84c628d32700badd=
ccf
        failing since 118 days (last pass: v4.14.206-21-gf1262f26e4d0, firs=
t fail: v4.14.206-23-g520c3568920c8) =

 =



platform             | arch  | lab             | compiler | defconfig      =
     | regressions
---------------------+-------+-----------------+----------+----------------=
-----+------------
qemu_arm-versatilepb | arm   | lab-linaro-lkft | gcc-8    | versatile_defco=
nfig | 1          =


  Details:     https://kernelci.org/test/plan/id/604cc85aa8bb0df770addcc7

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
25-41-g7a2b42eb1464b/arm/versatile_defconfig/gcc-8/lab-linaro-lkft/baseline=
-qemu_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
25-41-g7a2b42eb1464b/arm/versatile_defconfig/gcc-8/lab-linaro-lkft/baseline=
-qemu_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/604cc85aa8bb0df770add=
cc8
        failing since 118 days (last pass: v4.14.206-21-gf1262f26e4d0, firs=
t fail: v4.14.206-23-g520c3568920c8) =

 =20
