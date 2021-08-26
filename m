Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C1F983F8A63
	for <lists+stable@lfdr.de>; Thu, 26 Aug 2021 16:47:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236959AbhHZOrs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 26 Aug 2021 10:47:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35994 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232154AbhHZOrs (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 26 Aug 2021 10:47:48 -0400
Received: from mail-pl1-x62a.google.com (mail-pl1-x62a.google.com [IPv6:2607:f8b0:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 47F29C061757
        for <stable@vger.kernel.org>; Thu, 26 Aug 2021 07:47:01 -0700 (PDT)
Received: by mail-pl1-x62a.google.com with SMTP id e15so1950042plh.8
        for <stable@vger.kernel.org>; Thu, 26 Aug 2021 07:47:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=t87rC7x8fq7wO88VgCVW56X+dioaqeatbV/E4hrqBBw=;
        b=tZ+kxc0Qeq+sVDX8Qpze90pHUZyS0aX8CEy5GxGCtV+xu//sVH4s25iGjrQ3depuTm
         irSY97sNZck46rrveL6BbEIaBT38np6iIle+ZujgP18I0n2TPifI5j9PDBwvUkUmqdo3
         zCaHyXDWhHv3ey8de6nagU9gHHAt2sp+u/OQqdEhhDaz7OX5k3Z4dR2oHg2oUZ20RkQG
         6DF9XmtLcs5L8YFwLiXX4mTBMS0h5ejnFsAlM1Vc6PZzL2UQVgpzAHQ85xFKywDOAlV9
         vROUfWemOTQ2Ub26LUUQJvsOn7LfxrUJkyPk2JzneQJOiN30w5d0bzAJ5IPZJhPcEQME
         MAWA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=t87rC7x8fq7wO88VgCVW56X+dioaqeatbV/E4hrqBBw=;
        b=gUTsrVMSZiY1qj8Y/dCcjQaz7H95fPAQbhXeyTMUIf3prxhzhpFS1JhOgtd89H6YG6
         Liodo3cDeJrN2WYoBEFQy8WyDM8ixcyaD3sUk4cnKIkzv0Td+nhiQTdV3Au2dGM5OJ3G
         QXqo9an3y9him7kM5jUyEEURnUgTl7g0ZTBe9F5t1jjnYXzSjWa8MZR+BAsZa1VvsVmb
         Yp9OKGoQILLBfQiB5AgLVxF9nOqmFe8nIM/YBnzp/9iPv6Pbc0Yn2138bt1AyjZQeoqk
         15CS4o15j00IogtmXwr2L65147bqy6+QkZ2p0evb/Zq+FnJUFWiWSEEZDp6E8tD/TEDz
         FDYA==
X-Gm-Message-State: AOAM530pJiDahBEziQhyZ4W7mKXewUeZqOJe09DViND1fAgFfnW4yZsI
        NzaLr6R4/KtfOmVkbKOcP3NPo2j/fyQnFBF/
X-Google-Smtp-Source: ABdhPJychvFN2Mm6z/I9TUkKtSb60xrpMkGSK60DY08H5KzAfzgcpvlaoA4U8DqOEm6Dpd3GKELOcg==
X-Received: by 2002:a17:902:c950:b029:12d:2ada:9ef7 with SMTP id i16-20020a170902c950b029012d2ada9ef7mr3948773pla.61.1629989220502;
        Thu, 26 Aug 2021 07:47:00 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id j4sm4014035pgi.6.2021.08.26.07.47.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 26 Aug 2021 07:47:00 -0700 (PDT)
Message-ID: <6127a964.1c69fb81.48197.af13@mx.google.com>
Date:   Thu, 26 Aug 2021 07:47:00 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: queue/5.10
X-Kernelci-Kernel: v5.10.60-94-g933a0fb6cc52
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
Subject: stable-rc/queue/5.10 baseline: 207 runs,
 5 regressions (v5.10.60-94-g933a0fb6cc52)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.10 baseline: 207 runs, 5 regressions (v5.10.60-94-g933a0f=
b6cc52)

Regressions Summary
-------------------

platform           | arch  | lab           | compiler | defconfig          =
| regressions
-------------------+-------+---------------+----------+--------------------=
+------------
bcm2837-rpi-3-b-32 | arm   | lab-baylibre  | gcc-8    | bcm2835_defconfig  =
| 1          =

hip07-d05          | arm64 | lab-collabora | gcc-8    | defconfig          =
| 1          =

rk3288-veyron-jaq  | arm   | lab-collabora | gcc-8    | multi_v7_defconfig =
| 3          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.10/ker=
nel/v5.10.60-94-g933a0fb6cc52/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.10
  Describe: v5.10.60-94-g933a0fb6cc52
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      933a0fb6cc524ac0aab0211166f949b4028ccc9b =



Test Regressions
---------------- =



platform           | arch  | lab           | compiler | defconfig          =
| regressions
-------------------+-------+---------------+----------+--------------------=
+------------
bcm2837-rpi-3-b-32 | arm   | lab-baylibre  | gcc-8    | bcm2835_defconfig  =
| 1          =


  Details:     https://kernelci.org/test/plan/id/61277431f1e4fb000c8e2c82

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: bcm2835_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.60-=
94-g933a0fb6cc52/arm/bcm2835_defconfig/gcc-8/lab-baylibre/baseline-bcm2837-=
rpi-3-b-32.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.60-=
94-g933a0fb6cc52/arm/bcm2835_defconfig/gcc-8/lab-baylibre/baseline-bcm2837-=
rpi-3-b-32.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61277431f1e4fb000c8e2=
c83
        new failure (last pass: v5.10.60-97-g812f9eb4fd7e) =

 =



platform           | arch  | lab           | compiler | defconfig          =
| regressions
-------------------+-------+---------------+----------+--------------------=
+------------
hip07-d05          | arm64 | lab-collabora | gcc-8    | defconfig          =
| 1          =


  Details:     https://kernelci.org/test/plan/id/6127786d1912b95dd08e2ca3

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.60-=
94-g933a0fb6cc52/arm64/defconfig/gcc-8/lab-collabora/baseline-hip07-d05.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.60-=
94-g933a0fb6cc52/arm64/defconfig/gcc-8/lab-collabora/baseline-hip07-d05.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6127786d1912b95dd08e2=
ca4
        failing since 55 days (last pass: v5.10.46-100-gce5b41f85637, first=
 fail: v5.10.46-100-g3b96099161c8b) =

 =



platform           | arch  | lab           | compiler | defconfig          =
| regressions
-------------------+-------+---------------+----------+--------------------=
+------------
rk3288-veyron-jaq  | arm   | lab-collabora | gcc-8    | multi_v7_defconfig =
| 3          =


  Details:     https://kernelci.org/test/plan/id/61277a48e0e492d3528e2cb5

  Results:     67 PASS, 3 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.60-=
94-g933a0fb6cc52/arm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-rk3288=
-veyron-jaq.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.60-=
94-g933a0fb6cc52/arm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-rk3288=
-veyron-jaq.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.bootrr.rockchip-iodomain-grf-probed: https://kernelci.org/test=
/case/id/61277a48e0e492d3528e2cc9
        failing since 72 days (last pass: v5.10.43-44-g253317604975, first =
fail: v5.10.43-130-g87b5f83f722c)

    2021-08-26T11:25:54.937239  /lava-4415909/1/../bin/lava-test-case
    2021-08-26T11:25:54.954334  <8>[   13.784186] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Drockchip-iodomain-grf-probed RESULT=3Dfail>   =


  * baseline.bootrr.dwmmc_rockchip-sdio0-probed: https://kernelci.org/test/=
case/id/61277a48e0e492d3528e2ce1
        failing since 72 days (last pass: v5.10.43-44-g253317604975, first =
fail: v5.10.43-130-g87b5f83f722c)

    2021-08-26T11:25:53.532280  /lava-4415909/1/../bin/lava-test-case<8>[  =
 12.360860] <LAVA_SIGNAL_TESTCASE TEST_CASE_ID=3Ddwmmc_rockchip-sdio0-probe=
d RESULT=3Dfail>
    2021-08-26T11:25:53.532844  =

    2021-08-26T11:25:53.533273  /lava-4415909/1/../bin/lava-test-case   =


  * baseline.bootrr.dwmmc_rockchip-sdmmc-probed: https://kernelci.org/test/=
case/id/61277a48e0e492d3528e2ce2
        failing since 72 days (last pass: v5.10.43-44-g253317604975, first =
fail: v5.10.43-130-g87b5f83f722c)

    2021-08-26T11:25:51.480965  =

    2021-08-26T11:25:52.494650  /lava-4415909/1/../bin/lava-test-case
    2021-08-26T11:25:52.499977  <8>[   11.341449] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Ddwmmc_rockchip-sdmmc-probed RESULT=3Dfail>   =

 =20
