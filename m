Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 390843ECB14
	for <lists+stable@lfdr.de>; Sun, 15 Aug 2021 23:09:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229760AbhHOVKH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 15 Aug 2021 17:10:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55552 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229582AbhHOVKH (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 15 Aug 2021 17:10:07 -0400
Received: from mail-pl1-x632.google.com (mail-pl1-x632.google.com [IPv6:2607:f8b0:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 50871C061764
        for <stable@vger.kernel.org>; Sun, 15 Aug 2021 14:09:36 -0700 (PDT)
Received: by mail-pl1-x632.google.com with SMTP id q2so18578177plr.11
        for <stable@vger.kernel.org>; Sun, 15 Aug 2021 14:09:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=REeSjf24voIGlK2ggVaFZ4pQM5ZdmsgcDPiZI76d6jo=;
        b=YAJX0MwrQ59FL1rmmiVMSJvLiCyXAWMc2QILrJzjOgsyerQdioD7mVvmze/eD3yhr7
         OIJV1+0ttsAHSw1HM2ElO+l6LRqA8NB91vC4QX1IHL+X2Rp/ePNhXI0OKTNvrYr6WpCr
         N2eC3XvRJfQ594fl8rIXnrhbgOOYUCsVCzYiwke5UeKk+xtryN1KvkY/9KpflvkC8eCs
         fN5cQYM6VjGz2RvQo3cVrZoLo/osfN4Xi6kk6MS68HZgORhQ+sY0+xVLT/QbQ32VoZbV
         U3soRFK1piodi3XojaSW7GVL6XS0SKZS+J962AMaKvCH1kXNL+5EcBkl33IyR6Ov1Bge
         AWJw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=REeSjf24voIGlK2ggVaFZ4pQM5ZdmsgcDPiZI76d6jo=;
        b=r11IEJGMFFDzb6kaGYVNysZTHNzNmnNrVFxnGzZD8dDew6kodP9P8rFahkvPBumL3U
         Cot1pQm+2mcXT2CggsxbbE4kNN9zN6xpJ5SABfBgYgkxXJx/rgMSKFkXn9kJXdP2SLji
         2iLgJRTeQoUrW1HmaKwa9FBGrjOPDqxZkaTdZ2zahYCpio1k0UDkE7JOkRzcmhKRelbP
         Ifzym64NGJWDv0C31o36UpkUOGqtguhR/2c1MzQ7jZcCX7t3TKMljAY+1trgz2jBqICP
         qIr9QmrCdBNg1VxYQOLB7qOII57H5U0Sf+si6NdZIO+eCkS4lr1JFo97v6B6zVn+rvZV
         yb7w==
X-Gm-Message-State: AOAM533x07FHIyAlNuS9/OrwRglbtOvwAgeakk4NgI19kq/tCI5TSkEo
        Etrc5D+0TaelyAJLFA3+puZ5hzFAdT/4cbta
X-Google-Smtp-Source: ABdhPJxa71+lKUO25d549xZtleTpPk2NxH3Eobm/0+gxSQuv8lQBU/VU5c7/X92itogMAVmoiGupCw==
X-Received: by 2002:a17:90b:1d88:: with SMTP id pf8mr13364680pjb.152.1629061774147;
        Sun, 15 Aug 2021 14:09:34 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id v1sm10682744pgj.40.2021.08.15.14.09.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 15 Aug 2021 14:09:33 -0700 (PDT)
Message-ID: <6119828d.1c69fb81.16e50.c9ac@mx.google.com>
Date:   Sun, 15 Aug 2021 14:09:33 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: linux-5.4.y
X-Kernelci-Tree: stable
X-Kernelci-Kernel: v5.4.141
X-Kernelci-Report-Type: test
Subject: stable/linux-5.4.y baseline: 174 runs, 4 regressions (v5.4.141)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable/linux-5.4.y baseline: 174 runs, 4 regressions (v5.4.141)

Regressions Summary
-------------------

platform             | arch  | lab           | compiler | defconfig        =
  | regressions
---------------------+-------+---------------+----------+------------------=
--+------------
hifive-unleashed-a00 | riscv | lab-baylibre  | gcc-8    | defconfig        =
  | 1          =

rk3288-veyron-jaq    | arm   | lab-collabora | gcc-8    | multi_v7_defconfi=
g | 3          =


  Details:  https://kernelci.org/test/job/stable/branch/linux-5.4.y/kernel/=
v5.4.141/plan/baseline/

  Test:     baseline
  Tree:     stable
  Branch:   linux-5.4.y
  Describe: v5.4.141
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able.git
  SHA:      b704883aa8dc4d1d232d3a3cdc438a64889fcc6e =



Test Regressions
---------------- =



platform             | arch  | lab           | compiler | defconfig        =
  | regressions
---------------------+-------+---------------+----------+------------------=
--+------------
hifive-unleashed-a00 | riscv | lab-baylibre  | gcc-8    | defconfig        =
  | 1          =


  Details:     https://kernelci.org/test/plan/id/61194f749330bf33efb13689

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (riscv64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable/linux-5.4.y/v5.4.141/ri=
scv/defconfig/gcc-8/lab-baylibre/baseline-hifive-unleashed-a00.txt
  HTML log:    https://storage.kernelci.org//stable/linux-5.4.y/v5.4.141/ri=
scv/defconfig/gcc-8/lab-baylibre/baseline-hifive-unleashed-a00.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/riscv/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61194f749330bf33efb13=
68a
        failing since 2 days (last pass: v5.4.139, first fail: v5.4.140) =

 =



platform             | arch  | lab           | compiler | defconfig        =
  | regressions
---------------------+-------+---------------+----------+------------------=
--+------------
rk3288-veyron-jaq    | arm   | lab-collabora | gcc-8    | multi_v7_defconfi=
g | 3          =


  Details:     https://kernelci.org/test/plan/id/611951ef8e4d83e9c8b1366f

  Results:     67 PASS, 3 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable/linux-5.4.y/v5.4.141/ar=
m/multi_v7_defconfig/gcc-8/lab-collabora/baseline-rk3288-veyron-jaq.txt
  HTML log:    https://storage.kernelci.org//stable/linux-5.4.y/v5.4.141/ar=
m/multi_v7_defconfig/gcc-8/lab-collabora/baseline-rk3288-veyron-jaq.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.bootrr.rockchip-iodomain-grf-probed: https://kernelci.org/test=
/case/id/611951ef8e4d83e9c8b13687
        failing since 60 days (last pass: v5.4.125, first fail: v5.4.126)

    2021-08-15T17:41:56.164413  /lava-4367882/1/../bin/lava-test-case
    2021-08-15T17:41:56.181702  <8>[   14.988850] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Drockchip-iodomain-grf-probed RESULT=3Dfail>
    2021-08-15T17:41:56.181930  /lava-4367882/1/../bin/lava-test-case   =


  * baseline.bootrr.dwmmc_rockchip-sdio0-probed: https://kernelci.org/test/=
case/id/611951ef8e4d83e9c8b1369f
        failing since 60 days (last pass: v5.4.125, first fail: v5.4.126)

    2021-08-15T17:41:54.741453  /lava-4367882/1/../bin/lava-test-case
    2021-08-15T17:41:54.758518  <8>[   13.564726] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Ddwmmc_rockchip-sdio0-probed RESULT=3Dfail>
    2021-08-15T17:41:54.758743  /lava-4367882/1/../bin/lava-test-case   =


  * baseline.bootrr.dwmmc_rockchip-sdmmc-probed: https://kernelci.org/test/=
case/id/611951ef8e4d83e9c8b136a0
        failing since 60 days (last pass: v5.4.125, first fail: v5.4.126)

    2021-08-15T17:41:53.720556  /lava-4367882/1/../bin/lava-test-case
    2021-08-15T17:41:53.726685  <8>[   12.545156] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Ddwmmc_rockchip-sdmmc-probed RESULT=3Dfail>   =

 =20
