Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5E142311347
	for <lists+stable@lfdr.de>; Fri,  5 Feb 2021 22:18:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232750AbhBEVRN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 5 Feb 2021 16:17:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53194 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233651AbhBEVQq (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 5 Feb 2021 16:16:46 -0500
Received: from mail-pg1-x530.google.com (mail-pg1-x530.google.com [IPv6:2607:f8b0:4864:20::530])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6EDD2C061756
        for <stable@vger.kernel.org>; Fri,  5 Feb 2021 13:16:06 -0800 (PST)
Received: by mail-pg1-x530.google.com with SMTP id o63so5420659pgo.6
        for <stable@vger.kernel.org>; Fri, 05 Feb 2021 13:16:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=fnQNPCLhzVIim04wnTjlXyuBCreCJRyqYZYHye9GNgY=;
        b=baxuPrLU6lWDKNFo78Kha9QH8+MOfXUeNBjY5lWg1y2zWlrHFG7uMoSmcBks8ESfxz
         zNd4m2Ioq3nCVJ6EYhST00eTeAksZaE8dxd/Bv/GRRwiJAHTNgYAX4vMXWrt/m6SiUhi
         JdrYz4PyhDCArZGfEYTvTlBMwfhi8/ZB6LZdgMz/h2w+pV9HES8pEQLflilKi7ZVJL5T
         wvWS3ciOzK8hjPqvboIn3fJ3cp+6ArjSGyrHUTMDPScL/RZ5R6AymXQTE7xXAtZsqIYf
         e9Bfv2G7YBwcp1SZieAVTXeTZus1gFLPvYb1TWVbzS0ngbcIy8HRJP4jGUQXJNshwBkZ
         xKAA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=fnQNPCLhzVIim04wnTjlXyuBCreCJRyqYZYHye9GNgY=;
        b=aZQt8EbIKSMl9ArVBDCpV6jpdPGQXtQiZTkfZ07XNMjy65Ft8K8S0D3wAK7IT2T2DF
         WKOTih7mlr5iEj/Hlyf7BgIq56cZjVm5kgCEPSdziAPNd1ng7XVy5RYgX14kW9fRHekm
         rSOi+k6AKhXSVAOdR9zKexN1PtCiu7kyKAOf893VPwN3P8wOfNL8K3FXylNJJvmCHnXi
         VUbvjGcIIupmLgKkP4qTxM/RllSZabTNHMFQ4iTXf8l/jp/Q414Eo3FmWVJXAswE6AxA
         F1GnrQEAz/y21sfElmR41mq9dbLpoYZKokkGJzPB4EIdZ5R1dESY2ZGtL1QO1gA+Zpkh
         rTpg==
X-Gm-Message-State: AOAM532OF+4nBNLgijurI65MLNO8bYmqBvcBTEu+Ps5bJ+7lt2szx2h5
        54ejS37FMoeuiujlAFUy5Iya3SaMl2/llQ==
X-Google-Smtp-Source: ABdhPJwni/yxGMETWxfeMQTxs8E6pcLfrEhj2XMpjM6VJfY3T8NGHDnQVI42JmL9Y6DZPscPUsrlvA==
X-Received: by 2002:a63:1c13:: with SMTP id c19mr5919063pgc.359.1612559765675;
        Fri, 05 Feb 2021 13:16:05 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id u12sm11045885pgi.91.2021.02.05.13.16.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 05 Feb 2021 13:16:04 -0800 (PST)
Message-ID: <601db594.1c69fb81.e06e9.7f69@mx.google.com>
Date:   Fri, 05 Feb 2021 13:16:04 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v4.14.219-15-g82c6ae41b66a6
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/4.14
Subject: stable-rc/queue/4.14 baseline: 114 runs,
 4 regressions (v4.14.219-15-g82c6ae41b66a6)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.14 baseline: 114 runs, 4 regressions (v4.14.219-15-g82c6a=
e41b66a6)

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
nel/v4.14.219-15-g82c6ae41b66a6/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.14
  Describe: v4.14.219-15-g82c6ae41b66a6
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      82c6ae41b66a61ca6aa565a0bb98fcc46d0dce95 =



Test Regressions
---------------- =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-baylibre  | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/601d82836e137a1a893abe71

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.219=
-15-g82c6ae41b66a6/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu=
_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.219=
-15-g82c6ae41b66a6/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu=
_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/601d82836e137a1a893ab=
e72
        failing since 83 days (last pass: v4.14.206-21-g787a7a3ca16c, first=
 fail: v4.14.206-22-ga949bf40fb01) =

 =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-broonie   | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/601d86091ec3a26f083abf5a

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.219=
-15-g82c6ae41b66a6/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_=
arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.219=
-15-g82c6ae41b66a6/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_=
arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/601d86091ec3a26f083ab=
f5b
        failing since 83 days (last pass: v4.14.206-21-g787a7a3ca16c, first=
 fail: v4.14.206-22-ga949bf40fb01) =

 =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-cip       | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/601d82766e137a1a893abe6d

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.219=
-15-g82c6ae41b66a6/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-=
versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.219=
-15-g82c6ae41b66a6/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-=
versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/601d82766e137a1a893ab=
e6e
        failing since 83 days (last pass: v4.14.206-21-g787a7a3ca16c, first=
 fail: v4.14.206-22-ga949bf40fb01) =

 =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-collabora | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/601d823a0e0a40d7023abe6d

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.219=
-15-g82c6ae41b66a6/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qem=
u_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.219=
-15-g82c6ae41b66a6/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qem=
u_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/601d823a0e0a40d7023ab=
e6e
        failing since 83 days (last pass: v4.14.206-21-g787a7a3ca16c, first=
 fail: v4.14.206-22-ga949bf40fb01) =

 =20
