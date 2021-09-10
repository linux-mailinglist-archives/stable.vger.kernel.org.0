Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C63A9406E32
	for <lists+stable@lfdr.de>; Fri, 10 Sep 2021 17:33:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234455AbhIJPe1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 10 Sep 2021 11:34:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43430 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232438AbhIJPeQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 10 Sep 2021 11:34:16 -0400
Received: from mail-pf1-x42b.google.com (mail-pf1-x42b.google.com [IPv6:2607:f8b0:4864:20::42b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ABC90C061574
        for <stable@vger.kernel.org>; Fri, 10 Sep 2021 08:33:03 -0700 (PDT)
Received: by mail-pf1-x42b.google.com with SMTP id 18so2171241pfh.9
        for <stable@vger.kernel.org>; Fri, 10 Sep 2021 08:33:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=Xnh+N2YBYtw/IV2r7mTDnfu/608yzBEuWotgRojq9lk=;
        b=hDkAk+N5qPEobMlm9oaRSspeZFYaIlsLM+sDxZ/a78C+cBo4ebNldx0vU8emcTPUCf
         0LozvKxGGqwtPQgqEqFu/svMaPYjAigtHqvszXC0F+CMr4zOfb0aNrYaLdTbCKIhO3QX
         dhIXf9xahSHPod9PapwlsfXlSpMFbEF/5pIpwWE4s7cNJOEIf7Vh9r8MAQG9XeHVu0fA
         XXN+68gd0t9j56A1pVbEr9EqglN4rlcxD+uqsEBARV+Ava1uBXsa8YSCLk1d6yfTWxP/
         Rt0d5SqxjnHUsW11q/TzYZeiG1ddUzs+uP4s7c2Ioa3xMiEkOkXiL+3BhXM1URHzWiK4
         dikw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=Xnh+N2YBYtw/IV2r7mTDnfu/608yzBEuWotgRojq9lk=;
        b=Iv1jrxtWnC4mHe8DWVTLFWinDtawXOkjAYig5HuMUDMzW6EgTpabr0cVKu4UwUEqS3
         w6i0LCLHVMUs7OhnyF/5UZeRK6PXbpUP25fII9NJ5zLpV/NEMZmVwokGq7scxDuDSJjW
         gVTFCD5xXB3LMhoYnjKEVohmNcuQMjwFY13GD2NR1xvfJTEseUwxFYbrVGgGEo6LXXM+
         sKHIseXw9rEx+AIjjMVpj/u+E5cdusb38U67bzCReIqEkF6aYj8VYdPB104JPW1TKW9M
         vYpDJhnp1Ct+onyjqGgHeJqX8+pqdeZ0dHrMvJE/DuZDOQMFK9pI3uBzpdIpSWoAYwJb
         /IWg==
X-Gm-Message-State: AOAM532r7O6B1lKQBvF3bYYS1dvQdBmHZpSoiH+gattLZYxdUpEiztPr
        BJ/EFPIuZsSrLt0Haq+dy9oQ1G9nnFJl8TS2
X-Google-Smtp-Source: ABdhPJxnbXs8xq7RTy7yLw9mHZXHP9zRDC4Mu0kGs9w8BglEdLpqVJy0m/LhOdsfOOrSbHrSA4/o2w==
X-Received: by 2002:a63:4cd:: with SMTP id 196mr7870054pge.239.1631287983010;
        Fri, 10 Sep 2021 08:33:03 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id o14sm5723455pgl.85.2021.09.10.08.33.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 10 Sep 2021 08:33:02 -0700 (PDT)
Message-ID: <613b7aae.1c69fb81.89b67.0563@mx.google.com>
Date:   Fri, 10 Sep 2021 08:33:02 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v4.14.246-29-g066c74edd6a6
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-4.14.y
Subject: stable-rc/linux-4.14.y baseline: 155 runs,
 8 regressions (v4.14.246-29-g066c74edd6a6)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.14.y baseline: 155 runs, 8 regressions (v4.14.246-29-g066=
c74edd6a6)

Regressions Summary
-------------------

platform             | arch  | lab           | compiler | defconfig        =
   | regressions
---------------------+-------+---------------+----------+------------------=
---+------------
meson-gxbb-p200      | arm64 | lab-baylibre  | gcc-8    | defconfig        =
   | 1          =

qemu_arm-versatilepb | arm   | lab-baylibre  | gcc-8    | versatile_defconf=
ig | 1          =

qemu_arm-versatilepb | arm   | lab-broonie   | gcc-8    | versatile_defconf=
ig | 1          =

qemu_arm-versatilepb | arm   | lab-cip       | gcc-8    | versatile_defconf=
ig | 1          =

qemu_arm-versatilepb | arm   | lab-collabora | gcc-8    | versatile_defconf=
ig | 1          =

rk3288-veyron-jaq    | arm   | lab-collabora | gcc-8    | multi_v7_defconfi=
g  | 3          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-4.14.y/ker=
nel/v4.14.246-29-g066c74edd6a6/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-4.14.y
  Describe: v4.14.246-29-g066c74edd6a6
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      066c74edd6a6724d41504f46c7e2206802cbdd4b =



Test Regressions
---------------- =



platform             | arch  | lab           | compiler | defconfig        =
   | regressions
---------------------+-------+---------------+----------+------------------=
---+------------
meson-gxbb-p200      | arm64 | lab-baylibre  | gcc-8    | defconfig        =
   | 1          =


  Details:     https://kernelci.org/test/plan/id/613b469399d6c5fd97d5966e

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
46-29-g066c74edd6a6/arm64/defconfig/gcc-8/lab-baylibre/baseline-meson-gxbb-=
p200.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
46-29-g066c74edd6a6/arm64/defconfig/gcc-8/lab-baylibre/baseline-meson-gxbb-=
p200.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/613b469399d6c5fd97d59=
66f
        failing since 527 days (last pass: v4.14.172-114-g734382e2d26e, fir=
st fail: v4.14.174-131-g234ce78cac23) =

 =



platform             | arch  | lab           | compiler | defconfig        =
   | regressions
---------------------+-------+---------------+----------+------------------=
---+------------
qemu_arm-versatilepb | arm   | lab-baylibre  | gcc-8    | versatile_defconf=
ig | 1          =


  Details:     https://kernelci.org/test/plan/id/613b4591b181499c95d59668

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
46-29-g066c74edd6a6/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qem=
u_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
46-29-g066c74edd6a6/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qem=
u_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/613b4591b181499c95d59=
669
        failing since 299 days (last pass: v4.14.206-21-gf1262f26e4d0, firs=
t fail: v4.14.206-23-g520c3568920c8) =

 =



platform             | arch  | lab           | compiler | defconfig        =
   | regressions
---------------------+-------+---------------+----------+------------------=
---+------------
qemu_arm-versatilepb | arm   | lab-broonie   | gcc-8    | versatile_defconf=
ig | 1          =


  Details:     https://kernelci.org/test/plan/id/613b4e8722c658cdddd59669

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
46-29-g066c74edd6a6/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu=
_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
46-29-g066c74edd6a6/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu=
_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/613b4e8722c658cdddd59=
66a
        failing since 299 days (last pass: v4.14.206-21-gf1262f26e4d0, firs=
t fail: v4.14.206-23-g520c3568920c8) =

 =



platform             | arch  | lab           | compiler | defconfig        =
   | regressions
---------------------+-------+---------------+----------+------------------=
---+------------
qemu_arm-versatilepb | arm   | lab-cip       | gcc-8    | versatile_defconf=
ig | 1          =


  Details:     https://kernelci.org/test/plan/id/613b458c60d620eb39d59697

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
46-29-g066c74edd6a6/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm=
-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
46-29-g066c74edd6a6/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm=
-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/613b458c60d620eb39d59=
698
        failing since 299 days (last pass: v4.14.206-21-gf1262f26e4d0, firs=
t fail: v4.14.206-23-g520c3568920c8) =

 =



platform             | arch  | lab           | compiler | defconfig        =
   | regressions
---------------------+-------+---------------+----------+------------------=
---+------------
qemu_arm-versatilepb | arm   | lab-collabora | gcc-8    | versatile_defconf=
ig | 1          =


  Details:     https://kernelci.org/test/plan/id/613b452fb7eb9cf393d59699

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
46-29-g066c74edd6a6/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qe=
mu_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
46-29-g066c74edd6a6/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qe=
mu_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/613b452fb7eb9cf393d59=
69a
        failing since 299 days (last pass: v4.14.206-21-gf1262f26e4d0, firs=
t fail: v4.14.206-23-g520c3568920c8) =

 =



platform             | arch  | lab           | compiler | defconfig        =
   | regressions
---------------------+-------+---------------+----------+------------------=
---+------------
rk3288-veyron-jaq    | arm   | lab-collabora | gcc-8    | multi_v7_defconfi=
g  | 3          =


  Details:     https://kernelci.org/test/plan/id/613b5bc128b7ba5ab7d59680

  Results:     63 PASS, 6 FAIL, 1 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
46-29-g066c74edd6a6/arm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-rk3=
288-veyron-jaq.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
46-29-g066c74edd6a6/arm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-rk3=
288-veyron-jaq.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.bootrr.rockchip-iodomain-grf-probed: https://kernelci.org/test=
/case/id/613b5bc128b7ba5ab7d59694
        failing since 87 days (last pass: v4.14.236, first fail: v4.14.236-=
50-g2e03cf25d5d0) =


  * baseline.bootrr.dwmmc_rockchip-sdio0-probed: https://kernelci.org/test/=
case/id/613b5bc128b7ba5ab7d596ad
        failing since 87 days (last pass: v4.14.236, first fail: v4.14.236-=
50-g2e03cf25d5d0)

    2021-09-10T13:20:48.308748  /lava-4490660/1/../bin/lava-test-case
    2021-09-10T13:20:48.326846  [   14.262700] <LAVA_SIGNAL_TESTCASE TEST_C=
ASE_ID=3Ddwmmc_rockchip-sdio0-probed RESULT=3Dfail>
    2021-09-10T13:20:48.327327  /lava-4490660/1/../bin/lava-test-case   =


  * baseline.bootrr.dwmmc_rockchip-sdmmc-probed: https://kernelci.org/test/=
case/id/613b5bc128b7ba5ab7d596ae
        failing since 87 days (last pass: v4.14.236, first fail: v4.14.236-=
50-g2e03cf25d5d0)

    2021-09-10T13:20:47.291877  /lava-4490660/1/../bin/lava-test-case[   13=
.243953] <LAVA_SIGNAL_TESTCASE TEST_CASE_ID=3Ddwmmc_rockchip-sdmmc-probed R=
ESULT=3Dfail>
    2021-09-10T13:20:47.292129     =

 =20
