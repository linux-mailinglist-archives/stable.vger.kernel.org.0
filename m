Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B59213A7C00
	for <lists+stable@lfdr.de>; Tue, 15 Jun 2021 12:33:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231443AbhFOKfI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 15 Jun 2021 06:35:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40330 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231428AbhFOKfH (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 15 Jun 2021 06:35:07 -0400
Received: from mail-pl1-x62b.google.com (mail-pl1-x62b.google.com [IPv6:2607:f8b0:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ACAEAC061574
        for <stable@vger.kernel.org>; Tue, 15 Jun 2021 03:33:02 -0700 (PDT)
Received: by mail-pl1-x62b.google.com with SMTP id e1so8229224pld.13
        for <stable@vger.kernel.org>; Tue, 15 Jun 2021 03:33:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=grBMMqhOdJltvEu1iTjBglVQI8fKxQLDe+/qH10eFrg=;
        b=DfvVkto6tMbdd1008MyWl/yGNqtPAjnlfYw0WMifhC8c8YZy9IvcrYfQ/SNrXHQ5kv
         W+RbUJuK117NbyGvvJWeERXVN32q4IgrH/MZkL2Lfof+ap7MM6mXvnGjTzn71Ik5HzWg
         iDJo0yNnAflXS+y14NbcZhgS8S3yAlCLtHPMYQlBtiycyLQBPqKe3Ry2ZyBAtUiD5oaa
         cT16ZvVcIZo+kfTx+dqakGYh/Ber5DOmJlH5X5BmHK6RP4ChNq3M/FTsdm8KolxwtCMs
         OB9ksHpFktkbI+L4aQmAp0ZSX/lbf07bH6cYs1DJmT66Xg8qu2lSedkij+Q7fTCeS3+8
         gTBg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=grBMMqhOdJltvEu1iTjBglVQI8fKxQLDe+/qH10eFrg=;
        b=mZ4IZ0l+Ovi/UW8RtUghAo/7ooR8lzgrUkXk/H2lDT/tFLsoL8lVTT3kanbQ/takJN
         KQpT1+2/I59hWRUxsC5V+JmDELMMpu5VyXbmeSE8sTfjsWtOR3Wmo8QlclieuDfo5nB1
         eCnpAgQaojcvJH8PrPprUj9s42nqX1jyZ0OwHeltqjX3YKFI67sE26c9cwK5nkLZCGXb
         UbZHrSpXKz5XZYaZYo1LsBv0e5wcenBieUhDbCOULQxCrkU+qHbo3GyvwwZvSrZmiRYX
         HivmgJuKdvTdkhnkFsF4knOGXvapdyX02OBujNjqM3awnjNO98MEn5GdjHOQoj/P4Dcd
         JOZg==
X-Gm-Message-State: AOAM53268sJqkdDajskrwNnJ5YUeroCSd/zxE5yVhrA1/gCiQFndCJuu
        /KPRyuWnDyYUXg/r/qf2ahLseBdPCzHucg==
X-Google-Smtp-Source: ABdhPJzffQ7O1PRgCsnkZ72lprfnx52gCjAmBeTr9nYQ3NUUQiIHABAtQbcZ78uaZmE6/4M/OSsAVA==
X-Received: by 2002:a17:902:8d92:b029:113:91e7:89d6 with SMTP id v18-20020a1709028d92b029011391e789d6mr3695958plo.85.1623753181769;
        Tue, 15 Jun 2021 03:33:01 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id p11sm14846962pfo.126.2021.06.15.03.33.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 15 Jun 2021 03:33:01 -0700 (PDT)
Message-ID: <60c881dd.1c69fb81.2344b.a85e@mx.google.com>
Date:   Tue, 15 Jun 2021 03:33:01 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v4.9.272-42-gc59bf9447416
X-Kernelci-Branch: linux-4.9.y
X-Kernelci-Tree: stable-rc
Subject: stable-rc/linux-4.9.y baseline: 124 runs,
 6 regressions (v4.9.272-42-gc59bf9447416)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.9.y baseline: 124 runs, 6 regressions (v4.9.272-42-gc59bf=
9447416)

Regressions Summary
-------------------

platform             | arch  | lab             | compiler | defconfig      =
     | regressions
---------------------+-------+-----------------+----------+----------------=
-----+------------
qemu_arm-versatilepb | arm   | lab-baylibre    | gcc-8    | versatile_defco=
nfig | 1          =

qemu_arm-versatilepb | arm   | lab-broonie     | gcc-8    | versatile_defco=
nfig | 1          =

qemu_arm-versatilepb | arm   | lab-cip         | gcc-8    | versatile_defco=
nfig | 1          =

qemu_arm-versatilepb | arm   | lab-collabora   | gcc-8    | versatile_defco=
nfig | 1          =

qemu_arm-versatilepb | arm   | lab-linaro-lkft | gcc-8    | versatile_defco=
nfig | 1          =

r8a7795-salvator-x   | arm64 | lab-baylibre    | gcc-8    | defconfig      =
     | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-4.9.y/kern=
el/v4.9.272-42-gc59bf9447416/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-4.9.y
  Describe: v4.9.272-42-gc59bf9447416
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      c59bf94474162a1e1dfc71da00c35fc2eb3d6e81 =



Test Regressions
---------------- =



platform             | arch  | lab             | compiler | defconfig      =
     | regressions
---------------------+-------+-----------------+----------+----------------=
-----+------------
qemu_arm-versatilepb | arm   | lab-baylibre    | gcc-8    | versatile_defco=
nfig | 1          =


  Details:     https://kernelci.org/test/plan/id/60c852d0766793f79b41328e

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.272=
-42-gc59bf9447416/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_=
arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.272=
-42-gc59bf9447416/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_=
arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60c852d0766793f79b413=
28f
        failing since 212 days (last pass: v4.9.243-17-g9c24315b745a0, firs=
t fail: v4.9.243-26-g7b603f689c1c) =

 =



platform             | arch  | lab             | compiler | defconfig      =
     | regressions
---------------------+-------+-----------------+----------+----------------=
-----+------------
qemu_arm-versatilepb | arm   | lab-broonie     | gcc-8    | versatile_defco=
nfig | 1          =


  Details:     https://kernelci.org/test/plan/id/60c853e2be8707eded413296

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.272=
-42-gc59bf9447416/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_a=
rm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.272=
-42-gc59bf9447416/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_a=
rm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60c853e2be8707eded413=
297
        failing since 212 days (last pass: v4.9.243-17-g9c24315b745a0, firs=
t fail: v4.9.243-26-g7b603f689c1c) =

 =



platform             | arch  | lab             | compiler | defconfig      =
     | regressions
---------------------+-------+-----------------+----------+----------------=
-----+------------
qemu_arm-versatilepb | arm   | lab-cip         | gcc-8    | versatile_defco=
nfig | 1          =


  Details:     https://kernelci.org/test/plan/id/60c84e3d78dd8c380e413267

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.272=
-42-gc59bf9447416/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-v=
ersatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.272=
-42-gc59bf9447416/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-v=
ersatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60c84e3d78dd8c380e413=
268
        failing since 212 days (last pass: v4.9.243-17-g9c24315b745a0, firs=
t fail: v4.9.243-26-g7b603f689c1c) =

 =



platform             | arch  | lab             | compiler | defconfig      =
     | regressions
---------------------+-------+-----------------+----------+----------------=
-----+------------
qemu_arm-versatilepb | arm   | lab-collabora   | gcc-8    | versatile_defco=
nfig | 1          =


  Details:     https://kernelci.org/test/plan/id/60c85502a4fddd2592413286

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.272=
-42-gc59bf9447416/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu=
_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.272=
-42-gc59bf9447416/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu=
_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60c85502a4fddd2592413=
287
        failing since 212 days (last pass: v4.9.243-17-g9c24315b745a0, firs=
t fail: v4.9.243-26-g7b603f689c1c) =

 =



platform             | arch  | lab             | compiler | defconfig      =
     | regressions
---------------------+-------+-----------------+----------+----------------=
-----+------------
qemu_arm-versatilepb | arm   | lab-linaro-lkft | gcc-8    | versatile_defco=
nfig | 1          =


  Details:     https://kernelci.org/test/plan/id/60c853f01e4d23ab7941329d

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.272=
-42-gc59bf9447416/arm/versatile_defconfig/gcc-8/lab-linaro-lkft/baseline-qe=
mu_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.272=
-42-gc59bf9447416/arm/versatile_defconfig/gcc-8/lab-linaro-lkft/baseline-qe=
mu_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60c853f01e4d23ab79413=
29e
        failing since 212 days (last pass: v4.9.243-17-g9c24315b745a0, firs=
t fail: v4.9.243-26-g7b603f689c1c) =

 =



platform             | arch  | lab             | compiler | defconfig      =
     | regressions
---------------------+-------+-----------------+----------+----------------=
-----+------------
r8a7795-salvator-x   | arm64 | lab-baylibre    | gcc-8    | defconfig      =
     | 1          =


  Details:     https://kernelci.org/test/plan/id/60c84f7f1917e6ebd1413279

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.272=
-42-gc59bf9447416/arm64/defconfig/gcc-8/lab-baylibre/baseline-r8a7795-salva=
tor-x.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.272=
-42-gc59bf9447416/arm64/defconfig/gcc-8/lab-baylibre/baseline-r8a7795-salva=
tor-x.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60c84f7f1917e6ebd1413=
27a
        failing since 209 days (last pass: v4.9.243-17-g9c24315b745a0, firs=
t fail: v4.9.243-79-gd3e70b39d31a) =

 =20
