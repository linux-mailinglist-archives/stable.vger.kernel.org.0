Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C5D23427E12
	for <lists+stable@lfdr.de>; Sun, 10 Oct 2021 01:43:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231469AbhJIXpZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 9 Oct 2021 19:45:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39812 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231411AbhJIXpZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 9 Oct 2021 19:45:25 -0400
Received: from mail-pg1-x533.google.com (mail-pg1-x533.google.com [IPv6:2607:f8b0:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A59D4C061570
        for <stable@vger.kernel.org>; Sat,  9 Oct 2021 16:43:27 -0700 (PDT)
Received: by mail-pg1-x533.google.com with SMTP id a73so7089836pge.0
        for <stable@vger.kernel.org>; Sat, 09 Oct 2021 16:43:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=VVzEh8OhvQW0KVcX0uOg7IFC7kzwwyOTI4DIYcowp2Q=;
        b=OP2N+Z8nb7/BL0xkExUBIBn2tXxPMoVjJ3ytArE28d6x3tavm6GC1VBbGvjLUlJqe8
         WOW5ZsrSJWkP3MFGQyyj5bWdJw4wsxfYfGglTLV/7KHkCUEhin1C4KSK9gmP6inaiYqh
         bSlgE/u6OzCwxLikw9Y9RupUASe/tEFK0fKcwhxzO+AUptU6rAzV240G1mt8MCAGn08A
         leXqYEr1H+FmsJh1On6Yq68ODjpGFW6qneBEbH+egjcx2bpfLyJso7SqkauNyIQiyNJ4
         oqrEE/AWBHKQGgMcn3ohLhMbVWe6OsYNMJP9q76gxO4UmH56A8tA2nfqTWHsFJmDxGFN
         XUkQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=VVzEh8OhvQW0KVcX0uOg7IFC7kzwwyOTI4DIYcowp2Q=;
        b=jy0GkTwcU3Ie5hVJkfsbPcBNYLgc1cHiKPXn8C/TauIoa1PXL1xaVMJ+vHk0NKtm1H
         TJVtJrPWbF0fC7N2MKHd4JWSvibClnpokAdAbDCw/xEhtnX9SkG2abG7JA8HRqq8ypM2
         rvS0FH72m+fLp3ANnm8LfLnRvuEZH6z8SX2DgGK6Mpe+ib1/dH81qN+8+waicSW42Wgi
         ajQiowAOhG7tSxGirZRIR4mx5nZrdmIVz1KMjlqKl8GKOqmx9MPcJFl+90AhPjn9t0ol
         ccVDQ716LYsNvLlu87DlR3b33m5Cm0I2eNPQxpESLUqSW9u6sgOSaId49moXlID/q6JQ
         0UGA==
X-Gm-Message-State: AOAM530rjn6szafIph/gjasHL9LtsQ4e7FIL8JBPGuLbLcKTGF3Vx2zp
        L2Qai0Vd4+5Wzh0Zc7KHnv7IFmvwA58gck9n
X-Google-Smtp-Source: ABdhPJy75ZPp5bYLi8NysXcPPBBVRmsWgCoFAaaudvuIQRxZrLRj4Zjdldovh0PSU3fq5YD1fZWyuA==
X-Received: by 2002:a63:b204:: with SMTP id x4mr11389258pge.212.1633823006963;
        Sat, 09 Oct 2021 16:43:26 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id w15sm3170703pfc.220.2021.10.09.16.43.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 09 Oct 2021 16:43:26 -0700 (PDT)
Message-ID: <6162291e.1c69fb81.14eed.92d1@mx.google.com>
Date:   Sat, 09 Oct 2021 16:43:26 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v5.10.72-19-g2ca9b8bdb28b
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/5.10
Subject: stable-rc/queue/5.10 baseline: 174 runs,
 7 regressions (v5.10.72-19-g2ca9b8bdb28b)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.10 baseline: 174 runs, 7 regressions (v5.10.72-19-g2ca9b8=
bdb28b)

Regressions Summary
-------------------

platform                 | arch  | lab           | compiler | defconfig    =
      | regressions
-------------------------+-------+---------------+----------+--------------=
------+------------
imx6q-var-dt6customboard | arm   | lab-baylibre  | gcc-8    | multi_v7_defc=
onfig | 2          =

imx7d-sdb                | arm   | lab-nxp       | gcc-8    | multi_v7_defc=
onfig | 1          =

imx8mp-evk               | arm64 | lab-nxp       | gcc-8    | defconfig    =
      | 1          =

rk3288-veyron-jaq        | arm   | lab-collabora | gcc-8    | multi_v7_defc=
onfig | 3          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.10/ker=
nel/v5.10.72-19-g2ca9b8bdb28b/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.10
  Describe: v5.10.72-19-g2ca9b8bdb28b
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      2ca9b8bdb28b4698e26e197d886e3fbe26311d05 =



Test Regressions
---------------- =



platform                 | arch  | lab           | compiler | defconfig    =
      | regressions
-------------------------+-------+---------------+----------+--------------=
------+------------
imx6q-var-dt6customboard | arm   | lab-baylibre  | gcc-8    | multi_v7_defc=
onfig | 2          =


  Details:     https://kernelci.org/test/plan/id/6161f0ecc5d17ae87399a2ef

  Results:     4 PASS, 2 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.72-=
19-g2ca9b8bdb28b/arm/multi_v7_defconfig/gcc-8/lab-baylibre/baseline-imx6q-v=
ar-dt6customboard.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.72-=
19-g2ca9b8bdb28b/arm/multi_v7_defconfig/gcc-8/lab-baylibre/baseline-imx6q-v=
ar-dt6customboard.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.dmesg.alert: https://kernelci.org/test/case/id/6161f0ecc5d17ae=
87399a2f6
        new failure (last pass: v5.10.71-29-g7067f3d9b27d)
        4 lines

    2021-10-09T19:43:19.772698  kern  :alert : 8<--- cut here ---
    2021-10-09T19:43:19.803625  kern  :alert : Unhandled fault: alignment e=
xception (0x001) at 0xcec60217
    2021-10-09T19:43:19.803945  kern  :alert : pgd =3D (ptrval)
    2021-10-09T19:43:19.804949  kern  :alert : [<8>[   43.584779] <LAVA_SIG=
NAL_TESTCASE TEST_CASE_ID=3Dalert RESULT=3Dfail UNITS=3Dlines MEASUREMENT=
=3D4>
    2021-10-09T19:43:19.805321  cec60217] *pgd=3D1ec1141e(bad)   =


  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/6161f0ecc5d17ae=
87399a2f7
        new failure (last pass: v5.10.71-29-g7067f3d9b27d)
        26 lines

    2021-10-09T19:43:19.855841  kern  :emerg : Internal error: : 1 [#1] SMP=
 ARM
    2021-10-09T19:43:19.856204  kern  :emerg : Process kworker/0:0 (pid: 5,=
 stack limit =3D 0x(ptrval))
    2021-10-09T19:43:19.856743  kern  :emerg : Stack: (0xc210feb0 to <8>[  =
 43.630997] <LAVA_SIGNAL_TESTCASE TEST_CASE_ID=3Demerg RESULT=3Dfail UNITS=
=3Dlines MEASUREMENT=3D26>
    2021-10-09T19:43:19.857010  0xc2110000)
    2021-10-09T19:43:19.857260  kern  :emerg : fea0:<8>[   43.642914] <LAVA=
_SIGNAL_ENDRUN 0_dmesg 935625_1.5.2.4.1>
    2021-10-09T19:43:19.857499                                       c210e0=
00 ef78fdc0 c189c978 cec60217   =

 =



platform                 | arch  | lab           | compiler | defconfig    =
      | regressions
-------------------------+-------+---------------+----------+--------------=
------+------------
imx7d-sdb                | arm   | lab-nxp       | gcc-8    | multi_v7_defc=
onfig | 1          =


  Details:     https://kernelci.org/test/plan/id/6161f24df7847025f299a2e4

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.72-=
19-g2ca9b8bdb28b/arm/multi_v7_defconfig/gcc-8/lab-nxp/baseline-imx7d-sdb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.72-=
19-g2ca9b8bdb28b/arm/multi_v7_defconfig/gcc-8/lab-nxp/baseline-imx7d-sdb.ht=
ml
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6161f24df7847025f299a=
2e5
        new failure (last pass: v5.10.71-29-g7067f3d9b27d) =

 =



platform                 | arch  | lab           | compiler | defconfig    =
      | regressions
-------------------------+-------+---------------+----------+--------------=
------+------------
imx8mp-evk               | arm64 | lab-nxp       | gcc-8    | defconfig    =
      | 1          =


  Details:     https://kernelci.org/test/plan/id/6161f4f354265725c499a2fa

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.72-=
19-g2ca9b8bdb28b/arm64/defconfig/gcc-8/lab-nxp/baseline-imx8mp-evk.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.72-=
19-g2ca9b8bdb28b/arm64/defconfig/gcc-8/lab-nxp/baseline-imx8mp-evk.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6161f4f354265725c499a=
2fb
        new failure (last pass: v5.10.71-27-g0503cdd00c93) =

 =



platform                 | arch  | lab           | compiler | defconfig    =
      | regressions
-------------------------+-------+---------------+----------+--------------=
------+------------
rk3288-veyron-jaq        | arm   | lab-collabora | gcc-8    | multi_v7_defc=
onfig | 3          =


  Details:     https://kernelci.org/test/plan/id/616207090718365c0b99a3cb

  Results:     67 PASS, 3 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.72-=
19-g2ca9b8bdb28b/arm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-rk3288=
-veyron-jaq.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.72-=
19-g2ca9b8bdb28b/arm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-rk3288=
-veyron-jaq.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.bootrr.rockchip-iodomain-grf-probed: https://kernelci.org/test=
/case/id/616207090718365c0b99a3df
        failing since 116 days (last pass: v5.10.43-44-g253317604975, first=
 fail: v5.10.43-130-g87b5f83f722c)

    2021-10-09T21:17:44.476788  /lava-4686503/1/../bin/lava-test-case
    2021-10-09T21:17:44.493808  <8>[   13.614763] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Drockchip-iodomain-grf-probed RESULT=3Dfail>
    2021-10-09T21:17:44.494037  /lava-4686503/1/../bin/lava-test-case   =


  * baseline.bootrr.dwmmc_rockchip-sdio0-probed: https://kernelci.org/test/=
case/id/6162070a0718365c0b99a3f7
        failing since 116 days (last pass: v5.10.43-44-g253317604975, first=
 fail: v5.10.43-130-g87b5f83f722c)

    2021-10-09T21:17:43.049501  /lava-4686503/1/../bin/lava-test-case
    2021-10-09T21:17:43.066825  <8>[   12.186790] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Ddwmmc_rockchip-sdio0-probed RESULT=3Dfail>
    2021-10-09T21:17:43.067112  /lava-4686503/1/../bin/lava-test-case   =


  * baseline.bootrr.dwmmc_rockchip-sdmmc-probed: https://kernelci.org/test/=
case/id/6162070a0718365c0b99a3f8
        failing since 116 days (last pass: v5.10.43-44-g253317604975, first=
 fail: v5.10.43-130-g87b5f83f722c)

    2021-10-09T21:17:42.030566  /lava-4686503/1/../bin/lava-test-case
    2021-10-09T21:17:42.038520  <8>[   11.167176] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Ddwmmc_rockchip-sdmmc-probed RESULT=3Dfail>   =

 =20
