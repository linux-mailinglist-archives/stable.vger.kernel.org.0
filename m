Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B91AF3ECAEE
	for <lists+stable@lfdr.de>; Sun, 15 Aug 2021 22:29:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230077AbhHOUaX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 15 Aug 2021 16:30:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46968 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229582AbhHOUaX (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 15 Aug 2021 16:30:23 -0400
Received: from mail-pj1-x102b.google.com (mail-pj1-x102b.google.com [IPv6:2607:f8b0:4864:20::102b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2F39CC061764
        for <stable@vger.kernel.org>; Sun, 15 Aug 2021 13:29:53 -0700 (PDT)
Received: by mail-pj1-x102b.google.com with SMTP id m24-20020a17090a7f98b0290178b1a81700so24164601pjl.4
        for <stable@vger.kernel.org>; Sun, 15 Aug 2021 13:29:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=iK/zPxfxJ3mFd5EjgBxA+LKjz8QFxdQIIyiih8hF2+w=;
        b=r6eNgIdJ/7Tn1abvOO6rn0bQAI8TLDeU7enYYMUfBVpRCkvs+LUXIKuELovMvyt/+X
         3PuDMsBtGcgZbfV330/vcf5io79kebfP0dmltkgacZvFnbfH02jOl3ZAIyRVO4e3zRHY
         ffrszyVUwxQQ6s5jRcntDACw6KdRp4EYvQWMXnMDfELN+MqIchZqCxFgIEZDvsI20ovJ
         xtjuMxdecvYaNdex5SdvRfAdCO68ktwULiaE3kf+HLuoDdQaOl2hyMovwhwsE31sqCn0
         Uc3aDs/oru4zmiA9ReYa/vjM1sK7wPwrhq/BlbmnQijuKQtslfnNbxIzOMfrHEOrA1I6
         XSHw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=iK/zPxfxJ3mFd5EjgBxA+LKjz8QFxdQIIyiih8hF2+w=;
        b=ekQxIf/S2xlY/gPTUUkVH8biPtLLdgxS/OeBaFqLGR2e5klBr6ImDkM4bvAdTW/sUu
         IA8sTT2jCiP7Av9fQlX/t6DIZtGKXMefu9/QyqcId4I95Q6/jrjIEMoz1K7bvFHdYHlQ
         czhMFXlJkLz2DStrGdlIXllKK6E3zU6AXhIXZWsS8wWnjbah1aPi7HFLjn/oH9IkhTer
         Ma38qTcYieoV2JIdR1UvKUhZBTuDMQoB3K+EL9OQCwJbMhpB9vueioIIGtAiJCo/W5+i
         Qq7ZypnlYR7LcFR+sGX7A0IGbaNmmZtHGXrWONBZHuk5qmE46AZT+Mk2+3vvmdXGOZ8w
         EB7g==
X-Gm-Message-State: AOAM532ALJelSfkxVt4oqP0R1nIigcuzR747BmoXMppb4SKCAwLNz2wy
        Ur8xCmOMwsiceoWRDRSW9oUKsUhEGczBLX/k
X-Google-Smtp-Source: ABdhPJzqfxJIqJXiHUjTdaLbGzrPs3k14YEczh1n7HJjZXn1a/Xb0aBa1YRa1cVHVwt/gRQLnPixuA==
X-Received: by 2002:a17:90b:3794:: with SMTP id mz20mr8952130pjb.63.1629059392454;
        Sun, 15 Aug 2021 13:29:52 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id q29sm9306287pfl.142.2021.08.15.13.29.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 15 Aug 2021 13:29:52 -0700 (PDT)
Message-ID: <61197940.1c69fb81.7b534.88c9@mx.google.com>
Date:   Sun, 15 Aug 2021 13:29:52 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: queue/4.14
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v4.14.243-60-ge1cebe4ab3a6
X-Kernelci-Report-Type: test
Subject: stable-rc/queue/4.14 baseline: 150 runs,
 4 regressions (v4.14.243-60-ge1cebe4ab3a6)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.14 baseline: 150 runs, 4 regressions (v4.14.243-60-ge1ceb=
e4ab3a6)

Regressions Summary
-------------------

platform          | arch  | lab           | compiler | defconfig          |=
 regressions
------------------+-------+---------------+----------+--------------------+=
------------
fsl-ls1043a-rdb   | arm64 | lab-nxp       | gcc-8    | defconfig          |=
 1          =

rk3288-veyron-jaq | arm   | lab-collabora | gcc-8    | multi_v7_defconfig |=
 3          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.14/ker=
nel/v4.14.243-60-ge1cebe4ab3a6/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.14
  Describe: v4.14.243-60-ge1cebe4ab3a6
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      e1cebe4ab3a6433755de53f57d501c792ac29120 =



Test Regressions
---------------- =



platform          | arch  | lab           | compiler | defconfig          |=
 regressions
------------------+-------+---------------+----------+--------------------+=
------------
fsl-ls1043a-rdb   | arm64 | lab-nxp       | gcc-8    | defconfig          |=
 1          =


  Details:     https://kernelci.org/test/plan/id/6119482e0ee9f3028cb136a2

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.243=
-60-ge1cebe4ab3a6/arm64/defconfig/gcc-8/lab-nxp/baseline-fsl-ls1043a-rdb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.243=
-60-ge1cebe4ab3a6/arm64/defconfig/gcc-8/lab-nxp/baseline-fsl-ls1043a-rdb.ht=
ml
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6119482e0ee9f3028cb13=
6a3
        new failure (last pass: v4.14.243-38-g7e1cb7d15ad6) =

 =



platform          | arch  | lab           | compiler | defconfig          |=
 regressions
------------------+-------+---------------+----------+--------------------+=
------------
rk3288-veyron-jaq | arm   | lab-collabora | gcc-8    | multi_v7_defconfig |=
 3          =


  Details:     https://kernelci.org/test/plan/id/611947326311146e69b13695

  Results:     63 PASS, 6 FAIL, 1 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.243=
-60-ge1cebe4ab3a6/arm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-rk328=
8-veyron-jaq.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.243=
-60-ge1cebe4ab3a6/arm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-rk328=
8-veyron-jaq.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.bootrr.rockchip-iodomain-grf-probed: https://kernelci.org/test=
/case/id/611947326311146e69b136ad
        failing since 61 days (last pass: v4.14.236-20-gdb14655bb4bf, first=
 fail: v4.14.236-49-gfd4c319f2583) =


  * baseline.bootrr.dwmmc_rockchip-sdio0-probed: https://kernelci.org/test/=
case/id/611947326311146e69b136c6
        failing since 61 days (last pass: v4.14.236-20-gdb14655bb4bf, first=
 fail: v4.14.236-49-gfd4c319f2583)

    2021-08-15T16:56:01.011068  /lava-4367737/1/../bin/lava-test-case
    2021-08-15T16:56:01.027492  [   14.160286] <LAVA_SIGNAL_TESTCASE TEST_C=
ASE_ID=3Ddwmmc_rockchip-sdio0-probed RESULT=3Dfail>   =


  * baseline.bootrr.dwmmc_rockchip-sdmmc-probed: https://kernelci.org/test/=
case/id/611947326311146e69b136c7
        failing since 61 days (last pass: v4.14.236-20-gdb14655bb4bf, first=
 fail: v4.14.236-49-gfd4c319f2583)

    2021-08-15T16:55:59.991442  /lava-4367737/1/../bin/lava-test-case
    2021-08-15T16:55:59.996730  [   13.141430] <LAVA_SIGNAL_TESTCASE TEST_C=
ASE_ID=3Ddwmmc_rockchip-sdmmc-probed RESULT=3Dfail>   =

 =20
