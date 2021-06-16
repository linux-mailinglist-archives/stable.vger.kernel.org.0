Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 52CEC3AA0B8
	for <lists+stable@lfdr.de>; Wed, 16 Jun 2021 18:03:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232231AbhFPQFJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 16 Jun 2021 12:05:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46518 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230318AbhFPQFI (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 16 Jun 2021 12:05:08 -0400
Received: from mail-pl1-x62c.google.com (mail-pl1-x62c.google.com [IPv6:2607:f8b0:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 47834C061760
        for <stable@vger.kernel.org>; Wed, 16 Jun 2021 09:03:02 -0700 (PDT)
Received: by mail-pl1-x62c.google.com with SMTP id v13so1339566ple.9
        for <stable@vger.kernel.org>; Wed, 16 Jun 2021 09:03:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=bq4doMqC5cm7ITJY421SdR03dpPijmaDXgddjh+AMWQ=;
        b=AR8+sBsZv1lQKB0nLSXHCXHHsTF5q8lvjt5dnefjpGc3vAH+bf5emn+Z2JB+VzgT0H
         vnaMyMqlm2nwVLTbh9J/SjuTs0V6K1Y5f9NMcFqAgOwLfUsTR9jOTjjUQ4VHtiPeRjry
         vBwSyHDmrClB15cdIEcrcAUvq+ELfluP2sjC8HW1kDGxisPDu+VOfjHvApcyw2QMKyRz
         SVj4OEqQb1lVOQ7Ae39g6xGmiwg8cVc1hdxO8xE5ZJ/L/5rMjp1iJtApHDRLVn51U092
         FikpKkf4v5sFrA/PE6/vlkT/qmvysz3Il7EJJrHPcfm4XRFQVgXyCUjbGojTTT65ghky
         nr+w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=bq4doMqC5cm7ITJY421SdR03dpPijmaDXgddjh+AMWQ=;
        b=DIv0y9LGGiJwsmpRJQw4cPvkj95OhlsGMRuy5EdXBHUmpe0WrameUgyUSyfkwL6HWj
         nPSFT+DiZrcGTj9KnMaw6e/2XweqGqQmxyhaODBS45Rj8IlkypFbFruYDfGHbnxj1Dd9
         4yybiv/p535vTwftIHWnEgg88d4Qgbx1q5M/xj+gQcadDoLBT1xyc6XmZo8Mxn8n/B+k
         HQ/VvhcqyP/UAl+H0Bvibo84BvpYpDxhn/eApggP8UDra54kiT3MHg/jR/A/S1Av50Pq
         4RCC4QDjWO+N/kYrO36gThnSjEX8Crf4K5K6qVId/EI/MQJ0P6NHUDUZrDYy1dbcyFQ6
         WadQ==
X-Gm-Message-State: AOAM532z3O/1DfmaxyJN40DsK6m7enlCIwWXqxd4cpkgplgXhmdlf4j4
        fhFxE8VIsze15ySh9c1tnrskMoIVWXH3wNiU
X-Google-Smtp-Source: ABdhPJxXbCA4xYzA/+wJYFXlNQtm6D+wFwfAPhhj5VyWUqGyQghX7aMhZsJiNvwgzf6jyiBt3UyfyA==
X-Received: by 2002:a17:90a:8804:: with SMTP id s4mr511220pjn.200.1623859381628;
        Wed, 16 Jun 2021 09:03:01 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id j10sm2558434pjb.36.2021.06.16.09.02.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 16 Jun 2021 09:02:52 -0700 (PDT)
Message-ID: <60ca20ac.1c69fb81.4566.6a6b@mx.google.com>
Date:   Wed, 16 Jun 2021 09:02:52 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v5.4.125-84-g5fa9d9d0e834
X-Kernelci-Branch: queue/5.4
X-Kernelci-Tree: stable-rc
Subject: stable-rc/queue/5.4 baseline: 143 runs,
 3 regressions (v5.4.125-84-g5fa9d9d0e834)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.4 baseline: 143 runs, 3 regressions (v5.4.125-84-g5fa9d9d=
0e834)

Regressions Summary
-------------------

platform          | arch | lab           | compiler | defconfig          | =
regressions
------------------+------+---------------+----------+--------------------+-=
-----------
rk3288-veyron-jaq | arm  | lab-collabora | gcc-8    | multi_v7_defconfig | =
3          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.4/kern=
el/v5.4.125-84-g5fa9d9d0e834/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.4
  Describe: v5.4.125-84-g5fa9d9d0e834
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      5fa9d9d0e834313205379364b900c64b2e0eded4 =



Test Regressions
---------------- =



platform          | arch | lab           | compiler | defconfig          | =
regressions
------------------+------+---------------+----------+--------------------+-=
-----------
rk3288-veyron-jaq | arm  | lab-collabora | gcc-8    | multi_v7_defconfig | =
3          =


  Details:     https://kernelci.org/test/plan/id/60ca1de4aa8a54385941326e

  Results:     66 PASS, 3 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.125-8=
4-g5fa9d9d0e834/arm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-rk3288-=
veyron-jaq.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.125-8=
4-g5fa9d9d0e834/arm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-rk3288-=
veyron-jaq.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.bootrr.dwmmc_rockchip-sdmmc-probed: https://kernelci.org/test/=
case/id/60ca1de4aa8a54385941328b
        failing since 1 day (last pass: v5.4.125-37-g7cda316475cf, first fa=
il: v5.4.125-84-g411d62eda127)

    2021-06-16T15:50:53.538308  /lava-4036465/1/../bin/lava-test-case<8>[  =
 12.469848] <LAVA_SIGNAL_TESTCASE TEST_CASE_ID=3Ddwmmc_rockchip-sdmmc-probe=
d RESULT=3Dfail>
    2021-06-16T15:50:53.538751     =


  * baseline.bootrr.dwmmc_rockchip-sdio0-probed: https://kernelci.org/test/=
case/id/60ca1de4aa8a54385941328c
        failing since 1 day (last pass: v5.4.125-37-g7cda316475cf, first fa=
il: v5.4.125-84-g411d62eda127)

    2021-06-16T15:50:54.551780  /lava-4036465/1/../bin/lava-test-case
    2021-06-16T15:50:54.569104  <8>[   13.489363] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Ddwmmc_rockchip-sdio0-probed RESULT=3Dfail>
    2021-06-16T15:50:54.569348  /lava-4036465/1/../bin/lava-test-case   =


  * baseline.bootrr.rockchip-iodomain-grf-probed: https://kernelci.org/test=
/case/id/60ca1de4aa8a5438594132a4
        failing since 1 day (last pass: v5.4.125-37-g7cda316475cf, first fa=
il: v5.4.125-84-g411d62eda127)

    2021-06-16T15:50:55.967549  /lava-4036465/1/../bin/lava-test-case
    2021-06-16T15:50:55.978545  <8>[   14.913621] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Drockchip-iodomain-grf-probed RESULT=3Dfail>   =

 =20
