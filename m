Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5C7093FF564
	for <lists+stable@lfdr.de>; Thu,  2 Sep 2021 23:11:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245379AbhIBVMl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 2 Sep 2021 17:12:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57780 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232087AbhIBVMl (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 2 Sep 2021 17:12:41 -0400
Received: from mail-pf1-x433.google.com (mail-pf1-x433.google.com [IPv6:2607:f8b0:4864:20::433])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A04F8C061575
        for <stable@vger.kernel.org>; Thu,  2 Sep 2021 14:11:42 -0700 (PDT)
Received: by mail-pf1-x433.google.com with SMTP id u6so2676213pfi.0
        for <stable@vger.kernel.org>; Thu, 02 Sep 2021 14:11:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=i7faQboOtO03WPso3PfT58nPdTbahHnJSYVxs6QPrf8=;
        b=iTYcBmCDkozdDbHxwuhzyRYfcB4KBSu/8FDZC8r79cRjTvmeC3y91Dh/zFnvSjpgkN
         waaOAq4hC4XHS5sSLzhjqJcirvsVApkCJm1EbSo+A6eknhkDCM7pAPP6miIkqsjqKvAr
         jR4P4b+4iZqhvhp3XHpcif8T/FAsp2DBs1cIoBlsqYaaSxcO6b5eAcnFYGTPCCKX9P8x
         IFwcdq8hBdBl17gikN6vuYkreNwV/ZztCAiyb/2Z295zJWKmqKIchp8ohivOWsgNp5CK
         m8MkBIddNA6cpSeAknxIPxrUr34HRaGkdR0ji/1qz/dLaA514KD4X2HUE1e0tB2i42no
         fFFA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=i7faQboOtO03WPso3PfT58nPdTbahHnJSYVxs6QPrf8=;
        b=Y9iNuhJRd8avIhWRar/r22GUrdsFh7MOyXxbN3p1uljlkTBe0BcD0AslcekZWerPrw
         EHHivRSsd1P7N6VlFFXJ++z6WyI5Qa7ueQttjSGwrAMsAxZy0y5Zlf3/PnrnfE7I5x1m
         UZKLH/PUiuYS2A7ylMgH2efLm2MKh2bM0CRFKy5H2/sgY19n09F+gWDpe7dAt+SJqR9q
         rkYTq7WfiRZsdz5Tx/UIT5y7F1FgsOPwmVuNyfanMHlOgJXs6nWtsR+5A55zCuFIauqj
         rzTewTNfwbEi/Xfctft8kFwF+SynTpYl3cnazK3xf3Y2iNeHj/fRgMA8EALHVU79P2WI
         +Q1Q==
X-Gm-Message-State: AOAM533UOLjDjBvTBluNtjnpL38xVURjfA0TBRZWXRqqofk6nVjj/ZRz
        U9wm0ZEtM7J95M6+2KeK8+VT7WOJPKolgk20
X-Google-Smtp-Source: ABdhPJzFKIJDMH8ei6rfMaNxUYVGiVH5GoF45lQEnBN3ww0Of4RjQUqSFKqO54Z2dSjd/+zcLwWM3w==
X-Received: by 2002:a63:1618:: with SMTP id w24mr336070pgl.146.1630617101964;
        Thu, 02 Sep 2021 14:11:41 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id 138sm3101351pfz.187.2021.09.02.14.11.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 02 Sep 2021 14:11:41 -0700 (PDT)
Message-ID: <61313e0d.1c69fb81.c0dc5.819a@mx.google.com>
Date:   Thu, 02 Sep 2021 14:11:41 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v5.4.143-48-gb50a0fb6dbc3
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/5.4
Subject: stable-rc/queue/5.4 baseline: 214 runs,
 3 regressions (v5.4.143-48-gb50a0fb6dbc3)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.4 baseline: 214 runs, 3 regressions (v5.4.143-48-gb50a0fb=
6dbc3)

Regressions Summary
-------------------

platform          | arch | lab           | compiler | defconfig          | =
regressions
------------------+------+---------------+----------+--------------------+-=
-----------
rk3288-veyron-jaq | arm  | lab-collabora | gcc-8    | multi_v7_defconfig | =
3          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.4/kern=
el/v5.4.143-48-gb50a0fb6dbc3/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.4
  Describe: v5.4.143-48-gb50a0fb6dbc3
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      b50a0fb6dbc3235158015d69d29520ce8d6b5670 =



Test Regressions
---------------- =



platform          | arch | lab           | compiler | defconfig          | =
regressions
------------------+------+---------------+----------+--------------------+-=
-----------
rk3288-veyron-jaq | arm  | lab-collabora | gcc-8    | multi_v7_defconfig | =
3          =


  Details:     https://kernelci.org/test/plan/id/613117339bc13cb139d596a4

  Results:     67 PASS, 3 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.143-4=
8-gb50a0fb6dbc3/arm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-rk3288-=
veyron-jaq.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.143-4=
8-gb50a0fb6dbc3/arm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-rk3288-=
veyron-jaq.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.bootrr.rockchip-iodomain-grf-probed: https://kernelci.org/test=
/case/id/613117339bc13cb139d596b8
        failing since 79 days (last pass: v5.4.125-37-g7cda316475cf, first =
fail: v5.4.125-84-g411d62eda127)

    2021-09-02T18:25:33.601494  /lava-4437024/1/../bin/lava-test-case<8>[  =
 15.241248] <LAVA_SIGNAL_TESTCASE TEST_CASE_ID=3Drockchip-iodomain-grf-prob=
ed RESULT=3Dfail>
    2021-09-02T18:25:33.602014  =

    2021-09-02T18:25:33.602508  /lava-4437024/1/../bin/lava-test-case   =


  * baseline.bootrr.dwmmc_rockchip-sdio0-probed: https://kernelci.org/test/=
case/id/613117339bc13cb139d596d0
        failing since 79 days (last pass: v5.4.125-37-g7cda316475cf, first =
fail: v5.4.125-84-g411d62eda127)

    2021-09-02T18:25:32.160588  /lava-4437024/1/../bin/lava-test-case
    2021-09-02T18:25:32.165575  <8>[   13.817259] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Ddwmmc_rockchip-sdio0-probed RESULT=3Dfail>   =


  * baseline.bootrr.dwmmc_rockchip-sdmmc-probed: https://kernelci.org/test/=
case/id/613117339bc13cb139d596d1
        failing since 79 days (last pass: v5.4.125-37-g7cda316475cf, first =
fail: v5.4.125-84-g411d62eda127)

    2021-09-02T18:25:31.142458  /lava-4437024/1/../bin/lava-test-case
    2021-09-02T18:25:31.142844  <8>[   12.797737] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Ddwmmc_rockchip-sdmmc-probed RESULT=3Dfail>   =

 =20
