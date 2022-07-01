Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3EDBC56337D
	for <lists+stable@lfdr.de>; Fri,  1 Jul 2022 14:29:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232650AbiGAM3A (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 1 Jul 2022 08:29:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60376 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229565AbiGAM27 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 1 Jul 2022 08:28:59 -0400
Received: from mail-pg1-x533.google.com (mail-pg1-x533.google.com [IPv6:2607:f8b0:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5E4D834646
        for <stable@vger.kernel.org>; Fri,  1 Jul 2022 05:28:58 -0700 (PDT)
Received: by mail-pg1-x533.google.com with SMTP id z14so2328152pgh.0
        for <stable@vger.kernel.org>; Fri, 01 Jul 2022 05:28:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=Iklt7TicvwV0FkmAfMFqwKYzWTW/4wndricUqSXQ9ZU=;
        b=MBbBCHVuFG6rMKOJe2HKS8etTMdZpWiE3bOR0MV3X6dCbt1DNMzs3WrMT8Mme1E91o
         gMUiNTh8wh0Q0d5aWgMhRSa25jUZC09Ee0eNoADyfWkv3kcu8ujPGpvkPZW+DI/TcqHj
         MVOim+qz4doRXHPpCVSSQJXfEbKXWOObF+FyR+fM5NWYZ4vTb1VygUgahxlOecld1zV9
         VhStq+ndL3b7dhnYNku4PUV2O2T6WuPDJO0AmuLXylqcyRSbbzSKK1vg8Y9enNhae3D+
         BfCqHCk2Fc5y/amPNnbq7pCOX7zvqc49ERWc6RP8Ys9g05/18nG2+WKKGMR6c1RLTCuI
         PXSA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=Iklt7TicvwV0FkmAfMFqwKYzWTW/4wndricUqSXQ9ZU=;
        b=2g8fUIbT3+olOThsGAZaSMqNXwUltyDZqxrX1DyyYJnIytEPZgx2NbFpRgQM/oJt5W
         hovz/GPHc5W8U6D7xIuMwCJd+boV2v6EAGFj4z3G89BpntFmg3V7PGkITT8jzw4fZMdW
         3ZwRZs+3kneBLG0t2Ip3Bkw5KCEM2HHsNcbb9jG9SEGxU0Gp2bs5fHsdfRfqTyH6GxVi
         tCocSpp++GsZFXKy1h7V5A3a1pbk3hKg+9bbFaiA8E7sFAaSINOmvdDzT1Vk65NFvzBg
         qdoENNEzMm4Y9jpXav7tDxTp4my8lv2tco2OwR4rAlp6x1PGZk+jha4FQBtx0WVEUUm3
         ZpMw==
X-Gm-Message-State: AJIora8bahMh5u0leAbJodm3G+sWICQqgLWqQtiW3wplymvdD6fjPHdw
        rGeA5Xxpp8eAUZZpB0F65eOp8p8m8d+jQee0
X-Google-Smtp-Source: AGRyM1vhC5f6vibAp1jnaJBWbu/3af2rmLU1Ohjsr8XJ65GbvSyblzmnfdGZ6oh9aYpEC2RnzK+Eeg==
X-Received: by 2002:a05:6a00:1491:b0:528:1aa1:743c with SMTP id v17-20020a056a00149100b005281aa1743cmr7171076pfu.84.1656678537686;
        Fri, 01 Jul 2022 05:28:57 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id cb14-20020a056a00430e00b0051bbe085f16sm15378989pfb.104.2022.07.01.05.28.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 01 Jul 2022 05:28:57 -0700 (PDT)
Message-ID: <62bee889.1c69fb81.37cd9.5fc4@mx.google.com>
Date:   Fri, 01 Jul 2022 05:28:57 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v5.15.51-28-g6fe93cf1bf30
X-Kernelci-Branch: queue/5.15
X-Kernelci-Tree: stable-rc
Subject: stable-rc/queue/5.15 baseline: 91 runs,
 6 regressions (v5.15.51-28-g6fe93cf1bf30)
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

stable-rc/queue/5.15 baseline: 91 runs, 6 regressions (v5.15.51-28-g6fe93cf=
1bf30)

Regressions Summary
-------------------

platform          | arch  | lab           | compiler | defconfig           =
       | regressions
------------------+-------+---------------+----------+---------------------=
-------+------------
beagle-xm         | arm   | lab-baylibre  | gcc-10   | omap2plus_defconfig =
       | 1          =

jetson-tk1        | arm   | lab-baylibre  | gcc-10   | multi_v7_defconfig  =
       | 1          =

jetson-tk1        | arm   | lab-baylibre  | gcc-10   | tegra_defconfig     =
       | 1          =

rk3399-gru-kevin  | arm64 | lab-collabora | gcc-10   | defconfig+arm64-chro=
mebook | 1          =

tegra124-nyan-big | arm   | lab-collabora | gcc-10   | multi_v7_defconfig  =
       | 1          =

tegra124-nyan-big | arm   | lab-collabora | gcc-10   | tegra_defconfig     =
       | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.15/ker=
nel/v5.15.51-28-g6fe93cf1bf30/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.15
  Describe: v5.15.51-28-g6fe93cf1bf30
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      6fe93cf1bf3083865c9326924393a9e3904e4348 =



Test Regressions
---------------- =



platform          | arch  | lab           | compiler | defconfig           =
       | regressions
------------------+-------+---------------+----------+---------------------=
-------+------------
beagle-xm         | arm   | lab-baylibre  | gcc-10   | omap2plus_defconfig =
       | 1          =


  Details:     https://kernelci.org/test/plan/id/62beb2c5732359c89da39bfe

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.51-=
28-g6fe93cf1bf30/arm/omap2plus_defconfig/gcc-10/lab-baylibre/baseline-beagl=
e-xm.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.51-=
28-g6fe93cf1bf30/arm/omap2plus_defconfig/gcc-10/lab-baylibre/baseline-beagl=
e-xm.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220624.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62beb2c5732359c89da39=
bff
        failing since 92 days (last pass: v5.15.31-2-g57d4301e22c2, first f=
ail: v5.15.31-3-g4ae45332eb9c) =

 =



platform          | arch  | lab           | compiler | defconfig           =
       | regressions
------------------+-------+---------------+----------+---------------------=
-------+------------
jetson-tk1        | arm   | lab-baylibre  | gcc-10   | multi_v7_defconfig  =
       | 1          =


  Details:     https://kernelci.org/test/plan/id/62becccd8b7c367de2a39c18

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.51-=
28-g6fe93cf1bf30/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-jetson=
-tk1.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.51-=
28-g6fe93cf1bf30/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-jetson=
-tk1.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220624.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62becccd8b7c367de2a39=
c19
        failing since 20 days (last pass: v5.15.45-667-g99a55c4a9ecc0, firs=
t fail: v5.15.45-798-g69fa874c62551) =

 =



platform          | arch  | lab           | compiler | defconfig           =
       | regressions
------------------+-------+---------------+----------+---------------------=
-------+------------
jetson-tk1        | arm   | lab-baylibre  | gcc-10   | tegra_defconfig     =
       | 1          =


  Details:     https://kernelci.org/test/plan/id/62becac37bbca4016aa39bf2

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: tegra_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.51-=
28-g6fe93cf1bf30/arm/tegra_defconfig/gcc-10/lab-baylibre/baseline-jetson-tk=
1.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.51-=
28-g6fe93cf1bf30/arm/tegra_defconfig/gcc-10/lab-baylibre/baseline-jetson-tk=
1.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220624.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62becac37bbca4016aa39=
bf3
        failing since 18 days (last pass: v5.15.45-833-g04983d84c84ee, firs=
t fail: v5.15.45-880-g694575c32c9b2) =

 =



platform          | arch  | lab           | compiler | defconfig           =
       | regressions
------------------+-------+---------------+----------+---------------------=
-------+------------
rk3399-gru-kevin  | arm64 | lab-collabora | gcc-10   | defconfig+arm64-chro=
mebook | 1          =


  Details:     https://kernelci.org/test/plan/id/62beb284a775f1a70ba39bdb

  Results:     88 PASS, 4 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.51-=
28-g6fe93cf1bf30/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/base=
line-rk3399-gru-kevin.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.51-=
28-g6fe93cf1bf30/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/base=
line-rk3399-gru-kevin.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220624.0/arm64/rootfs.cpio.gz =



  * baseline.bootrr.rockchip-i2s1-probed: https://kernelci.org/test/case/id=
/62beb284a775f1a70ba39bfd
        failing since 115 days (last pass: v5.15.26-42-gc89c0807b943, first=
 fail: v5.15.26-257-g2b9a22cd5eb8)

    2022-07-01T08:38:13.304390  <8>[   59.891164] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Drockchip-i2s0-probed RESULT=3Dpass>
    2022-07-01T08:38:14.326648  /lava-6724113/1/../bin/lava-test-case   =

 =



platform          | arch  | lab           | compiler | defconfig           =
       | regressions
------------------+-------+---------------+----------+---------------------=
-------+------------
tegra124-nyan-big | arm   | lab-collabora | gcc-10   | multi_v7_defconfig  =
       | 1          =


  Details:     https://kernelci.org/test/plan/id/62bed3e0482153325ba39bf5

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.51-=
28-g6fe93cf1bf30/arm/multi_v7_defconfig/gcc-10/lab-collabora/baseline-tegra=
124-nyan-big.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.51-=
28-g6fe93cf1bf30/arm/multi_v7_defconfig/gcc-10/lab-collabora/baseline-tegra=
124-nyan-big.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220624.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62bed3e0482153325ba39=
bf6
        failing since 23 days (last pass: v5.15.45-652-g938d073d082af, firs=
t fail: v5.15.45-667-g6f48aa0f6b54d) =

 =



platform          | arch  | lab           | compiler | defconfig           =
       | regressions
------------------+-------+---------------+----------+---------------------=
-------+------------
tegra124-nyan-big | arm   | lab-collabora | gcc-10   | tegra_defconfig     =
       | 1          =


  Details:     https://kernelci.org/test/plan/id/62becc30160fc77abca39bd2

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: tegra_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.51-=
28-g6fe93cf1bf30/arm/tegra_defconfig/gcc-10/lab-collabora/baseline-tegra124=
-nyan-big.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.51-=
28-g6fe93cf1bf30/arm/tegra_defconfig/gcc-10/lab-collabora/baseline-tegra124=
-nyan-big.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220624.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62becc30160fc77abca39=
bd3
        failing since 12 days (last pass: v5.15.45-915-gfe83bcae3c626, firs=
t fail: v5.15.48-44-gaa2f7b1f36db5) =

 =20
