Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C5AA83B7C47
	for <lists+stable@lfdr.de>; Wed, 30 Jun 2021 05:50:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232769AbhF3DxG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 29 Jun 2021 23:53:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53596 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232327AbhF3DxG (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 29 Jun 2021 23:53:06 -0400
Received: from mail-pf1-x433.google.com (mail-pf1-x433.google.com [IPv6:2607:f8b0:4864:20::433])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E27C3C061760
        for <stable@vger.kernel.org>; Tue, 29 Jun 2021 20:50:37 -0700 (PDT)
Received: by mail-pf1-x433.google.com with SMTP id i6so1207820pfq.1
        for <stable@vger.kernel.org>; Tue, 29 Jun 2021 20:50:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=qVHcYXuyNH/ML7T8/HEEwrUZb8cLW6aAaxdPY+00AsM=;
        b=Q+2G87WmkByJXtL2z0+keCeI4DAHKvdUdkaQ+wTOHcygjfnDtxGOVOnPry5QDJxLb3
         W17r6uIQWVOHHIHQm6mq1xT9/3LrXrIrSB07MEkFZ8pjaqLdRvOweJQD2hSyxns9GVuR
         EZIIdRQAwnSHYBv2V63tlrXyvaQaisQHeu7cqhUk9Yl23TpnBeLR06IiG4gNUVdJTkX2
         o2xQ+ZH4m49HRyhuvsHYCutgOJIEVU/no8+uxMeSthYYxbAcEPOvC6ysUuTyJ8XX8iW0
         1FEQ3Jie/UcQUzpO0FqX5pA8kziPHlt5a9x683FrMtCtgUnNF3IKlQatkTgBiT/lul6A
         3t4w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=qVHcYXuyNH/ML7T8/HEEwrUZb8cLW6aAaxdPY+00AsM=;
        b=kho8Jqa8V7UFhqItgQiGqHK18GonaoLFvXG/NlpE/XqFZ6E9UGI0vcXlxKxSwBk8iT
         Sn8PYAvrOE29wJBIJsIYWOqB9GtyGnwIvQwiWfH0HtOupMGiBcyqx1UlEdM6tl0Xaxtt
         ffudpF7jLwBhbDmcHZ0jWTFha7N7KvI6nISMCXPKqlJrdmkZo6mOBeaHzUBMZl5iZBk4
         1d13gk72ezcoGcRTdXE7eSzRZNsrWn2+WRjU1DOdzFl8Ny5i/LISpOjjc2uwqb8OmF8c
         Cb6P8s3jTpNciCUn9BJaY9LGuKoU0JdMtoZA7SnVJfxry7Q3KkOLWQixM3O4+syOgAVe
         LMMA==
X-Gm-Message-State: AOAM5326lt8ZqeWmB7sb8Gh4F+GS6iDCBa1DdG6x6ykSRlhZbUDPBg9j
        5aKTcWV10swCqw7iVaPUVdSWbylWaqBK2B6v
X-Google-Smtp-Source: ABdhPJzAoYv+btpnPf98igl0/wWfFWdSqMWwXPk1HyV7KkqcomQPQ6LcIkrYmLS/oPia/0x/Ej3BLQ==
X-Received: by 2002:a63:4a18:: with SMTP id x24mr31561937pga.303.1625025037133;
        Tue, 29 Jun 2021 20:50:37 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id p14sm20942246pgb.2.2021.06.29.20.50.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 29 Jun 2021 20:50:36 -0700 (PDT)
Message-ID: <60dbea0c.1c69fb81.fd1ea.da0d@mx.google.com>
Date:   Tue, 29 Jun 2021 20:50:36 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v5.12.13-109-g47e1fda87919
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/5.12
Subject: stable-rc/queue/5.12 baseline: 152 runs,
 4 regressions (v5.12.13-109-g47e1fda87919)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.12 baseline: 152 runs, 4 regressions (v5.12.13-109-g47e1f=
da87919)

Regressions Summary
-------------------

platform           | arch | lab           | compiler | defconfig          |=
 regressions
-------------------+------+---------------+----------+--------------------+=
------------
bcm2837-rpi-3-b-32 | arm  | lab-baylibre  | gcc-8    | bcm2835_defconfig  |=
 1          =

rk3288-veyron-jaq  | arm  | lab-collabora | gcc-8    | multi_v7_defconfig |=
 3          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.12/ker=
nel/v5.12.13-109-g47e1fda87919/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.12
  Describe: v5.12.13-109-g47e1fda87919
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      47e1fda879199e701b2f401aa20dd1a6da5e3baa =



Test Regressions
---------------- =



platform           | arch | lab           | compiler | defconfig          |=
 regressions
-------------------+------+---------------+----------+--------------------+=
------------
bcm2837-rpi-3-b-32 | arm  | lab-baylibre  | gcc-8    | bcm2835_defconfig  |=
 1          =


  Details:     https://kernelci.org/test/plan/id/60dbb4034de5bb8a5523bbc4

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: bcm2835_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.12/v5.12.13-=
109-g47e1fda87919/arm/bcm2835_defconfig/gcc-8/lab-baylibre/baseline-bcm2837=
-rpi-3-b-32.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.12/v5.12.13-=
109-g47e1fda87919/arm/bcm2835_defconfig/gcc-8/lab-baylibre/baseline-bcm2837=
-rpi-3-b-32.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60dbb4034de5bb8a5523b=
bc5
        failing since 0 day (last pass: v5.12.13-12-gf45ef4c1b3a2, first fa=
il: v5.12.13-109-g5add6842f3ea) =

 =



platform           | arch | lab           | compiler | defconfig          |=
 regressions
-------------------+------+---------------+----------+--------------------+=
------------
rk3288-veyron-jaq  | arm  | lab-collabora | gcc-8    | multi_v7_defconfig |=
 3          =


  Details:     https://kernelci.org/test/plan/id/60dbe615f5053b02c323bc75

  Results:     67 PASS, 3 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.12/v5.12.13-=
109-g47e1fda87919/arm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-rk328=
8-veyron-jaq.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.12/v5.12.13-=
109-g47e1fda87919/arm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-rk328=
8-veyron-jaq.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.bootrr.dwmmc_rockchip-sdmmc-probed: https://kernelci.org/test/=
case/id/60dbe615f5053b02c323bc8f
        failing since 15 days (last pass: v5.12.10-48-g5e97c6651365, first =
fail: v5.12.10-173-gfd0b35fa0b0c)

    2021-06-30T03:33:28.958999  /lava-4115911/1/../bin/lava-test-case
    2021-06-30T03:33:28.965160  <8>[   11.432783] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Ddwmmc_rockchip-sdmmc-probed RESULT=3Dfail>   =


  * baseline.bootrr.dwmmc_rockchip-sdio0-probed: https://kernelci.org/test/=
case/id/60dbe615f5053b02c323bc90
        failing since 15 days (last pass: v5.12.10-48-g5e97c6651365, first =
fail: v5.12.10-173-gfd0b35fa0b0c)

    2021-06-30T03:33:29.996651  /lava-4115911/1/../bin/lava-test-case<8>[  =
 12.452499] <LAVA_SIGNAL_TESTCASE TEST_CASE_ID=3Ddwmmc_rockchip-sdio0-probe=
d RESULT=3Dfail>
    2021-06-30T03:33:29.997203  =

    2021-06-30T03:33:29.997733  /lava-4115911/1/../bin/lava-test-case   =


  * baseline.bootrr.rockchip-iodomain-grf-probed: https://kernelci.org/test=
/case/id/60dbe615f5053b02c323bca8
        failing since 15 days (last pass: v5.12.10-48-g5e97c6651365, first =
fail: v5.12.10-173-gfd0b35fa0b0c)

    2021-06-30T03:33:31.404995  /lava-4115911/1/../bin/lava-test-case
    2021-06-30T03:33:31.422110  <8>[   13.878853] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Drockchip-iodomain-grf-probed RESULT=3Dfail>
    2021-06-30T03:33:31.422658  /lava-4115911/1/../bin/lava-test-case   =

 =20
