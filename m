Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8F7D9408578
	for <lists+stable@lfdr.de>; Mon, 13 Sep 2021 09:38:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237599AbhIMHjz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Sep 2021 03:39:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35556 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237678AbhIMHjy (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Sep 2021 03:39:54 -0400
Received: from mail-pl1-x634.google.com (mail-pl1-x634.google.com [IPv6:2607:f8b0:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9B5EFC061574
        for <stable@vger.kernel.org>; Mon, 13 Sep 2021 00:38:38 -0700 (PDT)
Received: by mail-pl1-x634.google.com with SMTP id n4so5220932plh.9
        for <stable@vger.kernel.org>; Mon, 13 Sep 2021 00:38:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=5Es/Y0+kULgRmZrPrCidZhwCigzBYhelzhxBcdJV1AU=;
        b=JcS+B+lJLABLFRcsnciL3PuWVxXWf0jgv4gdYrM9tLYBE51ACgeIeFl7JZ5wdpxIK9
         E1Yf0CORkaUGxJ8shDVkWh8vcTEBv8I59KkpjYwGlirOMr5TPP6NFNxdi+4JJT9bKrqA
         x0ev52VdDPAxErH+GOPYQLE89zMExTwIda0Di1KMcwD2WaTGOEgFObQlGhNoaId4vtgK
         dlvtBKuXZwkaVPCwSx/vKqolJItQ3xVlS+rB4PgOCwGIAZsJa/EVLzeYWoEvRHWE9PbB
         Ul2gCgbGZsRLKSLDlr4OeB3TUHAocR6GUR6Yxn0EVBi5CrXIJ3IZnlLsRQWDRAZpyf1A
         Wq1g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=5Es/Y0+kULgRmZrPrCidZhwCigzBYhelzhxBcdJV1AU=;
        b=sQvCczQYtaob/uojYgPJChODHkyIFB+OPVcTzwCUrmWfbkG5nkmAQ7T5xNz48NYpFG
         rno+px6RhvKS8HRHS7HH9fsoHnuAAsKAOmtDEv8I1pwkzj6Ucu7WYqqBAjJ9zcduf5jb
         lJwQ6/Xuj8hTNP1DuyfdCsmj8TWDMnbjRQTICPQdanRtYUTOpCvsaeBHalRv03HzNnnk
         Y7wdY38J8PE72m8bLRIGWAthwr/gcGDqlVWCrKT3dvVi3PdmKPRTmhrFoQCBW5Ekewqc
         ob4lrZV0NNKorXzVhZ57iUQjim1Wg9Fq2UCEAWlRN+v8oYVJqceW9EG0YWVFTG7pVNLw
         HhgA==
X-Gm-Message-State: AOAM5336Pml864FbAR8tHhhi9PjVzJugcT8kjQAVvXRj5I0HSEWSgY/j
        FQXQ8jSHbD3DSrgFFIEqmzhLmzYPHHNGHem9
X-Google-Smtp-Source: ABdhPJzECnOnwopuMy6STRlwogDVRvDJZTt1h1VUt8//DUEl5KV28Yfh81ah0UZm/qGHv0zECRjubQ==
X-Received: by 2002:a17:90a:ea0a:: with SMTP id w10mr6180822pjy.32.1631518717829;
        Mon, 13 Sep 2021 00:38:37 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id l23sm1064760pjl.49.2021.09.13.00.38.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 Sep 2021 00:38:37 -0700 (PDT)
Message-ID: <613efffd.1c69fb81.79860.2b22@mx.google.com>
Date:   Mon, 13 Sep 2021 00:38:37 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v4.14.246-92-ga2923daf9a08
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/4.14
Subject: stable-rc/queue/4.14 baseline: 136 runs,
 3 regressions (v4.14.246-92-ga2923daf9a08)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.14 baseline: 136 runs, 3 regressions (v4.14.246-92-ga2923=
daf9a08)

Regressions Summary
-------------------

platform          | arch | lab           | compiler | defconfig          | =
regressions
------------------+------+---------------+----------+--------------------+-=
-----------
rk3288-veyron-jaq | arm  | lab-collabora | gcc-8    | multi_v7_defconfig | =
3          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.14/ker=
nel/v4.14.246-92-ga2923daf9a08/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.14
  Describe: v4.14.246-92-ga2923daf9a08
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      a2923daf9a08d20f83ebc98dbf21303e1842ae76 =



Test Regressions
---------------- =



platform          | arch | lab           | compiler | defconfig          | =
regressions
------------------+------+---------------+----------+--------------------+-=
-----------
rk3288-veyron-jaq | arm  | lab-collabora | gcc-8    | multi_v7_defconfig | =
3          =


  Details:     https://kernelci.org/test/plan/id/613ef152487b957aa7d5967d

  Results:     63 PASS, 6 FAIL, 1 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.246=
-92-ga2923daf9a08/arm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-rk328=
8-veyron-jaq.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.246=
-92-ga2923daf9a08/arm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-rk328=
8-veyron-jaq.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.bootrr.rockchip-iodomain-grf-probed: https://kernelci.org/test=
/case/id/613ef152487b957aa7d59691
        failing since 90 days (last pass: v4.14.236-20-gdb14655bb4bf, first=
 fail: v4.14.236-49-gfd4c319f2583)

    2021-09-13T06:35:54.657699  /lava-4506306/1/../bin/lava-test-case
    2021-09-13T06:35:54.663182  [   16.308444] <LAVA_SIGNAL_TESTCASE TEST_C=
ASE_ID=3Drockchip-iodomain-grf-probed RESULT=3Dfail>   =


  * baseline.bootrr.dwmmc_rockchip-sdio0-probed: https://kernelci.org/test/=
case/id/613ef152487b957aa7d596aa
        failing since 90 days (last pass: v4.14.236-20-gdb14655bb4bf, first=
 fail: v4.14.236-49-gfd4c319f2583)

    2021-09-13T06:35:51.214237  /lava-4506306/1/../bin/lava-test-case[   12=
.859002] <LAVA_SIGNAL_TESTCASE TEST_CASE_ID=3Ddwmmc_rockchip-sdmmc-probed R=
ESULT=3Dfail>
    2021-09-13T06:35:51.214896  =

    2021-09-13T06:35:52.227757  /lava-4506306/1/../bin/lava-test-case
    2021-09-13T06:35:52.245088  [   13.877720] <LAVA_SIGNAL_TESTCASE TEST_C=
ASE_ID=3Ddwmmc_rockchip-sdio0-probed RESULT=3Dfail>
    2021-09-13T06:35:52.245545  /lava-4506306/1/../bin/lava-test-case   =


  * baseline.bootrr.dwmmc_rockchip-sdmmc-probed: https://kernelci.org/test/=
case/id/613ef152487b957aa7d596ab
        failing since 90 days (last pass: v4.14.236-20-gdb14655bb4bf, first=
 fail: v4.14.236-49-gfd4c319f2583) =

 =20
