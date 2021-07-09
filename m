Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 44D453C1E80
	for <lists+stable@lfdr.de>; Fri,  9 Jul 2021 06:37:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229719AbhGIEk1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 9 Jul 2021 00:40:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39476 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231137AbhGIEk1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 9 Jul 2021 00:40:27 -0400
Received: from mail-pf1-x434.google.com (mail-pf1-x434.google.com [IPv6:2607:f8b0:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DC72FC06175F
        for <stable@vger.kernel.org>; Thu,  8 Jul 2021 21:37:40 -0700 (PDT)
Received: by mail-pf1-x434.google.com with SMTP id q10so7565647pfj.12
        for <stable@vger.kernel.org>; Thu, 08 Jul 2021 21:37:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=XlA7N9mTplBdHol6eeab4izjC9Qy7fXRuigkh+LSyQw=;
        b=AHQaUnDqcu1fmLcUrG4BtHBy9ynV7urWSSl3B4qwpL8yomGXrNkbP/wF77V+RHPnj9
         4XDQa6QMb0YSbhYcYUx6y3FIYiYiO/8NphRMIiuNery//iRMKrSbw4KCe/igHkQo9NSS
         C/dekwph4jhUarJPlCjZiUgk7OY4L8EZqLQSJMuJYHQ3CgSczuikRfKXCITTMbGwDIxH
         tZbsS2tj4JrpYgC2DxAhLStezYH3QTyT9Y5LSP7SWCmvJxT9R7fAI+XpGcdt11YSRD04
         i/UT1QT8Rr3UK5/FxoU8ZVoLxV+i95lMraOrZ5oJP+HdxBED6qPx9zEegRny2cOCZ8r+
         p4/Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=XlA7N9mTplBdHol6eeab4izjC9Qy7fXRuigkh+LSyQw=;
        b=fywqNSLxnqVgx8Av51CG0rpiCut7A2zxVTaBT5pclVNFcKafSIj9V0qAeRalMfTZCH
         CpR5Htx4Msn5LEccDKiqPW3b//Q+nUpsrADoMlZrl78pvqYJcB9lOfB1Za/akoF3iHir
         72Ew3usNrBXzT9bchVG9X/N0maJhxBiyyU/SjN7zAKGSjqRMUmTI11cE9KhLtESQvywa
         vKHooVXqiY5WRtJFpk2gkjqM/o28r3R62AyKQ9QPVIU0srlHNkqRZlWyT82CIqeFOga7
         sNE4o91Ru6w/EdnBUDAVSl8SFLQ7Xd0AIuVxdAFnTuVtGzbR2J72Lx72TlihbhzH1PPm
         Vp3w==
X-Gm-Message-State: AOAM5311FNdIf402R6ObaRF8iM6KAxj6rWXvhMhrUnPA1AyGfb/wX7zF
        ePUaoIWc4QX8j/PP9EOxiUn0Tr9RsMPAtVfs
X-Google-Smtp-Source: ABdhPJx8zsnmExzDmakaIeGssuOmn1pEtohtnNnmFkFiuLe0uuWMQrZF42COoCfI/GQSF4xUOa2iAg==
X-Received: by 2002:a63:505d:: with SMTP id q29mr27029907pgl.137.1625805460268;
        Thu, 08 Jul 2021 21:37:40 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id r33sm5538433pgk.51.2021.07.08.21.37.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 08 Jul 2021 21:37:39 -0700 (PDT)
Message-ID: <60e7d293.1c69fb81.a96c4.18de@mx.google.com>
Date:   Thu, 08 Jul 2021 21:37:39 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v5.10.48-6-gea5b7eca594d
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/5.10
Subject: stable-rc/queue/5.10 baseline: 192 runs,
 6 regressions (v5.10.48-6-gea5b7eca594d)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.10 baseline: 192 runs, 6 regressions (v5.10.48-6-gea5b7ec=
a594d)

Regressions Summary
-------------------

platform                | arch  | lab           | compiler | defconfig     =
     | regressions
------------------------+-------+---------------+----------+---------------=
-----+------------
bcm2837-rpi-3-b-32      | arm   | lab-baylibre  | gcc-8    | bcm2835_defcon=
fig  | 1          =

hip07-d05               | arm64 | lab-collabora | gcc-8    | defconfig     =
     | 1          =

rk3288-veyron-jaq       | arm   | lab-collabora | gcc-8    | multi_v7_defco=
nfig | 3          =

sun50i-a64-bananapi-m64 | arm64 | lab-clabbe    | gcc-8    | defconfig     =
     | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.10/ker=
nel/v5.10.48-6-gea5b7eca594d/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.10
  Describe: v5.10.48-6-gea5b7eca594d
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      ea5b7eca594d9766e7137c080ce46a1a2b0703af =



Test Regressions
---------------- =



platform                | arch  | lab           | compiler | defconfig     =
     | regressions
------------------------+-------+---------------+----------+---------------=
-----+------------
bcm2837-rpi-3-b-32      | arm   | lab-baylibre  | gcc-8    | bcm2835_defcon=
fig  | 1          =


  Details:     https://kernelci.org/test/plan/id/60e79c94ac7b0ff7fb117994

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: bcm2835_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.48-=
6-gea5b7eca594d/arm/bcm2835_defconfig/gcc-8/lab-baylibre/baseline-bcm2837-r=
pi-3-b-32.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.48-=
6-gea5b7eca594d/arm/bcm2835_defconfig/gcc-8/lab-baylibre/baseline-bcm2837-r=
pi-3-b-32.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60e79c94ac7b0ff7fb117=
995
        failing since 3 days (last pass: v5.10.47-6-gbe997714814b, first fa=
il: v5.10.47-6-g209c9d1f6abb) =

 =



platform                | arch  | lab           | compiler | defconfig     =
     | regressions
------------------------+-------+---------------+----------+---------------=
-----+------------
hip07-d05               | arm64 | lab-collabora | gcc-8    | defconfig     =
     | 1          =


  Details:     https://kernelci.org/test/plan/id/60e7a4afe318a5f982117978

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.48-=
6-gea5b7eca594d/arm64/defconfig/gcc-8/lab-collabora/baseline-hip07-d05.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.48-=
6-gea5b7eca594d/arm64/defconfig/gcc-8/lab-collabora/baseline-hip07-d05.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60e7a4afe318a5f982117=
979
        failing since 7 days (last pass: v5.10.46-100-gce5b41f85637, first =
fail: v5.10.46-100-g3b96099161c8b) =

 =



platform                | arch  | lab           | compiler | defconfig     =
     | regressions
------------------------+-------+---------------+----------+---------------=
-----+------------
rk3288-veyron-jaq       | arm   | lab-collabora | gcc-8    | multi_v7_defco=
nfig | 3          =


  Details:     https://kernelci.org/test/plan/id/60e7b7fbe29cd6c0ad1179a9

  Results:     67 PASS, 3 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.48-=
6-gea5b7eca594d/arm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-rk3288-=
veyron-jaq.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.48-=
6-gea5b7eca594d/arm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-rk3288-=
veyron-jaq.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.bootrr.dwmmc_rockchip-sdio0-probed: https://kernelci.org/test/=
case/id/60e7b7fbe29cd6c0ad1179c3
        failing since 23 days (last pass: v5.10.43-44-g253317604975, first =
fail: v5.10.43-130-g87b5f83f722c)

    2021-07-09T02:43:59.718170  /lava-4162018/1/../bin/lava-test-case
    2021-07-09T02:43:59.734947  <8>[   11.880514] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Ddwmmc_rockchip-sdio0-probed RESULT=3Dfail>   =


  * baseline.bootrr.rockchip-iodomain-grf-probed: https://kernelci.org/test=
/case/id/60e7b7fce29cd6c0ad1179ec
        failing since 23 days (last pass: v5.10.43-44-g253317604975, first =
fail: v5.10.43-130-g87b5f83f722c)

    2021-07-09T02:44:01.143961  /lava-4162018/1/../bin/lava-test-case<8>[  =
 13.304566] <LAVA_SIGNAL_TESTCASE TEST_CASE_ID=3Drockchip-iodomain-grf-prob=
ed RESULT=3Dfail>
    2021-07-09T02:44:01.144294     =


  * baseline.bootrr.dwmmc_rockchip-sdmmc-probed: https://kernelci.org/test/=
case/id/60e7b7fce29cd6c0ad1179ed
        failing since 23 days (last pass: v5.10.43-44-g253317604975, first =
fail: v5.10.43-130-g87b5f83f722c)

    2021-07-09T02:43:58.704493  /lava-4162018/1/../bin/lava-test-case<8>[  =
 10.861146] <LAVA_SIGNAL_TESTCASE TEST_CASE_ID=3Ddwmmc_rockchip-sdmmc-probe=
d RESULT=3Dfail>
    2021-07-09T02:43:58.704827     =

 =



platform                | arch  | lab           | compiler | defconfig     =
     | regressions
------------------------+-------+---------------+----------+---------------=
-----+------------
sun50i-a64-bananapi-m64 | arm64 | lab-clabbe    | gcc-8    | defconfig     =
     | 1          =


  Details:     https://kernelci.org/test/plan/id/60e7a0302e0ee785d6117999

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.48-=
6-gea5b7eca594d/arm64/defconfig/gcc-8/lab-clabbe/baseline-sun50i-a64-banana=
pi-m64.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.48-=
6-gea5b7eca594d/arm64/defconfig/gcc-8/lab-clabbe/baseline-sun50i-a64-banana=
pi-m64.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60e7a0302e0ee785d6117=
99a
        new failure (last pass: v5.10.47-6-g209c9d1f6abb) =

 =20
