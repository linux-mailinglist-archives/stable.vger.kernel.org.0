Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2AB2A309F47
	for <lists+stable@lfdr.de>; Sun, 31 Jan 2021 23:50:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229534AbhAaWuV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 31 Jan 2021 17:50:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53330 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229474AbhAaWuT (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 31 Jan 2021 17:50:19 -0500
Received: from mail-pl1-x629.google.com (mail-pl1-x629.google.com [IPv6:2607:f8b0:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0F384C061573
        for <stable@vger.kernel.org>; Sun, 31 Jan 2021 14:49:38 -0800 (PST)
Received: by mail-pl1-x629.google.com with SMTP id q2so8936208plk.4
        for <stable@vger.kernel.org>; Sun, 31 Jan 2021 14:49:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=ZCMEfvKbZC4PW4J7Df+/VVPbuvpZhuyx/Ke7Zk9P+Qc=;
        b=tmwRlf9GBgCg6bt39OXO6XGs2Y7EXF3gW4XCAaJ52dX6XEM12flVH2dbpnEq0lmdOM
         I0wAPI0qc1zMqj0h3+OZdJoK6VtgNEKG/GLBKT1M92TsDGSaqpCSXdlrJZLduFcfGPht
         nkxqea/tveBEC9/HFMYlAu7efS6d2QQ2HWGt8HjUlNd3cfTYLwUrTBut+s5LKvr6mZkG
         GIwlrR4a9vkhSXh1IxhUkCQTD+lyPjcCxqWHNLmSRbRZ30QDCWV8SEeiiwFLwYLV2gfe
         WRInnml/YThT+BtdiiM+r/tAT17Nd9uU3cYeTbnxc/HT8JlyUBROS5uG7OxyseDeP9eI
         m1sg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=ZCMEfvKbZC4PW4J7Df+/VVPbuvpZhuyx/Ke7Zk9P+Qc=;
        b=b4vNnL1+RhkzDR8i3hWXFop4eWmFv1tasaauyJSS2Mk/cm9JcGzB4yNlHisVZsUMXr
         NQ7I7MTbWTcCzVC9vEhFzd55+XtLVNst2hUWykkJY45tmaiADx42WJP1bAT1QN722q8V
         LwJW22I68mk482ABZOqEEEWJRJ4sVXXle7a7KbO9WlfT+L1DOgVsToQiYXVPS8wk1Gh1
         T5UiFrFXNxZKlhCJYz+iIDlix3kPmw8nl9m574GRsqgi499R0zEzG2Wxqc6Jz0E+nfO8
         WbcChrbVRPBY2+uH94Aqp+xRnlxb7VeHilLlTPWSWOuHQldgc/KkWJrWKk8SFDQB3QrZ
         559g==
X-Gm-Message-State: AOAM530gGRmb9eJzNXt8YyyDL9UZpA9f1CgZmcFq/9Wm7IYex0/qHjKk
        wCFmayO9aLZOIdcbmTNohmQT1qNMPPohwA==
X-Google-Smtp-Source: ABdhPJzJNTSxHJFDmcCHMuqufQOKBG19WYHwyrdDocku5qAIb/LCCdedNtWvShewMXTA5o/COGrxbQ==
X-Received: by 2002:a17:902:ab90:b029:e0:17b:ae98 with SMTP id f16-20020a170902ab90b02900e0017bae98mr15280070plr.6.1612133377245;
        Sun, 31 Jan 2021 14:49:37 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id oa10sm12974526pjb.45.2021.01.31.14.49.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 31 Jan 2021 14:49:36 -0800 (PST)
Message-ID: <60173400.1c69fb81.fc110.f89e@mx.google.com>
Date:   Sun, 31 Jan 2021 14:49:36 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.14.218-6-gd4c2cced9de43
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-4.14.y
Subject: stable-rc/linux-4.14.y baseline: 139 runs,
 8 regressions (v4.14.218-6-gd4c2cced9de43)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.14.y baseline: 139 runs, 8 regressions (v4.14.218-6-gd4c2=
cced9de43)

Regressions Summary
-------------------

platform             | arch   | lab           | compiler | defconfig       =
    | regressions
---------------------+--------+---------------+----------+-----------------=
----+------------
beaglebone-black     | arm    | lab-collabora | gcc-8    | omap2plus_defcon=
fig | 1          =

meson-gxbb-p200      | arm64  | lab-baylibre  | gcc-8    | defconfig       =
    | 1          =

qemu_arm-versatilepb | arm    | lab-baylibre  | gcc-8    | versatile_defcon=
fig | 1          =

qemu_arm-versatilepb | arm    | lab-broonie   | gcc-8    | versatile_defcon=
fig | 1          =

qemu_arm-versatilepb | arm    | lab-cip       | gcc-8    | versatile_defcon=
fig | 1          =

qemu_arm-versatilepb | arm    | lab-collabora | gcc-8    | versatile_defcon=
fig | 1          =

qemu_i386-uefi       | i386   | lab-baylibre  | gcc-8    | i386_defconfig  =
    | 1          =

qemu_x86_64-uefi     | x86_64 | lab-baylibre  | gcc-8    | x86_64_defconfig=
    | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-4.14.y/ker=
nel/v4.14.218-6-gd4c2cced9de43/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-4.14.y
  Describe: v4.14.218-6-gd4c2cced9de43
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      d4c2cced9de43f289f64f7247c037dc016b7949e =



Test Regressions
---------------- =



platform             | arch   | lab           | compiler | defconfig       =
    | regressions
---------------------+--------+---------------+----------+-----------------=
----+------------
beaglebone-black     | arm    | lab-collabora | gcc-8    | omap2plus_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/60171e6716004a8c82d3e057

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
18-6-gd4c2cced9de43/arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-be=
aglebone-black.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
18-6-gd4c2cced9de43/arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-be=
aglebone-black.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60171e6716004a8c82d3e=
058
        new failure (last pass: v4.14.218) =

 =



platform             | arch   | lab           | compiler | defconfig       =
    | regressions
---------------------+--------+---------------+----------+-----------------=
----+------------
meson-gxbb-p200      | arm64  | lab-baylibre  | gcc-8    | defconfig       =
    | 1          =


  Details:     https://kernelci.org/test/plan/id/6017016ca449def219d3dfd7

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
18-6-gd4c2cced9de43/arm64/defconfig/gcc-8/lab-baylibre/baseline-meson-gxbb-=
p200.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
18-6-gd4c2cced9de43/arm64/defconfig/gcc-8/lab-baylibre/baseline-meson-gxbb-=
p200.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6017016ca449def219d3d=
fd8
        failing since 306 days (last pass: v4.14.172-114-g734382e2d26e, fir=
st fail: v4.14.174-131-g234ce78cac23) =

 =



platform             | arch   | lab           | compiler | defconfig       =
    | regressions
---------------------+--------+---------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm    | lab-baylibre  | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/6016febe68dbc10b14d3dfe4

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
18-6-gd4c2cced9de43/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qem=
u_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
18-6-gd4c2cced9de43/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qem=
u_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6016febe68dbc10b14d3d=
fe5
        failing since 78 days (last pass: v4.14.206-21-gf1262f26e4d0, first=
 fail: v4.14.206-23-g520c3568920c8) =

 =



platform             | arch   | lab           | compiler | defconfig       =
    | regressions
---------------------+--------+---------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm    | lab-broonie   | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/6016fece68dbc10b14d3dff2

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
18-6-gd4c2cced9de43/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu=
_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
18-6-gd4c2cced9de43/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu=
_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6016fece68dbc10b14d3d=
ff3
        failing since 78 days (last pass: v4.14.206-21-gf1262f26e4d0, first=
 fail: v4.14.206-23-g520c3568920c8) =

 =



platform             | arch   | lab           | compiler | defconfig       =
    | regressions
---------------------+--------+---------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm    | lab-cip       | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/6016fecaa18001146fd3dfcd

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
18-6-gd4c2cced9de43/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm=
-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
18-6-gd4c2cced9de43/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm=
-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6016fecaa18001146fd3d=
fce
        failing since 78 days (last pass: v4.14.206-21-gf1262f26e4d0, first=
 fail: v4.14.206-23-g520c3568920c8) =

 =



platform             | arch   | lab           | compiler | defconfig       =
    | regressions
---------------------+--------+---------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm    | lab-collabora | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/6016fe7187123319bcd3dff6

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
18-6-gd4c2cced9de43/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qe=
mu_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
18-6-gd4c2cced9de43/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qe=
mu_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6016fe7187123319bcd3d=
ff7
        failing since 78 days (last pass: v4.14.206-21-gf1262f26e4d0, first=
 fail: v4.14.206-23-g520c3568920c8) =

 =



platform             | arch   | lab           | compiler | defconfig       =
    | regressions
---------------------+--------+---------------+----------+-----------------=
----+------------
qemu_i386-uefi       | i386   | lab-baylibre  | gcc-8    | i386_defconfig  =
    | 1          =


  Details:     https://kernelci.org/test/plan/id/6016ff908e0aae6daad3dfff

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: i386_defconfig
  Compiler:    gcc-8 (gcc (Debian 8.3.0-6) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
18-6-gd4c2cced9de43/i386/i386_defconfig/gcc-8/lab-baylibre/baseline-qemu_i3=
86-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
18-6-gd4c2cced9de43/i386/i386_defconfig/gcc-8/lab-baylibre/baseline-qemu_i3=
86-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/x86/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6016ff908e0aae6daad3e=
000
        new failure (last pass: v4.14.218) =

 =



platform             | arch   | lab           | compiler | defconfig       =
    | regressions
---------------------+--------+---------------+----------+-----------------=
----+------------
qemu_x86_64-uefi     | x86_64 | lab-baylibre  | gcc-8    | x86_64_defconfig=
    | 1          =


  Details:     https://kernelci.org/test/plan/id/6016ff434ac60b3940d3dfd3

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig
  Compiler:    gcc-8 (gcc (Debian 8.3.0-6) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
18-6-gd4c2cced9de43/x86_64/x86_64_defconfig/gcc-8/lab-baylibre/baseline-qem=
u_x86_64-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
18-6-gd4c2cced9de43/x86_64/x86_64_defconfig/gcc-8/lab-baylibre/baseline-qem=
u_x86_64-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/x86/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6016ff434ac60b3940d3d=
fd4
        new failure (last pass: v4.14.218) =

 =20
