Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 68E413E860B
	for <lists+stable@lfdr.de>; Wed, 11 Aug 2021 00:25:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235049AbhHJWZ7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Aug 2021 18:25:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33802 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234989AbhHJWZ6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 10 Aug 2021 18:25:58 -0400
Received: from mail-pj1-x102e.google.com (mail-pj1-x102e.google.com [IPv6:2607:f8b0:4864:20::102e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 756C6C061765
        for <stable@vger.kernel.org>; Tue, 10 Aug 2021 15:25:36 -0700 (PDT)
Received: by mail-pj1-x102e.google.com with SMTP id bo18so378740pjb.0
        for <stable@vger.kernel.org>; Tue, 10 Aug 2021 15:25:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=D7AwzkOcgevBp3OwMZqF2s18U4gWmt3ELIfvcXxG/BI=;
        b=Y3ca/rb2omsPfUgLWtHqUZ91O0eZdobbkC1BIVTqjLgSiPimZ73VRAaEAxWnXtB9LD
         3P5rtgDZqXwz5sqZMnZQsy46/67Dr/+jIcDQjkUvL93Kh4TUyIad/JZ0dpMBUym+FiN+
         lW7KYYgWzFi+N2FcDOAkxv0DKKXW6waB9fPNk5otMLisjziOXRBSjKzTuLWmjba10p4i
         0h7KTGHbUnbAjesL/+Y/ZniY20RkzFL1rAltStT5ZiDYm2vbaXlQS1cR6TgtU6dYNJP2
         4ZOaqtNWpgXo5+u7llmdBCLlzhMczJJ6zIdiE289aMJFCIVfO3OvdjkZCK1GBqcHs2EI
         GX8g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=D7AwzkOcgevBp3OwMZqF2s18U4gWmt3ELIfvcXxG/BI=;
        b=q+IJW9U3FYqGmZHfsdld2NfJXOZ+OpL0dDLQJe1YiQTm2xcP9Lz+NtWVIx4u7fUBom
         VLxytRigKLAicvELfknYhuuyE09Brwbl/kondK9PPZICt7GXwXShzSB1qKf+SqPCZ3Gb
         NcVOv1dht6Bi4IgyXjFYemNxkNNfEpI1Z0zCrwzuXwcWPWuORXaTdAJvPH+vxpMwAqFW
         ZmIwr2QtjBi08f0tsm8OGP9kgN+bLwrY1AnuLBzqwQAGMjZpaJKfRvn0aTl51/+KQYSC
         pnT99e4FUBJZtD058bBYsuwBUjy28CKThXos1sN3iMchRMKwVZEflz6AlYl47vXNFJmX
         /tsQ==
X-Gm-Message-State: AOAM532Bw2itjDlcWUKHd2YMzeAtQs6/UzTe47xRMOauj3388T1O7DQa
        QLvzmjfReG9VAp9RfRuKHGr2xaiKDCkwpzbQ
X-Google-Smtp-Source: ABdhPJzKf2yFOHx4t7u+OWoKdfesumaVhpsFeyFm6WFYUNmjzNiFcXsBY/p9KjzR3yVJ+g3FcJ8yRg==
X-Received: by 2002:a17:90a:eb0c:: with SMTP id j12mr7282673pjz.116.1628634335825;
        Tue, 10 Aug 2021 15:25:35 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id a21sm25987825pfi.15.2021.08.10.15.25.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 10 Aug 2021 15:25:35 -0700 (PDT)
Message-ID: <6112fcdf.1c69fb81.1e828.bc6d@mx.google.com>
Date:   Tue, 10 Aug 2021 15:25:35 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: queue/4.19
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v4.19.202-54-ga42e2354f943
X-Kernelci-Report-Type: test
Subject: stable-rc/queue/4.19 baseline: 139 runs,
 6 regressions (v4.19.202-54-ga42e2354f943)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.19 baseline: 139 runs, 6 regressions (v4.19.202-54-ga42e2=
354f943)

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

qemu_arm-versatilepb | arm  | lab-collabora | gcc-8    | versatile_defconfi=
g | 1          =

rk3288-veyron-jaq    | arm  | lab-collabora | gcc-8    | multi_v7_defconfig=
  | 3          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.19/ker=
nel/v4.19.202-54-ga42e2354f943/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.19
  Describe: v4.19.202-54-ga42e2354f943
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      a42e2354f943fd1274dc4256406ed4fb4bc4c03a =



Test Regressions
---------------- =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-baylibre  | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/6112c19f578b3f57a2b1366a

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.202=
-54-ga42e2354f943/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_=
arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.202=
-54-ga42e2354f943/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_=
arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6112c19f578b3f57a2b13=
66b
        failing since 269 days (last pass: v4.19.157-26-gd59f3161b3a0, firs=
t fail: v4.19.157-27-g5543cc2c41d55) =

 =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-broonie   | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/6112c55eb3bc2b8848b1366e

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.202=
-54-ga42e2354f943/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_a=
rm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.202=
-54-ga42e2354f943/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_a=
rm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6112c55eb3bc2b8848b13=
66f
        failing since 269 days (last pass: v4.19.157-26-gd59f3161b3a0, firs=
t fail: v4.19.157-27-g5543cc2c41d55) =

 =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-collabora | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/6112c183b328baf673b13669

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.202=
-54-ga42e2354f943/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu=
_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.202=
-54-ga42e2354f943/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu=
_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6112c183b328baf673b13=
66a
        failing since 269 days (last pass: v4.19.157-26-gd59f3161b3a0, firs=
t fail: v4.19.157-27-g5543cc2c41d55) =

 =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
rk3288-veyron-jaq    | arm  | lab-collabora | gcc-8    | multi_v7_defconfig=
  | 3          =


  Details:     https://kernelci.org/test/plan/id/6112c8a7f9a960dc06b13691

  Results:     64 PASS, 6 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.202=
-54-ga42e2354f943/arm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-rk328=
8-veyron-jaq.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.202=
-54-ga42e2354f943/arm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-rk328=
8-veyron-jaq.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.bootrr.rockchip-iodomain-grf-probed: https://kernelci.org/test=
/case/id/6112c8a7f9a960dc06b136a9
        failing since 56 days (last pass: v4.19.194-28-g6098ecdead2c, first=
 fail: v4.19.194-67-g1b5dea188d94)

    2021-08-10T18:42:13.638431  /lava-4343648/1/../bin/lava-test-case
    2021-08-10T18:42:13.655362  <8>[   17.938561] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Drockchip-iodomain-grf-probed RESULT=3Dfail>   =


  * baseline.bootrr.dwmmc_rockchip-sdio0-probed: https://kernelci.org/test/=
case/id/6112c8a7f9a960dc06b136c2
        failing since 56 days (last pass: v4.19.194-28-g6098ecdead2c, first=
 fail: v4.19.194-67-g1b5dea188d94)

    2021-08-10T18:42:11.198503  /lava-4343648/1/../bin/lava-test-case
    2021-08-10T18:42:11.215714  <8>[   15.497572] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Ddwmmc_rockchip-sdio0-probed RESULT=3Dfail>
    2021-08-10T18:42:11.216203  /lava-4343648/1/../bin/lava-test-case   =


  * baseline.bootrr.dwmmc_rockchip-sdmmc-probed: https://kernelci.org/test/=
case/id/6112c8a7f9a960dc06b136c3
        failing since 56 days (last pass: v4.19.194-28-g6098ecdead2c, first=
 fail: v4.19.194-67-g1b5dea188d94)

    2021-08-10T18:42:10.185111  /lava-4343648/1/../bin/lava-test-case<8>[  =
 14.478531] <LAVA_SIGNAL_TESTCASE TEST_CASE_ID=3Ddwmmc_rockchip-sdmmc-probe=
d RESULT=3Dfail>
    2021-08-10T18:42:10.185473     =

 =20
