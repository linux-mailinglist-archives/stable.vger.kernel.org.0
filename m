Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EDB06419268
	for <lists+stable@lfdr.de>; Mon, 27 Sep 2021 12:43:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233800AbhI0KpS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Sep 2021 06:45:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32864 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233839AbhI0KpR (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 27 Sep 2021 06:45:17 -0400
Received: from mail-pg1-x52b.google.com (mail-pg1-x52b.google.com [IPv6:2607:f8b0:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 65073C061575
        for <stable@vger.kernel.org>; Mon, 27 Sep 2021 03:43:40 -0700 (PDT)
Received: by mail-pg1-x52b.google.com with SMTP id x191so10478347pgd.9
        for <stable@vger.kernel.org>; Mon, 27 Sep 2021 03:43:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=mI00hbtzpZMkzqFS5zblIbyHAhaPo0UW3xQLyNhJcpU=;
        b=AFCTWLhSUTDV21gQHBTVtoLEmZd6u3c3X4/v1opGiT1KrRvDriSUPKwh2kv/bbu1OX
         zrhSik1mr/wtq/FXSB5yTOz39p6NbgBy30SKYt1CvDtdkq8k9pbjYEosDcPZHLzvaBtQ
         /v8Yfv86MDUkpF3CqcDeL40ly1pBCkv4LcBCK2UfRUuFANA6XnKF1hkd8qe2p50ATgeC
         6LNST/VIgJH7vBBlD77rD8xy1dp30mgkdhO5XB59sCuAXB3hUyHK5Y8zvyyuFRWly5OZ
         hBUaijAGdUumA+DmILiIxiUXgoE2tpTSUdgpe4PoqaY5zldnt60tsWtTlv4hdvxkQ5YQ
         Ot2A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=mI00hbtzpZMkzqFS5zblIbyHAhaPo0UW3xQLyNhJcpU=;
        b=6ynZQhGgHxB2S2JZVxt+gIxo4Iq8/WFaO62zsd959kB8bngFq9i7YP03Qbr6AuxyL1
         +jOAjmj6IngTWRR+5Bn0R36Yh0nUqOsDAhJCR+Y4rDTxNpLwf1ss82B3dtMaIJyDbEuO
         e0PtMXqnzklUyfjrijIdJYpTxsI1oycYhOxp4qjrszlYsSFxuZM/yligaJX8DvZEFro7
         nW88GbnLEXZ+fd6Cf5Oh+1UfLeFGfnFI72R5Vl7XfJt4pxH9EV/UX3uTRS0Yl58CeK1A
         +9rdD6WL8Rn8gLBzmUU9JlCa6LwmFDoQJrp/vGAoRCGYr7OT667cMgwFodOZepnkDA/8
         2m8g==
X-Gm-Message-State: AOAM532PyS28s9UM5/Z9LS4flUaGYG+astShd0iIfGp7vWrxFxbTfPUV
        Uls7MYnEktU4bljN4qTuH9vNx9zVn3xJhNLp
X-Google-Smtp-Source: ABdhPJwpEAkRKOhmstSFblXtZBSCwdQi9NJ5KO+PrXfJ4tnlGcALiHYUYNDNvgzfl4Gij4s/+65B+Q==
X-Received: by 2002:a65:5bcf:: with SMTP id o15mr4590454pgr.379.1632739419607;
        Mon, 27 Sep 2021 03:43:39 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id p17sm1181364pju.34.2021.09.27.03.43.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 27 Sep 2021 03:43:39 -0700 (PDT)
Message-ID: <6151a05b.1c69fb81.98b06.429c@mx.google.com>
Date:   Mon, 27 Sep 2021 03:43:39 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v5.10.68-162-gb0e69f785a41
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/5.10
Subject: stable-rc/queue/5.10 baseline: 129 runs,
 5 regressions (v5.10.68-162-gb0e69f785a41)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.10 baseline: 129 runs, 5 regressions (v5.10.68-162-gb0e69=
f785a41)

Regressions Summary
-------------------

platform                | arch  | lab           | compiler | defconfig     =
     | regressions
------------------------+-------+---------------+----------+---------------=
-----+------------
hip07-d05               | arm64 | lab-collabora | gcc-8    | defconfig     =
     | 1          =

rk3288-veyron-jaq       | arm   | lab-collabora | gcc-8    | multi_v7_defco=
nfig | 3          =

sun50i-a64-bananapi-m64 | arm64 | lab-clabbe    | gcc-8    | defconfig     =
     | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.10/ker=
nel/v5.10.68-162-gb0e69f785a41/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.10
  Describe: v5.10.68-162-gb0e69f785a41
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      b0e69f785a414268f9aa89997d503f9c84761f54 =



Test Regressions
---------------- =



platform                | arch  | lab           | compiler | defconfig     =
     | regressions
------------------------+-------+---------------+----------+---------------=
-----+------------
hip07-d05               | arm64 | lab-collabora | gcc-8    | defconfig     =
     | 1          =


  Details:     https://kernelci.org/test/plan/id/61516d025201e172dc99a2f1

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.68-=
162-gb0e69f785a41/arm64/defconfig/gcc-8/lab-collabora/baseline-hip07-d05.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.68-=
162-gb0e69f785a41/arm64/defconfig/gcc-8/lab-collabora/baseline-hip07-d05.ht=
ml
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61516d025201e172dc99a=
2f2
        failing since 87 days (last pass: v5.10.46-100-gce5b41f85637, first=
 fail: v5.10.46-100-g3b96099161c8b) =

 =



platform                | arch  | lab           | compiler | defconfig     =
     | regressions
------------------------+-------+---------------+----------+---------------=
-----+------------
rk3288-veyron-jaq       | arm   | lab-collabora | gcc-8    | multi_v7_defco=
nfig | 3          =


  Details:     https://kernelci.org/test/plan/id/61516fbf39d136bf4799a2fc

  Results:     67 PASS, 3 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.68-=
162-gb0e69f785a41/arm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-rk328=
8-veyron-jaq.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.68-=
162-gb0e69f785a41/arm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-rk328=
8-veyron-jaq.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.bootrr.rockchip-iodomain-grf-probed: https://kernelci.org/test=
/case/id/61516fbf39d136bf4799a310
        failing since 104 days (last pass: v5.10.43-44-g253317604975, first=
 fail: v5.10.43-130-g87b5f83f722c)

    2021-09-27T07:16:02.126863  /lava-4588489/1/../bin/lava-test-case<8>[  =
 14.242863] <LAVA_SIGNAL_TESTCASE TEST_CASE_ID=3Drockchip-iodomain-grf-prob=
ed RESULT=3Dfail>
    2021-09-27T07:16:02.127405  =

    2021-09-27T07:16:02.127874  /lava-4588489/1/../bin/lava-test-case   =


  * baseline.bootrr.dwmmc_rockchip-sdio0-probed: https://kernelci.org/test/=
case/id/61516fbf39d136bf4799a328
        failing since 104 days (last pass: v5.10.43-44-g253317604975, first=
 fail: v5.10.43-130-g87b5f83f722c)

    2021-09-27T07:16:00.702800  /lava-4588489/1/../bin/lava-test-case<8>[  =
 12.818936] <LAVA_SIGNAL_TESTCASE TEST_CASE_ID=3Ddwmmc_rockchip-sdio0-probe=
d RESULT=3Dfail>
    2021-09-27T07:16:00.703401  =

    2021-09-27T07:16:00.703868  /lava-4588489/1/../bin/lava-test-case   =


  * baseline.bootrr.dwmmc_rockchip-sdmmc-probed: https://kernelci.org/test/=
case/id/61516fbf39d136bf4799a329
        failing since 104 days (last pass: v5.10.43-44-g253317604975, first=
 fail: v5.10.43-130-g87b5f83f722c)

    2021-09-27T07:15:59.664651  /lava-4588489/1/../bin/lava-test-case
    2021-09-27T07:15:59.671071  <8>[   11.799608] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Ddwmmc_rockchip-sdmmc-probed RESULT=3Dfail>   =

 =



platform                | arch  | lab           | compiler | defconfig     =
     | regressions
------------------------+-------+---------------+----------+---------------=
-----+------------
sun50i-a64-bananapi-m64 | arm64 | lab-clabbe    | gcc-8    | defconfig     =
     | 1          =


  Details:     https://kernelci.org/test/plan/id/61516be5d3c225251799a2da

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.68-=
162-gb0e69f785a41/arm64/defconfig/gcc-8/lab-clabbe/baseline-sun50i-a64-bana=
napi-m64.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.68-=
162-gb0e69f785a41/arm64/defconfig/gcc-8/lab-clabbe/baseline-sun50i-a64-bana=
napi-m64.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61516be5d3c225251799a=
2db
        failing since 14 days (last pass: v5.10.63-26-gfb6b5e198aab, first =
fail: v5.10.64-214-g93e17c2075d7) =

 =20
