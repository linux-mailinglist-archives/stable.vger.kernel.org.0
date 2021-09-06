Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 456E2401A85
	for <lists+stable@lfdr.de>; Mon,  6 Sep 2021 13:22:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241070AbhIFLXV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 6 Sep 2021 07:23:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47142 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234967AbhIFLXS (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 6 Sep 2021 07:23:18 -0400
Received: from mail-pj1-x102a.google.com (mail-pj1-x102a.google.com [IPv6:2607:f8b0:4864:20::102a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2835DC061757
        for <stable@vger.kernel.org>; Mon,  6 Sep 2021 04:22:14 -0700 (PDT)
Received: by mail-pj1-x102a.google.com with SMTP id j1so4105316pjv.3
        for <stable@vger.kernel.org>; Mon, 06 Sep 2021 04:22:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=r/37onsbCt9Jvvefig1eO7ZofPIu2sGG/9B+eBV1BDU=;
        b=qmkNZiVTYuRuZVTINynETojmECtFrPEfJM9uQzmuMZTxwxTqd+qST8V6Nfioqb88+g
         9YKP3eTn22M3QtDV13VUSge2Oz8RBMBJf68DcPJd45SeZV2L4WO9AAqRjFDkEVsJaNYW
         6S1Q2k3pOWk8Pu2mNgBLeNhHWDdIdgHu3akDP4CBgOYz117GRv43/sInGa1f/OYdJnLW
         f806gxutAZbraJ7V0Tj1jpEQoQvuTq0xs3Zc6T0HOWZx+oSWhXMEb6fpSTgEszyYr8jx
         LKRVtvP43sxOATAQJS+LNvZjJwPzbhLX1cEo4nDR7zgOYz2DOCr0zVOZhUP9ROPtmQD9
         Sbcw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=r/37onsbCt9Jvvefig1eO7ZofPIu2sGG/9B+eBV1BDU=;
        b=qPvJ8bKH3f2OdPU9XqSIZYskSnS93XXYh5169u0o8mH5Uzx7VxiwxuYleDsIXYvBEJ
         30gocbipZyd2qaUYilVDprGQne9MMRnoj1rlse9NvfmQ2CzJq5O5ZM4oGcEYdgtfKWfV
         PfGyChBRxHGYIauKlciRDcLSUTQpTyiQWRtaBcp6+KDaFCEnG7MccTb9/vbQYaYBngVt
         iPKfIRTmWy3vUZZTcozK69YA1aJahwvprm/AfLzR9oWAhK4WwM0oejRsaUFylTYk2wA0
         8PFLNjiq+9gsa+0hPz5RVdJTKoqIFlZ8HTsUeTEuqt819y1xM6OktXlAL9mcTJ+/5XLX
         xO3A==
X-Gm-Message-State: AOAM531NOrTIXlh16C33GNWQHOTtePZUIpp00LfvP1O4lWcreOkqUujo
        vwsvB/B3S+XA4K6KQL6ChVrvwCTtxw4O68M0
X-Google-Smtp-Source: ABdhPJzOoli6eygOo9PvfvXpykHQHtup8aHqnVHDKLsvqpY6XFDeOqCEg3uFxmW+d4ciG+vE1S5gpA==
X-Received: by 2002:a17:902:ab18:b0:138:a41d:c7a0 with SMTP id ik24-20020a170902ab1800b00138a41dc7a0mr10446000plb.6.1630927333431;
        Mon, 06 Sep 2021 04:22:13 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id y7sm7496240pff.206.2021.09.06.04.22.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 06 Sep 2021 04:22:13 -0700 (PDT)
Message-ID: <6135f9e5.1c69fb81.c44cb.4630@mx.google.com>
Date:   Mon, 06 Sep 2021 04:22:13 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v5.4.144-17-gaf318e5ddb77
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/5.4
Subject: stable-rc/queue/5.4 baseline: 158 runs,
 3 regressions (v5.4.144-17-gaf318e5ddb77)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.4 baseline: 158 runs, 3 regressions (v5.4.144-17-gaf318e5=
ddb77)

Regressions Summary
-------------------

platform          | arch | lab           | compiler | defconfig          | =
regressions
------------------+------+---------------+----------+--------------------+-=
-----------
rk3288-veyron-jaq | arm  | lab-collabora | gcc-8    | multi_v7_defconfig | =
3          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.4/kern=
el/v5.4.144-17-gaf318e5ddb77/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.4
  Describe: v5.4.144-17-gaf318e5ddb77
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      af318e5ddb774dd742d48c2dd6bbe1edf18febff =



Test Regressions
---------------- =



platform          | arch | lab           | compiler | defconfig          | =
regressions
------------------+------+---------------+----------+--------------------+-=
-----------
rk3288-veyron-jaq | arm  | lab-collabora | gcc-8    | multi_v7_defconfig | =
3          =


  Details:     https://kernelci.org/test/plan/id/6135cad0f42c1e8af2d59675

  Results:     67 PASS, 3 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.144-1=
7-gaf318e5ddb77/arm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-rk3288-=
veyron-jaq.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.144-1=
7-gaf318e5ddb77/arm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-rk3288-=
veyron-jaq.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.bootrr.rockchip-iodomain-grf-probed: https://kernelci.org/test=
/case/id/6135cad0f42c1e8af2d59689
        failing since 83 days (last pass: v5.4.125-37-g7cda316475cf, first =
fail: v5.4.125-84-g411d62eda127)

    2021-09-06T08:00:57.730629  /lava-4455871/1/../bin/lava-test-case
    2021-09-06T08:00:57.746693  <8>[   15.116949] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Drockchip-iodomain-grf-probed RESULT=3Dfail>
    2021-09-06T08:00:57.750809  /lava-4455871/1/../bin/lava-test-case   =


  * baseline.bootrr.dwmmc_rockchip-sdio0-probed: https://kernelci.org/test/=
case/id/6135cad0f42c1e8af2d596a1
        failing since 83 days (last pass: v5.4.125-37-g7cda316475cf, first =
fail: v5.4.125-84-g411d62eda127)

    2021-09-06T08:00:56.322286  /lava-4455871/1/../bin/lava-test-case<8>[  =
 13.692800] <LAVA_SIGNAL_TESTCASE TEST_CASE_ID=3Ddwmmc_rockchip-sdio0-probe=
d RESULT=3Dfail>
    2021-09-06T08:00:56.322645  =

    2021-09-06T08:00:56.322817  /lava-4455871/1/../bin/lava-test-case   =


  * baseline.bootrr.dwmmc_rockchip-sdmmc-probed: https://kernelci.org/test/=
case/id/6135cad0f42c1e8af2d596a2
        failing since 83 days (last pass: v5.4.125-37-g7cda316475cf, first =
fail: v5.4.125-84-g411d62eda127)

    2021-09-06T08:00:55.285041  /lava-4455871/1/../bin/lava-test-case
    2021-09-06T08:00:55.290442  <8>[   12.673237] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Ddwmmc_rockchip-sdmmc-probed RESULT=3Dfail>   =

 =20
