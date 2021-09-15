Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 86BE840CDB9
	for <lists+stable@lfdr.de>; Wed, 15 Sep 2021 22:06:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231991AbhIOUH2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 Sep 2021 16:07:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53258 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232008AbhIOUH1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 15 Sep 2021 16:07:27 -0400
Received: from mail-pf1-x42c.google.com (mail-pf1-x42c.google.com [IPv6:2607:f8b0:4864:20::42c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 71269C061766
        for <stable@vger.kernel.org>; Wed, 15 Sep 2021 13:06:08 -0700 (PDT)
Received: by mail-pf1-x42c.google.com with SMTP id c1so811407pfp.10
        for <stable@vger.kernel.org>; Wed, 15 Sep 2021 13:06:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=r4zeq6f2oiqJv9ETQwRG0W5NwDBCm8B427ZPWmlBHM8=;
        b=eEr9F1w985ThN74uS0mRBLLtjh4y9vR3MynuowmU0y7U699Z93kJ/5epcVEdKNhyNy
         lcNk8u3rxR5tfVD6glvwc9G9PfBjuh0L5VwOHB4ev3lUS1otYJMK5zZXQCqr9SDJFARI
         +EOtqyKV4o1sx6NzDhoEMW3gc9uban7OlO1UU+tV4kB/H5LUB5KFIM4nOP2AA6OVYwWN
         LwW3R5pOjFU/0g7WjKrTdPnqKV3HxRdhcGZbUSgmJaFfRWjb/6gtwrGCRd/AoMMOfHbt
         GRB0SVioZFGp1BJHtgj0kJ6/X/OW7nq03snOKCVy34yJOSKirzpOAAElSEI4u9XdWZoy
         5voQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=r4zeq6f2oiqJv9ETQwRG0W5NwDBCm8B427ZPWmlBHM8=;
        b=MY2pLujoogH50x57l5+w+8Fr1SFB4cCqkQ3f9lLAydHmvum5ir831O9474Q0LGfvbL
         4lQVapG1RJhxE0FZJK+8NyMom1xRT/uATpTqJdGnCvxDlTNY6Gu5ZeTzP4/+95kEyl/t
         9vIx4Bz2dw6+YsrvrAAWzCDX1yveh0LLtZQUPuUnOo3pVycyVKlo67hzti1K2D275N7V
         qNdprKmB+7g/R/uHriuSHysQmNJ8UudaiBNMrfpRd/hC4xKZVKGf2Izjjm1sGcf0St1U
         YJxeFv8otqBo6vS5pO/Ann07VjjiHj4JxNtlGILlPgVZQheF1uMF34AzFqsYy6z+P5ew
         cGfw==
X-Gm-Message-State: AOAM531pLO7pEzuk1TN1c1qxUHQQTLZwNIsbXmuYZgPpGDZbtdmKPELK
        GZt4GvkAr0LsJRW/T4uZILZNXo92O/ktvn9lNLw=
X-Google-Smtp-Source: ABdhPJwNOZG5OkPSWz7SETNM2aKqLWkU9tDGByCsgRijnEl1z7kyBAZSp0ujgAuUv5YiUDXIbniGGA==
X-Received: by 2002:a63:c113:: with SMTP id w19mr1416199pgf.168.1631736367781;
        Wed, 15 Sep 2021 13:06:07 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id v14sm697084pfi.111.2021.09.15.13.06.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 15 Sep 2021 13:06:07 -0700 (PDT)
Message-ID: <6142522f.1c69fb81.7b4b9.3176@mx.google.com>
Date:   Wed, 15 Sep 2021 13:06:07 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.14.246
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-4.14.y
Subject: stable-rc/linux-4.14.y baseline: 182 runs, 10 regressions (v4.14.246)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.14.y baseline: 182 runs, 10 regressions (v4.14.246)

Regressions Summary
-------------------

platform             | arch  | lab             | compiler | defconfig      =
     | regressions
---------------------+-------+-----------------+----------+----------------=
-----+------------
fsl-ls2088a-rdb      | arm64 | lab-nxp         | gcc-8    | defconfig      =
     | 1          =

meson-gxbb-p200      | arm64 | lab-baylibre    | gcc-8    | defconfig      =
     | 1          =

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

rk3288-veyron-jaq    | arm   | lab-collabora   | gcc-8    | multi_v7_defcon=
fig  | 3          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-4.14.y/ker=
nel/v4.14.246/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-4.14.y
  Describe: v4.14.246
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      f96eb53cbd76415edfba99c2cfa88567a885a428 =



Test Regressions
---------------- =



platform             | arch  | lab             | compiler | defconfig      =
     | regressions
---------------------+-------+-----------------+----------+----------------=
-----+------------
fsl-ls2088a-rdb      | arm64 | lab-nxp         | gcc-8    | defconfig      =
     | 1          =


  Details:     https://kernelci.org/test/plan/id/6139464558f7afa702d5967b

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
46/arm64/defconfig/gcc-8/lab-nxp/baseline-fsl-ls2088a-rdb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
46/arm64/defconfig/gcc-8/lab-nxp/baseline-fsl-ls2088a-rdb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6139464558f7afa702d59=
67c
        failing since 1 day (last pass: v4.14.246-29-g066c74edd6a6, first f=
ail: v4.14.246-29-gb584e925ad43) =

 =



platform             | arch  | lab             | compiler | defconfig      =
     | regressions
---------------------+-------+-----------------+----------+----------------=
-----+------------
meson-gxbb-p200      | arm64 | lab-baylibre    | gcc-8    | defconfig      =
     | 1          =


  Details:     https://kernelci.org/test/plan/id/6138acb8942787c795d5966a

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
46/arm64/defconfig/gcc-8/lab-baylibre/baseline-meson-gxbb-p200.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
46/arm64/defconfig/gcc-8/lab-baylibre/baseline-meson-gxbb-p200.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6138acb8942787c795d59=
66b
        failing since 526 days (last pass: v4.14.172-114-g734382e2d26e, fir=
st fail: v4.14.174-131-g234ce78cac23) =

 =



platform             | arch  | lab             | compiler | defconfig      =
     | regressions
---------------------+-------+-----------------+----------+----------------=
-----+------------
qemu_arm-versatilepb | arm   | lab-baylibre    | gcc-8    | versatile_defco=
nfig | 1          =


  Details:     https://kernelci.org/test/plan/id/61320f1d4bacf2d15ad5967e

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
46/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_arm-versatilepb=
.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
46/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_arm-versatilepb=
.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61320f1d4bacf2d15ad59=
67f
        failing since 292 days (last pass: v4.14.206-21-gf1262f26e4d0, firs=
t fail: v4.14.206-23-g520c3568920c8) =

 =



platform             | arch  | lab             | compiler | defconfig      =
     | regressions
---------------------+-------+-----------------+----------+----------------=
-----+------------
qemu_arm-versatilepb | arm   | lab-broonie     | gcc-8    | versatile_defco=
nfig | 1          =


  Details:     https://kernelci.org/test/plan/id/61321ba16d9c81396ed596b5

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
46/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_arm-versatilepb.=
txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
46/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_arm-versatilepb.=
html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61321ba16d9c81396ed59=
6b6
        failing since 292 days (last pass: v4.14.206-21-gf1262f26e4d0, firs=
t fail: v4.14.206-23-g520c3568920c8) =

 =



platform             | arch  | lab             | compiler | defconfig      =
     | regressions
---------------------+-------+-----------------+----------+----------------=
-----+------------
qemu_arm-versatilepb | arm   | lab-cip         | gcc-8    | versatile_defco=
nfig | 1          =


  Details:     https://kernelci.org/test/plan/id/61320e309e42b618c0d5967c

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
46/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
46/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61320e309e42b618c0d59=
67d
        failing since 292 days (last pass: v4.14.206-21-gf1262f26e4d0, firs=
t fail: v4.14.206-23-g520c3568920c8) =

 =



platform             | arch  | lab             | compiler | defconfig      =
     | regressions
---------------------+-------+-----------------+----------+----------------=
-----+------------
qemu_arm-versatilepb | arm   | lab-collabora   | gcc-8    | versatile_defco=
nfig | 1          =


  Details:     https://kernelci.org/test/plan/id/6133520f3b5c178f97d5967b

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
46/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu_arm-versatilep=
b.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
46/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu_arm-versatilep=
b.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6133520f3b5c178f97d59=
67c
        failing since 292 days (last pass: v4.14.206-21-gf1262f26e4d0, firs=
t fail: v4.14.206-23-g520c3568920c8) =

 =



platform             | arch  | lab             | compiler | defconfig      =
     | regressions
---------------------+-------+-----------------+----------+----------------=
-----+------------
qemu_arm-versatilepb | arm   | lab-linaro-lkft | gcc-8    | versatile_defco=
nfig | 1          =


  Details:     https://kernelci.org/test/plan/id/61329cc32df3c1d4c2d5969b

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
46/arm/versatile_defconfig/gcc-8/lab-linaro-lkft/baseline-qemu_arm-versatil=
epb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
46/arm/versatile_defconfig/gcc-8/lab-linaro-lkft/baseline-qemu_arm-versatil=
epb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61329cc32df3c1d4c2d59=
69c
        failing since 292 days (last pass: v4.14.206-21-gf1262f26e4d0, firs=
t fail: v4.14.206-23-g520c3568920c8) =

 =



platform             | arch  | lab             | compiler | defconfig      =
     | regressions
---------------------+-------+-----------------+----------+----------------=
-----+------------
rk3288-veyron-jaq    | arm   | lab-collabora   | gcc-8    | multi_v7_defcon=
fig  | 3          =


  Details:     https://kernelci.org/test/plan/id/6132147ed1e4d27a24d596c4

  Results:     63 PASS, 6 FAIL, 1 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
46/arm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-rk3288-veyron-jaq.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
46/arm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-rk3288-veyron-jaq.ht=
ml
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.bootrr.rockchip-iodomain-grf-probed: https://kernelci.org/test=
/case/id/6132147ed1e4d27a24d596d8
        failing since 80 days (last pass: v4.14.236, first fail: v4.14.236-=
50-g2e03cf25d5d0) =


  * baseline.bootrr.dwmmc_rockchip-sdio0-probed: https://kernelci.org/test/=
case/id/6132147ed1e4d27a24d596f1
        failing since 80 days (last pass: v4.14.236, first fail: v4.14.236-=
50-g2e03cf25d5d0)

    2021-09-12T15:59:42.738139  /lava-4501858/1/../bin/lava-test-case
    2021-09-12T15:59:42.755044  [   14.375365] <LAVA_SIGNAL_TESTCASE TEST_C=
ASE_ID=3Ddwmmc_rockchip-sdio0-probed RESULT=3Dfail>
    2021-09-12T15:59:42.755541  /lava-4501858/1/../bin/lava-test-case   =


  * baseline.bootrr.dwmmc_rockchip-sdmmc-probed: https://kernelci.org/test/=
case/id/6132147ed1e4d27a24d596f2
        failing since 80 days (last pass: v4.14.236, first fail: v4.14.236-=
50-g2e03cf25d5d0)

    2021-09-12T15:59:41.721106  /lava-4501858/1/../bin/lava-test-case[   13=
.356793] <LAVA_SIGNAL_TESTCASE TEST_CASE_ID=3Ddwmmc_rockchip-sdmmc-probed R=
ESULT=3Dfail>
    2021-09-12T15:59:41.721691     =

 =20
