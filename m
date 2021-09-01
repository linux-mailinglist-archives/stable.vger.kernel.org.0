Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 487F03FE61B
	for <lists+stable@lfdr.de>; Thu,  2 Sep 2021 02:34:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231515AbhIAXbN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 1 Sep 2021 19:31:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42764 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242573AbhIAXbK (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 1 Sep 2021 19:31:10 -0400
Received: from mail-pg1-x532.google.com (mail-pg1-x532.google.com [IPv6:2607:f8b0:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D6885C061757
        for <stable@vger.kernel.org>; Wed,  1 Sep 2021 16:30:12 -0700 (PDT)
Received: by mail-pg1-x532.google.com with SMTP id n18so1078080pgm.12
        for <stable@vger.kernel.org>; Wed, 01 Sep 2021 16:30:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=CMF5ijBbJJQlEqyyCRunkmat4s32Y5bDRqSm09l8O2c=;
        b=ppWodzTHI1sJAq0rB6gYuEpQFgAQSRvazyLnipMN7XEUtPlsFI+aF09GK+NgvWT5EM
         Ckfc5shrCMIOuPTV6N/7Gdd+mH0l89O4+fJvF2SDizeWHH0iIdRTh72rnAxxtsJUHJZp
         fr6xmX55tWajI0PMuxjCxj1IDQWSi6oSO+l4IJxMkRxO+aSt73bRn9vSIXARHLJam++w
         xGZUy1xHhNHSQryvaegZKDyShDwTc5Mq3NjcTBtWxKnMiOa1IMZKYSjPHZ3ok6vYzcqM
         yF0m1FYHHvkhQagfB84mKi6GpeSGeZTb94ek7i1FBGP8jKL7D1BwMqwGyJeo1tXUUbEa
         glaA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=CMF5ijBbJJQlEqyyCRunkmat4s32Y5bDRqSm09l8O2c=;
        b=Om+vhZaSnKEHmFeUKUpTjpJKhylCLWwRYGOu92rMmc6lAwEK77WMZF3aAAEcAIsDqd
         y7GaH35DMSJVWZ4FI74pY1ia1zar4ubPZr+Y5k4/vC06pG+WFPY9y00UNIW8ZlwUsc0b
         OR9274Wznv3H2a7zoynkgbvWKCk2NbDj3WQuv/Y7qg6XwwnMbvpyXfRlcZ5ZAH78/SHW
         yJrvVQI8/tdsZZOWdji9B+BXs7ZcTPxNMPs8r/gdNdBhZ2857L+oxSVudXamIw7jTvlF
         M/CKOjFTB0I5L7zEO0dr+msO92DTeLkdtd9+x0ZHWd2SZopd58s2SldtePU4RYjAdauG
         xk9Q==
X-Gm-Message-State: AOAM533eaYoNEzf05/nNem8Z2BNDm7mgGR6iYqpC1qj8KsGjKHL2x7XP
        LzFbpsCu4WF53exvxc5ydkXK96p3YCEQbhkBBew=
X-Google-Smtp-Source: ABdhPJxyPHFseOkUckYU4sB37j3N0aKwvCycouaif975itpRlZOUvP3480lKdqEXybFFwbjyJTPZ2g==
X-Received: by 2002:a63:f650:: with SMTP id u16mr151316pgj.359.1630539012094;
        Wed, 01 Sep 2021 16:30:12 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id q29sm17861pgc.91.2021.09.01.16.30.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 01 Sep 2021 16:30:11 -0700 (PDT)
Message-ID: <61300d03.1c69fb81.90e82.0168@mx.google.com>
Date:   Wed, 01 Sep 2021 16:30:11 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v5.10.61-104-g63d6d9cde5d2
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/5.10
Subject: stable-rc/queue/5.10 baseline: 184 runs,
 8 regressions (v5.10.61-104-g63d6d9cde5d2)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.10 baseline: 184 runs, 8 regressions (v5.10.61-104-g63d6d=
9cde5d2)

Regressions Summary
-------------------

platform                | arch  | lab           | compiler | defconfig     =
      | regressions
------------------------+-------+---------------+----------+---------------=
------+------------
hip07-d05               | arm64 | lab-collabora | gcc-8    | defconfig     =
      | 1          =

imx7ulp-evk             | arm   | lab-nxp       | gcc-8    | imx_v6_v7_defc=
onfig | 1          =

imx8mn-ddr4-evk         | arm64 | lab-nxp       | gcc-8    | defconfig     =
      | 1          =

meson-gxbb-p200         | arm64 | lab-baylibre  | gcc-8    | defconfig     =
      | 1          =

rk3288-veyron-jaq       | arm   | lab-collabora | gcc-8    | multi_v7_defco=
nfig  | 3          =

sun50i-a64-bananapi-m64 | arm64 | lab-clabbe    | gcc-8    | defconfig     =
      | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.10/ker=
nel/v5.10.61-104-g63d6d9cde5d2/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.10
  Describe: v5.10.61-104-g63d6d9cde5d2
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      63d6d9cde5d2abd2af1ba6c429f8ee6780446099 =



Test Regressions
---------------- =



platform                | arch  | lab           | compiler | defconfig     =
      | regressions
------------------------+-------+---------------+----------+---------------=
------+------------
hip07-d05               | arm64 | lab-collabora | gcc-8    | defconfig     =
      | 1          =


  Details:     https://kernelci.org/test/plan/id/612fddc40b27518231d59680

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.61-=
104-g63d6d9cde5d2/arm64/defconfig/gcc-8/lab-collabora/baseline-hip07-d05.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.61-=
104-g63d6d9cde5d2/arm64/defconfig/gcc-8/lab-collabora/baseline-hip07-d05.ht=
ml
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/612fddc40b27518231d59=
681
        failing since 62 days (last pass: v5.10.46-100-gce5b41f85637, first=
 fail: v5.10.46-100-g3b96099161c8b) =

 =



platform                | arch  | lab           | compiler | defconfig     =
      | regressions
------------------------+-------+---------------+----------+---------------=
------+------------
imx7ulp-evk             | arm   | lab-nxp       | gcc-8    | imx_v6_v7_defc=
onfig | 1          =


  Details:     https://kernelci.org/test/plan/id/612fe06bb9890897cfd5966b

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: imx_v6_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.61-=
104-g63d6d9cde5d2/arm/imx_v6_v7_defconfig/gcc-8/lab-nxp/baseline-imx7ulp-ev=
k.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.61-=
104-g63d6d9cde5d2/arm/imx_v6_v7_defconfig/gcc-8/lab-nxp/baseline-imx7ulp-ev=
k.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/612fe06bb9890897cfd59=
66c
        new failure (last pass: v5.10.61-103-g4cd5172c2ba3) =

 =



platform                | arch  | lab           | compiler | defconfig     =
      | regressions
------------------------+-------+---------------+----------+---------------=
------+------------
imx8mn-ddr4-evk         | arm64 | lab-nxp       | gcc-8    | defconfig     =
      | 1          =


  Details:     https://kernelci.org/test/plan/id/612fd5e16162714bbcd5967d

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.61-=
104-g63d6d9cde5d2/arm64/defconfig/gcc-8/lab-nxp/baseline-imx8mn-ddr4-evk.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.61-=
104-g63d6d9cde5d2/arm64/defconfig/gcc-8/lab-nxp/baseline-imx8mn-ddr4-evk.ht=
ml
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/612fd5e16162714bbcd59=
67e
        new failure (last pass: v5.10.61-103-g4cd5172c2ba3) =

 =



platform                | arch  | lab           | compiler | defconfig     =
      | regressions
------------------------+-------+---------------+----------+---------------=
------+------------
meson-gxbb-p200         | arm64 | lab-baylibre  | gcc-8    | defconfig     =
      | 1          =


  Details:     https://kernelci.org/test/plan/id/612fd551ce814a4cb3d596e3

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.61-=
104-g63d6d9cde5d2/arm64/defconfig/gcc-8/lab-baylibre/baseline-meson-gxbb-p2=
00.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.61-=
104-g63d6d9cde5d2/arm64/defconfig/gcc-8/lab-baylibre/baseline-meson-gxbb-p2=
00.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/612fd551ce814a4cb3d59=
6e4
        new failure (last pass: v5.10.61-103-g4cd5172c2ba3) =

 =



platform                | arch  | lab           | compiler | defconfig     =
      | regressions
------------------------+-------+---------------+----------+---------------=
------+------------
rk3288-veyron-jaq       | arm   | lab-collabora | gcc-8    | multi_v7_defco=
nfig  | 3          =


  Details:     https://kernelci.org/test/plan/id/6130017fc65f50349cd59666

  Results:     67 PASS, 3 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.61-=
104-g63d6d9cde5d2/arm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-rk328=
8-veyron-jaq.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.61-=
104-g63d6d9cde5d2/arm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-rk328=
8-veyron-jaq.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.bootrr.rockchip-iodomain-grf-probed: https://kernelci.org/test=
/case/id/6130017fc65f50349cd5967a
        failing since 78 days (last pass: v5.10.43-44-g253317604975, first =
fail: v5.10.43-130-g87b5f83f722c)

    2021-09-01T22:40:31.911839  /lava-4430996/1/../bin/lava-test-case
    2021-09-01T22:40:31.928569  <8>[   13.849280] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Drockchip-iodomain-grf-probed RESULT=3Dfail>
    2021-09-01T22:40:31.929065  /lava-4430996/1/../bin/lava-test-case   =


  * baseline.bootrr.dwmmc_rockchip-sdio0-probed: https://kernelci.org/test/=
case/id/6130017fc65f50349cd59692
        failing since 78 days (last pass: v5.10.43-44-g253317604975, first =
fail: v5.10.43-130-g87b5f83f722c)

    2021-09-01T22:40:30.485826  /lava-4430996/1/../bin/lava-test-case
    2021-09-01T22:40:30.490794  <8>[   12.423338] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Ddwmmc_rockchip-sdio0-probed RESULT=3Dfail>   =


  * baseline.bootrr.dwmmc_rockchip-sdmmc-probed: https://kernelci.org/test/=
case/id/6130017fc65f50349cd59693
        failing since 78 days (last pass: v5.10.43-44-g253317604975, first =
fail: v5.10.43-130-g87b5f83f722c)

    2021-09-01T22:40:29.466666  /lava-4430996/1/../bin/lava-test-case
    2021-09-01T22:40:29.472260  <8>[   11.403857] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Ddwmmc_rockchip-sdmmc-probed RESULT=3Dfail>   =

 =



platform                | arch  | lab           | compiler | defconfig     =
      | regressions
------------------------+-------+---------------+----------+---------------=
------+------------
sun50i-a64-bananapi-m64 | arm64 | lab-clabbe    | gcc-8    | defconfig     =
      | 1          =


  Details:     https://kernelci.org/test/plan/id/612fd51d4d5fd82c39d59676

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.61-=
104-g63d6d9cde5d2/arm64/defconfig/gcc-8/lab-clabbe/baseline-sun50i-a64-bana=
napi-m64.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.61-=
104-g63d6d9cde5d2/arm64/defconfig/gcc-8/lab-clabbe/baseline-sun50i-a64-bana=
napi-m64.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/612fd51d4d5fd82c39d59=
677
        failing since 0 day (last pass: v5.10.61-100-g568e40c72849, first f=
ail: v5.10.61-103-g4cd5172c2ba3) =

 =20
