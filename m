Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 370733D0CFA
	for <lists+stable@lfdr.de>; Wed, 21 Jul 2021 13:09:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239534AbhGUKQr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 21 Jul 2021 06:16:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59476 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238293AbhGUJ5Q (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 21 Jul 2021 05:57:16 -0400
Received: from mail-pf1-x42b.google.com (mail-pf1-x42b.google.com [IPv6:2607:f8b0:4864:20::42b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A23B3C061767
        for <stable@vger.kernel.org>; Wed, 21 Jul 2021 03:37:53 -0700 (PDT)
Received: by mail-pf1-x42b.google.com with SMTP id o201so1926017pfd.1
        for <stable@vger.kernel.org>; Wed, 21 Jul 2021 03:37:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=cbhd67jqz2L1lJcAFfPUhKnpkEywQstFSG8CylrRZNM=;
        b=SkWjPxI/Y3aoqxoDHf0/4pBxyaOEja8U5Tyd29eiZHbfc1zXBLabLYZRZxwEoxugxD
         DuycXaJxIh0bSmqUaniAHVZRQhszxWZScDUf9GuLvmbZTopl6KVx6N8qJ1ZeRiBmIoEN
         XHYdTJezZtaRu6lVNF4orsYKStmmOl4tBK3N/GGCjza+ttnHcWJ0IhJwhsjUrgtZuJsV
         N40sGE7ExkfTTj86vCpg+EIoLaKm0RvqXruJplGAsoZthb7To7Dwn8Z4aNxlyrX2kOdR
         PQilo0c/ePtyodpEug6VoGf4/EmcMETOTG1UoaQaMRjeCD6xVAuOQVY6eNxBtIi11aKH
         gxpQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=cbhd67jqz2L1lJcAFfPUhKnpkEywQstFSG8CylrRZNM=;
        b=HqjJgeRq6+J/OJlg6mTeZY/PhoYYF2Qm2qCutp41lEE72CqWAm1KV9KuxMdIs6XyFC
         VlP/5uKn++jEHtt0HnZg9junzomPbeYc1QsLIhfqFOHreFRBgeS0hqmtR9aDlnX8iSJ1
         MnzVYrVv59LJTnOn2GqHKUVlnezjiqXlenmtDv4J7uAORfhrkanmypupIH5z1ALNlzOe
         33PHMPAGZ0HDbYRuryZ4xd4lofZ9rVDw6k7yVtbA6vAfcwldYap9Nhz2B17A4+O7uK9p
         p5I91Hz6LbCAaJ0w+Tqe/spH58dNL3LKghAPkY6vcNSOvTLvz6JYJRIH4i3OBFjBrfQJ
         tNFA==
X-Gm-Message-State: AOAM533kQyAnZWmUVft/xL0UD/+48bmEMvbw2ImWyR9T+SsSAR4NA8bI
        x14pTPGDBEd8+vYQkAgdwuWtugn2rSpoqkMU
X-Google-Smtp-Source: ABdhPJwQ7yri1KCzAhH7dkOYuvCYU9/WKc9QjhvyhuxEhD6LnbHKLxUiq4UT8bP5MOX8syXL5GNtKg==
X-Received: by 2002:a05:6a00:24c2:b029:32e:424c:53ac with SMTP id d2-20020a056a0024c2b029032e424c53acmr35779728pfv.17.1626863872941;
        Wed, 21 Jul 2021 03:37:52 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id q125sm20432192pga.87.2021.07.21.03.37.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 21 Jul 2021 03:37:52 -0700 (PDT)
Message-ID: <60f7f900.1c69fb81.ec8e7.c564@mx.google.com>
Date:   Wed, 21 Jul 2021 03:37:52 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: linux-4.19.y
X-Kernelci-Kernel: v4.19.197-420-g9ec1965d618f
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
Subject: stable-rc/linux-4.19.y baseline: 157 runs,
 7 regressions (v4.19.197-420-g9ec1965d618f)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.19.y baseline: 157 runs, 7 regressions (v4.19.197-420-g9e=
c1965d618f)

Regressions Summary
-------------------

platform              | arch | lab           | compiler | defconfig        =
   | regressions
----------------------+------+---------------+----------+------------------=
---+------------
at91-sama5d4_xplained | arm  | lab-baylibre  | gcc-8    | sama5_defconfig  =
   | 1          =

qemu_arm-versatilepb  | arm  | lab-baylibre  | gcc-8    | versatile_defconf=
ig | 1          =

qemu_arm-versatilepb  | arm  | lab-cip       | gcc-8    | versatile_defconf=
ig | 1          =

qemu_arm-versatilepb  | arm  | lab-collabora | gcc-8    | versatile_defconf=
ig | 1          =

rk3288-veyron-jaq     | arm  | lab-collabora | gcc-8    | multi_v7_defconfi=
g  | 3          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-4.19.y/ker=
nel/v4.19.197-420-g9ec1965d618f/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-4.19.y
  Describe: v4.19.197-420-g9ec1965d618f
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      9ec1965d618f6ee0de12cfed19640954abd387ae =



Test Regressions
---------------- =



platform              | arch | lab           | compiler | defconfig        =
   | regressions
----------------------+------+---------------+----------+------------------=
---+------------
at91-sama5d4_xplained | arm  | lab-baylibre  | gcc-8    | sama5_defconfig  =
   | 1          =


  Details:     https://kernelci.org/test/plan/id/60f7be1d0c2cdf3db885c25c

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: sama5_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.1=
97-420-g9ec1965d618f/arm/sama5_defconfig/gcc-8/lab-baylibre/baseline-at91-s=
ama5d4_xplained.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.1=
97-420-g9ec1965d618f/arm/sama5_defconfig/gcc-8/lab-baylibre/baseline-at91-s=
ama5d4_xplained.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60f7be1d0c2cdf3db885c=
25d
        failing since 400 days (last pass: v4.19.126-55-gf6c346f2d42d, firs=
t fail: v4.19.126-113-gd694d4388e88) =

 =



platform              | arch | lab           | compiler | defconfig        =
   | regressions
----------------------+------+---------------+----------+------------------=
---+------------
qemu_arm-versatilepb  | arm  | lab-baylibre  | gcc-8    | versatile_defconf=
ig | 1          =


  Details:     https://kernelci.org/test/plan/id/60f7c72aa66df8e2f785c25c

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.1=
97-420-g9ec1965d618f/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qe=
mu_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.1=
97-420-g9ec1965d618f/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qe=
mu_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60f7c72aa66df8e2f785c=
25d
        failing since 244 days (last pass: v4.19.157-26-ga8e7fec1fea1, firs=
t fail: v4.19.157-102-g1d674327c1b7) =

 =



platform              | arch | lab           | compiler | defconfig        =
   | regressions
----------------------+------+---------------+----------+------------------=
---+------------
qemu_arm-versatilepb  | arm  | lab-cip       | gcc-8    | versatile_defconf=
ig | 1          =


  Details:     https://kernelci.org/test/plan/id/60f7be50bda6b9a64d85c270

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.1=
97-420-g9ec1965d618f/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_ar=
m-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.1=
97-420-g9ec1965d618f/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_ar=
m-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60f7be50bda6b9a64d85c=
271
        failing since 244 days (last pass: v4.19.157-26-ga8e7fec1fea1, firs=
t fail: v4.19.157-102-g1d674327c1b7) =

 =



platform              | arch | lab           | compiler | defconfig        =
   | regressions
----------------------+------+---------------+----------+------------------=
---+------------
qemu_arm-versatilepb  | arm  | lab-collabora | gcc-8    | versatile_defconf=
ig | 1          =


  Details:     https://kernelci.org/test/plan/id/60f7bdf37452b5d3d285c258

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.1=
97-420-g9ec1965d618f/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-q=
emu_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.1=
97-420-g9ec1965d618f/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-q=
emu_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60f7bdf37452b5d3d285c=
259
        failing since 244 days (last pass: v4.19.157-26-ga8e7fec1fea1, firs=
t fail: v4.19.157-102-g1d674327c1b7) =

 =



platform              | arch | lab           | compiler | defconfig        =
   | regressions
----------------------+------+---------------+----------+------------------=
---+------------
rk3288-veyron-jaq     | arm  | lab-collabora | gcc-8    | multi_v7_defconfi=
g  | 3          =


  Details:     https://kernelci.org/test/plan/id/60f7e79bc0f9d5a36485c2b4

  Results:     64 PASS, 6 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.1=
97-420-g9ec1965d618f/arm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-rk=
3288-veyron-jaq.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.1=
97-420-g9ec1965d618f/arm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-rk=
3288-veyron-jaq.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.bootrr.rockchip-iodomain-grf-probed: https://kernelci.org/test=
/case/id/60f7e79bc0f9d5a36485c2c8
        failing since 36 days (last pass: v4.19.194, first fail: v4.19.194-=
68-g3c1f7bd17074)

    2021-07-21T09:23:27.723586  /lava-4223918/1/../bin/lava-test-case
    2021-07-21T09:23:27.740531  <8>[   17.386098] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Drockchip-iodomain-grf-probed RESULT=3Dfail>
    2021-07-21T09:23:27.740864  /lava-4223918/1/../bin/lava-test-case   =


  * baseline.bootrr.dwmmc_rockchip-sdio0-probed: https://kernelci.org/test/=
case/id/60f7e79bc0f9d5a36485c2e0
        failing since 36 days (last pass: v4.19.194, first fail: v4.19.194-=
68-g3c1f7bd17074)

    2021-07-21T09:23:25.282592  /lava-4223918/1/../bin/lava-test-case
    2021-07-21T09:23:25.299533  <8>[   14.944205] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Ddwmmc_rockchip-sdio0-probed RESULT=3Dfail>   =


  * baseline.bootrr.dwmmc_rockchip-sdmmc-probed: https://kernelci.org/test/=
case/id/60f7e79bc0f9d5a36485c2e1
        failing since 36 days (last pass: v4.19.194, first fail: v4.19.194-=
68-g3c1f7bd17074)

    2021-07-21T09:23:24.262482  /lava-4223918/1/../bin/lava-test-case
    2021-07-21T09:23:24.267874  <8>[   13.924806] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Ddwmmc_rockchip-sdmmc-probed RESULT=3Dfail>   =

 =20
