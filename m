Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 17B4B403E45
	for <lists+stable@lfdr.de>; Wed,  8 Sep 2021 19:19:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240197AbhIHRUd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 8 Sep 2021 13:20:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42658 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231723AbhIHRUc (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 8 Sep 2021 13:20:32 -0400
Received: from mail-pf1-x431.google.com (mail-pf1-x431.google.com [IPv6:2607:f8b0:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5E886C061575
        for <stable@vger.kernel.org>; Wed,  8 Sep 2021 10:19:24 -0700 (PDT)
Received: by mail-pf1-x431.google.com with SMTP id s29so2638039pfw.5
        for <stable@vger.kernel.org>; Wed, 08 Sep 2021 10:19:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=m+J+9bhZh13CdGEB0O9/pMsF+FfvmYTHaCVLyfaEaTk=;
        b=SOnsluNlIY+PZpP3WVXi0Oiwy4ZPxs1jbFI625XprbQAOhHpndKaW3oTp1uDrPiNuR
         MyD47mJXYFxRf94+jbeCzhkqFHmL7Hw1PV0XP1blwTfLlJSKq1elFakouQiRDN2NflhQ
         XN0DXmtiTl7cDQUV1RkdpnIl4C8sKAqbGI4HBq2SV9G9l6M3clX6fNXasuT/OnigJ3u/
         pFLZvWa1vp8SpKyUIbPjLJYPclJFvYA4/3YizaqUhmDgClcn09WkH1osS5eQNlImjWsB
         O8zmomycDS6es+bJaFUpnmZ1Xx0nfNdyVlKThrhlSIrCvC6hGYETvzGSMre+R1bd2cl6
         c1HA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=m+J+9bhZh13CdGEB0O9/pMsF+FfvmYTHaCVLyfaEaTk=;
        b=uWkcgtGIHXpIYCRofzSmF5Y2js/BjQopbh94ATKSXO35c76g5YotekWVrDSEZzEbcC
         Fj918KepbuLdTGWMORtwVzTSwwLPp6qtoSGbdHuZ0L2qTo/yUKHorKl0I6hTGyrToSj1
         KbznKRaPlUXiqlJV6I9rsQVkEfk2PY6jJJDPbfAN2hgV2io4O2nrf1orS8k/dvuPijW+
         4GQx5ORys82Vh93DZfAPZAdVJFVB1Nzw3ZW53uiR1FJEBvY2Wi33fXCLGJwoqyrmtckj
         CSaOnaYNrAOxR7ueGjekfeTdFG9RK8x82SPUcVjdJ3HMK3bCDJXT86UhG2qizaGct02I
         G9IQ==
X-Gm-Message-State: AOAM533/EXqeGCYKJTpUHNFmVriAzseB272zYX4YLTVOGR91BshK8/5g
        q/H9Sru1SKelAAoMWsFaBLIFpST1gYDVe/UG
X-Google-Smtp-Source: ABdhPJx0Wc9EkH1pHWew/kPyGAPUbcNu0nSFwPOZ6PjX3VVsJWxh5hm+ySPhdqHIV68bARauiTDOkg==
X-Received: by 2002:a62:cec1:0:b0:3f2:6877:238f with SMTP id y184-20020a62cec1000000b003f26877238fmr4694607pfg.1.1631121563565;
        Wed, 08 Sep 2021 10:19:23 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id 192sm3110862pfz.140.2021.09.08.10.19.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 08 Sep 2021 10:19:23 -0700 (PDT)
Message-ID: <6138f09b.1c69fb81.2274f.8cbe@mx.google.com>
Date:   Wed, 08 Sep 2021 10:19:23 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v4.14.246-24-g2dd51cbf7f11
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/4.14
Subject: stable-rc/queue/4.14 baseline: 159 runs,
 3 regressions (v4.14.246-24-g2dd51cbf7f11)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.14 baseline: 159 runs, 3 regressions (v4.14.246-24-g2dd51=
cbf7f11)

Regressions Summary
-------------------

platform          | arch | lab           | compiler | defconfig          | =
regressions
------------------+------+---------------+----------+--------------------+-=
-----------
rk3288-veyron-jaq | arm  | lab-collabora | gcc-8    | multi_v7_defconfig | =
3          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.14/ker=
nel/v4.14.246-24-g2dd51cbf7f11/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.14
  Describe: v4.14.246-24-g2dd51cbf7f11
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      2dd51cbf7f11b18161f3040cba8b92902054e677 =



Test Regressions
---------------- =



platform          | arch | lab           | compiler | defconfig          | =
regressions
------------------+------+---------------+----------+--------------------+-=
-----------
rk3288-veyron-jaq | arm  | lab-collabora | gcc-8    | multi_v7_defconfig | =
3          =


  Details:     https://kernelci.org/test/plan/id/6138da8302e6e24040d59678

  Results:     63 PASS, 6 FAIL, 1 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.246=
-24-g2dd51cbf7f11/arm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-rk328=
8-veyron-jaq.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.246=
-24-g2dd51cbf7f11/arm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-rk328=
8-veyron-jaq.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.bootrr.rockchip-iodomain-grf-probed: https://kernelci.org/test=
/case/id/6138da8302e6e24040d5968c
        failing since 85 days (last pass: v4.14.236-20-gdb14655bb4bf, first=
 fail: v4.14.236-49-gfd4c319f2583)

    2021-09-08T15:44:49.160464  /lava-4476779/1/../bin/lava-test-case
    2021-09-08T15:44:49.177495  [   16.159674] <LAVA_SIGNAL_TESTCASE TEST_C=
ASE_ID=3Drockchip-iodomain-grf-probed RESULT=3Dfail>   =


  * baseline.bootrr.dwmmc_rockchip-sdmmc-probed: https://kernelci.org/test/=
case/id/6138da8302e6e24040d596a3
        failing since 85 days (last pass: v4.14.236-20-gdb14655bb4bf, first=
 fail: v4.14.236-49-gfd4c319f2583) =


  * baseline.bootrr.dwmmc_rockchip-sdio0-probed: https://kernelci.org/test/=
case/id/6138da8402e6e24040d596bb
        failing since 85 days (last pass: v4.14.236-20-gdb14655bb4bf, first=
 fail: v4.14.236-49-gfd4c319f2583)

    2021-09-08T15:44:45.717554  /lava-4476779/1/../bin/lava-test-case[   12=
.710175] <LAVA_SIGNAL_TESTCASE TEST_CASE_ID=3Ddwmmc_rockchip-sdmmc-probed R=
ESULT=3Dfail>
    2021-09-08T15:44:45.717974  =

    2021-09-08T15:44:46.730822  /lava-4476779/1/../bin/lava-test-case
    2021-09-08T15:44:46.748349  [   13.728840] <LAVA_SIGNAL_TESTCASE TEST_C=
ASE_ID=3Ddwmmc_rockchip-sdio0-probed RESULT=3Dfail>
    2021-09-08T15:44:46.748846  /lava-4476779/1/../bin/lava-test-case   =

 =20
