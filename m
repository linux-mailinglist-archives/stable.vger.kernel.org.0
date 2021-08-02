Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 67CBC3DD2A2
	for <lists+stable@lfdr.de>; Mon,  2 Aug 2021 11:09:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232856AbhHBJJJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 2 Aug 2021 05:09:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54404 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232814AbhHBJJJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 2 Aug 2021 05:09:09 -0400
Received: from mail-pl1-x636.google.com (mail-pl1-x636.google.com [IPv6:2607:f8b0:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 39F16C06175F
        for <stable@vger.kernel.org>; Mon,  2 Aug 2021 02:09:00 -0700 (PDT)
Received: by mail-pl1-x636.google.com with SMTP id u16so10408273ple.2
        for <stable@vger.kernel.org>; Mon, 02 Aug 2021 02:09:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=lGhHvtak1baXaT/+y1O3C8NaGj6tMwFziVIR7TUkHBQ=;
        b=DYb7iXtI5rBT7WlhN6aJhXsUDGlpZa4AAZd1LXUwkiN15aasbmQI6OPh4GDrMSi9P1
         /y1bfnUT2S88FVQXrspv2OHdh4gE7RsRn/QuKtOSKtaEWarKppDu9M/SkiIP3Tv+uUA/
         SFtJOizVjf9gTYyS1LNpzfXvuMS7HQVZbr7/UNQhGQ10OdmFBvTrM6f+VLqAxXI0B6rh
         1JMyVhyMC7t/LVMU4UE6atMmSVlz2REIBPkQqWTdw0I1YEwsBkghY17UZuGqu9QTIRZF
         Xk9c0dXwF17YEsY4iVdd3lv1skKjTaOWlvbCbXJ+lw7cGf5DCJ6mkUsc7jU55OVofc8u
         CeeA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=lGhHvtak1baXaT/+y1O3C8NaGj6tMwFziVIR7TUkHBQ=;
        b=qZ2JwCl20rAKpEQqlQIfQVSvU2rtioNj03fblXzQxnD4MJrd07WFrjdNrjaUXoHP7D
         1bqNQN2meVBwwLvKnlwZe1C4S8iDyh2qLgQFNHn+j6QO8sTlzaKZrZ7S4euGW6etdphT
         ff3CwUQtAWoSYYym0o/mwdMGoSv9KAJjapFAxm/pm+tgxAYqXpPfhsaiI+2Q2UwihxCY
         2xqry1YuSwKDRj1mDtLkxluW2Uodv8ekihXSRJIAplHD22wN1c1kaL6U/x+Plm7yGf17
         iEnBTZO6aKIoYdeUEhBzlZzauHqxQgsD/zR2JBPY+9Q/ulvueS2F/eDils1LcOjVOpWU
         8SeQ==
X-Gm-Message-State: AOAM532fUH9rv16BsmL5gwHy4dT/CVzJTMbqowUs5vKkwCF4WgidmCjL
        gqlq5vqLofpBjmr5HF1vOZD4yFBsFsiwvJNi
X-Google-Smtp-Source: ABdhPJztSgtVXHvVp45epllqRNNE+BoDsJr4aW4ruAegAEMBTgz73t4Q84AXdhowqum+hUm5hUBH2g==
X-Received: by 2002:a17:90b:f92:: with SMTP id ft18mr16547695pjb.31.1627895339563;
        Mon, 02 Aug 2021 02:08:59 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id 131sm10506429pfv.129.2021.08.02.02.08.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 02 Aug 2021 02:08:59 -0700 (PDT)
Message-ID: <6107b62b.1c69fb81.8a09b.d198@mx.google.com>
Date:   Mon, 02 Aug 2021 02:08:59 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: queue/4.14
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v4.14.241-37-g5ecaa6682ec9
X-Kernelci-Report-Type: test
Subject: stable-rc/queue/4.14 baseline: 145 runs,
 3 regressions (v4.14.241-37-g5ecaa6682ec9)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.14 baseline: 145 runs, 3 regressions (v4.14.241-37-g5ecaa=
6682ec9)

Regressions Summary
-------------------

platform          | arch | lab           | compiler | defconfig          | =
regressions
------------------+------+---------------+----------+--------------------+-=
-----------
rk3288-veyron-jaq | arm  | lab-collabora | gcc-8    | multi_v7_defconfig | =
3          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.14/ker=
nel/v4.14.241-37-g5ecaa6682ec9/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.14
  Describe: v4.14.241-37-g5ecaa6682ec9
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      5ecaa6682ec90f094448ac50cbc9d7897cf08707 =



Test Regressions
---------------- =



platform          | arch | lab           | compiler | defconfig          | =
regressions
------------------+------+---------------+----------+--------------------+-=
-----------
rk3288-veyron-jaq | arm  | lab-collabora | gcc-8    | multi_v7_defconfig | =
3          =


  Details:     https://kernelci.org/test/plan/id/6107843751289f937285f4d7

  Results:     63 PASS, 6 FAIL, 1 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.241=
-37-g5ecaa6682ec9/arm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-rk328=
8-veyron-jaq.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.241=
-37-g5ecaa6682ec9/arm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-rk328=
8-veyron-jaq.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.bootrr.rockchip-iodomain-grf-probed: https://kernelci.org/test=
/case/id/6107843751289f937285f4eb
        failing since 48 days (last pass: v4.14.236-20-gdb14655bb4bf, first=
 fail: v4.14.236-49-gfd4c319f2583)

    2021-08-02T05:35:37.038263  /lava-4303748/1/../bin/lava-test-case
    2021-08-02T05:35:37.043941  [   17.383605] <LAVA_SIGNAL_TESTCASE TEST_C=
ASE_ID=3Drockchip-iodomain-grf-probed RESULT=3Dfail>   =


  * baseline.bootrr.dwmmc_rockchip-sdio0-probed: https://kernelci.org/test/=
case/id/6107843751289f937285f502
        failing since 48 days (last pass: v4.14.236-20-gdb14655bb4bf, first=
 fail: v4.14.236-49-gfd4c319f2583)

    2021-08-02T05:35:34.607530  /lava-4303748/1/../bin/lava-test-case
    2021-08-02T05:35:34.625435  [   14.953025] <LAVA_SIGNAL_TESTCASE TEST_C=
ASE_ID=3Ddwmmc_rockchip-sdio0-probed RESULT=3Dfail>
    2021-08-02T05:35:34.625715  /lava-4303748/1/../bin/lava-test-case   =


  * baseline.bootrr.dwmmc_rockchip-sdmmc-probed: https://kernelci.org/test/=
case/id/6107843751289f937285f503
        failing since 48 days (last pass: v4.14.236-20-gdb14655bb4bf, first=
 fail: v4.14.236-49-gfd4c319f2583)

    2021-08-02T05:35:33.588159  /lava-4303748/1/../bin/lava-test-case
    2021-08-02T05:35:33.593588  [   13.934127] <LAVA_SIGNAL_TESTCASE TEST_C=
ASE_ID=3Ddwmmc_rockchip-sdmmc-probed RESULT=3Dfail>   =

 =20
