Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D8B38419214
	for <lists+stable@lfdr.de>; Mon, 27 Sep 2021 12:16:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233767AbhI0KSP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Sep 2021 06:18:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54916 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233703AbhI0KSP (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 27 Sep 2021 06:18:15 -0400
Received: from mail-pl1-x633.google.com (mail-pl1-x633.google.com [IPv6:2607:f8b0:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 81E19C061575
        for <stable@vger.kernel.org>; Mon, 27 Sep 2021 03:16:37 -0700 (PDT)
Received: by mail-pl1-x633.google.com with SMTP id y1so11408331plk.10
        for <stable@vger.kernel.org>; Mon, 27 Sep 2021 03:16:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=BdB7IBoG0DRe31SFp13cmVmQjonYvgGAJ01I5xpbnD4=;
        b=AWg2Ss6FZc4HXsbYxVMLruYb+4zBDmsTcSS5ucuxXrgyUYZjKzh4Q1LoPsy/V1YXd3
         EHVpoOuDxT4BzMKRquUQryNn+JXF7/ybk6P5EoZge0RS/uq7iyJwUiMOQ/i9aQzzHOqJ
         fMAVnSgBpRTwSZznzQ6Pb4BWQHMMgTZLZd6pfV7d4WX8lYpQw5693OJ9kqbkEHYw/KLc
         XDbgC7dOw1XZFy4LB7+N6HqTaUY7GD7cAWmZmcaxuQALJk78u/H7tSICqnIWKCKe7hsU
         CEnsdheroYKc3QCGkOm/jEb2WY3JjX+5w+d08Ols8b/Xj1WQhDroIBb1sjNQCKyRQxMy
         KXLg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=BdB7IBoG0DRe31SFp13cmVmQjonYvgGAJ01I5xpbnD4=;
        b=AvWI0MfORYfch7GmILe4WcfeS2CojzdHqfZMs2gI10yhlUtGg3szyZ3LbrEdk5U1qc
         kzTcHmWYTTnUv2fFbPecMV4nFl4QJ8N2NS6/0N28sQnR2BVoZqzv7IpPSE0NLH3Ziiv1
         xLA3MLTyPtgM2g72/9Lpkv4EMBDZEWZvrcWq/XVQ2apmYVWX5chK3O/kazVCbI2XTPT2
         expYh5FJDun494Srku+ukpCuMn9HssKw+taeWyPPmsN9s64f24VU98z8WoXU9YrNqOK1
         zZWYuzuGBZrTE/j17h0KMOFdwXhkzf1i/xgOlIw85dXybyvnY05pzGCXfOjSZoTnv3tk
         Js1A==
X-Gm-Message-State: AOAM532KLGGhIPy8Z2+PCrWV4LJ6RtXeAaxTmqntTXxoiMIMIudlRB6S
        7cb88b7yAlQe4p58QzkFm3rmc+SKQTPUux4O
X-Google-Smtp-Source: ABdhPJzqgTz4in6r//vFjwd4riB1oDwvG5p0HEOewQLL2M/Y298HPBtRAYOddXItY9XUTpzMdgqu9A==
X-Received: by 2002:a17:90b:4ac1:: with SMTP id mh1mr19157409pjb.238.1632737796697;
        Mon, 27 Sep 2021 03:16:36 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id l185sm17075857pfd.29.2021.09.27.03.16.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 27 Sep 2021 03:16:36 -0700 (PDT)
Message-ID: <61519a04.1c69fb81.31bcb.6d64@mx.google.com>
Date:   Mon, 27 Sep 2021 03:16:36 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.19.207-80-ga032f307ecb0
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/4.19
Subject: stable-rc/queue/4.19 baseline: 129 runs,
 7 regressions (v4.19.207-80-ga032f307ecb0)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.19 baseline: 129 runs, 7 regressions (v4.19.207-80-ga032f=
307ecb0)

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

rk3288-veyron-jaq    | arm  | lab-collabora   | gcc-8    | multi_v7_defconf=
ig  | 3          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.19/ker=
nel/v4.19.207-80-ga032f307ecb0/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.19
  Describe: v4.19.207-80-ga032f307ecb0
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      a032f307ecb052eb7cfd5959ad3637be5e5726c8 =



Test Regressions
---------------- =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-broonie     | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/615160b6a0a80e317899a2f9

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.207=
-80-ga032f307ecb0/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_a=
rm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.207=
-80-ga032f307ecb0/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_a=
rm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/615160b6a0a80e317899a=
2fa
        failing since 317 days (last pass: v4.19.157-26-gd59f3161b3a0, firs=
t fail: v4.19.157-27-g5543cc2c41d55) =

 =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-cip         | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/6151607cfad5425c0b99a2fb

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.207=
-80-ga032f307ecb0/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-v=
ersatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.207=
-80-ga032f307ecb0/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-v=
ersatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6151607cfad5425c0b99a=
2fc
        failing since 317 days (last pass: v4.19.157-26-gd59f3161b3a0, firs=
t fail: v4.19.157-27-g5543cc2c41d55) =

 =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-collabora   | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/615183378f9df679e099a2df

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.207=
-80-ga032f307ecb0/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu=
_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.207=
-80-ga032f307ecb0/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu=
_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/615183378f9df679e099a=
2e0
        failing since 317 days (last pass: v4.19.157-26-gd59f3161b3a0, firs=
t fail: v4.19.157-27-g5543cc2c41d55) =

 =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-linaro-lkft | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/6151603e35187c7fba99a309

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.207=
-80-ga032f307ecb0/arm/versatile_defconfig/gcc-8/lab-linaro-lkft/baseline-qe=
mu_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.207=
-80-ga032f307ecb0/arm/versatile_defconfig/gcc-8/lab-linaro-lkft/baseline-qe=
mu_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6151603e35187c7fba99a=
30a
        failing since 317 days (last pass: v4.19.157-26-gd59f3161b3a0, firs=
t fail: v4.19.157-27-g5543cc2c41d55) =

 =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
rk3288-veyron-jaq    | arm  | lab-collabora   | gcc-8    | multi_v7_defconf=
ig  | 3          =


  Details:     https://kernelci.org/test/plan/id/615161073395eb39c899a300

  Results:     64 PASS, 6 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.207=
-80-ga032f307ecb0/arm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-rk328=
8-veyron-jaq.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.207=
-80-ga032f307ecb0/arm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-rk328=
8-veyron-jaq.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.bootrr.rockchip-iodomain-grf-probed: https://kernelci.org/test=
/case/id/615161073395eb39c899a314
        failing since 104 days (last pass: v4.19.194-28-g6098ecdead2c, firs=
t fail: v4.19.194-67-g1b5dea188d94)

    2021-09-27T06:13:14.900900  /lava-4588286/1/../bin/lava-test-case
    2021-09-27T06:13:14.916783  <8>[   18.368290] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Drockchip-iodomain-grf-probed RESULT=3Dfail>
    2021-09-27T06:13:14.917049  /lava-4588286/1/../bin/lava-test-case   =


  * baseline.bootrr.dwmmc_rockchip-sdio0-probed: https://kernelci.org/test/=
case/id/615161073395eb39c899a32d
        failing since 104 days (last pass: v4.19.194-28-g6098ecdead2c, firs=
t fail: v4.19.194-67-g1b5dea188d94)

    2021-09-27T06:13:12.459267  /lava-4588286/1/../bin/lava-test-case
    2021-09-27T06:13:12.477530  <8>[   15.927759] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Ddwmmc_rockchip-sdio0-probed RESULT=3Dfail>
    2021-09-27T06:13:12.477861  /lava-4588286/1/../bin/lava-test-case   =


  * baseline.bootrr.dwmmc_rockchip-sdmmc-probed: https://kernelci.org/test/=
case/id/615161073395eb39c899a32e
        failing since 104 days (last pass: v4.19.194-28-g6098ecdead2c, firs=
t fail: v4.19.194-67-g1b5dea188d94)

    2021-09-27T06:13:11.446934  /lava-4588286/1/../bin/lava-test-case<8>[  =
 14.908663] <LAVA_SIGNAL_TESTCASE TEST_CASE_ID=3Ddwmmc_rockchip-sdmmc-probe=
d RESULT=3Dfail>
    2021-09-27T06:13:11.447325     =

 =20
