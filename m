Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2F4F3419325
	for <lists+stable@lfdr.de>; Mon, 27 Sep 2021 13:33:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234030AbhI0Lez (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Sep 2021 07:34:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44174 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234063AbhI0Lez (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 27 Sep 2021 07:34:55 -0400
Received: from mail-pg1-x529.google.com (mail-pg1-x529.google.com [IPv6:2607:f8b0:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8C2C7C061575
        for <stable@vger.kernel.org>; Mon, 27 Sep 2021 04:33:17 -0700 (PDT)
Received: by mail-pg1-x529.google.com with SMTP id f129so17566295pgc.1
        for <stable@vger.kernel.org>; Mon, 27 Sep 2021 04:33:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=ApVnYvSBQNbp6wbNaebSdj/4Ua3sPxa0hHT7FfULBtI=;
        b=CL0NSgP8d/rDxieUzO1Shg/6CDINuaCRb7QnNqioVf/wQV24gqBy5WSTB6REfbsjo0
         i6Sl69/w7wtYGckMWoCbfesAKLQSIdzpBGdwRsPz2kudV5UMrqv/J6DV3+P7YVCDaEU3
         bt82/Gl5KVYowCsG77IZWvI7RZkYFK+MOpPX1PNb0g7jq48GDM2OCfC57NfjlztQEUGl
         9U122lRxD4txKBKW9lOEu8TTWVREsmbqAbF/Eg12a5fXUJ6SNGCSUcDVhpDpPR89d0zr
         pjK9fdi/K6E4C1E1ovkCLTsN3XaxAFitx5wqfLCdPwe2DNyiq/RQYxP4984HMmxID57G
         dBCA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=ApVnYvSBQNbp6wbNaebSdj/4Ua3sPxa0hHT7FfULBtI=;
        b=qY2bBAGCUxi7DvQAeqpV012MQMv3N+9r1ZOVSOgv3GH0DkDdBDS6L3jXxQxMUZFimS
         /X4sOsIkX9Vq7Tz+hOUSlYNYeaeHghUxs90C+6RGvsAOH2UQo6WlyCbs6wBhmh039aIA
         ew6rDX+GduLwre098f2PFUX29bJUid1KOwyX8Lq//+PqffJ7AhAU3LnrWtHSeGIOGj+K
         rFt2ZWhGo5/X8SpOpyZgEy5QU+r56QG48aKEYaRM2c35A1GNZRQStIYHG9RSv8nO3nNb
         +G6HMecOqpqpy+Q16Hv4E/zhEjOTQMpX7yxdDZEOsZVbrXexyET/FGVEavCJhncjNQFj
         122w==
X-Gm-Message-State: AOAM533lIDA5RinJaIUCBuMpc9RqkKS95Vhd0onGFPN25GOAMKWdum2M
        YyVbDw71W/7yuxaMNL5++b5mLlE/S1LeAXeD
X-Google-Smtp-Source: ABdhPJzoFHzc3mLIPXorjK5ObfDMvpFR3DC34zxvAMuWB0PDG4m65/d/njuaSBa7psjeNOpBqoA88g==
X-Received: by 2002:aa7:8e56:0:b029:3cd:c2ec:6c1c with SMTP id d22-20020aa78e560000b02903cdc2ec6c1cmr22953046pfr.80.1632742396833;
        Mon, 27 Sep 2021 04:33:16 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id c199sm17359371pfb.152.2021.09.27.04.33.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 27 Sep 2021 04:33:16 -0700 (PDT)
Message-ID: <6151abfc.1c69fb81.c4582.891d@mx.google.com>
Date:   Mon, 27 Sep 2021 04:33:16 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.14.247-63-gf81f1291cb0f
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/4.14
Subject: stable-rc/queue/4.14 baseline: 120 runs,
 3 regressions (v4.14.247-63-gf81f1291cb0f)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.14 baseline: 120 runs, 3 regressions (v4.14.247-63-gf81f1=
291cb0f)

Regressions Summary
-------------------

platform          | arch | lab           | compiler | defconfig          | =
regressions
------------------+------+---------------+----------+--------------------+-=
-----------
rk3288-veyron-jaq | arm  | lab-collabora | gcc-8    | multi_v7_defconfig | =
3          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.14/ker=
nel/v4.14.247-63-gf81f1291cb0f/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.14
  Describe: v4.14.247-63-gf81f1291cb0f
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      f81f1291cb0f026441b5ef04d5634be8d65cc0ca =



Test Regressions
---------------- =



platform          | arch | lab           | compiler | defconfig          | =
regressions
------------------+------+---------------+----------+--------------------+-=
-----------
rk3288-veyron-jaq | arm  | lab-collabora | gcc-8    | multi_v7_defconfig | =
3          =


  Details:     https://kernelci.org/test/plan/id/6151801fcb28e49f3f99a305

  Results:     63 PASS, 6 FAIL, 1 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.247=
-63-gf81f1291cb0f/arm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-rk328=
8-veyron-jaq.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.247=
-63-gf81f1291cb0f/arm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-rk328=
8-veyron-jaq.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.bootrr.rockchip-iodomain-grf-probed: https://kernelci.org/test=
/case/id/6151801fcb28e49f3f99a319
        failing since 104 days (last pass: v4.14.236-20-gdb14655bb4bf, firs=
t fail: v4.14.236-49-gfd4c319f2583)

    2021-09-27T08:25:49.379525  /lava-4588850/1/../bin/lava-test-case
    2021-09-27T08:25:49.396454  [   17.244749] <LAVA_SIGNAL_TESTCASE TEST_C=
ASE_ID=3Drockchip-iodomain-grf-probed RESULT=3Dfail>   =


  * baseline.bootrr.dwmmc_rockchip-sdio0-probed: https://kernelci.org/test/=
case/id/6151801fcb28e49f3f99a332
        failing since 104 days (last pass: v4.14.236-20-gdb14655bb4bf, firs=
t fail: v4.14.236-49-gfd4c319f2583)

    2021-09-27T08:25:45.935494  /lava-4588850/1/../bin/lava-test-case[   13=
.794426] <LAVA_SIGNAL_TESTCASE TEST_CASE_ID=3Ddwmmc_rockchip-sdmmc-probed R=
ESULT=3Dfail>
    2021-09-27T08:25:45.935900  =

    2021-09-27T08:25:46.947995  /lava-4588850/1/../bin/lava-test-case
    2021-09-27T08:25:46.966326  [   14.813159] <LAVA_SIGNAL_TESTCASE TEST_C=
ASE_ID=3Ddwmmc_rockchip-sdio0-probed RESULT=3Dfail>
    2021-09-27T08:25:46.967009  /lava-4588850/1/../bin/lava-test-case   =


  * baseline.bootrr.dwmmc_rockchip-sdmmc-probed: https://kernelci.org/test/=
case/id/6151801fcb28e49f3f99a333
        failing since 104 days (last pass: v4.14.236-20-gdb14655bb4bf, firs=
t fail: v4.14.236-49-gfd4c319f2583) =

 =20
