Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9831459CEC7
	for <lists+stable@lfdr.de>; Tue, 23 Aug 2022 04:50:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239198AbiHWCr0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 22 Aug 2022 22:47:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42050 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238808AbiHWCrZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 22 Aug 2022 22:47:25 -0400
Received: from mail-pl1-x632.google.com (mail-pl1-x632.google.com [IPv6:2607:f8b0:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 167075C94E
        for <stable@vger.kernel.org>; Mon, 22 Aug 2022 19:47:24 -0700 (PDT)
Received: by mail-pl1-x632.google.com with SMTP id 2so11646258pll.0
        for <stable@vger.kernel.org>; Mon, 22 Aug 2022 19:47:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:from:to:cc;
        bh=vCdWGXktOAl/V3rhsofly+Ow0zagQj0pxVxhiQfq+3o=;
        b=iuxLjQiIr0o8eATNpZ/o6Uuwqnp4u6YwnqVtS5l46NAaXcEzUVgFRMdZk/c8s8yOy3
         zZ/4VJRrK0pmVT30GjXHShlQ4x/5EocRoo/dw+DW52YesOn8rf0J0y+42zNqQJhHBPhq
         M0dQMJ5Sl0dz9kacaQBLeox7RID72zS5g1PR69GfyfuQGbj6XiOHSi7X4+5nNFNpDpec
         /b2Jk/gkA03MqB6sA4Q6h+jAsR6tCkeOw5Rr1UQE1rdLe9CJBBtSPwy6spENnJChJrCx
         Mos4rHIBQS33I0/2+v3nWdy7Z1kiMZY6oF8jSPSRk03RlU2YMTuEgjBiiCDCt0r1bBGy
         TxSQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:x-gm-message-state:from:to:cc;
        bh=vCdWGXktOAl/V3rhsofly+Ow0zagQj0pxVxhiQfq+3o=;
        b=tWDVeQX8nBsv6El+OmZTTd2fRrTNDSevfKTpDuqyV/DBb+J5Fd0ssCuhP8x6uiEmS3
         JFn0YmHxqEwi55HfoQ0wPE1qXH7hEc+6otTNpeiJ06jC9884cmBIVKlXofceDJR+FSLM
         k8Yis2z7G6L+kq8t2LO1H/iImQeXaQyHwHxwkbg8nRoHjPaNgBWyVdPtZ0LBoovjnYF1
         x8pucr+SHzLYUOkIZQlC1zI7yM2xq4O8TtdLEhsg7rtXg1WlOI5UlTiGHcNWHTpZ6ulf
         wtrFMeQpUT6+2iDGfa8AP2PCq4UVRV7E63t3i9ynW0Ltw1mdj/bb4kDPkfWoVgYas1lz
         qXrA==
X-Gm-Message-State: ACgBeo2rniJ8aUK+0uXs4egiYFdz6Q8ExGgW7/V+/ijhnjOrUBCUy6PO
        nVN/jK76qssiI0+4YYOeQIK4+fG+mwSuVkEo
X-Google-Smtp-Source: AA6agR6RbczYLYAKWzba9DstA6rgPs9A8ApYffXVvlRU3oItR5ibIrB1TbQsEJXsAYRwTf/QrBPdkA==
X-Received: by 2002:a17:902:f382:b0:173:5eb:f67b with SMTP id f2-20020a170902f38200b0017305ebf67bmr227020ple.53.1661222843453;
        Mon, 22 Aug 2022 19:47:23 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id r9-20020aa79629000000b00536a80dff1asm2971493pfg.177.2022.08.22.19.47.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 22 Aug 2022 19:47:23 -0700 (PDT)
Message-ID: <63043fbb.a70a0220.a513a.56fa@mx.google.com>
Date:   Mon, 22 Aug 2022 19:47:23 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: queue/5.15
X-Kernelci-Tree: stable-rc
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v5.15.62-232-g7f3b8845612d
Subject: stable-rc/queue/5.15 baseline: 147 runs,
 4 regressions (v5.15.62-232-g7f3b8845612d)
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

stable-rc/queue/5.15 baseline: 147 runs, 4 regressions (v5.15.62-232-g7f3b8=
845612d)

Regressions Summary
-------------------

platform        | arch | lab           | compiler | defconfig           | r=
egressions
----------------+------+---------------+----------+---------------------+--=
----------
bcm2836-rpi-2-b | arm  | lab-collabora | gcc-10   | bcm2835_defconfig   | 1=
          =

beagle-xm       | arm  | lab-baylibre  | gcc-10   | omap2plus_defconfig | 1=
          =

panda           | arm  | lab-baylibre  | gcc-10   | multi_v7_defconfig  | 1=
          =

panda           | arm  | lab-baylibre  | gcc-10   | omap2plus_defconfig | 1=
          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.15/ker=
nel/v5.15.62-232-g7f3b8845612d/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.15
  Describe: v5.15.62-232-g7f3b8845612d
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      7f3b8845612d5f44c70c280b0d61b13f3aab2039 =



Test Regressions
---------------- =



platform        | arch | lab           | compiler | defconfig           | r=
egressions
----------------+------+---------------+----------+---------------------+--=
----------
bcm2836-rpi-2-b | arm  | lab-collabora | gcc-10   | bcm2835_defconfig   | 1=
          =


  Details:     https://kernelci.org/test/plan/id/630426ed75591c431a355670

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: bcm2835_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.62-=
232-g7f3b8845612d/arm/bcm2835_defconfig/gcc-10/lab-collabora/baseline-bcm28=
36-rpi-2-b.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.62-=
232-g7f3b8845612d/arm/bcm2835_defconfig/gcc-10/lab-collabora/baseline-bcm28=
36-rpi-2-b.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/630426ed75591c431a355=
671
        new failure (last pass: v5.15.60-673-g7d1e7d167a411) =

 =



platform        | arch | lab           | compiler | defconfig           | r=
egressions
----------------+------+---------------+----------+---------------------+--=
----------
beagle-xm       | arm  | lab-baylibre  | gcc-10   | omap2plus_defconfig | 1=
          =


  Details:     https://kernelci.org/test/plan/id/63040e36b0ddebd2213556af

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.62-=
232-g7f3b8845612d/arm/omap2plus_defconfig/gcc-10/lab-baylibre/baseline-beag=
le-xm.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.62-=
232-g7f3b8845612d/arm/omap2plus_defconfig/gcc-10/lab-baylibre/baseline-beag=
le-xm.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63040e36b0ddebd221355=
6b0
        failing since 145 days (last pass: v5.15.31-2-g57d4301e22c2, first =
fail: v5.15.31-3-g4ae45332eb9c) =

 =



platform        | arch | lab           | compiler | defconfig           | r=
egressions
----------------+------+---------------+----------+---------------------+--=
----------
panda           | arm  | lab-baylibre  | gcc-10   | multi_v7_defconfig  | 1=
          =


  Details:     https://kernelci.org/test/plan/id/63043cea509189ff0f355652

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.62-=
232-g7f3b8845612d/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-panda=
.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.62-=
232-g7f3b8845612d/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-panda=
.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63043cea509189ff0f355=
653
        failing since 7 days (last pass: v5.15.60-48-g789367af88749, first =
fail: v5.15.60-779-ge1dae9850fdff) =

 =



platform        | arch | lab           | compiler | defconfig           | r=
egressions
----------------+------+---------------+----------+---------------------+--=
----------
panda           | arm  | lab-baylibre  | gcc-10   | omap2plus_defconfig | 1=
          =


  Details:     https://kernelci.org/test/plan/id/63043b1d7ca83c61dc355656

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.62-=
232-g7f3b8845612d/arm/omap2plus_defconfig/gcc-10/lab-baylibre/baseline-pand=
a.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.62-=
232-g7f3b8845612d/arm/omap2plus_defconfig/gcc-10/lab-baylibre/baseline-pand=
a.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63043b1d7ca83c61dc355=
657
        new failure (last pass: v5.15.61-1-geccb923b9eab2) =

 =20
