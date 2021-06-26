Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 258C93B4BF8
	for <lists+stable@lfdr.de>; Sat, 26 Jun 2021 04:24:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229915AbhFZC0c (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 25 Jun 2021 22:26:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46012 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229906AbhFZC0c (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 25 Jun 2021 22:26:32 -0400
Received: from mail-pg1-x52a.google.com (mail-pg1-x52a.google.com [IPv6:2607:f8b0:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 706FBC061574
        for <stable@vger.kernel.org>; Fri, 25 Jun 2021 19:24:09 -0700 (PDT)
Received: by mail-pg1-x52a.google.com with SMTP id e20so9790554pgg.0
        for <stable@vger.kernel.org>; Fri, 25 Jun 2021 19:24:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=cnOKk3ab5d+WgEifVbhMYvRkel8Jtu1yn8XozNemC9o=;
        b=UOucag61M26XJzqRbeTa6vUVjubE+z8pcHGyIUE1vGX/8i1Btefc86AgPlrFMMQICr
         IdfdnFKylw05x9yjTH+t+kAOoGlWSWlxMC0c0aUjHsanpdZnyZOULyoGkabfy8vto2fG
         aqhmOj+JA59OZasxz1EDOp+RSVSmD9Ie+uChlRjy3OSim3bQzECvm928g/WfVei+EiuO
         LJgfUTVMo+cgGsMPxv5zIdb3tP4vJQIs0YlsOskTnVbyClrslHYSWtWvrvPHNoRL7wwC
         Ei6meXsLBp294jP/G/sGhXhU4+7E/qC/tNqD5TpL6axhzRfiQ+nSWETOIzcSQ4H1a7tm
         Zlrw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=cnOKk3ab5d+WgEifVbhMYvRkel8Jtu1yn8XozNemC9o=;
        b=iQm8GXhQVLOjOrVVNFPYHYwOyK0WSEKQGU7XI3dm0pKsHzAv877BDLa1L61v8kVSTJ
         Hh96xX+jXynBvNZwkUEXWsS2oKkF0ooOYZuODFpEcW9tQ86l/RUELO47Uhz6eC+CTQOl
         YmgrGvEXLqrHvYpDTX9Cpl/oeLLPexDYEprQtdQcivB+OqBtIXnoP+/gi/RoMMD/g8pa
         fMyZ9KBzaEwQkstrnpmoIs6f8vcxhVPXcJqlP7xvUDcGCketgsAQbZ5Q+TFc6fSVocVd
         vk1KJXB9kkKaZF/xYyt5mP0CzhqhVhD5GGMYt9r38E4hXzoLZ1QaGLGDpT+8a/UH2MYX
         hfcg==
X-Gm-Message-State: AOAM532gB+L0UsCPvjLrp5c1HJVt6x6Vm8ikcxs/HCevKXL2M/gnkepS
        bfrVN8iXtp0qq/qQ1FpE9k1gg1x2WL3tndqD
X-Google-Smtp-Source: ABdhPJyoC0qrloKavOLcQKKM9MRe9os0L9pFDqmPLWRl7OmugFs7M2/UdbmrBeHnDaquvY9r60fCzA==
X-Received: by 2002:a63:64d:: with SMTP id 74mr12231843pgg.13.1624674248469;
        Fri, 25 Jun 2021 19:24:08 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id p4sm7060068pff.148.2021.06.25.19.24.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 25 Jun 2021 19:24:08 -0700 (PDT)
Message-ID: <60d68fc8.1c69fb81.b9ff9.58fb@mx.google.com>
Date:   Fri, 25 Jun 2021 19:24:08 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v4.14.237-71-g52d491500f4c
X-Kernelci-Branch: queue/4.14
X-Kernelci-Tree: stable-rc
Subject: stable-rc/queue/4.14 baseline: 139 runs,
 4 regressions (v4.14.237-71-g52d491500f4c)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.14 baseline: 139 runs, 4 regressions (v4.14.237-71-g52d49=
1500f4c)

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
nel/v4.14.237-71-g52d491500f4c/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.14
  Describe: v4.14.237-71-g52d491500f4c
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      52d491500f4c829f75b5efb4e39e38ad15924912 =



Test Regressions
---------------- =



platform          | arch  | lab           | compiler | defconfig          |=
 regressions
------------------+-------+---------------+----------+--------------------+=
------------
meson-gxm-q200    | arm64 | lab-baylibre  | gcc-8    | defconfig          |=
 1          =


  Details:     https://kernelci.org/test/plan/id/60d65e9f7cfe4d2a8a413280

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.237=
-71-g52d491500f4c/arm64/defconfig/gcc-8/lab-baylibre/baseline-meson-gxm-q20=
0.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.237=
-71-g52d491500f4c/arm64/defconfig/gcc-8/lab-baylibre/baseline-meson-gxm-q20=
0.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60d65e9f7cfe4d2a8a413=
281
        failing since 116 days (last pass: v4.14.222-11-g13b8482a0f700, fir=
st fail: v4.14.222-120-gdc8887cba23e) =

 =



platform          | arch  | lab           | compiler | defconfig          |=
 regressions
------------------+-------+---------------+----------+--------------------+=
------------
rk3288-veyron-jaq | arm   | lab-collabora | gcc-8    | multi_v7_defconfig |=
 3          =


  Details:     https://kernelci.org/test/plan/id/60d65d2ae85ad9e7084132e7

  Results:     62 PASS, 6 FAIL, 1 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.237=
-71-g52d491500f4c/arm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-rk328=
8-veyron-jaq.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.237=
-71-g52d491500f4c/arm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-rk328=
8-veyron-jaq.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.bootrr.dwmmc_rockchip-sdmmc-probed: https://kernelci.org/test/=
case/id/60d65d2ae85ad9e708413303
        failing since 10 days (last pass: v4.14.236-20-gdb14655bb4bf, first=
 fail: v4.14.236-49-gfd4c319f2583)

    2021-06-25T22:48:02.954314  /lava-4097064/1/../bin/lava-test-case
    2021-06-25T22:48:02.959679  [   13.451268] <LAVA_SIGNAL_TESTCASE TEST_C=
ASE_ID=3Ddwmmc_rockchip-sdmmc-probed RESULT=3Dfail>   =


  * baseline.bootrr.dwmmc_rockchip-sdio0-probed: https://kernelci.org/test/=
case/id/60d65d2ae85ad9e708413304
        failing since 10 days (last pass: v4.14.236-20-gdb14655bb4bf, first=
 fail: v4.14.236-49-gfd4c319f2583)

    2021-06-25T22:48:03.973138  /lava-4097064/1/../bin/lava-test-case
    2021-06-25T22:48:03.990204  [   14.470132] <LAVA_SIGNAL_TESTCASE TEST_C=
ASE_ID=3Ddwmmc_rockchip-sdio0-probed RESULT=3Dfail>   =


  * baseline.bootrr.rockchip-iodomain-grf-probed: https://kernelci.org/test=
/case/id/60d65d2ae85ad9e70841331d
        failing since 10 days (last pass: v4.14.236-20-gdb14655bb4bf, first=
 fail: v4.14.236-49-gfd4c319f2583)

    2021-06-25T22:48:06.404158  /lava-4097064/1/../bin/lava-test-case
    2021-06-25T22:48:06.421552  [   16.901462] <LAVA_SIGNAL_TESTCASE TEST_C=
ASE_ID=3Drockchip-iodomain-grf-probed RESULT=3Dfail>
    2021-06-25T22:48:06.421808  /lava-4097064/1/../bin/lava-test-case   =

 =20
