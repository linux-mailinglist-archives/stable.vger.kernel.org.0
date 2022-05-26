Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1EDB6535602
	for <lists+stable@lfdr.de>; Fri, 27 May 2022 00:13:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345720AbiEZWMQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 26 May 2022 18:12:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58600 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235553AbiEZWMP (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 26 May 2022 18:12:15 -0400
Received: from mail-pj1-x1035.google.com (mail-pj1-x1035.google.com [IPv6:2607:f8b0:4864:20::1035])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 51707EAB8F
        for <stable@vger.kernel.org>; Thu, 26 May 2022 15:12:14 -0700 (PDT)
Received: by mail-pj1-x1035.google.com with SMTP id l7-20020a17090aaa8700b001dd1a5b9965so2808818pjq.2
        for <stable@vger.kernel.org>; Thu, 26 May 2022 15:12:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=DpN89FadbX2hT4DwxJhzUcDWSDnS3DCqRxR2DsKaStY=;
        b=DGp5slL8EOQx/Uit7e28Vc8Bml6reoQ3VT23BUNKNQb2e4OC7Awq50lAVJm1cKdQOx
         vB/iVK2IldzZ7j7ZPrT2o5wHxCe/z/wLg/ax82+4+ArIROIraLfwn9C40lZzqjiKyZ6a
         vjl9ivzIh+vkS9emSuNVl7Y1TABjC0Oc++Qut/WAh1M8ELtJbBQufDhAnS4rfUkbyzxG
         aqM/ef3wBo+JJJPPOB8JeVhYTmNtP0y7i6NxKKIT9dCFNpFCMMzmQ0xUKgSJ7tAx/9IF
         QfZ732v4F778SS2OFjWP2A6mf1idT0Is82aqTHuKku2WDmmsz/iYaJSR3Obi85CyURAx
         KRPQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=DpN89FadbX2hT4DwxJhzUcDWSDnS3DCqRxR2DsKaStY=;
        b=DmuIHVR/T1oFCv9sO1dPQgu3zAdfaFlQJTgt78ghb0UyZwYi1w0jhmPeHEsd8Ijz0d
         Q/wP+LsMirLpUFnhu5nZ5iE1ekVqCQsxb4gk52O2WSo4D6IhUoq3l1Zo4rf8XDpC9Jdv
         L1gbDrLcYxF4OQYwACI4wjA9ioG5XoD+thWPFU3hMkOD95he4lF1jEJ625kOASXYITsP
         UdKoxXe1WaTOFX1hNTixcDDBckrgpktxosERrMqloVTrU/wc760lO5bn6lCHpn39vFVl
         mXOonpqZWLVGR8/HfDb5NhGZl5T2Kfo/DM+o7qATR1uNSpPZmtD5Vcb4tMSjjsXNwe5Q
         +MUA==
X-Gm-Message-State: AOAM532Z7LEJeZypn5Ax5pYWvavqE1S1ziDQFocQ76d5EioxWQa7Bppj
        lzXyqlre+zgTTZPWGuNFkXOgYrkqW60afSrxrMs=
X-Google-Smtp-Source: ABdhPJyl3V+JZPYTvWGvRU51T5wbNYrjoVLM6u0knr48yMbIE0BEPxtWXASbH2CzAQbv+HVASoN4ow==
X-Received: by 2002:a17:90b:38d2:b0:1df:51e5:9a0b with SMTP id nn18-20020a17090b38d200b001df51e59a0bmr4820900pjb.101.1653603133630;
        Thu, 26 May 2022 15:12:13 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id e16-20020aa78c50000000b0050dc76281b4sm2168763pfd.142.2022.05.26.15.12.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 26 May 2022 15:12:12 -0700 (PDT)
Message-ID: <628ffb3c.1c69fb81.2f6a.5354@mx.google.com>
Date:   Thu, 26 May 2022 15:12:12 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v5.15.43-144-g375b1504fe930
X-Kernelci-Branch: queue/5.15
X-Kernelci-Tree: stable-rc
Subject: stable-rc/queue/5.15 baseline: 115 runs,
 5 regressions (v5.15.43-144-g375b1504fe930)
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

stable-rc/queue/5.15 baseline: 115 runs, 5 regressions (v5.15.43-144-g375b1=
504fe930)

Regressions Summary
-------------------

platform                | arch  | lab           | compiler | defconfig     =
             | regressions
------------------------+-------+---------------+----------+---------------=
-------------+------------
beagle-xm               | arm   | lab-baylibre  | gcc-10   | omap2plus_defc=
onfig        | 1          =

jetson-tk1              | arm   | lab-baylibre  | gcc-10   | multi_v7_defco=
nfig         | 1          =

jetson-tk1              | arm   | lab-baylibre  | gcc-10   | tegra_defconfi=
g            | 1          =

rk3399-gru-kevin        | arm64 | lab-collabora | gcc-10   | defconfig+arm6=
4-chromebook | 1          =

sun50i-a64-bananapi-m64 | arm64 | lab-clabbe    | gcc-10   | defconfig     =
             | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.15/ker=
nel/v5.15.43-144-g375b1504fe930/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.15
  Describe: v5.15.43-144-g375b1504fe930
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      375b1504fe9301fb7799c7ff92bea1c603fff855 =



Test Regressions
---------------- =



platform                | arch  | lab           | compiler | defconfig     =
             | regressions
------------------------+-------+---------------+----------+---------------=
-------------+------------
beagle-xm               | arm   | lab-baylibre  | gcc-10   | omap2plus_defc=
onfig        | 1          =


  Details:     https://kernelci.org/test/plan/id/628fc785de20efb022a39c0b

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.43-=
144-g375b1504fe930/arm/omap2plus_defconfig/gcc-10/lab-baylibre/baseline-bea=
gle-xm.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.43-=
144-g375b1504fe930/arm/omap2plus_defconfig/gcc-10/lab-baylibre/baseline-bea=
gle-xm.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220513.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/628fc785de20efb022a39=
c0c
        failing since 56 days (last pass: v5.15.31-2-g57d4301e22c2, first f=
ail: v5.15.31-3-g4ae45332eb9c) =

 =



platform                | arch  | lab           | compiler | defconfig     =
             | regressions
------------------------+-------+---------------+----------+---------------=
-------------+------------
jetson-tk1              | arm   | lab-baylibre  | gcc-10   | multi_v7_defco=
nfig         | 1          =


  Details:     https://kernelci.org/test/plan/id/628fd149a026cd626ea39bf8

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.43-=
144-g375b1504fe930/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-jets=
on-tk1.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.43-=
144-g375b1504fe930/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-jets=
on-tk1.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220513.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/628fd149a026cd626ea39=
bf9
        failing since 2 days (last pass: v5.15.40-98-g6e388a6f5046, first f=
ail: v5.15.41-132-gede7034a09d1) =

 =



platform                | arch  | lab           | compiler | defconfig     =
             | regressions
------------------------+-------+---------------+----------+---------------=
-------------+------------
jetson-tk1              | arm   | lab-baylibre  | gcc-10   | tegra_defconfi=
g            | 1          =


  Details:     https://kernelci.org/test/plan/id/628fd3cdb79b0ae393a39ced

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: tegra_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.43-=
144-g375b1504fe930/arm/tegra_defconfig/gcc-10/lab-baylibre/baseline-jetson-=
tk1.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.43-=
144-g375b1504fe930/arm/tegra_defconfig/gcc-10/lab-baylibre/baseline-jetson-=
tk1.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220513.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/628fd3cdb79b0ae393a39=
cee
        failing since 2 days (last pass: v5.15.40-98-g6e388a6f5046, first f=
ail: v5.15.41-132-gede7034a09d1) =

 =



platform                | arch  | lab           | compiler | defconfig     =
             | regressions
------------------------+-------+---------------+----------+---------------=
-------------+------------
rk3399-gru-kevin        | arm64 | lab-collabora | gcc-10   | defconfig+arm6=
4-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/628fc802444415987ea39be8

  Results:     88 PASS, 4 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.43-=
144-g375b1504fe930/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/ba=
seline-rk3399-gru-kevin.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.43-=
144-g375b1504fe930/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/ba=
seline-rk3399-gru-kevin.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220513.0/arm64/rootfs.cpio.gz =



  * baseline.bootrr.rockchip-i2s1-probed: https://kernelci.org/test/case/id=
/628fc802444415987ea39c0e
        failing since 79 days (last pass: v5.15.26-42-gc89c0807b943, first =
fail: v5.15.26-257-g2b9a22cd5eb8)

    2022-05-26T18:33:16.161610  /lava-6479477/1/../bin/lava-test-case   =

 =



platform                | arch  | lab           | compiler | defconfig     =
             | regressions
------------------------+-------+---------------+----------+---------------=
-------------+------------
sun50i-a64-bananapi-m64 | arm64 | lab-clabbe    | gcc-10   | defconfig     =
             | 1          =


  Details:     https://kernelci.org/test/plan/id/628fc70b5788d09682a39c2f

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.43-=
144-g375b1504fe930/arm64/defconfig/gcc-10/lab-clabbe/baseline-sun50i-a64-ba=
nanapi-m64.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.43-=
144-g375b1504fe930/arm64/defconfig/gcc-10/lab-clabbe/baseline-sun50i-a64-ba=
nanapi-m64.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220513.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/628fc70b5788d09682a39=
c30
        new failure (last pass: v5.15.43-4-gcd1decd79c79) =

 =20
