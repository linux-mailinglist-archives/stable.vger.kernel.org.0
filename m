Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 271A05ADBF8
	for <lists+stable@lfdr.de>; Tue,  6 Sep 2022 01:50:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230425AbiIEXun (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 5 Sep 2022 19:50:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48198 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229546AbiIEXul (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 5 Sep 2022 19:50:41 -0400
Received: from mail-pl1-x634.google.com (mail-pl1-x634.google.com [IPv6:2607:f8b0:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2E3682CDFE
        for <stable@vger.kernel.org>; Mon,  5 Sep 2022 16:50:40 -0700 (PDT)
Received: by mail-pl1-x634.google.com with SMTP id f24so9700004plr.1
        for <stable@vger.kernel.org>; Mon, 05 Sep 2022 16:50:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:from:to:cc:subject:date;
        bh=ZaTJ/u9q3mDE459JKlR/LD9u2a5Vzqhu56bkMj/BEMM=;
        b=ciSlESOujDNconq3uwTzmdJ04Flag4/z+jisigaAgq0weVjLK3kxQstOaf0cl9493c
         6/rvfmlvkSOf2gvtQEF6qOtWKnyv/O0yymUdQL71OWOcahFfbMF5VtHBoW5fFc4R2bpr
         hpbT0DtetVaK1pgLLvoc6qJoHhyKuqFdox46pNRcaN8aG49Bkk3rMAsz89/1AKypGYck
         fIZhnbQ9bBS3akwheo3nSV8TcsJOdz/eb1ZLaevaawRwyLESEntnmCcPY0Euw60C4mAQ
         FnlBnjMF2vAKwtchB6GEKnI3xPp5ohxxPe5//RGbjr3JA9lA7hakhp5oBvG1wdYZAiNP
         ls0A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date;
        bh=ZaTJ/u9q3mDE459JKlR/LD9u2a5Vzqhu56bkMj/BEMM=;
        b=zTHQ1mnqspfpDVkGgFlp3NipigFvdTn5xNQO25H26NZwhmY7Mtg47n3pvaKOH3W6Ep
         7rqeGePvCOI20wUyDg2eUvIGN7NNMv6aS116+jPYMtEqrhpm9P41JutgS8QSMiPVPST2
         E376+8sDn5H47nvtGnC991dENd/m8+9ZPMozlhm77Q2czAvQ/LsOgoeqvp6DJF8FTYDO
         g3Fn01JoROuMP7lbW27XOnox7dGaTuJkuabsmr1Gah9SjYojAUbOEFqBR9MQSNsfxwFD
         IKoyJkBo79y+lCTdPgRIUwYcWte14/9yTxy74P0RwItTbYjFRrlm+jAlYIFDScNPhehJ
         VX2A==
X-Gm-Message-State: ACgBeo3jiaK6rd401/thBy3phYzGM5Pq2uxLnLZPyBPkw3uPVlqlWs0r
        5iqH20vBm4mBObn5TVU77ElYDHGjRjRazM8hnbg=
X-Google-Smtp-Source: AA6agR4ZdaoUDkZvzVG/AmIkPzdsLUCNNyueSUj8BvzZHsdQJDs07QHAIsE85fmwpSWSJ9SBhirIGg==
X-Received: by 2002:a17:902:c209:b0:175:1a78:a170 with SMTP id 9-20020a170902c20900b001751a78a170mr34037157pll.45.1662421839497;
        Mon, 05 Sep 2022 16:50:39 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id y7-20020a1709029b8700b0016dbe37cebdsm8089911plp.246.2022.09.05.16.50.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 05 Sep 2022 16:50:39 -0700 (PDT)
Message-ID: <63168b4f.170a0220.7d0ae.c5ea@mx.google.com>
Date:   Mon, 05 Sep 2022 16:50:39 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: queue/5.18
X-Kernelci-Tree: stable-rc
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v5.18.19-1-g1330c8c8f8f63
Subject: stable-rc/queue/5.18 baseline: 200 runs,
 7 regressions (v5.18.19-1-g1330c8c8f8f63)
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

stable-rc/queue/5.18 baseline: 200 runs, 7 regressions (v5.18.19-1-g1330c8c=
8f8f63)

Regressions Summary
-------------------

platform           | arch   | lab             | compiler | defconfig       =
             | regressions
-------------------+--------+-----------------+----------+-----------------=
-------------+------------
bcm2835-rpi-b-rev2 | arm    | lab-broonie     | gcc-10   | bcm2835_defconfi=
g            | 1          =

bcm2836-rpi-2-b    | arm    | lab-collabora   | gcc-10   | bcm2835_defconfi=
g            | 1          =

beagle-xm          | arm    | lab-baylibre    | gcc-10   | omap2plus_defcon=
fig          | 1          =

hp-11A-G6-EE-grunt | x86_64 | lab-collabora   | gcc-10   | x86_64_defcon...=
6-chromebook | 1          =

imx6ul-pico-hobbit | arm    | lab-pengutronix | gcc-10   | multi_v7_defconf=
ig           | 1          =

odroid-xu3         | arm    | lab-collabora   | gcc-10   | exynos_defconfig=
             | 1          =

rk3288-veyron-jaq  | arm    | lab-collabora   | gcc-10   | multi_v7_defconf=
ig           | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.18/ker=
nel/v5.18.19-1-g1330c8c8f8f63/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.18
  Describe: v5.18.19-1-g1330c8c8f8f63
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      1330c8c8f8f63a2ee2b7c08b6052851a15ff466b =



Test Regressions
---------------- =



platform           | arch   | lab             | compiler | defconfig       =
             | regressions
-------------------+--------+-----------------+----------+-----------------=
-------------+------------
bcm2835-rpi-b-rev2 | arm    | lab-broonie     | gcc-10   | bcm2835_defconfi=
g            | 1          =


  Details:     https://kernelci.org/test/plan/id/63165322600dbae518355642

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: bcm2835_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.18/v5.18.19-=
1-g1330c8c8f8f63/arm/bcm2835_defconfig/gcc-10/lab-broonie/baseline-bcm2835-=
rpi-b-rev2.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.18/v5.18.19-=
1-g1330c8c8f8f63/arm/bcm2835_defconfig/gcc-10/lab-broonie/baseline-bcm2835-=
rpi-b-rev2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63165322600dbae518355=
643
        failing since 20 days (last pass: v5.18.16-7-g7fc5e6c7e4db1, first =
fail: v5.18.17-1094-g906dae830019d) =

 =



platform           | arch   | lab             | compiler | defconfig       =
             | regressions
-------------------+--------+-----------------+----------+-----------------=
-------------+------------
bcm2836-rpi-2-b    | arm    | lab-collabora   | gcc-10   | bcm2835_defconfi=
g            | 1          =


  Details:     https://kernelci.org/test/plan/id/6316531521fe66175b35566d

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: bcm2835_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.18/v5.18.19-=
1-g1330c8c8f8f63/arm/bcm2835_defconfig/gcc-10/lab-collabora/baseline-bcm283=
6-rpi-2-b.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.18/v5.18.19-=
1-g1330c8c8f8f63/arm/bcm2835_defconfig/gcc-10/lab-collabora/baseline-bcm283=
6-rpi-2-b.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6316531521fe66175b355=
66e
        failing since 21 days (last pass: v5.18.17-134-g620d3eac5bbd1, firs=
t fail: v5.18.17-1078-g5c55e4c4afa02) =

 =



platform           | arch   | lab             | compiler | defconfig       =
             | regressions
-------------------+--------+-----------------+----------+-----------------=
-------------+------------
beagle-xm          | arm    | lab-baylibre    | gcc-10   | omap2plus_defcon=
fig          | 1          =


  Details:     https://kernelci.org/test/plan/id/631659745c6d92377e35567e

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.18/v5.18.19-=
1-g1330c8c8f8f63/arm/omap2plus_defconfig/gcc-10/lab-baylibre/baseline-beagl=
e-xm.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.18/v5.18.19-=
1-g1330c8c8f8f63/arm/omap2plus_defconfig/gcc-10/lab-baylibre/baseline-beagl=
e-xm.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/631659745c6d92377e355=
67f
        new failure (last pass: v5.18.18-6-gad8a0ac8e472) =

 =



platform           | arch   | lab             | compiler | defconfig       =
             | regressions
-------------------+--------+-----------------+----------+-----------------=
-------------+------------
hp-11A-G6-EE-grunt | x86_64 | lab-collabora   | gcc-10   | x86_64_defcon...=
6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/631654617004450332355659

  Results:     18 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.18/v5.18.19-=
1-g1330c8c8f8f63/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabor=
a/baseline-hp-11A-G6-EE-grunt.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.18/v5.18.19-=
1-g1330c8c8f8f63/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabor=
a/baseline-hp-11A-G6-EE-grunt.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/x86/rootfs.cpio.gz =



  * baseline.bootrr.tpm-chip-is-online: https://kernelci.org/test/case/id/6=
3165461700445033235566c
        new failure (last pass: v5.18.18-6-gad8a0ac8e472)

    2022-09-05T19:55:52.219378  /usr/bin/tpm2_getcap
    2022-09-05T19:55:52.244544  ERROR:tcti:src/tss2-tcti/tcti-device.c:286:=
tcti_device_receive() Failed to read response from fd 3, got errno 14: Bad =
address =

    2022-09-05T19:55:52.253131  ERROR:esys:src/tss2-esys/api/Esys_GetCapabi=
lity.c:307:Esys_GetCapability_Finish() Received a non-TPM Error =

    2022-09-05T19:55:52.263453  ERROR:esys:src/tss2-esys/api/Esys_GetCapabi=
lity.c:107:Esys_GetCapability() Esys Finish ErrorCode (0x000a000a) =

    2022-09-05T19:55:52.266399  ERROR: Esys_GetCapability(0xA000A) - tcti:I=
O failure
    2022-09-05T19:55:52.269216  ERROR: Unable to run tpm2_getcap
    2022-09-05T19:55:53.265152  ERROR:tcti:src/tss2-tcti/tcti-device.c:286:=
tcti_device_receive() Failed to read response from fd 3, got errno 14: Bad =
address =

    2022-09-05T19:55:53.273712  ERROR:esys:src/tss2-esys/api/Esys_GetCapabi=
lity.c:307:Esys_GetCapability_Finish() Received a non-TPM Error =

    2022-09-05T19:55:53.284694  ERROR:esys:src/tss2-esys/api/Esys_GetCapabi=
lity.c:107:Esys_GetCapability() Esys Finish ErrorCode (0x000a000a) =

    2022-09-05T19:55:53.288260  ERROR: Esys_GetCapability(0xA000A) - tcti:I=
O failure =

    ... (42 line(s) more)  =

 =



platform           | arch   | lab             | compiler | defconfig       =
             | regressions
-------------------+--------+-----------------+----------+-----------------=
-------------+------------
imx6ul-pico-hobbit | arm    | lab-pengutronix | gcc-10   | multi_v7_defconf=
ig           | 1          =


  Details:     https://kernelci.org/test/plan/id/63165b3987ca1bf3ec355659

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.18/v5.18.19-=
1-g1330c8c8f8f63/arm/multi_v7_defconfig/gcc-10/lab-pengutronix/baseline-imx=
6ul-pico-hobbit.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.18/v5.18.19-=
1-g1330c8c8f8f63/arm/multi_v7_defconfig/gcc-10/lab-pengutronix/baseline-imx=
6ul-pico-hobbit.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63165b3987ca1bf3ec355=
65a
        failing since 61 days (last pass: v5.18.9-96-g91cfa3d0b94d, first f=
ail: v5.18.9-102-ga6b8287ea0b9) =

 =



platform           | arch   | lab             | compiler | defconfig       =
             | regressions
-------------------+--------+-----------------+----------+-----------------=
-------------+------------
odroid-xu3         | arm    | lab-collabora   | gcc-10   | exynos_defconfig=
             | 1          =


  Details:     https://kernelci.org/test/plan/id/6316541ad7cbd5ab7535565d

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: exynos_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.18/v5.18.19-=
1-g1330c8c8f8f63/arm/exynos_defconfig/gcc-10/lab-collabora/baseline-odroid-=
xu3.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.18/v5.18.19-=
1-g1330c8c8f8f63/arm/exynos_defconfig/gcc-10/lab-collabora/baseline-odroid-=
xu3.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6316541ad7cbd5ab75355=
65e
        failing since 23 days (last pass: v5.18.17-41-g6a725335d402d, first=
 fail: v5.18.17-134-g620d3eac5bbd1) =

 =



platform           | arch   | lab             | compiler | defconfig       =
             | regressions
-------------------+--------+-----------------+----------+-----------------=
-------------+------------
rk3288-veyron-jaq  | arm    | lab-collabora   | gcc-10   | multi_v7_defconf=
ig           | 1          =


  Details:     https://kernelci.org/test/plan/id/631665257decad72c9355652

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.18/v5.18.19-=
1-g1330c8c8f8f63/arm/multi_v7_defconfig/gcc-10/lab-collabora/baseline-rk328=
8-veyron-jaq.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.18/v5.18.19-=
1-g1330c8c8f8f63/arm/multi_v7_defconfig/gcc-10/lab-collabora/baseline-rk328=
8-veyron-jaq.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/631665257decad72c9355=
653
        failing since 21 days (last pass: v5.18.17-134-g620d3eac5bbd1, firs=
t fail: v5.18.17-1078-g5c55e4c4afa02) =

 =20
