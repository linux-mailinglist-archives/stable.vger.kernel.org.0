Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4E64F3EC376
	for <lists+stable@lfdr.de>; Sat, 14 Aug 2021 17:10:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234665AbhHNPLZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 14 Aug 2021 11:11:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57624 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234654AbhHNPLB (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 14 Aug 2021 11:11:01 -0400
Received: from mail-pj1-x102f.google.com (mail-pj1-x102f.google.com [IPv6:2607:f8b0:4864:20::102f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0341CC061764
        for <stable@vger.kernel.org>; Sat, 14 Aug 2021 08:10:26 -0700 (PDT)
Received: by mail-pj1-x102f.google.com with SMTP id qe12-20020a17090b4f8c00b00179321cbae7so9836290pjb.2
        for <stable@vger.kernel.org>; Sat, 14 Aug 2021 08:10:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=o7prPxuOelY4ppGArqPJVO6ZOKY+q1j9TpImHST3SOE=;
        b=JWE1d5ViHfrCjHpT8WuG2ySTvaz2jnPaH4nIzMtNwJ92PcPJjk3E0bloYzOqjajEii
         y8PqpGGfJ5d02hWJMsWmq6sKuc4EHu4PEvBllvVv57T+9LZojE+JZC+XiRmqa9qKr1s0
         GRiob1h1Po5hLZA76enxtN+xJEI5VJWF6O10OaIitqirzBI9+rSJ6M+RbnEAbHN2Cb10
         9T9koV6d6fKtGmyb87kpBNzMABZ5LObEPPfFLBkuQn98DdzZNgwdNRzXxHi4jlS3LMqz
         2STX8NrdOdFNqpya0y/P400tNk5KlXj3XqMj8cv52/AvdqU1GZiQxztyuw0A0J1MTrqG
         zapA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=o7prPxuOelY4ppGArqPJVO6ZOKY+q1j9TpImHST3SOE=;
        b=KqVIEGtQ1sobfo4GcST5ZLXLNqZIvKKb2Skl4Dfj56IQlBLpxIffMkq0oDv66WJ2uQ
         6qSZ8PfstIOWLI2dmNdaeodotKlX2z1yM+yDNjGaZAL1zXm4WHMAwx41QBxwwe9UcxgZ
         w4OCmkugD7vG1blc9mzaNWgXK6523QVF+saiT7hjH7YcWRhvHSYMvFuHRRjvnsU+0fYP
         gvDyFi+ON8T8Rz7ATLfJ4MSVBdhR780SueN9D8ds71bRIgjfufcIU0f8/7GTon1xlFHO
         MQjDkV8qlXERpRog0jcB1H6vNrwCfv6vSnxfiLC8KjPtpRLs/9k7GqdAjIOeKimaM9S0
         T0XQ==
X-Gm-Message-State: AOAM530af3tAI9k6D33G9dbHfZU3XslFnjYRGPpC8Bbkc+J3QTeYuVHh
        iR1fS0Wz27JDHVakJaDw2oDPZ2yRBrcibWfp
X-Google-Smtp-Source: ABdhPJxQjwJZsjjf0Bj3yMChEkmA469g5JenZRq7nk/RhisHI7u9fdJKlqhRHAPQuCY+BDNvZx8MXg==
X-Received: by 2002:a17:90a:eac4:: with SMTP id ev4mr1058901pjb.115.1628953825345;
        Sat, 14 Aug 2021 08:10:25 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id r4sm6071375pfc.167.2021.08.14.08.10.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 14 Aug 2021 08:10:25 -0700 (PDT)
Message-ID: <6117dce1.1c69fb81.81ff9.efd6@mx.google.com>
Date:   Sat, 14 Aug 2021 08:10:25 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: linux-5.10.y
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v5.10.57-155-ged2493daa915
X-Kernelci-Report-Type: test
Subject: stable-rc/linux-5.10.y baseline: 175 runs,
 6 regressions (v5.10.57-155-ged2493daa915)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-5.10.y baseline: 175 runs, 6 regressions (v5.10.57-155-ged2=
493daa915)

Regressions Summary
-------------------

platform          | arch  | lab           | compiler | defconfig           =
| regressions
------------------+-------+---------------+----------+---------------------=
+------------
hip07-d05         | arm64 | lab-collabora | gcc-8    | defconfig           =
| 1          =

imx7ulp-evk       | arm   | lab-nxp       | gcc-8    | imx_v6_v7_defconfig =
| 1          =

imx8mp-evk        | arm64 | lab-nxp       | gcc-8    | defconfig           =
| 1          =

rk3288-veyron-jaq | arm   | lab-collabora | gcc-8    | multi_v7_defconfig  =
| 3          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-5.10.y/ker=
nel/v5.10.57-155-ged2493daa915/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-5.10.y
  Describe: v5.10.57-155-ged2493daa915
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      ed2493daa915286093123bc53c2172d717bc5d82 =



Test Regressions
---------------- =



platform          | arch  | lab           | compiler | defconfig           =
| regressions
------------------+-------+---------------+----------+---------------------=
+------------
hip07-d05         | arm64 | lab-collabora | gcc-8    | defconfig           =
| 1          =


  Details:     https://kernelci.org/test/plan/id/6117ae7d880ba576d5b13664

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.5=
7-155-ged2493daa915/arm64/defconfig/gcc-8/lab-collabora/baseline-hip07-d05.=
txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.5=
7-155-ged2493daa915/arm64/defconfig/gcc-8/lab-collabora/baseline-hip07-d05.=
html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6117ae7d880ba576d5b13=
665
        failing since 43 days (last pass: v5.10.46-101-ga41d5119dc1e, first=
 fail: v5.10.47) =

 =



platform          | arch  | lab           | compiler | defconfig           =
| regressions
------------------+-------+---------------+----------+---------------------=
+------------
imx7ulp-evk       | arm   | lab-nxp       | gcc-8    | imx_v6_v7_defconfig =
| 1          =


  Details:     https://kernelci.org/test/plan/id/6117adf54a6ce85f66b1376e

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: imx_v6_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.5=
7-155-ged2493daa915/arm/imx_v6_v7_defconfig/gcc-8/lab-nxp/baseline-imx7ulp-=
evk.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.5=
7-155-ged2493daa915/arm/imx_v6_v7_defconfig/gcc-8/lab-nxp/baseline-imx7ulp-=
evk.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6117adf54a6ce85f66b13=
76f
        new failure (last pass: v5.10.57-136-g252d84386e00) =

 =



platform          | arch  | lab           | compiler | defconfig           =
| regressions
------------------+-------+---------------+----------+---------------------=
+------------
imx8mp-evk        | arm64 | lab-nxp       | gcc-8    | defconfig           =
| 1          =


  Details:     https://kernelci.org/test/plan/id/6117ad7d412e674060b13668

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.5=
7-155-ged2493daa915/arm64/defconfig/gcc-8/lab-nxp/baseline-imx8mp-evk.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.5=
7-155-ged2493daa915/arm64/defconfig/gcc-8/lab-nxp/baseline-imx8mp-evk.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6117ad7d412e674060b13=
669
        new failure (last pass: v5.10.57-136-g252d84386e00) =

 =



platform          | arch  | lab           | compiler | defconfig           =
| regressions
------------------+-------+---------------+----------+---------------------=
+------------
rk3288-veyron-jaq | arm   | lab-collabora | gcc-8    | multi_v7_defconfig  =
| 3          =


  Details:     https://kernelci.org/test/plan/id/6117abf1084bb4d925b136fb

  Results:     67 PASS, 3 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.5=
7-155-ged2493daa915/arm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-rk3=
288-veyron-jaq.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.5=
7-155-ged2493daa915/arm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-rk3=
288-veyron-jaq.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.bootrr.rockchip-iodomain-grf-probed: https://kernelci.org/test=
/case/id/6117abf1084bb4d925b13713
        failing since 60 days (last pass: v5.10.43, first fail: v5.10.43-13=
1-g3f05ff8b3370)

    2021-08-14T11:41:26.005238  /lava-4363624/1/../bin/lava-test-case<8>[  =
 14.864363] <LAVA_SIGNAL_TESTCASE TEST_CASE_ID=3Drockchip-iodomain-grf-prob=
ed RESULT=3Dfail>
    2021-08-14T11:41:26.005557  =

    2021-08-14T11:41:26.005849  /lava-4363624/1/../bin/lava-test-case   =


  * baseline.bootrr.dwmmc_rockchip-sdio0-probed: https://kernelci.org/test/=
case/id/6117abf1084bb4d925b1372b
        failing since 60 days (last pass: v5.10.43, first fail: v5.10.43-13=
1-g3f05ff8b3370)

    2021-08-14T11:41:24.562956  /lava-4363624/1/../bin/lava-test-case
    2021-08-14T11:41:24.579869  <8>[   13.438635] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Ddwmmc_rockchip-sdio0-probed RESULT=3Dfail>
    2021-08-14T11:41:24.580100  /lava-4363624/1/../bin/lava-test-case   =


  * baseline.bootrr.dwmmc_rockchip-sdmmc-probed: https://kernelci.org/test/=
case/id/6117abf1084bb4d925b1372c
        failing since 60 days (last pass: v5.10.43, first fail: v5.10.43-13=
1-g3f05ff8b3370)

    2021-08-14T11:41:23.542902  /lava-4363624/1/../bin/lava-test-case
    2021-08-14T11:41:23.548157  <8>[   12.418935] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Ddwmmc_rockchip-sdmmc-probed RESULT=3Dfail>   =

 =20
