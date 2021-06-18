Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D746B3AD370
	for <lists+stable@lfdr.de>; Fri, 18 Jun 2021 22:11:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230430AbhFRUN7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 18 Jun 2021 16:13:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38330 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230136AbhFRUN7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 18 Jun 2021 16:13:59 -0400
Received: from mail-pf1-x42c.google.com (mail-pf1-x42c.google.com [IPv6:2607:f8b0:4864:20::42c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7041BC061574
        for <stable@vger.kernel.org>; Fri, 18 Jun 2021 13:11:49 -0700 (PDT)
Received: by mail-pf1-x42c.google.com with SMTP id g6so8576697pfq.1
        for <stable@vger.kernel.org>; Fri, 18 Jun 2021 13:11:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=ccvU2HsgHU3yrhQmcCfiLMNxwwoNVxTsTz4TG3V56uY=;
        b=WRQYOFFLv9mwkGxA5fWBb2+p+V4vmF9eGqJDAQAyHt/Pouu0ZnEJjvJh5iN/TDrUbO
         UdrzVJcNBzGuM+6EXGPwjOLnax21gEeO2IT7/eru6GUcvV3FKbcRWFs/+ENr9L1S7fZt
         iATw9Uq3Zuw81sDsy1p2gOTrwWwPFgbN/2PHxaGpf6wtOpTbxIxTsUsXMPWu6y3A2VHW
         mUGhZ++9Uv3BunOPvrCSrE92WRH427vLOfWLS+Hw2IqXNe8LPDwzuPFrVFpIPGCJx6Fs
         WuxfUpBTOOsydBTYv/NHivaft7tRspG5m+r7FndbjwTevr5lY5iQHYWl9/TX9zxdJuTM
         mm7w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=ccvU2HsgHU3yrhQmcCfiLMNxwwoNVxTsTz4TG3V56uY=;
        b=bUggCxUxS3wwt0aIct45Ekqagjs9UJ20kKVdifrPSsVfX1hNOdW6x4ZckPPXFfwLqI
         /NuYcQB7ZUtElw1jD9caOUCm1AMuHAX3zISyMZRXbjfIirykRA39z2szw6xvLfFta4SP
         gTJR6txbIMEy7qL/YSEJ5dDHGt5ZX9UmUgRPP79EvDi1JnblBHqyZRVGI5u2+sCCFya7
         o6LAxmSmsQlW5aLorkKred3/tFxNACgWq6eoHi7beBtLLbZIy4uwf9Jal7QLL+gJ4Hbk
         Qbm+qEM9sj+aXC+GaIhN/uFaXmI8NIZpWVU79QC5s3tfCE5ht5qbCJ33hZY2B03dfbKo
         oX7w==
X-Gm-Message-State: AOAM533LDEayp6Jz4qksXapw04w9kLVGsWMeiO6un6o3R9UGxZBSTBwz
        B5Qhve7i3/mbRhzBDU7n2a7tSEHECrN1w8M3
X-Google-Smtp-Source: ABdhPJzcnOAqLOCtvyumsHuVRtCpl7jCrtcFIC7A7e+scvuhemDCq/BfDXC81P0YH67NfHQa08yARw==
X-Received: by 2002:a05:6a00:1146:b029:2fe:d681:fbcc with SMTP id b6-20020a056a001146b02902fed681fbccmr6880544pfm.31.1624047108857;
        Fri, 18 Jun 2021 13:11:48 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id d127sm8617234pfc.50.2021.06.18.13.11.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 18 Jun 2021 13:11:48 -0700 (PDT)
Message-ID: <60ccfe04.1c69fb81.6483c.7edd@mx.google.com>
Date:   Fri, 18 Jun 2021 13:11:48 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v4.14.237-21-g0edd8ca2ad72
X-Kernelci-Branch: queue/4.14
X-Kernelci-Tree: stable-rc
Subject: stable-rc/queue/4.14 baseline: 111 runs,
 5 regressions (v4.14.237-21-g0edd8ca2ad72)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.14 baseline: 111 runs, 5 regressions (v4.14.237-21-g0edd8=
ca2ad72)

Regressions Summary
-------------------

platform          | arch  | lab           | compiler | defconfig          |=
 regressions
------------------+-------+---------------+----------+--------------------+=
------------
fsl-ls2088a-rdb   | arm64 | lab-nxp       | gcc-8    | defconfig          |=
 1          =

meson-gxm-q200    | arm64 | lab-baylibre  | gcc-8    | defconfig          |=
 1          =

rk3288-veyron-jaq | arm   | lab-collabora | gcc-8    | multi_v7_defconfig |=
 3          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.14/ker=
nel/v4.14.237-21-g0edd8ca2ad72/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.14
  Describe: v4.14.237-21-g0edd8ca2ad72
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      0edd8ca2ad72cf181515082771a62aa302e4040e =



Test Regressions
---------------- =



platform          | arch  | lab           | compiler | defconfig          |=
 regressions
------------------+-------+---------------+----------+--------------------+=
------------
fsl-ls2088a-rdb   | arm64 | lab-nxp       | gcc-8    | defconfig          |=
 1          =


  Details:     https://kernelci.org/test/plan/id/60cccf4fe7d7b2c36a413319

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.237=
-21-g0edd8ca2ad72/arm64/defconfig/gcc-8/lab-nxp/baseline-fsl-ls2088a-rdb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.237=
-21-g0edd8ca2ad72/arm64/defconfig/gcc-8/lab-nxp/baseline-fsl-ls2088a-rdb.ht=
ml
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60cccf4fe7d7b2c36a413=
31a
        new failure (last pass: v4.14.237-17-gb9f48f685d2c) =

 =



platform          | arch  | lab           | compiler | defconfig          |=
 regressions
------------------+-------+---------------+----------+--------------------+=
------------
meson-gxm-q200    | arm64 | lab-baylibre  | gcc-8    | defconfig          |=
 1          =


  Details:     https://kernelci.org/test/plan/id/60ccde9d50da3fd4cb4132a2

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.237=
-21-g0edd8ca2ad72/arm64/defconfig/gcc-8/lab-baylibre/baseline-meson-gxm-q20=
0.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.237=
-21-g0edd8ca2ad72/arm64/defconfig/gcc-8/lab-baylibre/baseline-meson-gxm-q20=
0.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60ccde9d50da3fd4cb413=
2a3
        failing since 109 days (last pass: v4.14.222-11-g13b8482a0f700, fir=
st fail: v4.14.222-120-gdc8887cba23e) =

 =



platform          | arch  | lab           | compiler | defconfig          |=
 regressions
------------------+-------+---------------+----------+--------------------+=
------------
rk3288-veyron-jaq | arm   | lab-collabora | gcc-8    | multi_v7_defconfig |=
 3          =


  Details:     https://kernelci.org/test/plan/id/60cce7e4bff560f2b5413273

  Results:     62 PASS, 6 FAIL, 1 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.237=
-21-g0edd8ca2ad72/arm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-rk328=
8-veyron-jaq.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.237=
-21-g0edd8ca2ad72/arm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-rk328=
8-veyron-jaq.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.bootrr.dwmmc_rockchip-sdmmc-probed: https://kernelci.org/test/=
case/id/60cce7e4bff560f2b541328f
        failing since 3 days (last pass: v4.14.236-20-gdb14655bb4bf, first =
fail: v4.14.236-49-gfd4c319f2583)

    2021-06-18T18:37:00.682710  /lava-4053520/1/../bin/lava-test-case
    2021-06-18T18:37:00.683360  [   12.648312] <LAVA_SIGNAL_TESTCASE TEST_C=
ASE_ID=3Ddwmmc_rockchip-sdmmc-probed RESULT=3Dfail>   =


  * baseline.bootrr.dwmmc_rockchip-sdio0-probed: https://kernelci.org/test/=
case/id/60cce7e4bff560f2b5413290
        failing since 3 days (last pass: v4.14.236-20-gdb14655bb4bf, first =
fail: v4.14.236-49-gfd4c319f2583)

    2021-06-18T18:37:01.700404  /lava-4053520/1/../bin/lava-test-case
    2021-06-18T18:37:01.717605  [   13.667077] <LAVA_SIGNAL_TESTCASE TEST_C=
ASE_ID=3Ddwmmc_rockchip-sdio0-probed RESULT=3Dfail>
    2021-06-18T18:37:01.718078  /lava-4053520/1/../bin/lava-test-case   =


  * baseline.bootrr.rockchip-iodomain-grf-probed: https://kernelci.org/test=
/case/id/60cce7e4bff560f2b54132a9
        failing since 3 days (last pass: v4.14.236-20-gdb14655bb4bf, first =
fail: v4.14.236-49-gfd4c319f2583)

    2021-06-18T18:37:04.130591  /lava-4053520/1/../bin/lava-test-case
    2021-06-18T18:37:04.147532  [   16.097355] <LAVA_SIGNAL_TESTCASE TEST_C=
ASE_ID=3Drockchip-iodomain-grf-probed RESULT=3Dfail>
    2021-06-18T18:37:04.148034  /lava-4053520/1/../bin/lava-test-case   =

 =20
