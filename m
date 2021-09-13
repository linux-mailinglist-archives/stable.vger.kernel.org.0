Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E74474099F3
	for <lists+stable@lfdr.de>; Mon, 13 Sep 2021 18:50:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238219AbhIMQvl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Sep 2021 12:51:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50354 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238876AbhIMQvl (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Sep 2021 12:51:41 -0400
Received: from mail-pg1-x52f.google.com (mail-pg1-x52f.google.com [IPv6:2607:f8b0:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5F411C061574
        for <stable@vger.kernel.org>; Mon, 13 Sep 2021 09:50:25 -0700 (PDT)
Received: by mail-pg1-x52f.google.com with SMTP id k24so9998493pgh.8
        for <stable@vger.kernel.org>; Mon, 13 Sep 2021 09:50:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=BX2zARKjDBoMfpgqao8O7a4gNAW3Ob+vy3ZgtjaV+FU=;
        b=ZSVHBY/PCxfi1Rn2sm0YOuV/kchr2IDiHmbFLU4RzawqNdMedJnyGYkPwYoHVjMnCU
         diTzqDk9D45XEJoFTFi4eVuQOUTpGjzOV4HS56cNsyASfz39oZDwwqDXAYoq3D2PENbI
         k+cD5RS+KRQZw2thtS8z02dvF/gn2ZH8nGOGUaMaZvzH9WgRvY85kGwFq8aVewcjlD5s
         L3oYz1SyVQ5Z7pkhKkr36b24o59fW2GOXHKNodzP7M7ngvBep09ZynAKa85vPpDD6SSl
         ruGn/Y6iYdLpbUfkx0OZALzkpTWJf/sTTAVBWqzYx0WrHOqgstz+ogJSMx/CbclNPVUL
         AJOA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=BX2zARKjDBoMfpgqao8O7a4gNAW3Ob+vy3ZgtjaV+FU=;
        b=TgFG2oKLauCbdDKTUfMiN68cgB5agNfvUbKnFYWMhO6XyPPEm0YkTzAvsk2os6bDkL
         bRr1nVt2FkNoUmgrscPuRjczcI6PRy/KSs31e+GYzBTwP5w0kmbZAcFlVyDpulAwDfrJ
         eZ4UFWTUZVB1LI6wJ8NeTLtNi3rtcAtYs4aJNZZKbirwc+Z0NVxO9bjrrbU26wFcNxHs
         f/0oBtAl9saS8c+anJ23yXQkj8ZuiuUjO+FpVOpEaZS4mfkCn32wfk/yXv8+zhbTL8K2
         dk/4Z2+S78EjFTgnj7KLPpXy8lSc1/2sNu8uLFetck7NrLBm2X1H7ThlZQFuHHlhWyPv
         DIvQ==
X-Gm-Message-State: AOAM53325GVm7xghQWUYib0gtv5SKlzNvBI3jWU1puoXmnatvUdGVQ39
        252K2zgQ5INvyTh3k+0LWYMV957B2EvbGckg
X-Google-Smtp-Source: ABdhPJwfaURqUPsO1bUOzsyIapdUVmpI8+Hy7yXkeiGu3QkDs//fWcoOHB9Zq0FwPS58D2oiVkxj5w==
X-Received: by 2002:a63:be0e:: with SMTP id l14mr11711344pgf.363.1631551824674;
        Mon, 13 Sep 2021 09:50:24 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id v9sm8336688pga.82.2021.09.13.09.50.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 Sep 2021 09:50:24 -0700 (PDT)
Message-ID: <613f8150.1c69fb81.402be.7412@mx.google.com>
Date:   Mon, 13 Sep 2021 09:50:24 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v5.10.64-215-g5352b1865825
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-5.10.y
Subject: stable-rc/linux-5.10.y baseline: 174 runs,
 5 regressions (v5.10.64-215-g5352b1865825)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-5.10.y baseline: 174 runs, 5 regressions (v5.10.64-215-g535=
2b1865825)

Regressions Summary
-------------------

platform                | arch  | lab           | compiler | defconfig     =
     | regressions
------------------------+-------+---------------+----------+---------------=
-----+------------
imx8mp-evk              | arm64 | lab-nxp       | gcc-8    | defconfig     =
     | 1          =

rk3288-veyron-jaq       | arm   | lab-collabora | gcc-8    | multi_v7_defco=
nfig | 3          =

sun50i-a64-bananapi-m64 | arm64 | lab-clabbe    | gcc-8    | defconfig     =
     | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-5.10.y/ker=
nel/v5.10.64-215-g5352b1865825/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-5.10.y
  Describe: v5.10.64-215-g5352b1865825
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      5352b186582596dcdab356bc77bcdbdbc18a9623 =



Test Regressions
---------------- =



platform                | arch  | lab           | compiler | defconfig     =
     | regressions
------------------------+-------+---------------+----------+---------------=
-----+------------
imx8mp-evk              | arm64 | lab-nxp       | gcc-8    | defconfig     =
     | 1          =


  Details:     https://kernelci.org/test/plan/id/613f50e1b619ee5ac699a2f9

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.6=
4-215-g5352b1865825/arm64/defconfig/gcc-8/lab-nxp/baseline-imx8mp-evk.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.6=
4-215-g5352b1865825/arm64/defconfig/gcc-8/lab-nxp/baseline-imx8mp-evk.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/613f50e1b619ee5ac699a=
2fa
        new failure (last pass: v5.10.64) =

 =



platform                | arch  | lab           | compiler | defconfig     =
     | regressions
------------------------+-------+---------------+----------+---------------=
-----+------------
rk3288-veyron-jaq       | arm   | lab-collabora | gcc-8    | multi_v7_defco=
nfig | 3          =


  Details:     https://kernelci.org/test/plan/id/613f64c600f6403ed999a2f6

  Results:     67 PASS, 3 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.6=
4-215-g5352b1865825/arm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-rk3=
288-veyron-jaq.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.6=
4-215-g5352b1865825/arm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-rk3=
288-veyron-jaq.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.bootrr.rockchip-iodomain-grf-probed: https://kernelci.org/test=
/case/id/613f64c600f6403ed999a30a
        failing since 90 days (last pass: v5.10.43, first fail: v5.10.43-13=
1-g3f05ff8b3370)

    2021-09-13T14:48:07.121772  /lava-4509565/1/../bin/lava-test-case
    2021-09-13T14:48:07.139289  <8>[   13.321525] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Drockchip-iodomain-grf-probed RESULT=3Dfail>
    2021-09-13T14:48:07.139539  /lava-4509565/1/../bin/lava-test-case   =


  * baseline.bootrr.dwmmc_rockchip-sdmmc-probed: https://kernelci.org/test/=
case/id/613f64c600f6403ed999a31e
        failing since 90 days (last pass: v5.10.43, first fail: v5.10.43-13=
1-g3f05ff8b3370)

    2021-09-13T14:48:04.683236  /lava-4509565/1/../bin/lava-test-case<8>[  =
 10.876503] <LAVA_SIGNAL_TESTCASE TEST_CASE_ID=3Ddwmmc_rockchip-sdmmc-probe=
d RESULT=3Dfail>
    2021-09-13T14:48:04.683596     =


  * baseline.bootrr.dwmmc_rockchip-sdio0-probed: https://kernelci.org/test/=
case/id/613f64c600f6403ed999a33a
        failing since 90 days (last pass: v5.10.43, first fail: v5.10.43-13=
1-g3f05ff8b3370)

    2021-09-13T14:48:05.696059  /lava-4509565/1/../bin/lava-test-case
    2021-09-13T14:48:05.701338  <8>[   11.895982] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Ddwmmc_rockchip-sdio0-probed RESULT=3Dfail>   =

 =



platform                | arch  | lab           | compiler | defconfig     =
     | regressions
------------------------+-------+---------------+----------+---------------=
-----+------------
sun50i-a64-bananapi-m64 | arm64 | lab-clabbe    | gcc-8    | defconfig     =
     | 1          =


  Details:     https://kernelci.org/test/plan/id/613f4fd809b0fd1bbc99a332

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.6=
4-215-g5352b1865825/arm64/defconfig/gcc-8/lab-clabbe/baseline-sun50i-a64-ba=
nanapi-m64.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.6=
4-215-g5352b1865825/arm64/defconfig/gcc-8/lab-clabbe/baseline-sun50i-a64-ba=
nanapi-m64.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/613f4fd809b0fd1bbc99a=
333
        new failure (last pass: v5.10.64) =

 =20
