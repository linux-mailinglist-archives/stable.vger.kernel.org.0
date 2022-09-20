Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8C2595BEDE7
	for <lists+stable@lfdr.de>; Tue, 20 Sep 2022 21:37:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231549AbiITThi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 20 Sep 2022 15:37:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59456 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231555AbiITTh1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 20 Sep 2022 15:37:27 -0400
Received: from mail-pf1-x431.google.com (mail-pf1-x431.google.com [IPv6:2607:f8b0:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D035076450
        for <stable@vger.kernel.org>; Tue, 20 Sep 2022 12:37:11 -0700 (PDT)
Received: by mail-pf1-x431.google.com with SMTP id b75so3696274pfb.7
        for <stable@vger.kernel.org>; Tue, 20 Sep 2022 12:37:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:from:to:cc:subject:date;
        bh=BEy6jrhk9oFSyvbqiiylDoqgDa+Hu2uVMSWaRU201gQ=;
        b=3UsD3TlvoCotZcHh9yHZMflViMY/q5VsQ9keB3BRCan+eE2xCSwsKdJeJHCQSLkdm6
         ANjbLxyHrP2yyvq4rypvOUM+0KFph2q4EJZ0kNYJPEptDBPK2Dz4+/c53F3U5HKHc5BE
         /JWpTM6w3SUMhqq9xYaKoOcSNIqlIVRHJRKDbPOMAZfZ/VW904MDoGzQ+NJPo9dbzFOQ
         M9hSSV22jiLytBJ8PH3n0lMHhWbfyprTSoq8L0gA5bD+KzjhVSgiiwH4hiGUdQBPP3WM
         utBNczfORatascSQDOpHXy0EgZp7UklT4bDzpVL3hVZPouJPhnC+a21OiGC+NiLItIqf
         4SqA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date;
        bh=BEy6jrhk9oFSyvbqiiylDoqgDa+Hu2uVMSWaRU201gQ=;
        b=PiGakOw4moXhIHtJe1DvYdpNfeUb3/5v434qORuSIDUOzc9AJUP2BSCuFxYavA6uSu
         rTjoYo8YIoQSvAOfmE981BMcnlHdIEd8TIX+oEI3kKkqT6G949OKGXLkXJU1DdWW6gtK
         9zFiTaHtOWSJYYTELbHfp6OdpYBgGOTbObWHNbj8jxC7GDGOecK5mNbBHWfCOXQlfssK
         wa9aFOyRpD56EcZDVEcI79ZVk00dLyabvrkpP/ga+Kd3+fBzAvUobYyXwSdZOOTd3RL+
         VpEZY13a+NeEMyCsOlLJNvMvVTCTI2hhCMeKWLMJ/rWUd/cfReZvsJPZuLft/XXsqDH5
         Kmog==
X-Gm-Message-State: ACrzQf2p9M3Y8fd0e7oUlcmR7jEPJwjQiypvUWXDZzSLxf1omvvaVax8
        vDLOzxCqM0umcmxw7p7dMmL9lVgX0vHFJ9f6dWU=
X-Google-Smtp-Source: AMsMyM7oz/Z163XXkQF2SNZjLPahPmxmyc/r2PBt+s4Jtlcbm/QWE2dAzPiXzEwxhGQcKNDoUZPLrg==
X-Received: by 2002:a63:e74f:0:b0:439:8a43:416b with SMTP id j15-20020a63e74f000000b004398a43416bmr21373532pgk.224.1663702631248;
        Tue, 20 Sep 2022 12:37:11 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id m2-20020a170902d18200b001728ac8af94sm248015plb.248.2022.09.20.12.37.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 20 Sep 2022 12:37:09 -0700 (PDT)
Message-ID: <632a1665.170a0220.3f20c.0f0d@mx.google.com>
Date:   Tue, 20 Sep 2022 12:37:09 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: queue/5.18
X-Kernelci-Tree: stable-rc
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v5.18.19-1-g0bd6de61e01ed
Subject: stable-rc/queue/5.18 baseline: 189 runs,
 6 regressions (v5.18.19-1-g0bd6de61e01ed)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.18 baseline: 189 runs, 6 regressions (v5.18.19-1-g0bd6de6=
1e01ed)

Regressions Summary
-------------------

platform           | arch | lab           | compiler | defconfig           =
| regressions
-------------------+------+---------------+----------+---------------------=
+------------
bcm2835-rpi-b-rev2 | arm  | lab-broonie   | gcc-10   | bcm2835_defconfig   =
| 1          =

bcm2836-rpi-2-b    | arm  | lab-collabora | gcc-10   | bcm2835_defconfig   =
| 1          =

beagle-xm          | arm  | lab-baylibre  | gcc-10   | omap2plus_defconfig =
| 1          =

odroid-xu3         | arm  | lab-collabora | gcc-10   | exynos_defconfig    =
| 1          =

panda              | arm  | lab-baylibre  | gcc-10   | multi_v7_defconfig  =
| 1          =

rk3288-veyron-jaq  | arm  | lab-collabora | gcc-10   | multi_v7_defconfig  =
| 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.18/ker=
nel/v5.18.19-1-g0bd6de61e01ed/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.18
  Describe: v5.18.19-1-g0bd6de61e01ed
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      0bd6de61e01ed4a9998363fed28b8a81b2087eeb =



Test Regressions
---------------- =



platform           | arch | lab           | compiler | defconfig           =
| regressions
-------------------+------+---------------+----------+---------------------=
+------------
bcm2835-rpi-b-rev2 | arm  | lab-broonie   | gcc-10   | bcm2835_defconfig   =
| 1          =


  Details:     https://kernelci.org/test/plan/id/6329e281e9e9fb3947355670

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: bcm2835_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.18/v5.18.19-=
1-g0bd6de61e01ed/arm/bcm2835_defconfig/gcc-10/lab-broonie/baseline-bcm2835-=
rpi-b-rev2.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.18/v5.18.19-=
1-g0bd6de61e01ed/arm/bcm2835_defconfig/gcc-10/lab-broonie/baseline-bcm2835-=
rpi-b-rev2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220919.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6329e281e9e9fb3947355=
671
        failing since 35 days (last pass: v5.18.16-7-g7fc5e6c7e4db1, first =
fail: v5.18.17-1094-g906dae830019d) =

 =



platform           | arch | lab           | compiler | defconfig           =
| regressions
-------------------+------+---------------+----------+---------------------=
+------------
bcm2836-rpi-2-b    | arm  | lab-collabora | gcc-10   | bcm2835_defconfig   =
| 1          =


  Details:     https://kernelci.org/test/plan/id/6329e525d0a5ee59cc3556dc

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: bcm2835_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.18/v5.18.19-=
1-g0bd6de61e01ed/arm/bcm2835_defconfig/gcc-10/lab-collabora/baseline-bcm283=
6-rpi-2-b.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.18/v5.18.19-=
1-g0bd6de61e01ed/arm/bcm2835_defconfig/gcc-10/lab-collabora/baseline-bcm283=
6-rpi-2-b.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220919.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6329e525d0a5ee59cc355=
6dd
        failing since 36 days (last pass: v5.18.17-134-g620d3eac5bbd1, firs=
t fail: v5.18.17-1078-g5c55e4c4afa02) =

 =



platform           | arch | lab           | compiler | defconfig           =
| regressions
-------------------+------+---------------+----------+---------------------=
+------------
beagle-xm          | arm  | lab-baylibre  | gcc-10   | omap2plus_defconfig =
| 1          =


  Details:     https://kernelci.org/test/plan/id/6329e5553e92ca366d35566a

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.18/v5.18.19-=
1-g0bd6de61e01ed/arm/omap2plus_defconfig/gcc-10/lab-baylibre/baseline-beagl=
e-xm.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.18/v5.18.19-=
1-g0bd6de61e01ed/arm/omap2plus_defconfig/gcc-10/lab-baylibre/baseline-beagl=
e-xm.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220919.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6329e5553e92ca366d355=
66b
        failing since 14 days (last pass: v5.18.18-6-gad8a0ac8e472, first f=
ail: v5.18.19-1-g1330c8c8f8f63) =

 =



platform           | arch | lab           | compiler | defconfig           =
| regressions
-------------------+------+---------------+----------+---------------------=
+------------
odroid-xu3         | arm  | lab-collabora | gcc-10   | exynos_defconfig    =
| 1          =


  Details:     https://kernelci.org/test/plan/id/632a0880380c6b1c78355666

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: exynos_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.18/v5.18.19-=
1-g0bd6de61e01ed/arm/exynos_defconfig/gcc-10/lab-collabora/baseline-odroid-=
xu3.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.18/v5.18.19-=
1-g0bd6de61e01ed/arm/exynos_defconfig/gcc-10/lab-collabora/baseline-odroid-=
xu3.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220919.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/632a0880380c6b1c78355=
667
        failing since 37 days (last pass: v5.18.17-41-g6a725335d402d, first=
 fail: v5.18.17-134-g620d3eac5bbd1) =

 =



platform           | arch | lab           | compiler | defconfig           =
| regressions
-------------------+------+---------------+----------+---------------------=
+------------
panda              | arm  | lab-baylibre  | gcc-10   | multi_v7_defconfig  =
| 1          =


  Details:     https://kernelci.org/test/plan/id/6329e8f8b6bd53de5e355643

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.18/v5.18.19-=
1-g0bd6de61e01ed/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-panda.=
txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.18/v5.18.19-=
1-g0bd6de61e01ed/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-panda.=
html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220919.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6329e8f8b6bd53de5e355=
644
        failing since 36 days (last pass: v5.18.17-134-g620d3eac5bbd1, firs=
t fail: v5.18.17-1078-g5c55e4c4afa02) =

 =



platform           | arch | lab           | compiler | defconfig           =
| regressions
-------------------+------+---------------+----------+---------------------=
+------------
rk3288-veyron-jaq  | arm  | lab-collabora | gcc-10   | multi_v7_defconfig  =
| 1          =


  Details:     https://kernelci.org/test/plan/id/6329f7e52008b80c73355644

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.18/v5.18.19-=
1-g0bd6de61e01ed/arm/multi_v7_defconfig/gcc-10/lab-collabora/baseline-rk328=
8-veyron-jaq.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.18/v5.18.19-=
1-g0bd6de61e01ed/arm/multi_v7_defconfig/gcc-10/lab-collabora/baseline-rk328=
8-veyron-jaq.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220919.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6329f7e52008b80c73355=
645
        failing since 36 days (last pass: v5.18.17-134-g620d3eac5bbd1, firs=
t fail: v5.18.17-1078-g5c55e4c4afa02) =

 =20
