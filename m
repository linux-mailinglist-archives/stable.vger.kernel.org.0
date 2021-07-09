Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9E70E3C1E0F
	for <lists+stable@lfdr.de>; Fri,  9 Jul 2021 06:20:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229641AbhGIEWn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 9 Jul 2021 00:22:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35586 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229506AbhGIEWn (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 9 Jul 2021 00:22:43 -0400
Received: from mail-pf1-x432.google.com (mail-pf1-x432.google.com [IPv6:2607:f8b0:4864:20::432])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BD98FC061574
        for <stable@vger.kernel.org>; Thu,  8 Jul 2021 21:19:59 -0700 (PDT)
Received: by mail-pf1-x432.google.com with SMTP id x16so7540862pfa.13
        for <stable@vger.kernel.org>; Thu, 08 Jul 2021 21:19:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=M79TKipcagffqRfM0VKBTGU+ZCdYc3J19H34dMsVl7o=;
        b=CzeORZ7TRhQiUF5FbeEshROWfQ8TZkrCNIuJHhksLeCTgMvDJAVeukXbT51rMmJVN7
         /TV4MLQw57/iQULdMT5NcP8gBUcGq3+aWcO3g26xeMgzZ2K/vHTI0/pK4viN919/wCLo
         ymwLJPx2eWAWavwJyPvHU1Y1wsKrvCpbnjj3xJ//OF8yl36q90YfnM3ZXuo0PzHWr603
         MXsePhK4kdpxsmC1su+mN8zT/LyYb2s5Bg7fYXewMc/DDT62SF3p7vQXufo8Ti08gCGG
         qz2q2Lw9whDXR5lU3h/Tax+JHUG8fQte5mllkif8UMoDn7oVXz9l7aarZAEe7dbFFVlW
         tIWw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=M79TKipcagffqRfM0VKBTGU+ZCdYc3J19H34dMsVl7o=;
        b=eaa80J8FGqPVPgjp4V3bFWGIVGxu8KL1QdJ1QCGjTSvFvqYK/SKRG/B04EGIJXnSHU
         m801aCVqfpMqGhJJdQBnm0F03Gl4j0GKrCMVsf+LbdE1VEzWydWqhWQrolqjKfTnLQMs
         uj7glYx/OuyQrva5v0ra+s5Z7qjDzw+91hhFLJge3d4kOhK5kon/HlfyMrf0OQla1Eg/
         Fa+hMe/cB7gedCN/NduZ8HIkyOYZzAOeodu7OSB1210y5YEaJlj5JW5myB1xZK+GliOe
         O6GEYTgUwShI0LUx/bVOOC0sHgR1C0qR8fDj4FFllbU38XfgmKhHu0/9jmEuRWhtjbjN
         HHvw==
X-Gm-Message-State: AOAM5302v0OiUumRGsgzNRmuI8X9I8vYApBWBXSKeBFSg2mQZyeN9TKU
        of6hXde0ytFvZPABIStZ9MMLVX6MlBvCgbOK
X-Google-Smtp-Source: ABdhPJy5uQpfUpAjxMvAk59nIjLd55G4G2TcOFtnl75TYA2j4YuJ3ChCEt3KCVuFGJn+gdIzd5tgwQ==
X-Received: by 2002:a62:e90b:0:b029:30e:4530:8dca with SMTP id j11-20020a62e90b0000b029030e45308dcamr34886623pfh.17.1625804399094;
        Thu, 08 Jul 2021 21:19:59 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id c24sm5351153pgj.11.2021.07.08.21.19.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 08 Jul 2021 21:19:58 -0700 (PDT)
Message-ID: <60e7ce6e.1c69fb81.3785.1700@mx.google.com>
Date:   Thu, 08 Jul 2021 21:19:58 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v5.4.130-4-g2151dbfa7bb2
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/5.4
Subject: stable-rc/queue/5.4 baseline: 191 runs,
 3 regressions (v5.4.130-4-g2151dbfa7bb2)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.4 baseline: 191 runs, 3 regressions (v5.4.130-4-g2151dbfa=
7bb2)

Regressions Summary
-------------------

platform          | arch | lab           | compiler | defconfig          | =
regressions
------------------+------+---------------+----------+--------------------+-=
-----------
rk3288-veyron-jaq | arm  | lab-collabora | gcc-8    | multi_v7_defconfig | =
3          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.4/kern=
el/v5.4.130-4-g2151dbfa7bb2/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.4
  Describe: v5.4.130-4-g2151dbfa7bb2
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      2151dbfa7bb26965801445e3eb48b3290eef26bf =



Test Regressions
---------------- =



platform          | arch | lab           | compiler | defconfig          | =
regressions
------------------+------+---------------+----------+--------------------+-=
-----------
rk3288-veyron-jaq | arm  | lab-collabora | gcc-8    | multi_v7_defconfig | =
3          =


  Details:     https://kernelci.org/test/plan/id/60e7a582e4eae55990117976

  Results:     67 PASS, 3 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.130-4=
-g2151dbfa7bb2/arm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-rk3288-v=
eyron-jaq.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.130-4=
-g2151dbfa7bb2/arm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-rk3288-v=
eyron-jaq.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.bootrr.rockchip-iodomain-grf-probed: https://kernelci.org/test=
/case/id/60e7a582e4eae5599011798a
        failing since 23 days (last pass: v5.4.125-37-g7cda316475cf, first =
fail: v5.4.125-84-g411d62eda127)

    2021-07-09T01:25:01.296508  /lava-4161679/1/../bin/lava-test-case
    2021-07-09T01:25:01.313443  <8>[   14.760025] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Drockchip-iodomain-grf-probed RESULT=3Dfail>   =


  * baseline.bootrr.dwmmc_rockchip-sdio0-probed: https://kernelci.org/test/=
case/id/60e7a582e4eae559901179a2
        failing since 23 days (last pass: v5.4.125-37-g7cda316475cf, first =
fail: v5.4.125-84-g411d62eda127)

    2021-07-09T01:24:59.888837  /lava-4161679/1/../bin/lava-test-case<8>[  =
 13.335090] <LAVA_SIGNAL_TESTCASE TEST_CASE_ID=3Ddwmmc_rockchip-sdio0-probe=
d RESULT=3Dfail>
    2021-07-09T01:24:59.889182  =

    2021-07-09T01:24:59.889374  /lava-4161679/1/../bin/lava-test-case   =


  * baseline.bootrr.dwmmc_rockchip-sdmmc-probed: https://kernelci.org/test/=
case/id/60e7a582e4eae559901179a3
        failing since 23 days (last pass: v5.4.125-37-g7cda316475cf, first =
fail: v5.4.125-84-g411d62eda127)

    2021-07-09T01:24:58.851654  /lava-4161679/1/../bin/lava-test-case
    2021-07-09T01:24:58.856998  <8>[   12.315374] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Ddwmmc_rockchip-sdmmc-probed RESULT=3Dfail>   =

 =20
