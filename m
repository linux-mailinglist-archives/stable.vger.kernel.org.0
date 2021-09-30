Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3C24E41E41A
	for <lists+stable@lfdr.de>; Fri,  1 Oct 2021 00:46:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230005AbhI3Wr4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 30 Sep 2021 18:47:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37982 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229836AbhI3Wrz (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 30 Sep 2021 18:47:55 -0400
Received: from mail-pf1-x42f.google.com (mail-pf1-x42f.google.com [IPv6:2607:f8b0:4864:20::42f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D2315C06176A
        for <stable@vger.kernel.org>; Thu, 30 Sep 2021 15:46:12 -0700 (PDT)
Received: by mail-pf1-x42f.google.com with SMTP id p1so224700pfh.8
        for <stable@vger.kernel.org>; Thu, 30 Sep 2021 15:46:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=BQpSAwvTjgGGzGL88Mqs2ngtPwibVUxxJrowEZJil3U=;
        b=F46y5XAfc6mubDjS0Rkux9fxaeFV5t7ZT4PNzi7NdIeGu6po8P3vbSHqJFKAQ81iPn
         0Nr6Q3QpU2FxaprFvzv1AfNyhgRKNk37xXMmmuFBE9+vTaQkMqFBLvH060iiU5JPC8NO
         vZ0XoMD286Xa7KgKhl9ZdZuNYDLEX19zQv3o23jJ2Iuhfhkg5SvojNk64oPp4b702aa+
         BPvo0KsmuNMoJCUY7tcG8W7ggVVOQWtg9dKVSM0qkKhhVxCyooAwISdKXS8zy9qT+xo4
         Os6HHeyuaLpoao+za2pIMp6rB1/8P3QU+uOPNSWV736gTcXla1iYiIDW2YHz28DR4BWf
         IjVw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=BQpSAwvTjgGGzGL88Mqs2ngtPwibVUxxJrowEZJil3U=;
        b=Nl7XZW/JbUC3dOcpXwterSJXeAtPoyLvmci2CDo7EwekVrwSaHjJpkeKrV+Oqkx4xm
         QN/oTtgCXUw0Vk8QRKmDr3gowRJMXfcbNIcmcsw84B7q98mCcyLz7RLmJY0oHaxTe1do
         GvXy/poPuH5T/t8DceQyLLqlCQJMDXe0nKg8hlkHcoFx3br++398XVU0qDpmA5312VCL
         LEtiVTYQH0kE/VOVyjh6ffRY3LsAyGKuiTL7RheHwJHiqI8yLrYUOWgoeK2Sz6sD8vrD
         hXHdx1MG2O06RH0ysu/slNd0MMdPhCUTroTCQBBhmxy84asiUxbk1aq/t8GvWKZtqqBd
         bYHQ==
X-Gm-Message-State: AOAM533pm7yTl9qg53+raqVYDaoapQlWz5DQBZKs0HU1DpyFK0FDTQrE
        Jn2xkzLRvBaqVgEimjoIAXDYELazv9Yx2GT+
X-Google-Smtp-Source: ABdhPJzxMdKoZaC6N+vAyJbfmAXVP50XxsuWELCdXZfFSd8a9UB9Qtkj/sS4GHsnWQixkO9tUANdbQ==
X-Received: by 2002:a62:ce0d:0:b0:438:71f1:4442 with SMTP id y13-20020a62ce0d000000b0043871f14442mr6722931pfg.21.1633041972090;
        Thu, 30 Sep 2021 15:46:12 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id k190sm4097290pgc.11.2021.09.30.15.46.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 30 Sep 2021 15:46:11 -0700 (PDT)
Message-ID: <61563e33.1c69fb81.14e57.c401@mx.google.com>
Date:   Thu, 30 Sep 2021 15:46:11 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v5.10.69-102-g5542f2f74fe9
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/5.10
Subject: stable-rc/queue/5.10 baseline: 161 runs,
 4 regressions (v5.10.69-102-g5542f2f74fe9)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.10 baseline: 161 runs, 4 regressions (v5.10.69-102-g5542f=
2f74fe9)

Regressions Summary
-------------------

platform                | arch  | lab           | compiler | defconfig     =
     | regressions
------------------------+-------+---------------+----------+---------------=
-----+------------
rk3288-veyron-jaq       | arm   | lab-collabora | gcc-8    | multi_v7_defco=
nfig | 3          =

sun50i-a64-bananapi-m64 | arm64 | lab-clabbe    | gcc-8    | defconfig     =
     | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.10/ker=
nel/v5.10.69-102-g5542f2f74fe9/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.10
  Describe: v5.10.69-102-g5542f2f74fe9
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      5542f2f74fe9efc38a3aaec87ea9cdc76158cf5a =



Test Regressions
---------------- =



platform                | arch  | lab           | compiler | defconfig     =
     | regressions
------------------------+-------+---------------+----------+---------------=
-----+------------
rk3288-veyron-jaq       | arm   | lab-collabora | gcc-8    | multi_v7_defco=
nfig | 3          =


  Details:     https://kernelci.org/test/plan/id/61560d30913fed8d2899a2db

  Results:     67 PASS, 3 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.69-=
102-g5542f2f74fe9/arm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-rk328=
8-veyron-jaq.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.69-=
102-g5542f2f74fe9/arm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-rk328=
8-veyron-jaq.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.bootrr.rockchip-iodomain-grf-probed: https://kernelci.org/test=
/case/id/61560d30913fed8d2899a2ef
        failing since 107 days (last pass: v5.10.43-44-g253317604975, first=
 fail: v5.10.43-130-g87b5f83f722c)

    2021-09-30T19:16:44.404853  /lava-4614063/1/../bin/lava-test-case
    2021-09-30T19:16:44.421928  <8>[   13.204501] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Drockchip-iodomain-grf-probed RESULT=3Dfail>   =


  * baseline.bootrr.dwmmc_rockchip-sdio0-probed: https://kernelci.org/test/=
case/id/61560d30913fed8d2899a307
        failing since 107 days (last pass: v5.10.43-44-g253317604975, first=
 fail: v5.10.43-130-g87b5f83f722c)

    2021-09-30T19:16:42.979921  /lava-4614063/1/../bin/lava-test-case
    2021-09-30T19:16:42.996695  <8>[   11.779895] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Ddwmmc_rockchip-sdio0-probed RESULT=3Dfail>   =


  * baseline.bootrr.dwmmc_rockchip-sdmmc-probed: https://kernelci.org/test/=
case/id/61560d30913fed8d2899a308
        failing since 107 days (last pass: v5.10.43-44-g253317604975, first=
 fail: v5.10.43-130-g87b5f83f722c)

    2021-09-30T19:16:41.960986  /lava-4614063/1/../bin/lava-test-case
    2021-09-30T19:16:41.966410  <8>[   10.760473] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Ddwmmc_rockchip-sdmmc-probed RESULT=3Dfail>   =

 =



platform                | arch  | lab           | compiler | defconfig     =
     | regressions
------------------------+-------+---------------+----------+---------------=
-----+------------
sun50i-a64-bananapi-m64 | arm64 | lab-clabbe    | gcc-8    | defconfig     =
     | 1          =


  Details:     https://kernelci.org/test/plan/id/61560be008417bf25f99a2df

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.69-=
102-g5542f2f74fe9/arm64/defconfig/gcc-8/lab-clabbe/baseline-sun50i-a64-bana=
napi-m64.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.69-=
102-g5542f2f74fe9/arm64/defconfig/gcc-8/lab-clabbe/baseline-sun50i-a64-bana=
napi-m64.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61560be008417bf25f99a=
2e0
        failing since 17 days (last pass: v5.10.63-26-gfb6b5e198aab, first =
fail: v5.10.64-214-g93e17c2075d7) =

 =20
