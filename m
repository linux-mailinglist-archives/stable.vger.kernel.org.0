Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A91725B5EDB
	for <lists+stable@lfdr.de>; Mon, 12 Sep 2022 19:08:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229968AbiILRIG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Sep 2022 13:08:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34214 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229771AbiILRIF (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 12 Sep 2022 13:08:05 -0400
Received: from mail-pj1-x102f.google.com (mail-pj1-x102f.google.com [IPv6:2607:f8b0:4864:20::102f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1820A2127C
        for <stable@vger.kernel.org>; Mon, 12 Sep 2022 10:08:04 -0700 (PDT)
Received: by mail-pj1-x102f.google.com with SMTP id z9-20020a17090a468900b001ffff693b27so8809722pjf.2
        for <stable@vger.kernel.org>; Mon, 12 Sep 2022 10:08:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:from:to:cc:subject:date;
        bh=Mw32Y65iOyrXMcKV19s/M/DPGozQzjJyTJm1G73c30U=;
        b=a2UZkX7Ju8zhvEymSMiX75DGLnrDvsWxTAUMJrdBnY0EeEr8OcB2X6VUzfuRQ2WiiE
         HAl8o5tdbv9ZAfRcGD/uRJx0wMQ7rct2L5q8d7ocdKcGuEn861rgSUdTOAURd/V+bPBr
         DBhbJz91k1gjeIE/HS/0YTsOhwxqQmCJGg3gq5WqxiR6+JcoVC8bQdKq56DGUk22soo3
         T/GmMS5HE80gnjaBEDDm5P5mI5lIZ/85OCiufc+zu/f0s5IIx0/YNcyAFruHEKF6i72E
         MDMowsC5flOPWRNtv9l5kK7HzxA/IO/FJ42bGnM+QT1Mub82CS+gRO2wwdLwtJnQYJZV
         oXyw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date;
        bh=Mw32Y65iOyrXMcKV19s/M/DPGozQzjJyTJm1G73c30U=;
        b=R5lcuzRED7Mkpwy4wbXauco6ceQkm00lh/dqINHPWUhPqUr7kKswKRI9YKCIXFkGjy
         W/0+kfGheRIrqfV22KMjkVxveUNnRgjHzXbHZNEIrw9qq9U3ohyn1jOIVJLUWXG2VLqX
         NwRUxpaTX/V2tgFhkyA3N0ZHSsWB3dbATgRxVTucGlGpDPqUURGJrB9xoENqsqTkY05g
         wyF7Qx5fs787PtidBoMH1FxMKroWO6uEW6PA1aEhtzYQl3Wesx7PoN4C+piXAai18IDL
         3KmHKhOPcguzZIf0o7pemtuwl6wZxNQfJk96b/WmHDoLui5T+npAdcmtwdeYjxj89+Ou
         nEig==
X-Gm-Message-State: ACgBeo1WT9pf4W7+vFj/rJhKlyx5SzcJbyB3ClDn+s2UYqYUV/hwMil6
        EHdUSyfTiWVX86ci9Cp4StJYpZe4JMsTnoIDjdQ=
X-Google-Smtp-Source: AA6agR43/tIxo8tjM4F3+RD7+o04tjh9y/bhIsyP+ADogVi6d8tr9EPfA12eFGe+tnVrGRkCEfWxOw==
X-Received: by 2002:a17:902:d2c4:b0:178:32c4:6648 with SMTP id n4-20020a170902d2c400b0017832c46648mr5823680plc.88.1663002483319;
        Mon, 12 Sep 2022 10:08:03 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id q9-20020a17090a1b0900b00200461cfa99sm5475811pjq.11.2022.09.12.10.08.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 12 Sep 2022 10:08:02 -0700 (PDT)
Message-ID: <631f6772.170a0220.2a814.8db5@mx.google.com>
Date:   Mon, 12 Sep 2022 10:08:02 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: queue/5.18
X-Kernelci-Tree: stable-rc
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v5.18.19-1-g935d5e1a94dd
Subject: stable-rc/queue/5.18 baseline: 188 runs,
 7 regressions (v5.18.19-1-g935d5e1a94dd)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.18 baseline: 188 runs, 7 regressions (v5.18.19-1-g935d5e1=
a94dd)

Regressions Summary
-------------------

platform           | arch  | lab             | compiler | defconfig        =
   | regressions
-------------------+-------+-----------------+----------+------------------=
---+------------
bcm2835-rpi-b-rev2 | arm   | lab-broonie     | gcc-10   | bcm2835_defconfig=
   | 1          =

bcm2836-rpi-2-b    | arm   | lab-collabora   | gcc-10   | bcm2835_defconfig=
   | 1          =

beagle-xm          | arm   | lab-baylibre    | gcc-10   | omap2plus_defconf=
ig | 1          =

imx6ul-pico-hobbit | arm   | lab-pengutronix | gcc-10   | multi_v7_defconfi=
g  | 1          =

imx8mn-ddr4-evk    | arm64 | lab-nxp         | gcc-10   | defconfig        =
   | 1          =

odroid-xu3         | arm   | lab-collabora   | gcc-10   | exynos_defconfig =
   | 1          =

rk3288-veyron-jaq  | arm   | lab-collabora   | gcc-10   | multi_v7_defconfi=
g  | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.18/ker=
nel/v5.18.19-1-g935d5e1a94dd/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.18
  Describe: v5.18.19-1-g935d5e1a94dd
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      935d5e1a94dd6f2f38e9469b08ca2e36a956b2c4 =



Test Regressions
---------------- =



platform           | arch  | lab             | compiler | defconfig        =
   | regressions
-------------------+-------+-----------------+----------+------------------=
---+------------
bcm2835-rpi-b-rev2 | arm   | lab-broonie     | gcc-10   | bcm2835_defconfig=
   | 1          =


  Details:     https://kernelci.org/test/plan/id/631f2e0a2f63c22f3b355646

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: bcm2835_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.18/v5.18.19-=
1-g935d5e1a94dd/arm/bcm2835_defconfig/gcc-10/lab-broonie/baseline-bcm2835-r=
pi-b-rev2.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.18/v5.18.19-=
1-g935d5e1a94dd/arm/bcm2835_defconfig/gcc-10/lab-broonie/baseline-bcm2835-r=
pi-b-rev2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/631f2e0a2f63c22f3b355=
647
        failing since 26 days (last pass: v5.18.16-7-g7fc5e6c7e4db1, first =
fail: v5.18.17-1094-g906dae830019d) =

 =



platform           | arch  | lab             | compiler | defconfig        =
   | regressions
-------------------+-------+-----------------+----------+------------------=
---+------------
bcm2836-rpi-2-b    | arm   | lab-collabora   | gcc-10   | bcm2835_defconfig=
   | 1          =


  Details:     https://kernelci.org/test/plan/id/631f3aa5a91a5a8a37355663

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: bcm2835_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.18/v5.18.19-=
1-g935d5e1a94dd/arm/bcm2835_defconfig/gcc-10/lab-collabora/baseline-bcm2836=
-rpi-2-b.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.18/v5.18.19-=
1-g935d5e1a94dd/arm/bcm2835_defconfig/gcc-10/lab-collabora/baseline-bcm2836=
-rpi-2-b.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/631f3aa5a91a5a8a37355=
664
        failing since 28 days (last pass: v5.18.17-134-g620d3eac5bbd1, firs=
t fail: v5.18.17-1078-g5c55e4c4afa02) =

 =



platform           | arch  | lab             | compiler | defconfig        =
   | regressions
-------------------+-------+-----------------+----------+------------------=
---+------------
beagle-xm          | arm   | lab-baylibre    | gcc-10   | omap2plus_defconf=
ig | 1          =


  Details:     https://kernelci.org/test/plan/id/631f309193efbb9d16355695

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.18/v5.18.19-=
1-g935d5e1a94dd/arm/omap2plus_defconfig/gcc-10/lab-baylibre/baseline-beagle=
-xm.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.18/v5.18.19-=
1-g935d5e1a94dd/arm/omap2plus_defconfig/gcc-10/lab-baylibre/baseline-beagle=
-xm.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/631f309193efbb9d16355=
696
        failing since 6 days (last pass: v5.18.18-6-gad8a0ac8e472, first fa=
il: v5.18.19-1-g1330c8c8f8f63) =

 =



platform           | arch  | lab             | compiler | defconfig        =
   | regressions
-------------------+-------+-----------------+----------+------------------=
---+------------
imx6ul-pico-hobbit | arm   | lab-pengutronix | gcc-10   | multi_v7_defconfi=
g  | 1          =


  Details:     https://kernelci.org/test/plan/id/631f34fce799de4c3d35565c

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.18/v5.18.19-=
1-g935d5e1a94dd/arm/multi_v7_defconfig/gcc-10/lab-pengutronix/baseline-imx6=
ul-pico-hobbit.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.18/v5.18.19-=
1-g935d5e1a94dd/arm/multi_v7_defconfig/gcc-10/lab-pengutronix/baseline-imx6=
ul-pico-hobbit.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/631f34fce799de4c3d355=
65d
        failing since 68 days (last pass: v5.18.9-96-g91cfa3d0b94d, first f=
ail: v5.18.9-102-ga6b8287ea0b9) =

 =



platform           | arch  | lab             | compiler | defconfig        =
   | regressions
-------------------+-------+-----------------+----------+------------------=
---+------------
imx8mn-ddr4-evk    | arm64 | lab-nxp         | gcc-10   | defconfig        =
   | 1          =


  Details:     https://kernelci.org/test/plan/id/631f3024866b66acd1355670

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.18/v5.18.19-=
1-g935d5e1a94dd/arm64/defconfig/gcc-10/lab-nxp/baseline-imx8mn-ddr4-evk.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.18/v5.18.19-=
1-g935d5e1a94dd/arm64/defconfig/gcc-10/lab-nxp/baseline-imx8mn-ddr4-evk.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/631f3024866b66acd1355=
671
        new failure (last pass: v5.18.19-1-g13ec0d616810) =

 =



platform           | arch  | lab             | compiler | defconfig        =
   | regressions
-------------------+-------+-----------------+----------+------------------=
---+------------
odroid-xu3         | arm   | lab-collabora   | gcc-10   | exynos_defconfig =
   | 1          =


  Details:     https://kernelci.org/test/plan/id/631f482174421a9c55355658

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: exynos_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.18/v5.18.19-=
1-g935d5e1a94dd/arm/exynos_defconfig/gcc-10/lab-collabora/baseline-odroid-x=
u3.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.18/v5.18.19-=
1-g935d5e1a94dd/arm/exynos_defconfig/gcc-10/lab-collabora/baseline-odroid-x=
u3.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/631f482174421a9c55355=
659
        failing since 29 days (last pass: v5.18.17-41-g6a725335d402d, first=
 fail: v5.18.17-134-g620d3eac5bbd1) =

 =



platform           | arch  | lab             | compiler | defconfig        =
   | regressions
-------------------+-------+-----------------+----------+------------------=
---+------------
rk3288-veyron-jaq  | arm   | lab-collabora   | gcc-10   | multi_v7_defconfi=
g  | 1          =


  Details:     https://kernelci.org/test/plan/id/631f51e8709531d3f535564c

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.18/v5.18.19-=
1-g935d5e1a94dd/arm/multi_v7_defconfig/gcc-10/lab-collabora/baseline-rk3288=
-veyron-jaq.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.18/v5.18.19-=
1-g935d5e1a94dd/arm/multi_v7_defconfig/gcc-10/lab-collabora/baseline-rk3288=
-veyron-jaq.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/631f51e8709531d3f5355=
64d
        failing since 28 days (last pass: v5.18.17-134-g620d3eac5bbd1, firs=
t fail: v5.18.17-1078-g5c55e4c4afa02) =

 =20
