Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 705653FE50A
	for <lists+stable@lfdr.de>; Wed,  1 Sep 2021 23:40:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232215AbhIAVll (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 1 Sep 2021 17:41:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46008 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232085AbhIAVll (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 1 Sep 2021 17:41:41 -0400
Received: from mail-pj1-x102a.google.com (mail-pj1-x102a.google.com [IPv6:2607:f8b0:4864:20::102a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EDD1AC061575
        for <stable@vger.kernel.org>; Wed,  1 Sep 2021 14:40:43 -0700 (PDT)
Received: by mail-pj1-x102a.google.com with SMTP id g13-20020a17090a3c8d00b00196286963b9so670675pjc.3
        for <stable@vger.kernel.org>; Wed, 01 Sep 2021 14:40:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=kpRrmfA+d9LJ/bg8+R7MaJky0SM1GgUeApAUMuQq1Pk=;
        b=SSUC4sgYx6i/ziWU4LTJfrnfUeGU1PhCQihbcumLIMf2/IUT4siyvTTh2N9z44eC+H
         iLbPSKbrV/D39VV6/HZF/kxQNbj7YUptg0JKOuFcFMeoqZr6MF8Zdc5WfcavyKL7Hmne
         ++mlfdMPoU8aQwmHTn65TJ2zS6JEzkg6+vbztMPBhTr1cfC4t8JtPGiTR5Aozt5hUhoO
         PuLGkNwNXNV88BG+cgtviGNTy9NXaD3cflm18VdZMHCHvNDXG7ZKzxy/rls7oPXulzGk
         +Yn3a8UB6/6r3BOLe9xDle2rwzfx+QP0OJYPDw2Acn1HfIgVG/S1TJUI4ziDDi2Rou8d
         8gfA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=kpRrmfA+d9LJ/bg8+R7MaJky0SM1GgUeApAUMuQq1Pk=;
        b=WjfEnhrApw/PmZ5NrYhVK0EFhNbULPRG654TDyw1Ur1HHmAE1fOSlberQIS3BDnp67
         BysNQGtidM2t5iVpvJWuOnVFIy979JrqtEEi5BWVq4j3sm4U9IhB3u18x5NMr00+084n
         tS0nz4Gy2tQteB2vRkNZzMp6HOGMjEXh5uaE8pjcbupsIv+bFtfYDw8tt8t0OLRuMhPO
         rBLgIIElcEIpFJDxazXz7KlFnSzYDU9ArJ/mcroyCWj+HyjhvnNbJ/h7QE1sx0ELDVhw
         i0bUBtOpZRcCQOjQVjs6pEuzjXzCb/qX98kBrrAZQTADIW8oCnM8OFnXSJlEtDRkvb21
         J0og==
X-Gm-Message-State: AOAM530K4KpZupgvDrbnJa0P3wNFu7YZJ8ZF16YkUmmWmhozjNBBLl0v
        zIhr0UkOGXuqOSShNPOXLgNuXydIdBtKJFkC+9A=
X-Google-Smtp-Source: ABdhPJwPKkbGGDebSdvs2RZalHmCvGgB2SNyErojWBWYbj+A/TqyEruN0UIsKiwLtBdwezKxC5Ni0Q==
X-Received: by 2002:a17:90a:c584:: with SMTP id l4mr1470060pjt.28.1630532443213;
        Wed, 01 Sep 2021 14:40:43 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id t13sm383618pjg.25.2021.09.01.14.40.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 01 Sep 2021 14:40:42 -0700 (PDT)
Message-ID: <612ff35a.1c69fb81.fb4f3.1ccc@mx.google.com>
Date:   Wed, 01 Sep 2021 14:40:42 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v4.14.245-23-g0d3439213045
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/4.14
Subject: stable-rc/queue/4.14 baseline: 154 runs,
 4 regressions (v4.14.245-23-g0d3439213045)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.14 baseline: 154 runs, 4 regressions (v4.14.245-23-g0d343=
9213045)

Regressions Summary
-------------------

platform          | arch  | lab           | compiler | defconfig          |=
 regressions
------------------+-------+---------------+----------+--------------------+=
------------
meson-gxm-q200    | arm64 | lab-baylibre  | gcc-8    | defconfig          |=
 1          =

rk3288-veyron-jaq | arm   | lab-collabora | gcc-8    | multi_v7_defconfig |=
 3          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.14/ker=
nel/v4.14.245-23-g0d3439213045/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.14
  Describe: v4.14.245-23-g0d3439213045
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      0d34392130458ea42ee751c97bd42cf86f632b60 =



Test Regressions
---------------- =



platform          | arch  | lab           | compiler | defconfig          |=
 regressions
------------------+-------+---------------+----------+--------------------+=
------------
meson-gxm-q200    | arm64 | lab-baylibre  | gcc-8    | defconfig          |=
 1          =


  Details:     https://kernelci.org/test/plan/id/612fc78ea19ad3a760d59665

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.245=
-23-g0d3439213045/arm64/defconfig/gcc-8/lab-baylibre/baseline-meson-gxm-q20=
0.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.245=
-23-g0d3439213045/arm64/defconfig/gcc-8/lab-baylibre/baseline-meson-gxm-q20=
0.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/612fc78ea19ad3a760d59=
666
        failing since 184 days (last pass: v4.14.222-11-g13b8482a0f700, fir=
st fail: v4.14.222-120-gdc8887cba23e) =

 =



platform          | arch  | lab           | compiler | defconfig          |=
 regressions
------------------+-------+---------------+----------+--------------------+=
------------
rk3288-veyron-jaq | arm   | lab-collabora | gcc-8    | multi_v7_defconfig |=
 3          =


  Details:     https://kernelci.org/test/plan/id/612fde3b3ccd368d28d59676

  Results:     63 PASS, 6 FAIL, 1 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.245=
-23-g0d3439213045/arm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-rk328=
8-veyron-jaq.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.245=
-23-g0d3439213045/arm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-rk328=
8-veyron-jaq.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.bootrr.rockchip-iodomain-grf-probed: https://kernelci.org/test=
/case/id/612fde3b3ccd368d28d5968a
        failing since 78 days (last pass: v4.14.236-20-gdb14655bb4bf, first=
 fail: v4.14.236-49-gfd4c319f2583)

    2021-09-01T20:10:22.446461  /lava-4430311/1/../bin/lava-test-case
    2021-09-01T20:10:22.462775  [   17.245573] <LAVA_SIGNAL_TESTCASE TEST_C=
ASE_ID=3Drockchip-iodomain-grf-probed RESULT=3Dfail>
    2021-09-01T20:10:22.462978  /lava-4430311/1/../bin/lava-test-case   =


  * baseline.bootrr.dwmmc_rockchip-sdio0-probed: https://kernelci.org/test/=
case/id/612fde3b3ccd368d28d596a3
        failing since 78 days (last pass: v4.14.236-20-gdb14655bb4bf, first=
 fail: v4.14.236-49-gfd4c319f2583) =


  * baseline.bootrr.dwmmc_rockchip-sdmmc-probed: https://kernelci.org/test/=
case/id/612fde3b3ccd368d28d596a4
        failing since 78 days (last pass: v4.14.236-20-gdb14655bb4bf, first=
 fail: v4.14.236-49-gfd4c319f2583)

    2021-09-01T20:10:18.996471  /lava-4430311/1/../bin/lava-test-case
    2021-09-01T20:10:19.001978  [   13.795633] <LAVA_SIGNAL_TESTCASE TEST_C=
ASE_ID=3Ddwmmc_rockchip-sdmmc-probed RESULT=3Dfail>   =

 =20
