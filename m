Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0D5643EC32B
	for <lists+stable@lfdr.de>; Sat, 14 Aug 2021 16:21:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232315AbhHNOVt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 14 Aug 2021 10:21:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46798 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238592AbhHNOVa (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 14 Aug 2021 10:21:30 -0400
Received: from mail-pj1-x1034.google.com (mail-pj1-x1034.google.com [IPv6:2607:f8b0:4864:20::1034])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D0C36C061764
        for <stable@vger.kernel.org>; Sat, 14 Aug 2021 07:21:01 -0700 (PDT)
Received: by mail-pj1-x1034.google.com with SMTP id w13-20020a17090aea0db029017897a5f7bcso20290461pjy.5
        for <stable@vger.kernel.org>; Sat, 14 Aug 2021 07:21:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=gJ8X5PwqansP73OKNMas5GSThhyLjiR/WoJHed6xwBw=;
        b=ruzxZEcCiBcsvRmTEzl45oyx3Rzk0MmwN3gboP/Cpe8E1JJPwZWWZ4itLRjXaW6At1
         Kfd61oJ5KvA98y8xYpkJ+V7OvtUSPF5YEwcIpyEVLNltTskpBUmzW2rwGuTzS9Y4BlYM
         d/72NNy97+gNrr6cKukYk3nBp4npSHYIzlz0SeBKSiZhCWcMm3MR8nTigRUryYA+1BpY
         NJ8+/mqfIGv8N1Yu+/VDWgcTnuDABkHpMBDlwOTMUrLRq1MD4vG2Uu6+DT2xNmY0wvdk
         3NhHbzaCD/6ZGN/PVxGrdMbRrihbk7rOmKpJrFtjBw0R+41qNuZE/TbDaq3V9LK+3SdQ
         79fw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=gJ8X5PwqansP73OKNMas5GSThhyLjiR/WoJHed6xwBw=;
        b=PPZtdgMEUu2FC3pK11pIFKTRj/rQG4e8UCok4sGnLcJ/ixgKxZ8AAEVZVEIaTFGkDx
         NUGnjYVyNRJSaDg+scm6YYcM7ely55rcL3dhzTFmdtOvqV8crtvlwe5oFEXV9uM+hIck
         snCIR3vn2sIBMFgJcSjzEHpA7fBXBpyMIODUmCL/Yyq5yevsCzjatS1FfqG6/89Ge6rh
         Zvpit+b/ce76AS3kP8Puk39N/7BerQOvUNfgY8PAtCediSqJK5m6lBECDkFtaE4RAVtx
         w+GW0lITNvjmae2C2wDUHf9aK8Y9AfHWZcu11NFuYtj0DwuzR9JqY8Y1izhV980hJ9HW
         1z6g==
X-Gm-Message-State: AOAM530LpNIHhUVRjEgXWrdIf+DzPI2AcrlyfmXZSAGq0u9HTOEUfu14
        j/leE9v7cTC5HhyYBY9NPjMZbl20jJVqO0dN
X-Google-Smtp-Source: ABdhPJxUNehPpuM6bIZqSYrK5/VfvTSwUF4qt3RhfusFSE7Bs3D2IqdO0ux3tKY8MkSIE4PwmVmjAQ==
X-Received: by 2002:a17:902:7d82:b029:12c:5930:98c7 with SMTP id a2-20020a1709027d82b029012c593098c7mr6008519plm.46.1628950861245;
        Sat, 14 Aug 2021 07:21:01 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id x73sm6265364pfc.98.2021.08.14.07.21.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 14 Aug 2021 07:21:00 -0700 (PDT)
Message-ID: <6117d14c.1c69fb81.70b45.f96d@mx.google.com>
Date:   Sat, 14 Aug 2021 07:21:00 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: linux-4.19.y
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v4.19.202-66-gb834d1a90a9e
X-Kernelci-Report-Type: test
Subject: stable-rc/linux-4.19.y baseline: 159 runs,
 7 regressions (v4.19.202-66-gb834d1a90a9e)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.19.y baseline: 159 runs, 7 regressions (v4.19.202-66-gb83=
4d1a90a9e)

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

qemu_arm-versatilepb | arm  | lab-collabora   | gcc-8    | versatile_defcon=
fig | 1          =

qemu_arm-versatilepb | arm  | lab-linaro-lkft | gcc-8    | versatile_defcon=
fig | 1          =

rk3288-veyron-jaq    | arm  | lab-collabora   | gcc-8    | multi_v7_defconf=
ig  | 3          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-4.19.y/ker=
nel/v4.19.202-66-gb834d1a90a9e/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-4.19.y
  Describe: v4.19.202-66-gb834d1a90a9e
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      b834d1a90a9e65e1801193248f277d85161dfe69 =



Test Regressions
---------------- =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-baylibre    | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/61179a5f45307ce167b1367b

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.2=
02-66-gb834d1a90a9e/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qem=
u_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.2=
02-66-gb834d1a90a9e/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qem=
u_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61179a5f45307ce167b13=
67c
        failing since 269 days (last pass: v4.19.157-26-ga8e7fec1fea1, firs=
t fail: v4.19.157-102-g1d674327c1b7) =

 =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-broonie     | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/61179a6645307ce167b13686

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.2=
02-66-gb834d1a90a9e/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu=
_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.2=
02-66-gb834d1a90a9e/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu=
_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61179a6645307ce167b13=
687
        failing since 269 days (last pass: v4.19.157-26-ga8e7fec1fea1, firs=
t fail: v4.19.157-102-g1d674327c1b7) =

 =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-collabora   | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/61179a16b42ecf2145b136ce

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.2=
02-66-gb834d1a90a9e/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qe=
mu_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.2=
02-66-gb834d1a90a9e/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qe=
mu_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61179a16b42ecf2145b13=
6cf
        failing since 269 days (last pass: v4.19.157-26-ga8e7fec1fea1, firs=
t fail: v4.19.157-102-g1d674327c1b7) =

 =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-linaro-lkft | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/61179a14b42ecf2145b136c8

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.2=
02-66-gb834d1a90a9e/arm/versatile_defconfig/gcc-8/lab-linaro-lkft/baseline-=
qemu_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.2=
02-66-gb834d1a90a9e/arm/versatile_defconfig/gcc-8/lab-linaro-lkft/baseline-=
qemu_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61179a14b42ecf2145b13=
6c9
        failing since 269 days (last pass: v4.19.157-26-ga8e7fec1fea1, firs=
t fail: v4.19.157-102-g1d674327c1b7) =

 =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
rk3288-veyron-jaq    | arm  | lab-collabora   | gcc-8    | multi_v7_defconf=
ig  | 3          =


  Details:     https://kernelci.org/test/plan/id/6117a166e62e3771b9b13667

  Results:     64 PASS, 6 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.2=
02-66-gb834d1a90a9e/arm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-rk3=
288-veyron-jaq.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.2=
02-66-gb834d1a90a9e/arm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-rk3=
288-veyron-jaq.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.bootrr.rockchip-iodomain-grf-probed: https://kernelci.org/test=
/case/id/6117a166e62e3771b9b1367f
        failing since 60 days (last pass: v4.19.194, first fail: v4.19.194-=
68-g3c1f7bd17074)

    2021-08-14T10:56:16.988243  /lava-4363538/1/../bin/lava-test-case
    2021-08-14T10:56:17.004357  <8>[   17.562769] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Drockchip-iodomain-grf-probed RESULT=3Dfail>
    2021-08-14T10:56:17.004592  /lava-4363538/1/../bin/lava-test-case   =


  * baseline.bootrr.dwmmc_rockchip-sdio0-probed: https://kernelci.org/test/=
case/id/6117a166e62e3771b9b13695
        failing since 60 days (last pass: v4.19.194, first fail: v4.19.194-=
68-g3c1f7bd17074)

    2021-08-14T10:56:14.546055  /lava-4363538/1/../bin/lava-test-case
    2021-08-14T10:56:14.564192  <8>[   15.121676] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Ddwmmc_rockchip-sdio0-probed RESULT=3Dfail>   =


  * baseline.bootrr.dwmmc_rockchip-sdmmc-probed: https://kernelci.org/test/=
case/id/6117a166e62e3771b9b13696
        failing since 60 days (last pass: v4.19.194, first fail: v4.19.194-=
68-g3c1f7bd17074)

    2021-08-14T10:56:13.533426  /lava-4363538/1/../bin/lava-test-case<8>[  =
 14.102511] <LAVA_SIGNAL_TESTCASE TEST_CASE_ID=3Ddwmmc_rockchip-sdmmc-probe=
d RESULT=3Dfail>
    2021-08-14T10:56:13.533758     =

 =20
