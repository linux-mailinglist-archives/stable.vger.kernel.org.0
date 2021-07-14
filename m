Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C200D3C92B9
	for <lists+stable@lfdr.de>; Wed, 14 Jul 2021 23:03:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230382AbhGNVGW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 14 Jul 2021 17:06:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41142 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230180AbhGNVGV (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 14 Jul 2021 17:06:21 -0400
Received: from mail-pf1-x436.google.com (mail-pf1-x436.google.com [IPv6:2607:f8b0:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 22A6FC06175F
        for <stable@vger.kernel.org>; Wed, 14 Jul 2021 14:03:29 -0700 (PDT)
Received: by mail-pf1-x436.google.com with SMTP id d12so3151145pfj.2
        for <stable@vger.kernel.org>; Wed, 14 Jul 2021 14:03:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=ScZ3rUEEix4BF68pEXmy4eyC5aIo63jytRxDpaA52U4=;
        b=mDOecBmp9FY0HWfWlKKZNwz8+c/qebepnFZFMmUfDLmfXO4YaDHFsYdddCqyJnWCax
         hdfjeXb0hlGjtxA24KbcgHQT4mbfeuXcJKFe29VL+G+xUs2v2wP+ib43X2suKEUK67Tv
         WCosiFirH9SB+zeZoAb1mJFcBnMsCKtI3i9LvCGb7RXZ84nfRgfj3ChRE8Q+s7xfY3Mn
         i+T0bzbswVNaBnIgY61sI6EE/cah/f2X4wRcL7o6/cJOFPOVW/rUApDvjNZkbW99HU7i
         2LKDKnGj7HBqGt440ohQXz9ZMN8VdjgfdfQx/iTy5zYqPdII41FJ2iWCFaPhpfVMyUXk
         IXRw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=ScZ3rUEEix4BF68pEXmy4eyC5aIo63jytRxDpaA52U4=;
        b=OwgxgwgIMaqVFcFCqdGkVzdlkVSHgrQQam8+ybDZkD2P5T76ozFe1xSIMkn1ryqCoH
         MY8vxfVwbqjEdEsGON1CHb0tf6jZHr06bpKM7tmGe6jHFnhHgJIGkNogLsLeb9EcBCU3
         TkqEbgLUJ4ipneCKRFs3wX8RQIkQeb7GN3q09+jEELmJzMFcK6Cib3iroEVxZOV36Yow
         7QPKghMCnrOqTB4uRbKXwmKX3SH3af8XeznNevGh1A229E5C0ys0hJ7wukrHOCkn3n7r
         4IYC+t0A6Uorx6E2ReCxFp1yhvD//TFUWj3EjIJHTEIj36tS0FKnZqo6yYW1pupsq338
         FQ3A==
X-Gm-Message-State: AOAM530shbN7NTiyCsecHrpztgnB4V5hro2haqt0Rx9eveUMRhtV92dW
        INh3PGsaTwSJB2TZNFhcnaExo2qWMfAo/I7k
X-Google-Smtp-Source: ABdhPJxIJmxtXA8bVFoic+yP51kroLzTRB0irSMXJlC8Q4Wcemht4uiNGdo9fMhloJlW/pRaTFnjIg==
X-Received: by 2002:a63:2f05:: with SMTP id v5mr11265383pgv.449.1626296608424;
        Wed, 14 Jul 2021 14:03:28 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id 11sm4345637pge.7.2021.07.14.14.03.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 14 Jul 2021 14:03:28 -0700 (PDT)
Message-ID: <60ef5120.1c69fb81.c5384.d815@mx.google.com>
Date:   Wed, 14 Jul 2021 14:03:28 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/5.10
X-Kernelci-Kernel: v5.10.49-595-g4dccdd372b12
Subject: stable-rc/queue/5.10 baseline: 130 runs,
 6 regressions (v5.10.49-595-g4dccdd372b12)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.10 baseline: 130 runs, 6 regressions (v5.10.49-595-g4dccd=
d372b12)

Regressions Summary
-------------------

platform                 | arch | lab             | compiler | defconfig   =
        | regressions
-------------------------+------+-----------------+----------+-------------=
--------+------------
imx6q-var-dt6customboard | arm  | lab-baylibre    | gcc-8    | multi_v7_def=
config  | 2          =

imx6ul-pico-hobbit       | arm  | lab-pengutronix | gcc-8    | imx_v6_v7_de=
fconfig | 1          =

rk3288-veyron-jaq        | arm  | lab-collabora   | gcc-8    | multi_v7_def=
config  | 3          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.10/ker=
nel/v5.10.49-595-g4dccdd372b12/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.10
  Describe: v5.10.49-595-g4dccdd372b12
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      4dccdd372b12ff56923943f8bcefdb3d6d87aefb =



Test Regressions
---------------- =



platform                 | arch | lab             | compiler | defconfig   =
        | regressions
-------------------------+------+-----------------+----------+-------------=
--------+------------
imx6q-var-dt6customboard | arm  | lab-baylibre    | gcc-8    | multi_v7_def=
config  | 2          =


  Details:     https://kernelci.org/test/plan/id/60ef1ae7f0803f95d38a93a3

  Results:     4 PASS, 2 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.49-=
595-g4dccdd372b12/arm/multi_v7_defconfig/gcc-8/lab-baylibre/baseline-imx6q-=
var-dt6customboard.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.49-=
595-g4dccdd372b12/arm/multi_v7_defconfig/gcc-8/lab-baylibre/baseline-imx6q-=
var-dt6customboard.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.dmesg.alert: https://kernelci.org/test/case/id/60ef1ae7f0803f9=
5d38a93a7
        new failure (last pass: v5.10.49-596-gbf7048dec18f0)
        4 lines

    2021-07-14T17:11:42.873157  kern  :alert : 8<--- cut here ---
    2021-07-14T17:11:42.873560  kern  :alert : Unhandled fault: alignment e=
xception (0x001) at 0xcec60217
    2021-07-14T17:11:42.874071  kern  :alert : pgd =3D (ptrval)
    2021-07-14T17:11:42.874626  kern  :alert : [<8>[   39.434015] <LAVA_SIG=
NAL_TESTCASE TEST_CASE_ID=3Dalert RESULT=3Dfail UNITS=3Dlines MEASUREMENT=
=3D4>
    2021-07-14T17:11:42.874895  cec60217] *pgd=3D1ec1141e(bad)   =


  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/60ef1ae7f0803f9=
5d38a93a8
        new failure (last pass: v5.10.49-596-gbf7048dec18f0)
        26 lines

    2021-07-14T17:11:42.926056  kern  :emerg : Internal error: : 1 [#1] SMP=
 ARM
    2021-07-14T17:11:42.926447  kern  :emerg : Process kworker/1:1 (pid: 57=
, stack limit =3D 0x(ptrval))
    2021-07-14T17:11:42.926959  kern  :emerg : Stack: (0xc2461eb0 to<8>[   =
39.480872] <LAVA_SIGNAL_TESTCASE TEST_CASE_ID=3Demerg RESULT=3Dfail UNITS=
=3Dlines MEASUREMENT=3D26>
    2021-07-14T17:11:42.927231   0xc2462000)
    2021-07-14T17:11:42.927476  kern  :emerg : 1ea0<8>[   39.492459] <LAVA_=
SIGNAL_ENDRUN 0_dmesg 560769_1.5.2.4.1>
    2021-07-14T17:11:42.927715  :                                     00000=
000 00000000 c2460000 cec60217   =

 =



platform                 | arch | lab             | compiler | defconfig   =
        | regressions
-------------------------+------+-----------------+----------+-------------=
--------+------------
imx6ul-pico-hobbit       | arm  | lab-pengutronix | gcc-8    | imx_v6_v7_de=
fconfig | 1          =


  Details:     https://kernelci.org/test/plan/id/60ef1a08acc138faa58a93bf

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: imx_v6_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.49-=
595-g4dccdd372b12/arm/imx_v6_v7_defconfig/gcc-8/lab-pengutronix/baseline-im=
x6ul-pico-hobbit.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.49-=
595-g4dccdd372b12/arm/imx_v6_v7_defconfig/gcc-8/lab-pengutronix/baseline-im=
x6ul-pico-hobbit.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60ef1a08acc138faa58a9=
3c0
        new failure (last pass: v5.10.49-593-g5e321de204df8) =

 =



platform                 | arch | lab             | compiler | defconfig   =
        | regressions
-------------------------+------+-----------------+----------+-------------=
--------+------------
rk3288-veyron-jaq        | arm  | lab-collabora   | gcc-8    | multi_v7_def=
config  | 3          =


  Details:     https://kernelci.org/test/plan/id/60ef2559c587586d138a93ae

  Results:     67 PASS, 3 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.49-=
595-g4dccdd372b12/arm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-rk328=
8-veyron-jaq.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.49-=
595-g4dccdd372b12/arm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-rk328=
8-veyron-jaq.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.bootrr.rockchip-iodomain-grf-probed: https://kernelci.org/test=
/case/id/60ef255ac587586d138a93c0
        failing since 29 days (last pass: v5.10.43-44-g253317604975, first =
fail: v5.10.43-130-g87b5f83f722c)

    2021-07-14T17:56:13.217642  /lava-4197553/1/../bin/lava-test-case
    2021-07-14T17:56:13.234818  <8>[   13.808522] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Drockchip-iodomain-grf-probed RESULT=3Dfail>
    2021-07-14T17:56:13.235047  /lava-4197553/1/../bin/lava-test-case   =


  * baseline.bootrr.dwmmc_rockchip-sdio0-probed: https://kernelci.org/test/=
case/id/60ef255ac587586d138a93d8
        failing since 29 days (last pass: v5.10.43-44-g253317604975, first =
fail: v5.10.43-130-g87b5f83f722c)

    2021-07-14T17:56:11.790732  /lava-4197553/1/../bin/lava-test-case
    2021-07-14T17:56:11.808850  <8>[   12.381302] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Ddwmmc_rockchip-sdio0-probed RESULT=3Dfail>
    2021-07-14T17:56:11.809078  /lava-4197553/1/../bin/lava-test-case   =


  * baseline.bootrr.dwmmc_rockchip-sdmmc-probed: https://kernelci.org/test/=
case/id/60ef255ac587586d138a93d9
        failing since 29 days (last pass: v5.10.43-44-g253317604975, first =
fail: v5.10.43-130-g87b5f83f722c)

    2021-07-14T17:56:10.770730  /lava-4197553/1/../bin/lava-test-case
    2021-07-14T17:56:10.776351  <8>[   11.361631] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Ddwmmc_rockchip-sdmmc-probed RESULT=3Dfail>   =

 =20
