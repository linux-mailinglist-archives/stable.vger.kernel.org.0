Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 735565B20B3
	for <lists+stable@lfdr.de>; Thu,  8 Sep 2022 16:37:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232234AbiIHOhi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 8 Sep 2022 10:37:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54498 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231928AbiIHOhd (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 8 Sep 2022 10:37:33 -0400
Received: from mail-pl1-x62c.google.com (mail-pl1-x62c.google.com [IPv6:2607:f8b0:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5C6DFE72EF
        for <stable@vger.kernel.org>; Thu,  8 Sep 2022 07:37:32 -0700 (PDT)
Received: by mail-pl1-x62c.google.com with SMTP id c2so18087983plo.3
        for <stable@vger.kernel.org>; Thu, 08 Sep 2022 07:37:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:from:to:cc:subject:date;
        bh=q68zmfiLsgEisTBGmVRAcq+YLOscCiyrN+q93IC335c=;
        b=Kf2GsYNv9zo2lR0e6mdsBu4IGN7y+nMwj/jsMn1s21/E5wk7TBnnOynK37r/uGh99t
         hb9oz/xbgMC3civzZRFaR5AGkD8OaxkUVr8oSFp6WwwvDlixGocj+vOEMpTSxY9lSRUE
         o9SLiZq8YcHmE2Thi8P3LA8PI0nc3Y7TWUdMUTrqs0V//7jSx7pM4sDwjceGJYw75Xt7
         dVSnwmWgnUp5337+rh8mfJDA3D1KHXEdjSm78bvZMxyDNINWQfeSa7JGoyS4ORtvolnj
         yeVfG1A/VKts+dLJED4lwPAmj8M4z040f/L64ZR768nFcK3WuP1o/f3mlpwe97yERjft
         tVsw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date;
        bh=q68zmfiLsgEisTBGmVRAcq+YLOscCiyrN+q93IC335c=;
        b=z8knl1nDubfR8sgNtRmr7JcEzghppCoyaM5SS+EMStngLxOT0N3wV7Kpx25L7j705v
         hoBbpoYSwpBCr9M1f27+OvhA5A2OQtGFJhlG7ouDUgmQwEhuYHzIxfOJQUSnc/49vR/x
         xgcU5osu2meg9u+8ggXn2wmShFVyDMFX38Ke+w344wdHQHa6HIbf1as7zWrcOp11FzMA
         aUFBQU4ymHQ52h4QmNCcj8A3PWSrNJZOMGtsa3YuE7Zc5TrZVGGOkDd9C55lziyyQLPp
         uL34EuhcGsIHTCHaJ3vEkuy+uCuc4nYymj+xq2yFleHSsh5Tr0dJ5Nc6hl8zlWSirQKp
         svIg==
X-Gm-Message-State: ACgBeo2VpwG2rzJQHPGMogx7TpdvP5qI1BAULw0+sqKxK0KspXgTG4pQ
        8/PUi47GwTYhGzoPPcmkq1b6rzZ4l7e3Cj17NvM=
X-Google-Smtp-Source: AA6agR5lKPE6VUR3fg/bJUlwjx3zQTVLVzfh+Yt9rVk7BLLZwCXh7L0rEVNM3zA0oPYf/QWN1bbT3w==
X-Received: by 2002:a17:902:e889:b0:175:3e0e:169f with SMTP id w9-20020a170902e88900b001753e0e169fmr9291197plg.114.1662647851214;
        Thu, 08 Sep 2022 07:37:31 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id 15-20020a63184f000000b00434abd19eeasm5780625pgy.78.2022.09.08.07.37.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 08 Sep 2022 07:37:30 -0700 (PDT)
Message-ID: <6319fe2a.630a0220.abe3.93c4@mx.google.com>
Date:   Thu, 08 Sep 2022 07:37:30 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: queue/5.18
X-Kernelci-Tree: stable-rc
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v5.18.19-1-g13ec0d616810
Subject: stable-rc/queue/5.18 baseline: 184 runs,
 6 regressions (v5.18.19-1-g13ec0d616810)
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

stable-rc/queue/5.18 baseline: 184 runs, 6 regressions (v5.18.19-1-g13ec0d6=
16810)

Regressions Summary
-------------------

platform           | arch | lab             | compiler | defconfig         =
  | regressions
-------------------+------+-----------------+----------+-------------------=
--+------------
bcm2835-rpi-b-rev2 | arm  | lab-broonie     | gcc-10   | bcm2835_defconfig =
  | 1          =

bcm2836-rpi-2-b    | arm  | lab-collabora   | gcc-10   | bcm2835_defconfig =
  | 1          =

beagle-xm          | arm  | lab-baylibre    | gcc-10   | omap2plus_defconfi=
g | 1          =

imx6ul-pico-hobbit | arm  | lab-pengutronix | gcc-10   | multi_v7_defconfig=
  | 1          =

odroid-xu3         | arm  | lab-collabora   | gcc-10   | exynos_defconfig  =
  | 1          =

rk3288-veyron-jaq  | arm  | lab-collabora   | gcc-10   | multi_v7_defconfig=
  | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.18/ker=
nel/v5.18.19-1-g13ec0d616810/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.18
  Describe: v5.18.19-1-g13ec0d616810
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      13ec0d616810beb8164530538db8a87b94571d80 =



Test Regressions
---------------- =



platform           | arch | lab             | compiler | defconfig         =
  | regressions
-------------------+------+-----------------+----------+-------------------=
--+------------
bcm2835-rpi-b-rev2 | arm  | lab-broonie     | gcc-10   | bcm2835_defconfig =
  | 1          =


  Details:     https://kernelci.org/test/plan/id/6319ca23bbf1f55c6e35564c

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: bcm2835_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.18/v5.18.19-=
1-g13ec0d616810/arm/bcm2835_defconfig/gcc-10/lab-broonie/baseline-bcm2835-r=
pi-b-rev2.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.18/v5.18.19-=
1-g13ec0d616810/arm/bcm2835_defconfig/gcc-10/lab-broonie/baseline-bcm2835-r=
pi-b-rev2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6319ca23bbf1f55c6e355=
64d
        failing since 22 days (last pass: v5.18.16-7-g7fc5e6c7e4db1, first =
fail: v5.18.17-1094-g906dae830019d) =

 =



platform           | arch | lab             | compiler | defconfig         =
  | regressions
-------------------+------+-----------------+----------+-------------------=
--+------------
bcm2836-rpi-2-b    | arm  | lab-collabora   | gcc-10   | bcm2835_defconfig =
  | 1          =


  Details:     https://kernelci.org/test/plan/id/6319cab61f9563ff23355642

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: bcm2835_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.18/v5.18.19-=
1-g13ec0d616810/arm/bcm2835_defconfig/gcc-10/lab-collabora/baseline-bcm2836=
-rpi-2-b.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.18/v5.18.19-=
1-g13ec0d616810/arm/bcm2835_defconfig/gcc-10/lab-collabora/baseline-bcm2836=
-rpi-2-b.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6319cab61f9563ff23355=
643
        failing since 23 days (last pass: v5.18.17-134-g620d3eac5bbd1, firs=
t fail: v5.18.17-1078-g5c55e4c4afa02) =

 =



platform           | arch | lab             | compiler | defconfig         =
  | regressions
-------------------+------+-----------------+----------+-------------------=
--+------------
beagle-xm          | arm  | lab-baylibre    | gcc-10   | omap2plus_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/6319cbdb48a4895a63355643

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.18/v5.18.19-=
1-g13ec0d616810/arm/omap2plus_defconfig/gcc-10/lab-baylibre/baseline-beagle=
-xm.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.18/v5.18.19-=
1-g13ec0d616810/arm/omap2plus_defconfig/gcc-10/lab-baylibre/baseline-beagle=
-xm.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6319cbdb48a4895a63355=
644
        failing since 2 days (last pass: v5.18.18-6-gad8a0ac8e472, first fa=
il: v5.18.19-1-g1330c8c8f8f63) =

 =



platform           | arch | lab             | compiler | defconfig         =
  | regressions
-------------------+------+-----------------+----------+-------------------=
--+------------
imx6ul-pico-hobbit | arm  | lab-pengutronix | gcc-10   | multi_v7_defconfig=
  | 1          =


  Details:     https://kernelci.org/test/plan/id/6319d91e71332bac68355655

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.18/v5.18.19-=
1-g13ec0d616810/arm/multi_v7_defconfig/gcc-10/lab-pengutronix/baseline-imx6=
ul-pico-hobbit.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.18/v5.18.19-=
1-g13ec0d616810/arm/multi_v7_defconfig/gcc-10/lab-pengutronix/baseline-imx6=
ul-pico-hobbit.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6319d91e71332bac68355=
656
        failing since 64 days (last pass: v5.18.9-96-g91cfa3d0b94d, first f=
ail: v5.18.9-102-ga6b8287ea0b9) =

 =



platform           | arch | lab             | compiler | defconfig         =
  | regressions
-------------------+------+-----------------+----------+-------------------=
--+------------
odroid-xu3         | arm  | lab-collabora   | gcc-10   | exynos_defconfig  =
  | 1          =


  Details:     https://kernelci.org/test/plan/id/6319cec72367184cd435564e

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: exynos_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.18/v5.18.19-=
1-g13ec0d616810/arm/exynos_defconfig/gcc-10/lab-collabora/baseline-odroid-x=
u3.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.18/v5.18.19-=
1-g13ec0d616810/arm/exynos_defconfig/gcc-10/lab-collabora/baseline-odroid-x=
u3.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6319cec72367184cd4355=
64f
        failing since 25 days (last pass: v5.18.17-41-g6a725335d402d, first=
 fail: v5.18.17-134-g620d3eac5bbd1) =

 =



platform           | arch | lab             | compiler | defconfig         =
  | regressions
-------------------+------+-----------------+----------+-------------------=
--+------------
rk3288-veyron-jaq  | arm  | lab-collabora   | gcc-10   | multi_v7_defconfig=
  | 1          =


  Details:     https://kernelci.org/test/plan/id/6319d84fa775c5e849355677

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.18/v5.18.19-=
1-g13ec0d616810/arm/multi_v7_defconfig/gcc-10/lab-collabora/baseline-rk3288=
-veyron-jaq.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.18/v5.18.19-=
1-g13ec0d616810/arm/multi_v7_defconfig/gcc-10/lab-collabora/baseline-rk3288=
-veyron-jaq.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6319d84fa775c5e849355=
678
        failing since 23 days (last pass: v5.18.17-134-g620d3eac5bbd1, firs=
t fail: v5.18.17-1078-g5c55e4c4afa02) =

 =20
