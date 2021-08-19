Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 562043F2149
	for <lists+stable@lfdr.de>; Thu, 19 Aug 2021 22:00:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234436AbhHSUA5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 19 Aug 2021 16:00:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36630 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234121AbhHSUA5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 19 Aug 2021 16:00:57 -0400
Received: from mail-pf1-x430.google.com (mail-pf1-x430.google.com [IPv6:2607:f8b0:4864:20::430])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B3F41C061575
        for <stable@vger.kernel.org>; Thu, 19 Aug 2021 13:00:20 -0700 (PDT)
Received: by mail-pf1-x430.google.com with SMTP id w68so6512184pfd.0
        for <stable@vger.kernel.org>; Thu, 19 Aug 2021 13:00:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=9EOaiIWZrXofZwc+YYjwKQun/2fvAo469SJ/3bsumOM=;
        b=kivBcyVXSpiPx4Sn0jEZTfItU3KYOnRfPtxIWbdpJBshx9/xLeTQit5RiUiw3zzayM
         f6HC3mOGRB3oZOh41yOQIqm94FOr2Gb8XVYkulrvqt9zlrEgpA28AU3kl16x4pXviwSp
         h8brGycNra5Rtt7xWScPPIQcGSZNo+zYmdCpjLcwmWzU6ux3LAFILAfqw15c26M/HdIv
         tJLk5YI5lOT1LrgYW5wXvqhSEKnGnGsxTupe/OqZrdUhhWVWVmd24BWJ6RbYAmw1GE/u
         Y6q7kaSslWWnYRDYqqRDO6gxrZUktSlxoT4pr9/aGR5dCPuU8HtKaYf84BDVAwmxyHky
         xoRA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=9EOaiIWZrXofZwc+YYjwKQun/2fvAo469SJ/3bsumOM=;
        b=tr1qCNtL4oEFWW8JqXBLNklOeAfUNd+fbRGeL7Ca067prRwrM9OAdXw4SPqVmXvHgw
         b3ydRcmrIrEJLsHTcWdVJp6hmjk9eyJEcU8Wcu6kKB5H6liqxuJwe53e+pRxAS2eK1Ac
         Giwci2JHK+zMplycPcNzaXkEg+QU9x91/d9ZwFeQu726dVhWBinpURXIbVJhxKMjXH0J
         RAKLEB2N6B22JqyWaKG8YSa3Xgs+Lbd1RnUbQDRKpXksOMvzqXWGK1KI2SlT2j3ve8L6
         GYos/K9bTzQwnl1QkGkRZAp6Ryxj1aWBLft8mn6RYfSNTpGq53tRGpEEzTS8fxS+Xn5d
         U7WA==
X-Gm-Message-State: AOAM530n5oUHVVEL7dH9yxoXii0syY2etfGNqVgglfHUFhBBaECSOpP2
        wwS78+PF53Wm3dsXOMOZJi9/F6P5aUFpbI7v
X-Google-Smtp-Source: ABdhPJw5JQv4A0qEAZtsuHTorbGd/IVOAeiUPGD+XpI0gn/qlotL0tuV8dlCwMgX+FcAmoGwONKjiA==
X-Received: by 2002:a05:6a00:24ca:b0:3e1:14fc:e34c with SMTP id d10-20020a056a0024ca00b003e114fce34cmr15702483pfv.76.1629403219677;
        Thu, 19 Aug 2021 13:00:19 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id j7sm454302pjf.39.2021.08.19.13.00.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 19 Aug 2021 13:00:19 -0700 (PDT)
Message-ID: <611eb853.1c69fb81.c5989.2446@mx.google.com>
Date:   Thu, 19 Aug 2021 13:00:19 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: queue/5.10
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v5.10.60-34-gaa41030a741e
X-Kernelci-Report-Type: test
Subject: stable-rc/queue/5.10 baseline: 116 runs,
 3 regressions (v5.10.60-34-gaa41030a741e)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.10 baseline: 116 runs, 3 regressions (v5.10.60-34-gaa4103=
0a741e)

Regressions Summary
-------------------

platform          | arch | lab           | compiler | defconfig          | =
regressions
------------------+------+---------------+----------+--------------------+-=
-----------
rk3288-veyron-jaq | arm  | lab-collabora | gcc-8    | multi_v7_defconfig | =
3          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.10/ker=
nel/v5.10.60-34-gaa41030a741e/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.10
  Describe: v5.10.60-34-gaa41030a741e
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      aa41030a741e678e668234c5ba966f6b6a522b9d =



Test Regressions
---------------- =



platform          | arch | lab           | compiler | defconfig          | =
regressions
------------------+------+---------------+----------+--------------------+-=
-----------
rk3288-veyron-jaq | arm  | lab-collabora | gcc-8    | multi_v7_defconfig | =
3          =


  Details:     https://kernelci.org/test/plan/id/611e877d8f219ae9c3b13683

  Results:     67 PASS, 3 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.60-=
34-gaa41030a741e/arm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-rk3288=
-veyron-jaq.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.60-=
34-gaa41030a741e/arm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-rk3288=
-veyron-jaq.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.bootrr.rockchip-iodomain-grf-probed: https://kernelci.org/test=
/case/id/611e877d8f219ae9c3b1369b
        failing since 65 days (last pass: v5.10.43-44-g253317604975, first =
fail: v5.10.43-130-g87b5f83f722c)

    2021-08-19T16:31:33.030623  /lava-4387230/1/../bin/lava-test-case
    2021-08-19T16:31:33.044487  <8>[   13.339515] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Drockchip-iodomain-grf-probed RESULT=3Dfail>   =


  * baseline.bootrr.dwmmc_rockchip-sdio0-probed: https://kernelci.org/test/=
case/id/611e877d8f219ae9c3b136b1
        failing since 65 days (last pass: v5.10.43-44-g253317604975, first =
fail: v5.10.43-130-g87b5f83f722c)

    2021-08-19T16:31:31.618570  /lava-4387230/1/../bin/lava-test-case<8>[  =
 11.912665] <LAVA_SIGNAL_TESTCASE TEST_CASE_ID=3Ddwmmc_rockchip-sdio0-probe=
d RESULT=3Dfail>
    2021-08-19T16:31:31.618913  =

    2021-08-19T16:31:31.619110  /lava-4387230/1/../bin/lava-test-case   =


  * baseline.bootrr.dwmmc_rockchip-sdmmc-probed: https://kernelci.org/test/=
case/id/611e877d8f219ae9c3b136b2
        failing since 65 days (last pass: v5.10.43-44-g253317604975, first =
fail: v5.10.43-130-g87b5f83f722c)

    2021-08-19T16:31:30.580704  /lava-4387230/1/../bin/lava-test-case
    2021-08-19T16:31:30.586253  <8>[   10.892743] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Ddwmmc_rockchip-sdmmc-probed RESULT=3Dfail>   =

 =20
