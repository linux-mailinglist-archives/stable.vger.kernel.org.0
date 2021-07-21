Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7DA703D0E40
	for <lists+stable@lfdr.de>; Wed, 21 Jul 2021 13:58:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237063AbhGULQH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 21 Jul 2021 07:16:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44624 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235157AbhGUK4t (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 21 Jul 2021 06:56:49 -0400
Received: from mail-pf1-x432.google.com (mail-pf1-x432.google.com [IPv6:2607:f8b0:4864:20::432])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F33EFC061767
        for <stable@vger.kernel.org>; Wed, 21 Jul 2021 04:37:25 -0700 (PDT)
Received: by mail-pf1-x432.google.com with SMTP id d5so432468pfq.12
        for <stable@vger.kernel.org>; Wed, 21 Jul 2021 04:37:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=03j9zm7p1tdyBleh12DTvgLDILx9rCTLSYXWWhWVl28=;
        b=hZLM8vqXQggqRy3RPLB+KlxzFcAK62xG5vAhEGRTND1HJRwnn6knywSAdpFStZrlk0
         GjTxUVFzMuVZUTtpjJjAEOWGbok//BnbKZ+nnLEfqc/KEyjE/arXbLBjsoyAsrw0Pjtj
         Cd8U6TMkJLLf4WbV7PIW6BnDOXyoOf4ssO6DmvXPy4OUvP+CFskI94bNFPY2hg18ALvb
         KHMOjI4/0CznhOro6NHDql+s8RTiyccKOXAVIEF4qFlpaKkd+WCF0S3rpAqN7ghRTIK1
         canfmyeyCRBY8qTGq0qnNqiKY1fhYQWezX+PzaWjtGxLMkeFBz+ElKxERfNOsaJsKyiL
         Ytvw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=03j9zm7p1tdyBleh12DTvgLDILx9rCTLSYXWWhWVl28=;
        b=o/82gWpcwtj0SmyAxP+EVVBkQrrH/w187pWOvCs7luFOKnawsOp5GJyekrGhPtE4ar
         UcyQeSRYax02YGEWQin4H5NEHYjy+mxa8qj2iR1CfClYn6UwytiJn4jyCY/kKZwKdO8E
         Oo4QQuBVjKSZx3oNr0WBh5ymGwSknIbrS29Lif1RgRscHS3Hi0Xj/+kXRcjFvs9lDvYm
         qmOV6YYsXaRGeoTQYGPXyg7pjut1PihkPC7NXZqKtCTnNOjvMqiwZqVPS4oqUQydFl3f
         H0XMvOc6mi2ub2mdyZEljR294Fa9eLfgZFab8CqZs6LixrCYzHBuE0BdprlbzNrWGKid
         Xy7w==
X-Gm-Message-State: AOAM530AnEBMH5MeIwX2DqckC9buWyB1yEHftWteZ+Eweq29LCVurpd0
        e6ynFLvmQ3cQheHFIzFEDnxVxjV040g+5cuf
X-Google-Smtp-Source: ABdhPJymBKIkxxRBZPZnEfKudyPTm/cKsUDX1JsvUKAx+LJnNMrhmeBzOl8mIguDkaeRjcTUUbHbYw==
X-Received: by 2002:a05:6a00:cd1:b029:346:8678:ce1b with SMTP id b17-20020a056a000cd1b02903468678ce1bmr17001506pfv.41.1626867445334;
        Wed, 21 Jul 2021 04:37:25 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id p3sm3884221pfw.171.2021.07.21.04.37.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 21 Jul 2021 04:37:25 -0700 (PDT)
Message-ID: <60f806f5.1c69fb81.53f67.c6af@mx.google.com>
Date:   Wed, 21 Jul 2021 04:37:25 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: linux-5.12.y
X-Kernelci-Kernel: v5.12.18-288-gaa783473cf1e0
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
Subject: stable-rc/linux-5.12.y baseline: 184 runs,
 8 regressions (v5.12.18-288-gaa783473cf1e0)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-5.12.y baseline: 184 runs, 8 regressions (v5.12.18-288-gaa7=
83473cf1e0)

Regressions Summary
-------------------

platform                | arch   | lab           | compiler | defconfig    =
                | regressions
------------------------+--------+---------------+----------+--------------=
----------------+------------
beagle-xm               | arm    | lab-baylibre  | gcc-8    | omap2plus_def=
config          | 1          =

d2500cc                 | x86_64 | lab-clabbe    | gcc-8    | x86_64_defcon=
...6-chromebook | 1          =

d2500cc                 | x86_64 | lab-clabbe    | gcc-8    | x86_64_defcon=
fig             | 1          =

imx8mp-evk              | arm64  | lab-nxp       | gcc-8    | defconfig    =
                | 1          =

rk3288-veyron-jaq       | arm    | lab-collabora | gcc-8    | multi_v7_defc=
onfig           | 3          =

sun50i-a64-bananapi-m64 | arm64  | lab-clabbe    | gcc-8    | defconfig    =
                | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-5.12.y/ker=
nel/v5.12.18-288-gaa783473cf1e0/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-5.12.y
  Describe: v5.12.18-288-gaa783473cf1e0
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      aa783473cf1e00e4344531089962861c6bbbb818 =



Test Regressions
---------------- =



platform                | arch   | lab           | compiler | defconfig    =
                | regressions
------------------------+--------+---------------+----------+--------------=
----------------+------------
beagle-xm               | arm    | lab-baylibre  | gcc-8    | omap2plus_def=
config          | 1          =


  Details:     https://kernelci.org/test/plan/id/60f7d4f3826c3d281b85c285

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.12.y/v5.12.1=
8-288-gaa783473cf1e0/arm/omap2plus_defconfig/gcc-8/lab-baylibre/baseline-be=
agle-xm.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.12.y/v5.12.1=
8-288-gaa783473cf1e0/arm/omap2plus_defconfig/gcc-8/lab-baylibre/baseline-be=
agle-xm.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60f7d4f3826c3d281b85c=
286
        failing since 1 day (last pass: v5.12.17, first fail: v5.12.18-289-=
g713b6ddbe96a8) =

 =



platform                | arch   | lab           | compiler | defconfig    =
                | regressions
------------------------+--------+---------------+----------+--------------=
----------------+------------
d2500cc                 | x86_64 | lab-clabbe    | gcc-8    | x86_64_defcon=
...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/60f7cde8a81370e26385c288

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-8 (gcc (Debian 8.3.0-6) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.12.y/v5.12.1=
8-288-gaa783473cf1e0/x86_64/x86_64_defconfig+x86-chromebook/gcc-8/lab-clabb=
e/baseline-d2500cc.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.12.y/v5.12.1=
8-288-gaa783473cf1e0/x86_64/x86_64_defconfig+x86-chromebook/gcc-8/lab-clabb=
e/baseline-d2500cc.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/x86/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60f7cde8a81370e26385c=
289
        failing since 9 days (last pass: v5.12.15, first fail: v5.12.16) =

 =



platform                | arch   | lab           | compiler | defconfig    =
                | regressions
------------------------+--------+---------------+----------+--------------=
----------------+------------
d2500cc                 | x86_64 | lab-clabbe    | gcc-8    | x86_64_defcon=
fig             | 1          =


  Details:     https://kernelci.org/test/plan/id/60f7cfc8d3968d717e85c266

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig
  Compiler:    gcc-8 (gcc (Debian 8.3.0-6) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.12.y/v5.12.1=
8-288-gaa783473cf1e0/x86_64/x86_64_defconfig/gcc-8/lab-clabbe/baseline-d250=
0cc.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.12.y/v5.12.1=
8-288-gaa783473cf1e0/x86_64/x86_64_defconfig/gcc-8/lab-clabbe/baseline-d250=
0cc.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/x86/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60f7cfc8d3968d717e85c=
267
        failing since 9 days (last pass: v5.12.16, first fail: v5.12.16-702=
-gd61ecea7819e8) =

 =



platform                | arch   | lab           | compiler | defconfig    =
                | regressions
------------------------+--------+---------------+----------+--------------=
----------------+------------
imx8mp-evk              | arm64  | lab-nxp       | gcc-8    | defconfig    =
                | 1          =


  Details:     https://kernelci.org/test/plan/id/60f7d1b3a52538714985c288

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.12.y/v5.12.1=
8-288-gaa783473cf1e0/arm64/defconfig/gcc-8/lab-nxp/baseline-imx8mp-evk.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.12.y/v5.12.1=
8-288-gaa783473cf1e0/arm64/defconfig/gcc-8/lab-nxp/baseline-imx8mp-evk.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60f7d1b3a52538714985c=
289
        failing since 1 day (last pass: v5.12.17, first fail: v5.12.18-289-=
g713b6ddbe96a8) =

 =



platform                | arch   | lab           | compiler | defconfig    =
                | regressions
------------------------+--------+---------------+----------+--------------=
----------------+------------
rk3288-veyron-jaq       | arm    | lab-collabora | gcc-8    | multi_v7_defc=
onfig           | 3          =


  Details:     https://kernelci.org/test/plan/id/60f7efedb0d332cc9785c258

  Results:     67 PASS, 3 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.12.y/v5.12.1=
8-288-gaa783473cf1e0/arm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-rk=
3288-veyron-jaq.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.12.y/v5.12.1=
8-288-gaa783473cf1e0/arm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-rk=
3288-veyron-jaq.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.bootrr.rockchip-iodomain-grf-probed: https://kernelci.org/test=
/case/id/60f7efedb0d332cc9785c26c
        failing since 36 days (last pass: v5.12.10, first fail: v5.12.10-17=
4-g38004b22b0ae)

    2021-07-21T09:59:04.155769  /lava-4224120/1/../bin/lava-test-case
    2021-07-21T09:59:04.173065  <8>[   13.436480] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Drockchip-iodomain-grf-probed RESULT=3Dfail>
    2021-07-21T09:59:04.173296  /lava-4224120/1/../bin/lava-test-case   =


  * baseline.bootrr.dwmmc_rockchip-sdio0-probed: https://kernelci.org/test/=
case/id/60f7efedb0d332cc9785c283
        failing since 36 days (last pass: v5.12.10, first fail: v5.12.10-17=
4-g38004b22b0ae)

    2021-07-21T09:59:02.729009  /lava-4224120/1/../bin/lava-test-case
    2021-07-21T09:59:02.745989  <8>[   12.008774] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Ddwmmc_rockchip-sdio0-probed RESULT=3Dfail>
    2021-07-21T09:59:02.746220  /lava-4224120/1/../bin/lava-test-case   =


  * baseline.bootrr.dwmmc_rockchip-sdmmc-probed: https://kernelci.org/test/=
case/id/60f7efedb0d332cc9785c284
        failing since 36 days (last pass: v5.12.10, first fail: v5.12.10-17=
4-g38004b22b0ae)

    2021-07-21T09:59:01.708892  /lava-4224120/1/../bin/lava-test-case
    2021-07-21T09:59:01.714409  <8>[   10.989265] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Ddwmmc_rockchip-sdmmc-probed RESULT=3Dfail>   =

 =



platform                | arch   | lab           | compiler | defconfig    =
                | regressions
------------------------+--------+---------------+----------+--------------=
----------------+------------
sun50i-a64-bananapi-m64 | arm64  | lab-clabbe    | gcc-8    | defconfig    =
                | 1          =


  Details:     https://kernelci.org/test/plan/id/60f7d07780de54826585c287

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.12.y/v5.12.1=
8-288-gaa783473cf1e0/arm64/defconfig/gcc-8/lab-clabbe/baseline-sun50i-a64-b=
ananapi-m64.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.12.y/v5.12.1=
8-288-gaa783473cf1e0/arm64/defconfig/gcc-8/lab-clabbe/baseline-sun50i-a64-b=
ananapi-m64.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60f7d07780de54826585c=
288
        failing since 1 day (last pass: v5.12.16-705-gfd3222df4dfe5, first =
fail: v5.12.18-289-g713b6ddbe96a8) =

 =20
