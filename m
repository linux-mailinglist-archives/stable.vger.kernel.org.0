Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 029F04005CE
	for <lists+stable@lfdr.de>; Fri,  3 Sep 2021 21:27:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235044AbhICT2S (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 3 Sep 2021 15:28:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51474 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234472AbhICT2R (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 3 Sep 2021 15:28:17 -0400
Received: from mail-pg1-x530.google.com (mail-pg1-x530.google.com [IPv6:2607:f8b0:4864:20::530])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F2584C061575
        for <stable@vger.kernel.org>; Fri,  3 Sep 2021 12:27:09 -0700 (PDT)
Received: by mail-pg1-x530.google.com with SMTP id f129so73251pgc.1
        for <stable@vger.kernel.org>; Fri, 03 Sep 2021 12:27:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=v4IJmcujRa0CLBKGMpCF58mIAlRCD366szfCpWfOCOc=;
        b=nmroZGNRaGLmSa/tM87vJo9CGsqv8co5zcOoXi1ei0zbZLbnzV4w1+FIn4Y8AijcnC
         qViG1ty9/S2T+vngO2gpg1GMaL4X4TCt5dPWMEdysBN96iaUbkPJwu2VfVex/qPYjEUX
         XcaXkhynVEVu/RSEDLqkVnLdo2m4iIQUg8jkmgbkurLp9O0/MqnU5YPQcRY93nB723Co
         SF2kVrzikwUhhDTsEx+XdmUAaAM4xO8h51sntltYMpSciMIum9+9QpIomtVm6CO1jGn0
         2kFVyrQw33fi12+1KYQrABCEgCfOp01Al5oGF8616C0Cqr+OVxTpvIZcgQr5NdvEuNAn
         Y7lQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=v4IJmcujRa0CLBKGMpCF58mIAlRCD366szfCpWfOCOc=;
        b=ThH/H86m2MvCvir5tKH3H8jL3xH0UP1z1IDnlBoo5j9z4ZVrVdV1P1WSzu8jcAg4jy
         kmaPtF5nVLtZBjnD+CcfSC8K9rl2QMi4D80O3sO7GJqs0gRzIYpX5nZaMamiBB4/It18
         lz08npPoh3Qq5eAvbPlUsfHcTlL3ibxHvn5cEQ8tTWo1mnazqXYI2UDvu8/YhkwrBmob
         N21JTlUGjkyir6G3fmrkL5LLfWaL9nMq3jXVWRur1+QuZa4wuBk0oNy8adrziRMlectC
         RVrdUt3/L9jLdmIVMiBRxDm0HXNJCx9HIzIpGQA/KaoB3WrekbUlgrWiW7e/MFAYEAtN
         Td4A==
X-Gm-Message-State: AOAM533Ixm8ii+GnMC8oHotnn/cON1+vcGmBmS9jvlpu+1DSqExfF/yd
        W7DM6YUg8M4zR6Z1kSdSgEZWycHrpKZ3SzaN
X-Google-Smtp-Source: ABdhPJwbTaoj03Qh4Ex/tC1jQ+wN02sTyPOcjSorr0+GYKROEwGEpQOM7JRKqMrs58EiUchrEeGCaw==
X-Received: by 2002:a63:cf44:: with SMTP id b4mr523367pgj.215.1630697229251;
        Fri, 03 Sep 2021 12:27:09 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id l12sm150792pgc.41.2021.09.03.12.27.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 03 Sep 2021 12:27:08 -0700 (PDT)
Message-ID: <6132770c.1c69fb81.ac29b.0aff@mx.google.com>
Date:   Fri, 03 Sep 2021 12:27:08 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v5.10.62-8-g7b314af003ef
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/5.10
Subject: stable-rc/queue/5.10 baseline: 166 runs,
 5 regressions (v5.10.62-8-g7b314af003ef)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.10 baseline: 166 runs, 5 regressions (v5.10.62-8-g7b314af=
003ef)

Regressions Summary
-------------------

platform                     | arch  | lab           | compiler | defconfig=
          | regressions
-----------------------------+-------+---------------+----------+----------=
----------+------------
hip07-d05                    | arm64 | lab-collabora | gcc-8    | defconfig=
          | 1          =

meson-g12b-a311d-khadas-vim3 | arm64 | lab-baylibre  | gcc-8    | defconfig=
          | 1          =

rk3288-veyron-jaq            | arm   | lab-collabora | gcc-8    | multi_v7_=
defconfig | 3          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.10/ker=
nel/v5.10.62-8-g7b314af003ef/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.10
  Describe: v5.10.62-8-g7b314af003ef
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      7b314af003efaee147249a3624a46cee7aeb1061 =



Test Regressions
---------------- =



platform                     | arch  | lab           | compiler | defconfig=
          | regressions
-----------------------------+-------+---------------+----------+----------=
----------+------------
hip07-d05                    | arm64 | lab-collabora | gcc-8    | defconfig=
          | 1          =


  Details:     https://kernelci.org/test/plan/id/61324039ea5d2d7bf6d5968e

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.62-=
8-g7b314af003ef/arm64/defconfig/gcc-8/lab-collabora/baseline-hip07-d05.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.62-=
8-g7b314af003ef/arm64/defconfig/gcc-8/lab-collabora/baseline-hip07-d05.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61324039ea5d2d7bf6d59=
68f
        failing since 64 days (last pass: v5.10.46-100-gce5b41f85637, first=
 fail: v5.10.46-100-g3b96099161c8b) =

 =



platform                     | arch  | lab           | compiler | defconfig=
          | regressions
-----------------------------+-------+---------------+----------+----------=
----------+------------
meson-g12b-a311d-khadas-vim3 | arm64 | lab-baylibre  | gcc-8    | defconfig=
          | 1          =


  Details:     https://kernelci.org/test/plan/id/6132403e21f048515dd59696

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.62-=
8-g7b314af003ef/arm64/defconfig/gcc-8/lab-baylibre/baseline-meson-g12b-a311=
d-khadas-vim3.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.62-=
8-g7b314af003ef/arm64/defconfig/gcc-8/lab-baylibre/baseline-meson-g12b-a311=
d-khadas-vim3.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6132403e21f048515dd59=
697
        new failure (last pass: v5.10.61-104-g63d6d9cde5d2) =

 =



platform                     | arch  | lab           | compiler | defconfig=
          | regressions
-----------------------------+-------+---------------+----------+----------=
----------+------------
rk3288-veyron-jaq            | arm   | lab-collabora | gcc-8    | multi_v7_=
defconfig | 3          =


  Details:     https://kernelci.org/test/plan/id/613246db0f64fc60e9d59676

  Results:     67 PASS, 3 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.62-=
8-g7b314af003ef/arm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-rk3288-=
veyron-jaq.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.62-=
8-g7b314af003ef/arm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-rk3288-=
veyron-jaq.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.bootrr.rockchip-iodomain-grf-probed: https://kernelci.org/test=
/case/id/613246db0f64fc60e9d59689
        failing since 80 days (last pass: v5.10.43-44-g253317604975, first =
fail: v5.10.43-130-g87b5f83f722c)

    2021-09-03T16:01:23.498185  /lava-4444347/1/../bin/lava-test-case
    2021-09-03T16:01:23.515202  <8>[   13.277543] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Drockchip-iodomain-grf-probed RESULT=3Dfail>   =


  * baseline.bootrr.dwmmc_rockchip-sdio0-probed: https://kernelci.org/test/=
case/id/613246db0f64fc60e9d596a0
        failing since 80 days (last pass: v5.10.43-44-g253317604975, first =
fail: v5.10.43-130-g87b5f83f722c)

    2021-09-03T16:01:22.089792  /lava-4444347/1/../bin/lava-test-case<8>[  =
 11.851316] <LAVA_SIGNAL_TESTCASE TEST_CASE_ID=3Ddwmmc_rockchip-sdio0-probe=
d RESULT=3Dfail>
    2021-09-03T16:01:22.090523  =

    2021-09-03T16:01:22.091069  /lava-4444347/1/../bin/lava-test-case   =


  * baseline.bootrr.dwmmc_rockchip-sdmmc-probed: https://kernelci.org/test/=
case/id/613246db0f64fc60e9d596a1
        failing since 80 days (last pass: v5.10.43-44-g253317604975, first =
fail: v5.10.43-130-g87b5f83f722c)

    2021-09-03T16:01:21.052334  /lava-4444347/1/../bin/lava-test-case
    2021-09-03T16:01:21.057704  <8>[   10.831553] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Ddwmmc_rockchip-sdmmc-probed RESULT=3Dfail>   =

 =20
