Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 345383F0EB8
	for <lists+stable@lfdr.de>; Thu, 19 Aug 2021 01:42:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234882AbhHRXmk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 18 Aug 2021 19:42:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37028 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235060AbhHRXmj (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 18 Aug 2021 19:42:39 -0400
Received: from mail-pl1-x636.google.com (mail-pl1-x636.google.com [IPv6:2607:f8b0:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 71A70C061764
        for <stable@vger.kernel.org>; Wed, 18 Aug 2021 16:42:04 -0700 (PDT)
Received: by mail-pl1-x636.google.com with SMTP id q2so2824538plr.11
        for <stable@vger.kernel.org>; Wed, 18 Aug 2021 16:42:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=dOh7G6EpEFzDjB8sAeVtcytZKguCg+lyPLHBAYcGpC4=;
        b=rs+WquClTwv7Fgj/OHAtQPJEqEyi6Ve/eesSEbYJu9rKKw7INnewJrY51xwg8tIAzf
         jcgTdqqFanIng5xKIiHqyENf+I67ps8vvFOi9mDe890k4KW1UEvPk8qqHwgp+bMEIHxp
         HgrXxyPEXrj72w/WTXk/bC+ME7SDF4vfVDoAp/Ksvv9p82zfzEKC3wTDJUyvn6eObY5G
         +HlPjMyqy6SfSpYirlHZkAk3FivxFqFDzGxmUFbATWZL9S4Z9OA6fH4OCeEGVIseptDl
         77rI6Gnxy/n4d/DJ+VefhZsM8xmvYJ5QA9lQxEjJVh5wpM4A5qWHjLEr8K5LAfgGQLan
         lj8Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=dOh7G6EpEFzDjB8sAeVtcytZKguCg+lyPLHBAYcGpC4=;
        b=bjRMXCFG8AlrH1+PHG/V7NeUoJa517XO83pzgXO8JXyj1ibTFhqrhZqnKnr1WwVVJS
         I5k6kzD9+Rqtz5iyF6xnOvnjVAj+3fMGo/qh/EZ280gZNrvz9j7w3aHcDkcQh3E3SP/1
         B8BHjBhgDxTa9yKRn/dwSB8FwY1QfpOvsGxxyAIkol4J+6WcDIX9qXv5pxmOSdSNSSzV
         03wi+Xz8HlAbcRTvNMt4B3ItgB7nBQu1JLqOdH2hNiPmFeJN+XDq4+G6ZIhVACfyoJMo
         SjWMQU9Daw9rW6nGY44pw86jcoRfyxB6rAMvnZfAvZlih0+EboT9vi68lBWWwiThtdUU
         NOOA==
X-Gm-Message-State: AOAM532xZiBk33QrlWlVWsfLP3yJkzdBxxMypuUmJk53zLcd9dQw0iQb
        D6JYQm0CWcncYKZPyCbpjUtzb5F1iHVV9ZGG
X-Google-Smtp-Source: ABdhPJxmO/O3KytVpiqO9QlmXe0vXXqE6IDHTm/bptg+SlAzr/gF/pnX0DJdrJ8GsoPg3Q8sMJP5xg==
X-Received: by 2002:a17:90b:1989:: with SMTP id mv9mr11600553pjb.100.1629330123833;
        Wed, 18 Aug 2021 16:42:03 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id u11sm905350pfk.100.2021.08.18.16.42.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 18 Aug 2021 16:42:03 -0700 (PDT)
Message-ID: <611d9acb.1c69fb81.8739a.489e@mx.google.com>
Date:   Wed, 18 Aug 2021 16:42:03 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: linux-5.10.y
X-Kernelci-Tree: stable
X-Kernelci-Kernel: v5.10.60
X-Kernelci-Report-Type: test
Subject: stable/linux-5.10.y baseline: 161 runs, 8 regressions (v5.10.60)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable/linux-5.10.y baseline: 161 runs, 8 regressions (v5.10.60)

Regressions Summary
-------------------

platform                | arch  | lab           | compiler | defconfig     =
     | regressions
------------------------+-------+---------------+----------+---------------=
-----+------------
fsl-ls1028a-rdb         | arm64 | lab-nxp       | gcc-8    | defconfig     =
     | 1          =

hip07-d05               | arm64 | lab-collabora | gcc-8    | defconfig     =
     | 1          =

imx6q-sabresd           | arm   | lab-nxp       | gcc-8    | multi_v7_defco=
nfig | 1          =

imx8mp-evk              | arm64 | lab-nxp       | gcc-8    | defconfig     =
     | 1          =

rk3288-veyron-jaq       | arm   | lab-collabora | gcc-8    | multi_v7_defco=
nfig | 3          =

sun50i-a64-bananapi-m64 | arm64 | lab-clabbe    | gcc-8    | defconfig     =
     | 1          =


  Details:  https://kernelci.org/test/job/stable/branch/linux-5.10.y/kernel=
/v5.10.60/plan/baseline/

  Test:     baseline
  Tree:     stable
  Branch:   linux-5.10.y
  Describe: v5.10.60
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able.git
  SHA:      2c5bd949b1df3f9fb109107b3d766e2ebabd7238 =



Test Regressions
---------------- =



platform                | arch  | lab           | compiler | defconfig     =
     | regressions
------------------------+-------+---------------+----------+---------------=
-----+------------
fsl-ls1028a-rdb         | arm64 | lab-nxp       | gcc-8    | defconfig     =
     | 1          =


  Details:     https://kernelci.org/test/plan/id/611d6ca402171ec899b1367c

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable/linux-5.10.y/v5.10.60/a=
rm64/defconfig/gcc-8/lab-nxp/baseline-fsl-ls1028a-rdb.txt
  HTML log:    https://storage.kernelci.org//stable/linux-5.10.y/v5.10.60/a=
rm64/defconfig/gcc-8/lab-nxp/baseline-fsl-ls1028a-rdb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/611d6ca402171ec899b13=
67d
        new failure (last pass: v5.10.56) =

 =



platform                | arch  | lab           | compiler | defconfig     =
     | regressions
------------------------+-------+---------------+----------+---------------=
-----+------------
hip07-d05               | arm64 | lab-collabora | gcc-8    | defconfig     =
     | 1          =


  Details:     https://kernelci.org/test/plan/id/611d7d9cf995032742b1366c

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable/linux-5.10.y/v5.10.60/a=
rm64/defconfig/gcc-8/lab-collabora/baseline-hip07-d05.txt
  HTML log:    https://storage.kernelci.org//stable/linux-5.10.y/v5.10.60/a=
rm64/defconfig/gcc-8/lab-collabora/baseline-hip07-d05.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/611d7d9cf995032742b13=
66d
        failing since 42 days (last pass: v5.10.46, first fail: v5.10.48) =

 =



platform                | arch  | lab           | compiler | defconfig     =
     | regressions
------------------------+-------+---------------+----------+---------------=
-----+------------
imx6q-sabresd           | arm   | lab-nxp       | gcc-8    | multi_v7_defco=
nfig | 1          =


  Details:     https://kernelci.org/test/plan/id/611d6b558d5c3ad115b1367a

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable/linux-5.10.y/v5.10.60/a=
rm/multi_v7_defconfig/gcc-8/lab-nxp/baseline-imx6q-sabresd.txt
  HTML log:    https://storage.kernelci.org//stable/linux-5.10.y/v5.10.60/a=
rm/multi_v7_defconfig/gcc-8/lab-nxp/baseline-imx6q-sabresd.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/611d6b558d5c3ad115b13=
67b
        new failure (last pass: v5.10.57) =

 =



platform                | arch  | lab           | compiler | defconfig     =
     | regressions
------------------------+-------+---------------+----------+---------------=
-----+------------
imx8mp-evk              | arm64 | lab-nxp       | gcc-8    | defconfig     =
     | 1          =


  Details:     https://kernelci.org/test/plan/id/611d6a4a66c23efdb2b1367a

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable/linux-5.10.y/v5.10.60/a=
rm64/defconfig/gcc-8/lab-nxp/baseline-imx8mp-evk.txt
  HTML log:    https://storage.kernelci.org//stable/linux-5.10.y/v5.10.60/a=
rm64/defconfig/gcc-8/lab-nxp/baseline-imx8mp-evk.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/611d6a4a66c23efdb2b13=
67b
        failing since 13 days (last pass: v5.10.54, first fail: v5.10.56) =

 =



platform                | arch  | lab           | compiler | defconfig     =
     | regressions
------------------------+-------+---------------+----------+---------------=
-----+------------
rk3288-veyron-jaq       | arm   | lab-collabora | gcc-8    | multi_v7_defco=
nfig | 3          =


  Details:     https://kernelci.org/test/plan/id/611d6aacafd99f049fb13679

  Results:     67 PASS, 3 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable/linux-5.10.y/v5.10.60/a=
rm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-rk3288-veyron-jaq.txt
  HTML log:    https://storage.kernelci.org//stable/linux-5.10.y/v5.10.60/a=
rm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-rk3288-veyron-jaq.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.bootrr.rockchip-iodomain-grf-probed: https://kernelci.org/test=
/case/id/611d6aacafd99f049fb13691
        failing since 63 days (last pass: v5.10.43, first fail: v5.10.44)

    2021-08-18T20:16:26.801444  /lava-4379615/1/../bin/lava-test-case<8>[  =
 13.470823] <LAVA_SIGNAL_TESTCASE TEST_CASE_ID=3Drockchip-iodomain-grf-prob=
ed RESULT=3Dfail>
    2021-08-18T20:16:26.801774  =

    2021-08-18T20:16:26.801970  /lava-4379615/1/../bin/lava-test-case   =


  * baseline.bootrr.dwmmc_rockchip-sdio0-probed: https://kernelci.org/test/=
case/id/611d6aadafd99f049fb136a9
        failing since 63 days (last pass: v5.10.43, first fail: v5.10.44)

    2021-08-18T20:16:25.358878  /lava-4379615/1/../bin/lava-test-case
    2021-08-18T20:16:25.375805  <8>[   12.045940] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Ddwmmc_rockchip-sdio0-probed RESULT=3Dfail>   =


  * baseline.bootrr.dwmmc_rockchip-sdmmc-probed: https://kernelci.org/test/=
case/id/611d6aadafd99f049fb136aa
        failing since 63 days (last pass: v5.10.43, first fail: v5.10.44)

    2021-08-18T20:16:24.339102  /lava-4379615/1/../bin/lava-test-case
    2021-08-18T20:16:24.344787  <8>[   11.026340] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Ddwmmc_rockchip-sdmmc-probed RESULT=3Dfail>   =

 =



platform                | arch  | lab           | compiler | defconfig     =
     | regressions
------------------------+-------+---------------+----------+---------------=
-----+------------
sun50i-a64-bananapi-m64 | arm64 | lab-clabbe    | gcc-8    | defconfig     =
     | 1          =


  Details:     https://kernelci.org/test/plan/id/611d692bb9f5cb0e87b136aa

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable/linux-5.10.y/v5.10.60/a=
rm64/defconfig/gcc-8/lab-clabbe/baseline-sun50i-a64-bananapi-m64.txt
  HTML log:    https://storage.kernelci.org//stable/linux-5.10.y/v5.10.60/a=
rm64/defconfig/gcc-8/lab-clabbe/baseline-sun50i-a64-bananapi-m64.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/611d692bb9f5cb0e87b13=
6ab
        failing since 5 days (last pass: v5.10.56, first fail: v5.10.58) =

 =20
