Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C08E73BF14E
	for <lists+stable@lfdr.de>; Wed,  7 Jul 2021 23:18:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230295AbhGGVU7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 7 Jul 2021 17:20:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47746 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229829AbhGGVU7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 7 Jul 2021 17:20:59 -0400
Received: from mail-pl1-x631.google.com (mail-pl1-x631.google.com [IPv6:2607:f8b0:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8C3F6C061574
        for <stable@vger.kernel.org>; Wed,  7 Jul 2021 14:18:18 -0700 (PDT)
Received: by mail-pl1-x631.google.com with SMTP id y2so1786860plc.8
        for <stable@vger.kernel.org>; Wed, 07 Jul 2021 14:18:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=z03lXGzIPy/zRuNZ4SlBDeOByI7kVXqONGtj202E08A=;
        b=hCK0peqkHt3n1kWd7jwFCQbQDIVfKYKPZ2ykMMh1ihRl0f8Vcy4Yl+B2Chq1v/ktHv
         BSqEoeQCZUgV/HeBe3lFt0H+38lo8ITKexk5MlKPO3zlLf7Oqm7/69j3AbSmo4sEyqI9
         N+9hFQ/i0tg/AZZz/OY4YxmDpN3JWDS1YVfIK/Me7fEZD7aAWkRpbz9Q/53rKo6Z9HEy
         IeKHu0bqGNlAR1BUYuduQOT0hv+4u2anMhU+331dzbFpgmaUd/8YWadfOh30nlStuBur
         AxRbvk4c4jWf+RIqVgQsP1DUHh6qOWPxBDgko1UvzJ468Tlc9ynrLr4f+cXYVV4Le0mJ
         nw8Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=z03lXGzIPy/zRuNZ4SlBDeOByI7kVXqONGtj202E08A=;
        b=XQtf7uj54v+J7Daxn309DZvBh4Bqn74DZfZRhcTvwU8DvPHKaAQTCwNvyQJMj4i3mF
         idlGP2KbyI6IRT0r254HDSXzBCvLQ9y4M2q9pO3mtT2qBXWDiLl+mF2GoINVzag2g/zA
         fLNUFZjbJVrlgodYbal7cEEl16gGQv6hVaOv7jEPX8bkYdDeoAXpgY5NtTo9UbDG7840
         2mZmvFkhFnMPP7MxODvXgwtuelvWg8mRk+7vd0mcz1nykG7OBFPYykbVTESFyW0epgA+
         BhDp80X/OaCua0tazeDPmGddjL6tzdD+XEW32KW+wXZtI3Ea3y69uB3Y+4zkbKUAcTfR
         lV4w==
X-Gm-Message-State: AOAM533A3rc7vbeaDWq7hGpbVeS37NR1AO1/TxzZIr6LdeGD8nmiTOKf
        hip3QFcWcH9i4UiosAhi56p+axHggxp3/Zcn
X-Google-Smtp-Source: ABdhPJxxZpw2RC/avPy00xCFks0XctMS9bTo769gTRI9UhGHvR06dFBtoaKzfSPaohtAnywrVm3/IA==
X-Received: by 2002:a17:90a:ea98:: with SMTP id h24mr1018784pjz.7.1625692697922;
        Wed, 07 Jul 2021 14:18:17 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id t6sm7279294pjo.4.2021.07.07.14.18.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 07 Jul 2021 14:18:17 -0700 (PDT)
Message-ID: <60e61a19.1c69fb81.dfb01.6b2f@mx.google.com>
Date:   Wed, 07 Jul 2021 14:18:17 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v5.10.48
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable
X-Kernelci-Branch: linux-5.10.y
Subject: stable/linux-5.10.y baseline: 221 runs, 6 regressions (v5.10.48)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable/linux-5.10.y baseline: 221 runs, 6 regressions (v5.10.48)

Regressions Summary
-------------------

platform             | arch  | lab           | compiler | defconfig        =
  | regressions
---------------------+-------+---------------+----------+------------------=
--+------------
hip07-d05            | arm64 | lab-collabora | gcc-8    | defconfig        =
  | 1          =

imx8mp-evk           | arm64 | lab-nxp       | gcc-8    | defconfig        =
  | 1          =

meson-gxl-s905d-p230 | arm64 | lab-baylibre  | gcc-8    | defconfig        =
  | 1          =

rk3288-veyron-jaq    | arm   | lab-collabora | gcc-8    | multi_v7_defconfi=
g | 3          =


  Details:  https://kernelci.org/test/job/stable/branch/linux-5.10.y/kernel=
/v5.10.48/plan/baseline/

  Test:     baseline
  Tree:     stable
  Branch:   linux-5.10.y
  Describe: v5.10.48
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able.git
  SHA:      a09a52277207fa79fc1aa7c32be6035c264a79c4 =



Test Regressions
---------------- =



platform             | arch  | lab           | compiler | defconfig        =
  | regressions
---------------------+-------+---------------+----------+------------------=
--+------------
hip07-d05            | arm64 | lab-collabora | gcc-8    | defconfig        =
  | 1          =


  Details:     https://kernelci.org/test/plan/id/60e5e9fec8b2befc38117982

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable/linux-5.10.y/v5.10.48/a=
rm64/defconfig/gcc-8/lab-collabora/baseline-hip07-d05.txt
  HTML log:    https://storage.kernelci.org//stable/linux-5.10.y/v5.10.48/a=
rm64/defconfig/gcc-8/lab-collabora/baseline-hip07-d05.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60e5e9fec8b2befc38117=
983
        new failure (last pass: v5.10.46) =

 =



platform             | arch  | lab           | compiler | defconfig        =
  | regressions
---------------------+-------+---------------+----------+------------------=
--+------------
imx8mp-evk           | arm64 | lab-nxp       | gcc-8    | defconfig        =
  | 1          =


  Details:     https://kernelci.org/test/plan/id/60e5e5d4d4a079e48711797a

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable/linux-5.10.y/v5.10.48/a=
rm64/defconfig/gcc-8/lab-nxp/baseline-imx8mp-evk.txt
  HTML log:    https://storage.kernelci.org//stable/linux-5.10.y/v5.10.48/a=
rm64/defconfig/gcc-8/lab-nxp/baseline-imx8mp-evk.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60e5e5d4d4a079e487117=
97b
        new failure (last pass: v5.10.47) =

 =



platform             | arch  | lab           | compiler | defconfig        =
  | regressions
---------------------+-------+---------------+----------+------------------=
--+------------
meson-gxl-s905d-p230 | arm64 | lab-baylibre  | gcc-8    | defconfig        =
  | 1          =


  Details:     https://kernelci.org/test/plan/id/60e5ea7659df209baa117976

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable/linux-5.10.y/v5.10.48/a=
rm64/defconfig/gcc-8/lab-baylibre/baseline-meson-gxl-s905d-p230.txt
  HTML log:    https://storage.kernelci.org//stable/linux-5.10.y/v5.10.48/a=
rm64/defconfig/gcc-8/lab-baylibre/baseline-meson-gxl-s905d-p230.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60e5ea7659df209baa117=
977
        failing since 7 days (last pass: v5.10.46, first fail: v5.10.47) =

 =



platform             | arch  | lab           | compiler | defconfig        =
  | regressions
---------------------+-------+---------------+----------+------------------=
--+------------
rk3288-veyron-jaq    | arm   | lab-collabora | gcc-8    | multi_v7_defconfi=
g | 3          =


  Details:     https://kernelci.org/test/plan/id/60e5e4879935eb1d35117976

  Results:     67 PASS, 3 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable/linux-5.10.y/v5.10.48/a=
rm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-rk3288-veyron-jaq.txt
  HTML log:    https://storage.kernelci.org//stable/linux-5.10.y/v5.10.48/a=
rm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-rk3288-veyron-jaq.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.bootrr.rockchip-iodomain-grf-probed: https://kernelci.org/test=
/case/id/60e5e4889935eb1d3511798a
        failing since 21 days (last pass: v5.10.43, first fail: v5.10.44)

    2021-07-07T17:29:21.617104  /lava-4153400/1/../bin/lava-test-case
    2021-07-07T17:29:21.634309  <8>[   13.241482] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Drockchip-iodomain-grf-probed RESULT=3Dfail>
    2021-07-07T17:29:21.634873  /lava-4153400/1/../bin/lava-test-case   =


  * baseline.bootrr.dwmmc_rockchip-sdio0-probed: https://kernelci.org/test/=
case/id/60e5e4889935eb1d351179a2
        failing since 21 days (last pass: v5.10.43, first fail: v5.10.44)

    2021-07-07T17:29:20.187944  /lava-4153400/1/../bin/lava-test-case
    2021-07-07T17:29:20.193515  <8>[   11.813370] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Ddwmmc_rockchip-sdio0-probed RESULT=3Dfail>   =


  * baseline.bootrr.dwmmc_rockchip-sdmmc-probed: https://kernelci.org/test/=
case/id/60e5e4889935eb1d351179a3
        failing since 21 days (last pass: v5.10.43, first fail: v5.10.44)

    2021-07-07T17:29:19.168983  /lava-4153400/1/../bin/lava-test-case
    2021-07-07T17:29:19.174310  <8>[   10.793495] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Ddwmmc_rockchip-sdmmc-probed RESULT=3Dfail>   =

 =20
