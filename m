Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 096A73E899D
	for <lists+stable@lfdr.de>; Wed, 11 Aug 2021 07:16:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234112AbhHKFQz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 11 Aug 2021 01:16:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40826 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233813AbhHKFQz (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 11 Aug 2021 01:16:55 -0400
Received: from mail-pl1-x62a.google.com (mail-pl1-x62a.google.com [IPv6:2607:f8b0:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 133ACC061765
        for <stable@vger.kernel.org>; Tue, 10 Aug 2021 22:15:57 -0700 (PDT)
Received: by mail-pl1-x62a.google.com with SMTP id k2so1122081plk.13
        for <stable@vger.kernel.org>; Tue, 10 Aug 2021 22:15:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=OkvkyGB0lcDKwUU5v25nv/Zvf7JkNMByZm3VYOaQxUA=;
        b=er0XxDMRpfkOSUr7t20PtRvxiSwdMPQVFiw0O3AbSTirPJkpGu/3965XiXlgOQaFP2
         xp8ffDYvpE0hbCJmaAcXqGqZOM1h6eyG9/NMmT8G9BU0vo+8J0PmA98LkTFJUZZnQbgz
         cx0qaAjaDI10y5cLyABpchd2o9QAF6xlqHYFZ3DzMrFnrXLiuF6T1hLg5fIw9QcbsESU
         3K8/kfiq97qlWO1VUUg8MNgXsG/dKKmE6djs9vZHKMmuCDg3wL8oyHaJ23WUHm319ZQu
         +Wps32pajw5vpGnBpBPH2f0SHzEzW1shpscZLpqqWljH3kxW7A+qcO9kqiLoSyzdJza/
         yYGA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=OkvkyGB0lcDKwUU5v25nv/Zvf7JkNMByZm3VYOaQxUA=;
        b=juVIiIz+1RcqCvI6GxfaHthw/vaKkw1rRupDaGpe3CdbTQTRGXz8LLn3RAy8lGDcF8
         BGzh+kE92dLGmkcMBAmNhlxYx2asNAqIHVUAB9UHz4D9qU9oz+si+UrWIR91ofFs33gg
         WlBz3IOnGeSov3C9dGFmKaXfYN/zSQDm0ZGOSC6MwR+a1OdKJ8gM6ObZv3B7AaWT1NEx
         dJXccypk23M0Pj4HWWVZtsw14BC4amFvkC6bbOon08bnZT/r3RalMrfpSAuiyC5YECVM
         zqY3b/I/0oJI1x7ivovn4tknT2zvYrOs519O/AQ/z2btXaCh5vD8ESH4W/9ykkm+7NZS
         ybZA==
X-Gm-Message-State: AOAM530ttlQEoKbXvRkp95/eBBQUcPE8qpIzH9Y6Kfa3b1VghBoePJeu
        Fuh2PS2xVo/j3RBVXfOLoDrmMHH6f9PO011F
X-Google-Smtp-Source: ABdhPJyLEC8ywy8SgO6qusq/CHEvM60FlBJ2F49EQReuaCLXREdfdSc1xP6M0vha9b7Gi1mTXmXQzQ==
X-Received: by 2002:a17:90b:4ad1:: with SMTP id mh17mr35256881pjb.164.1628658956477;
        Tue, 10 Aug 2021 22:15:56 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id p30sm13800054pfh.116.2021.08.10.22.15.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 10 Aug 2021 22:15:56 -0700 (PDT)
Message-ID: <61135d0c.1c69fb81.2fed1.6bc5@mx.google.com>
Date:   Tue, 10 Aug 2021 22:15:56 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: linux-4.9.y
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v4.9.279-27-gb2ca234bf356
X-Kernelci-Report-Type: test
Subject: stable-rc/linux-4.9.y baseline: 103 runs,
 4 regressions (v4.9.279-27-gb2ca234bf356)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.9.y baseline: 103 runs, 4 regressions (v4.9.279-27-gb2ca2=
34bf356)

Regressions Summary
-------------------

platform             | arch  | lab           | compiler | defconfig        =
   | regressions
---------------------+-------+---------------+----------+------------------=
---+------------
qemu_arm-versatilepb | arm   | lab-baylibre  | gcc-8    | versatile_defconf=
ig | 1          =

qemu_arm-versatilepb | arm   | lab-broonie   | gcc-8    | versatile_defconf=
ig | 1          =

qemu_arm-versatilepb | arm   | lab-collabora | gcc-8    | versatile_defconf=
ig | 1          =

r8a7795-salvator-x   | arm64 | lab-baylibre  | gcc-8    | defconfig        =
   | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-4.9.y/kern=
el/v4.9.279-27-gb2ca234bf356/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-4.9.y
  Describe: v4.9.279-27-gb2ca234bf356
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      b2ca234bf356f99610158f5b5c9b0df65738e9f8 =



Test Regressions
---------------- =



platform             | arch  | lab           | compiler | defconfig        =
   | regressions
---------------------+-------+---------------+----------+------------------=
---+------------
qemu_arm-versatilepb | arm   | lab-baylibre  | gcc-8    | versatile_defconf=
ig | 1          =


  Details:     https://kernelci.org/test/plan/id/61132823808705d6deb13783

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.279=
-27-gb2ca234bf356/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_=
arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.279=
-27-gb2ca234bf356/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_=
arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61132823808705d6deb13=
784
        failing since 269 days (last pass: v4.9.243-17-g9c24315b745a0, firs=
t fail: v4.9.243-26-g7b603f689c1c) =

 =



platform             | arch  | lab           | compiler | defconfig        =
   | regressions
---------------------+-------+---------------+----------+------------------=
---+------------
qemu_arm-versatilepb | arm   | lab-broonie   | gcc-8    | versatile_defconf=
ig | 1          =


  Details:     https://kernelci.org/test/plan/id/61132826808705d6deb13790

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.279=
-27-gb2ca234bf356/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_a=
rm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.279=
-27-gb2ca234bf356/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_a=
rm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61132826808705d6deb13=
791
        failing since 269 days (last pass: v4.9.243-17-g9c24315b745a0, firs=
t fail: v4.9.243-26-g7b603f689c1c) =

 =



platform             | arch  | lab           | compiler | defconfig        =
   | regressions
---------------------+-------+---------------+----------+------------------=
---+------------
qemu_arm-versatilepb | arm   | lab-collabora | gcc-8    | versatile_defconf=
ig | 1          =


  Details:     https://kernelci.org/test/plan/id/611327c3f565138e93b13680

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.279=
-27-gb2ca234bf356/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu=
_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.279=
-27-gb2ca234bf356/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu=
_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/611327c3f565138e93b13=
681
        failing since 269 days (last pass: v4.9.243-17-g9c24315b745a0, firs=
t fail: v4.9.243-26-g7b603f689c1c) =

 =



platform             | arch  | lab           | compiler | defconfig        =
   | regressions
---------------------+-------+---------------+----------+------------------=
---+------------
r8a7795-salvator-x   | arm64 | lab-baylibre  | gcc-8    | defconfig        =
   | 1          =


  Details:     https://kernelci.org/test/plan/id/611329785616b8b351b13661

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.279=
-27-gb2ca234bf356/arm64/defconfig/gcc-8/lab-baylibre/baseline-r8a7795-salva=
tor-x.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.279=
-27-gb2ca234bf356/arm64/defconfig/gcc-8/lab-baylibre/baseline-r8a7795-salva=
tor-x.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/611329785616b8b351b13=
662
        failing since 265 days (last pass: v4.9.243-17-g9c24315b745a0, firs=
t fail: v4.9.243-79-gd3e70b39d31a) =

 =20
