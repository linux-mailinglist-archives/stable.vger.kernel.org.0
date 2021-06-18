Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D42BF3AD4DE
	for <lists+stable@lfdr.de>; Sat, 19 Jun 2021 00:11:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234876AbhFRWNW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 18 Jun 2021 18:13:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37120 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234870AbhFRWNV (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 18 Jun 2021 18:13:21 -0400
Received: from mail-pj1-x1031.google.com (mail-pj1-x1031.google.com [IPv6:2607:f8b0:4864:20::1031])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 84506C061574
        for <stable@vger.kernel.org>; Fri, 18 Jun 2021 15:11:11 -0700 (PDT)
Received: by mail-pj1-x1031.google.com with SMTP id pf4-20020a17090b1d84b029016f6699c3f2so1650393pjb.0
        for <stable@vger.kernel.org>; Fri, 18 Jun 2021 15:11:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=HbZPAy2RHwzQW6M3FtEp1UP9msijutcTH/Wd46UuVUk=;
        b=EATAwbICQbtBAVT8aDRY54fmt1kSU5wtTs2qEgHjk/Yj54bMOKSJpmA3R2HjJGGdXZ
         2hDP7XmMVMbIJJqqJqv/cg3mIVBokPWp8RXCDBg02GdTRqKFmwozMBUq9cte3Arwk8xy
         891sykGoTSxMUsE4UhAzrjHZWKoNHXUX3umRqIWcSAEdduEojcowqNGfkG+AMQxmc5FK
         AnDndPP+zC9cwb3ZGjQRmU+lXbALPPxesKrr9Fl5mQSgilUdf28HFEu50AHsYZed+NRG
         +hOJZNilr1qt64z1NYJlR2BHVGzlQU2urYMgb6zrYHOGsyGkxByu5UUCUUkRJzfcZzqj
         8A9w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=HbZPAy2RHwzQW6M3FtEp1UP9msijutcTH/Wd46UuVUk=;
        b=E849BJeLCwwAHKvJim67D8uRVIHPGjma30OtDub6sUSdDvRDIrV6cGBNlgS4kgMFpq
         dkUO18wy0yPaSqhMOVgbzByWzjap9KrUChxhypGzKqnDp2GMtola2nGP8KoQyRfmr6yf
         bCVDjpo6Px3ZOtJhpUrifcFXGI7PEGUINY/Zw+sXG0A73uBTQRwchOOQ7mNkO05Rfn6u
         F+OcmPFlW7zsTMW81FzAsgNvBg7GmEyfcLloHoITrB+d6F1xyoijoT/NgiMCJIS733iP
         DaisuRpqT2i1Xalk7FQ3eqbdqW/yIxjl1jJSIAd1AgBkDDf9c1HCmT/Pm98+blDcDFPK
         wgxA==
X-Gm-Message-State: AOAM531s9YpNT8ZKMbjHFJVhD57y2YfIdtLoIqhb5ypZPkQ+a5n3+3N8
        npREae/Fb3Rnvrddttdt1Jc78wNwWp5c8tmi
X-Google-Smtp-Source: ABdhPJw2zkDAmhPHs/IdtYtCUDiVGErCMqlzGGhjaaR3igKULy/ACF4/Hm9qyQYj0cK23AUEH8lPuw==
X-Received: by 2002:a17:90a:6001:: with SMTP id y1mr23208467pji.5.1624054270807;
        Fri, 18 Jun 2021 15:11:10 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id 76sm8750475pfy.82.2021.06.18.15.11.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 18 Jun 2021 15:11:10 -0700 (PDT)
Message-ID: <60cd19fe.1c69fb81.e16b9.8338@mx.google.com>
Date:   Fri, 18 Jun 2021 15:11:10 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v4.9.273-19-gafb7b9c97ade
X-Kernelci-Branch: queue/4.9
X-Kernelci-Tree: stable-rc
Subject: stable-rc/queue/4.9 baseline: 111 runs,
 4 regressions (v4.9.273-19-gafb7b9c97ade)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.9 baseline: 111 runs, 4 regressions (v4.9.273-19-gafb7b9c=
97ade)

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

qemu_arm-versatilepb | arm  | lab-linaro-lkft | gcc-8    | versatile_defcon=
fig | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.9/kern=
el/v4.9.273-19-gafb7b9c97ade/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.9
  Describe: v4.9.273-19-gafb7b9c97ade
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      afb7b9c97adeffc2324be4c0b8317ad4ff713578 =



Test Regressions
---------------- =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-baylibre    | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/60cce07b4ea821cdae413281

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.273-1=
9-gafb7b9c97ade/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_ar=
m-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.273-1=
9-gafb7b9c97ade/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_ar=
m-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60cce07b4ea821cdae413=
282
        failing since 216 days (last pass: v4.9.243-16-gd8d67e375b0a, first=
 fail: v4.9.243-25-ga01fe8e99a22) =

 =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-broonie     | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/60ccec00bb30fe5ca2413266

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.273-1=
9-gafb7b9c97ade/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_arm=
-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.273-1=
9-gafb7b9c97ade/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_arm=
-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60ccec00bb30fe5ca2413=
267
        failing since 216 days (last pass: v4.9.243-16-gd8d67e375b0a, first=
 fail: v4.9.243-25-ga01fe8e99a22) =

 =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-cip         | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/60cce05d0c97bf94f4413274

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.273-1=
9-gafb7b9c97ade/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-ver=
satilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.273-1=
9-gafb7b9c97ade/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-ver=
satilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60cce05d0c97bf94f4413=
275
        failing since 216 days (last pass: v4.9.243-16-gd8d67e375b0a, first=
 fail: v4.9.243-25-ga01fe8e99a22) =

 =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-linaro-lkft | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/60cd16a32cc40810dc41327b

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.273-1=
9-gafb7b9c97ade/arm/versatile_defconfig/gcc-8/lab-linaro-lkft/baseline-qemu=
_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.273-1=
9-gafb7b9c97ade/arm/versatile_defconfig/gcc-8/lab-linaro-lkft/baseline-qemu=
_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60cd16a32cc40810dc413=
27c
        failing since 216 days (last pass: v4.9.243-16-gd8d67e375b0a, first=
 fail: v4.9.243-25-ga01fe8e99a22) =

 =20
