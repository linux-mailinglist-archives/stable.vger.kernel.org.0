Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 576D75EDF5F
	for <lists+stable@lfdr.de>; Wed, 28 Sep 2022 16:58:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234489AbiI1O6t (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Sep 2022 10:58:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34166 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234619AbiI1O6i (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Sep 2022 10:58:38 -0400
Received: from mail-pg1-x536.google.com (mail-pg1-x536.google.com [IPv6:2607:f8b0:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4F7DF870A9
        for <stable@vger.kernel.org>; Wed, 28 Sep 2022 07:58:37 -0700 (PDT)
Received: by mail-pg1-x536.google.com with SMTP id f193so12496844pgc.0
        for <stable@vger.kernel.org>; Wed, 28 Sep 2022 07:58:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:from:to:cc:subject:date;
        bh=Xdr22aWRMdF9+UhoBBck38M//F/fiNQaqGimbRrCjOo=;
        b=VwYDfCDt/yvkDoME24HR4WPfApBqYXLKUB90LS/L49mwIpMQPTqIs02AMJ2Xki5ZhC
         AbcCJk5777kPuvzVGZ2XYx/vXOrpV+XoYgYitLaPPKGazwMYurhQBNMTDu/RkdD6ralL
         vqfaH6mNAv0aYbYoOnDf8qXfZ8RkJ3Nb1udjml2W91BEjTTxCfFQeMfp1L9DQhjgmvhi
         VrCffxd+3JHPIxvcSg4txCR/TIXMKcztHOpk8mvLhE1um9+DZnwcty1iTDZGUL+wv/09
         /5QaqLpia03/rs0aRnp0cqJnbbn6ldGgaDsuWDLNXy2P/73UxCdYoTD+MYUbtEI4No+K
         gCkQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date;
        bh=Xdr22aWRMdF9+UhoBBck38M//F/fiNQaqGimbRrCjOo=;
        b=XRVKHEsnkO/ZRuUmKlxJCHObs5nb9dBGBYcuS2+CndBmXQP63YXspsWo+QGdaxDLi1
         qC3o/NUgb7kE7sXbRUnUOigvECnacaW8UcJqFn6Zf1V4GbwEakV16NIK60HlmDTw320v
         CuSLZwF7Kq9P6ThurCVSdOaynWPnxMtyjE/Y8ELLieEjK366+JsFKqj2GlZLVtBdeK2R
         nxlE8b10rdtnit3B7k3pLNs9Gxa6Y+hujsAPq0g/PGpeThPVRkE22+d2MBGX0xOjhrYP
         hxnc/RVg6cxHMY9WLIehJ5L7Us2QRFL4SOsHdj6mJwta3AJ92QkNLuXYCS31gg7enNVG
         J8Xg==
X-Gm-Message-State: ACrzQf3JWEb1viqTjM/ljHNdcNBudXkH64DtI3setuzRFxqvYFEMbeli
        SGMueRxKdw0vG0Y4OwJIrI/SUbGZtK+beQf6
X-Google-Smtp-Source: AMsMyM77JN3yriq5p5vW1JlJR3+LoP2pTFwb6jzzbxHiEYLnSWmmZkNvz/CczPVG+m+o2OIgKByuag==
X-Received: by 2002:a63:5415:0:b0:439:e932:e025 with SMTP id i21-20020a635415000000b00439e932e025mr29047968pgb.63.1664377116593;
        Wed, 28 Sep 2022 07:58:36 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id z10-20020aa7958a000000b0053b208b55d1sm4119259pfj.85.2022.09.28.07.58.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 28 Sep 2022 07:58:35 -0700 (PDT)
Message-ID: <6334611b.a70a0220.17553.7526@mx.google.com>
Date:   Wed, 28 Sep 2022 07:58:35 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v5.15.70-143-gc4d8548b1fa86
X-Kernelci-Branch: queue/5.15
X-Kernelci-Tree: stable-rc
Subject: stable-rc/queue/5.15 baseline: 180 runs,
 5 regressions (v5.15.70-143-gc4d8548b1fa86)
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

stable-rc/queue/5.15 baseline: 180 runs, 5 regressions (v5.15.70-143-gc4d85=
48b1fa86)

Regressions Summary
-------------------

platform    | arch | lab          | compiler | defconfig           | regres=
sions
------------+------+--------------+----------+---------------------+-------=
-----
beagle-xm   | arm  | lab-baylibre | gcc-10   | omap2plus_defconfig | 1     =
     =

imx7ulp-evk | arm  | lab-nxp      | gcc-10   | imx_v6_v7_defconfig | 1     =
     =

imx7ulp-evk | arm  | lab-nxp      | gcc-10   | multi_v7_defconfig  | 1     =
     =

panda       | arm  | lab-baylibre | gcc-10   | multi_v7_defconfig  | 1     =
     =

panda       | arm  | lab-baylibre | gcc-10   | omap2plus_defconfig | 1     =
     =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.15/ker=
nel/v5.15.70-143-gc4d8548b1fa86/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.15
  Describe: v5.15.70-143-gc4d8548b1fa86
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      c4d8548b1fa867c342da9dc2aeadd8a79376451c =



Test Regressions
---------------- =



platform    | arch | lab          | compiler | defconfig           | regres=
sions
------------+------+--------------+----------+---------------------+-------=
-----
beagle-xm   | arm  | lab-baylibre | gcc-10   | omap2plus_defconfig | 1     =
     =


  Details:     https://kernelci.org/test/plan/id/63342c696c955b5d9dec4fc3

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.70-=
143-gc4d8548b1fa86/arm/omap2plus_defconfig/gcc-10/lab-baylibre/baseline-bea=
gle-xm.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.70-=
143-gc4d8548b1fa86/arm/omap2plus_defconfig/gcc-10/lab-baylibre/baseline-bea=
gle-xm.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220919.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63342c696c955b5d9dec4=
fc4
        failing since 6 days (last pass: v5.15.69-17-g7d846e6eef7f, first f=
ail: v5.15.69-45-g01bb9cc9bf6e) =

 =



platform    | arch | lab          | compiler | defconfig           | regres=
sions
------------+------+--------------+----------+---------------------+-------=
-----
imx7ulp-evk | arm  | lab-nxp      | gcc-10   | imx_v6_v7_defconfig | 1     =
     =


  Details:     https://kernelci.org/test/plan/id/63342b9931707bef11ec4ed7

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: imx_v6_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.70-=
143-gc4d8548b1fa86/arm/imx_v6_v7_defconfig/gcc-10/lab-nxp/baseline-imx7ulp-=
evk.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.70-=
143-gc4d8548b1fa86/arm/imx_v6_v7_defconfig/gcc-10/lab-nxp/baseline-imx7ulp-=
evk.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220919.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63342b9931707bef11ec4=
ed8
        failing since 2 days (last pass: v5.15.70-117-g5ae36aa8ead6e, first=
 fail: v5.15.70-133-gbad831d5b9cf) =

 =



platform    | arch | lab          | compiler | defconfig           | regres=
sions
------------+------+--------------+----------+---------------------+-------=
-----
imx7ulp-evk | arm  | lab-nxp      | gcc-10   | multi_v7_defconfig  | 1     =
     =


  Details:     https://kernelci.org/test/plan/id/633429b6450d923219ec4f02

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.70-=
143-gc4d8548b1fa86/arm/multi_v7_defconfig/gcc-10/lab-nxp/baseline-imx7ulp-e=
vk.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.70-=
143-gc4d8548b1fa86/arm/multi_v7_defconfig/gcc-10/lab-nxp/baseline-imx7ulp-e=
vk.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220919.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/633429b6450d923219ec4=
f03
        failing since 2 days (last pass: v5.15.69-44-g09c929d3da79, first f=
ail: v5.15.70-123-gaf951c1b9b36) =

 =



platform    | arch | lab          | compiler | defconfig           | regres=
sions
------------+------+--------------+----------+---------------------+-------=
-----
panda       | arm  | lab-baylibre | gcc-10   | multi_v7_defconfig  | 1     =
     =


  Details:     https://kernelci.org/test/plan/id/63342a77511e047962ec4eab

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.70-=
143-gc4d8548b1fa86/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-pand=
a.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.70-=
143-gc4d8548b1fa86/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-pand=
a.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220919.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63342a77511e047962ec4=
eac
        failing since 43 days (last pass: v5.15.60-48-g789367af88749, first=
 fail: v5.15.60-779-ge1dae9850fdff) =

 =



platform    | arch | lab          | compiler | defconfig           | regres=
sions
------------+------+--------------+----------+---------------------+-------=
-----
panda       | arm  | lab-baylibre | gcc-10   | omap2plus_defconfig | 1     =
     =


  Details:     https://kernelci.org/test/plan/id/63342de8a62ba5cbf1ec4ea6

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.70-=
143-gc4d8548b1fa86/arm/omap2plus_defconfig/gcc-10/lab-baylibre/baseline-pan=
da.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.70-=
143-gc4d8548b1fa86/arm/omap2plus_defconfig/gcc-10/lab-baylibre/baseline-pan=
da.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220919.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63342de8a62ba5cbf1ec4=
ea7
        failing since 36 days (last pass: v5.15.61-1-geccb923b9eab2, first =
fail: v5.15.62-232-g7f3b8845612d) =

 =20
