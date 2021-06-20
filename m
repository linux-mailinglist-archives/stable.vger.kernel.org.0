Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 455CF3ADDD8
	for <lists+stable@lfdr.de>; Sun, 20 Jun 2021 11:05:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229581AbhFTJHl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 20 Jun 2021 05:07:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38504 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229491AbhFTJHk (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 20 Jun 2021 05:07:40 -0400
Received: from mail-pl1-x633.google.com (mail-pl1-x633.google.com [IPv6:2607:f8b0:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C41C6C061574
        for <stable@vger.kernel.org>; Sun, 20 Jun 2021 02:05:28 -0700 (PDT)
Received: by mail-pl1-x633.google.com with SMTP id v12so6904693plo.10
        for <stable@vger.kernel.org>; Sun, 20 Jun 2021 02:05:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=N99bNMrVd1ZwSP14EgCFUTsjKwGv88M422j09ydiVUE=;
        b=hOrDvrDV0SbrZ/7WowuiYc9uVKS8d5VN1pyJQOrN45vkmHPwKPF3mxh7Gv2TXL5DHH
         b1Z+43cmfYnqNabliufbB3C8I/A6nbL3c68W/7NVp84i/l8VZ7x0LlDAqWnWw/HHsGS9
         ncg/2T1tajXiIZwDEWWmFQVxdL2eNCwSFhZlHn7Zrq+Bnqyhn/hYVQOs5FOTCZA+aJn1
         i6YaWeb4itqcVHJRg/KQf4bysjQuDlplPrRbutZGpD91m4DBk6emnvebWOeKfw4qFznz
         2gjhSmIrHld2+ZLL7NJkx0OILlmD6kv4O4Wxk3/QhVbY//7Ph1he0orM2P/+Go/N4sxM
         4+FQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=N99bNMrVd1ZwSP14EgCFUTsjKwGv88M422j09ydiVUE=;
        b=XrvxWasnqX6Bh8uxKxCCMDW/MBKm6J4nPmX375MEARb0yImDX4ofk50m9BN56yVSNN
         AMHdFfvFirJKm8ut0ghBtqYydPkZdaTNfttZdrWYawAOZNXeijUPiTDMB8B7oQ8yA2Tj
         UvXcJRiZ046fqLpU0jh0dzvdk27IO2qhJSNzTmUlsofRozXs3xQd6lFr22LxhWDDoZM2
         E/xbKCgQT3SBAmFkF3315o9dCQYL3co2HEUCQoMbWokGARy6E8okpwZTJ/PLRC//jSzl
         XwHXAQLev28hhaqZ6fmIM69kKdfV4/wBvEM1wiDZPLopAbv7ePSdAqwa6fmIQns+8PZp
         A6jw==
X-Gm-Message-State: AOAM530vxh3hMkV5pcMmIaBe9AiJCgKUhctiLNzTWW7fvz0oVcDqfLpG
        BORCpKwvJLAPenC2ry/dDUoiJRFLdOMDHjSD
X-Google-Smtp-Source: ABdhPJykyyYv5ZtLr1og31R6Q53OEZrB0U9ttLhrCxvy09RB41lzf2O/NjcGJvDpcIRe9MWuRwfebQ==
X-Received: by 2002:a17:903:1243:b029:107:eca4:d5bf with SMTP id u3-20020a1709031243b0290107eca4d5bfmr12511329plh.15.1624179927536;
        Sun, 20 Jun 2021 02:05:27 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id y21sm3127272pgc.93.2021.06.20.02.05.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 20 Jun 2021 02:05:27 -0700 (PDT)
Message-ID: <60cf04d7.1c69fb81.1df37.7ddf@mx.google.com>
Date:   Sun, 20 Jun 2021 02:05:27 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v4.19.195-53-gdef10eaed2fc
X-Kernelci-Branch: queue/4.19
X-Kernelci-Tree: stable-rc
Subject: stable-rc/queue/4.19 baseline: 155 runs,
 3 regressions (v4.19.195-53-gdef10eaed2fc)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.19 baseline: 155 runs, 3 regressions (v4.19.195-53-gdef10=
eaed2fc)

Regressions Summary
-------------------

platform          | arch | lab           | compiler | defconfig          | =
regressions
------------------+------+---------------+----------+--------------------+-=
-----------
rk3288-veyron-jaq | arm  | lab-collabora | gcc-8    | multi_v7_defconfig | =
3          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.19/ker=
nel/v4.19.195-53-gdef10eaed2fc/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.19
  Describe: v4.19.195-53-gdef10eaed2fc
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      def10eaed2fc9bee77d3f3ae412d9a877bed48b2 =



Test Regressions
---------------- =



platform          | arch | lab           | compiler | defconfig          | =
regressions
------------------+------+---------------+----------+--------------------+-=
-----------
rk3288-veyron-jaq | arm  | lab-collabora | gcc-8    | multi_v7_defconfig | =
3          =


  Details:     https://kernelci.org/test/plan/id/60ceedb30b40913f50413277

  Results:     63 PASS, 6 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.195=
-53-gdef10eaed2fc/arm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-rk328=
8-veyron-jaq.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.195=
-53-gdef10eaed2fc/arm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-rk328=
8-veyron-jaq.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.bootrr.dwmmc_rockchip-sdmmc-probed: https://kernelci.org/test/=
case/id/60ceedb30b40913f50413293
        failing since 5 days (last pass: v4.19.194-28-g6098ecdead2c, first =
fail: v4.19.194-67-g1b5dea188d94)

    2021-06-20T07:26:36.155621  /lava-4063582/1/../bin/lava-test-case
    2021-06-20T07:26:36.160879  <8>[   14.343314] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Ddwmmc_rockchip-sdmmc-probed RESULT=3Dfail>   =


  * baseline.bootrr.dwmmc_rockchip-sdio0-probed: https://kernelci.org/test/=
case/id/60ceedb30b40913f50413294
        failing since 5 days (last pass: v4.19.194-28-g6098ecdead2c, first =
fail: v4.19.194-67-g1b5dea188d94)

    2021-06-20T07:26:37.176574  /lava-4063582/1/../bin/lava-test-case<8>[  =
 15.362823] <LAVA_SIGNAL_TESTCASE TEST_CASE_ID=3Ddwmmc_rockchip-sdio0-probe=
d RESULT=3Dfail>
    2021-06-20T07:26:37.177059     =


  * baseline.bootrr.rockchip-iodomain-grf-probed: https://kernelci.org/test=
/case/id/60ceedb30b40913f504132ad
        failing since 5 days (last pass: v4.19.194-28-g6098ecdead2c, first =
fail: v4.19.194-67-g1b5dea188d94)

    2021-06-20T07:26:39.617673  /lava-4063582/1/../bin/lava-test-case
    2021-06-20T07:26:39.634546  <8>[   17.805512] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Drockchip-iodomain-grf-probed RESULT=3Dfail>   =

 =20
